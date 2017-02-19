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

public typealias ResultHandler = (WebAPIResult) -> Void

open class WebAPIRequest {

    open let provider: WebAPIProvider
    open let path: String
    open let method: HTTPMethod

    open var requireAuthentication: Bool?
    open var authentication: WebAPIAuthentication?

    /// `HttpClient` to send out the http request.
    open var httpClient: HTTPClient?

    /// Plugins only apply to this request.
    open var plugins: PluginHub?

    /// Query items in url.
    open var queryItems = [URLQueryItem]()

    /// Http header fileds.
    open var headers = HTTPHeaders()

    /// Parameters for POST, PUT, PATCH requests.
    /// To be encoded to `httpBody` by `parameterEncoding`.
    /// Will be ignored if `httpBody` is set.
    open var parameters = Parameters()

    /// Encoding to encode `parameters` to `httpBody`.
    open var parameterEncoding: ParameterEncoding?

    /// Http body for POST, PUT, PATCH requests.
    /// Will ignore `parameters` if value provided.
    open var httpBody: Data?

    public init(provider: WebAPIProvider, path: String, method: HTTPMethod = .get) {
        self.provider = provider
        self.path = path
        self.method = method
    }

    @discardableResult
    open func send(by httpClient: HTTPClient? = nil, handler: @escaping ResultHandler) -> Cancelable {
        let httpClient = httpClient ?? self.httpClient ?? provider.httpClient ?? SessionManager.default
        return WebAPISender(provider: provider, request: self, httpClient: httpClient, handler: handler)
    }

    /// Turn to an `URLRequest`, to be sent by `HttpClient` or `URLSession` or any other networking library.
    open func toURLRequest() throws -> URLRequest {
        let url = try makeURL()
        let request = try makeURLRequest(with: url)
        return try processURLRequest(request)
    }

    /// Step 1/3 of `toURLRequest()`: make `URL` from `baseURL`, `path`, and `queryItems`.
    open func makeURL() throws -> URL {
        let url = provider.baseURL.appendingPathComponent(path)
        if queryItems.isEmpty {
            return url
        }

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw AFError.invalidURL(url: url)
        }
        components.queryItems = queryItems
        return try components.asURL()
    }

    /// Step 2/3 of `toURLRequest()`: make `URLRequest` from `URL`, `method`, `headers`, and `parameters`/`httpBody`.
    open func makeURLRequest(with url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if !headers.isEmpty {
            request.allHTTPHeaderFields = headers
        }

        if let httpBody = httpBody {
            request.httpBody = httpBody
        } else if !parameters.isEmpty {
            let encoding = parameterEncoding ?? provider.parameterEncoding ?? URLEncoding.default
            return try encoding.encode(request, with: parameters)
        }

        return request
    }

    /// Step 3/3 of `toURLRequest()`: process `URLRequest` by `Authentication` and `RequestProcessor` plugins.
    open func processURLRequest(_ request: URLRequest) throws -> URLRequest {
        var request = request

        if requireAuthentication ?? provider.requireAuthentication {
            guard let authentication = authentication ?? provider.authentication else {
                throw WebAPIError.authentication(.missing)
            }
            request = try authentication.authenticate(request)
        }

        try provider.plugins?.requestProcessors.forEach {
            request = try $0.processRequest(request)
        }

        try plugins?.requestProcessors.forEach {
            request = try $0.processRequest(request)
        }

        return request
    }

}
