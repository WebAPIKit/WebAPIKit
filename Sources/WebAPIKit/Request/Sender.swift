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

final class WebAPISender: Cancelable {

    private let provider: WebAPIProvider
    private let request: WebAPIRequest
    private let httpClient: HttpClient
    private let handler: (WebAPIResult) -> Void
    init(provider: WebAPIProvider, request: WebAPIRequest, httpClient: HttpClient, handler: @escaping ResultHandler) {
        self.provider = provider
        self.request = request
        self.httpClient = httpClient
        self.handler = handler
        send()
    }

    private var task: Cancelable?

    private func send() {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.toURLRequest()
        } catch {
            fail(with: (error as? WebAPIError) ?? .invalidRequest(error))
            return
        }

        invokeRequestHooks(with: urlRequest)

        task = httpClient.send(urlRequest, queue: nil, handler: httpHandler)
    }

    public func cancel() {
        if let task = task {
            task.cancel()
            self.task = nil
        }
    }

    private func invokeRequestHooks(with urlRequest: URLRequest) {
        provider.plugins?.requestHooks.forEach {
            $0.willSendRequest(urlRequest)
        }
        request.plugins?.requestHooks.forEach {
            $0.willSendRequest(urlRequest)
        }
    }

    private func httpHandler(data: Data?, response: HTTPURLResponse?, error: Error?) {
        task = nil

        if let error = error {
            return fail(with: .sendFailed(error))
        }

        guard let response = response else {
            return fail(with: .noResponse)
        }

        let status = StatusCode(response.statusCode)
        if request.requireAuthentication ?? provider.requireAuthentication,
            let authentication = request.authentication ?? provider.authentication,
            let error = authentication.validate(status: status, response: response) {
            return fail(with: error)
        }

    }

    private func fail(with error: WebAPIError) {
        handler(.failure(error))
    }
}
