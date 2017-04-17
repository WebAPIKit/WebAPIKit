/**
 *  WebAPIKit
 *
 *  Copyright (c) 2017 Evan Liu. Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import Foundation

/// A type to send a request via `HTTPClient` and validate/process the response.
final class WebAPISender: Cancelable {

    private let provider: WebAPIProvider
    private let request: WebAPIRequest
    private let httpClient: HTTPClient
    private let handler: ResultHandler
    init(provider: WebAPIProvider, request: WebAPIRequest, httpClient: HTTPClient, handler: @escaping ResultHandler) {
        self.provider = provider
        self.request = request
        self.httpClient = httpClient
        self.handler = handler
        send()
    }

    private var task: Cancelable?
    private var isCanceled = false

    private func send() {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.toURLRequest()
        } catch {
            return fail(with: (error as? WebAPIError) ?? .invalidRequest(error))
        }

        invokeSendHooks(with: urlRequest)

        task = httpClient.send(urlRequest, queue: nil, handler: httpHandler)
    }

    public func cancel() {
        guard !isCanceled else { return }

        if let task = task {
            task.cancel()
            self.task = nil
        }
        isCanceled = true
    }

    private func httpHandler(data: Data?, httpResponse: HTTPURLResponse?, error: Error?) {
        task = nil
        invokeReceiveHooks(data: data, response: httpResponse, error: error)

        if let error = error {
            return fail(with: .sendFailed(error))
        }

        guard let httpResponse = httpResponse else {
            return fail(with: .noResponse)
        }

        let status = StatusCode(httpResponse.statusCode)
        if request.requireAuthentication ?? provider.requireAuthentication,
            let authentication = request.authentication ?? provider.authentication,
            let error = authentication.validate(status: status, response: httpResponse) {

            if let refreshable = authentication as? RefreshableAuthentication, refreshable.canRefresh {
                return refreshAuthentication(refreshable)
            } else {
                return fail(with: error)
            }
        }

        var response = WebAPIResponse(status: status, headers: httpResponse.allHeaderFields, data: data ?? Data())
        do {
            try provider.plugins.responseProcessors.forEach {
                try response = $0.processResponse(response)
            }
            try request.plugins?.responseProcessors.forEach {
                try response = $0.processResponse(response)
            }
            success(with: response)
        } catch {
            fail(with: (error as? WebAPIError) ?? .invalidResponse(error))
        }
    }

    private func refreshAuthentication(_ authentication: RefreshableAuthentication) {
        authentication.refresh { isSuccess in
            guard !self.isCanceled else { return }

            if isSuccess {
                self.send()
            } else {
                self.fail(with: .authentication(.failed))
            }
        }
    }

    private func invokeSendHooks(with urlRequest: URLRequest) {
        provider.plugins.httpClientHooks.forEach {
            $0.willSend(request: urlRequest)
        }
        request.plugins?.httpClientHooks.forEach {
            $0.willSend(request: urlRequest)
        }
    }

    private func invokeReceiveHooks(data: Data?, response: HTTPURLResponse?, error: Error?) {
        provider.plugins.httpClientHooks.forEach {
            $0.didReceive(data: data, response: response, error: error)
        }
        request.plugins?.httpClientHooks.forEach {
            $0.didReceive(data: data, response: response, error: error)
        }
    }

    private func fail(with error: WebAPIError) {
        handler(.failure(error))
    }

    private func success(with response: WebAPIResponse) {
        handler(.success(response))
    }
}
