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

// MARK: Config `sender`
extension WebAPIRequest {

    @discardableResult
    open func setHttpClient(_ httpClient: HTTPClient) -> Self {
        self.httpClient = httpClient
        return self
    }

}

// MARK: Config plugins
extension WebAPIRequest {

    @discardableResult
    open func setPlugins(_ plugins: PluginHub) -> Self {
        self.plugins = plugins
        return self
    }

    @discardableResult
    open func addPlugin(_ plugin: WebAPIPlugin) -> Self {
        let plugins = self.plugins ?? PluginHub()
        plugins.add(plugin)
        self.plugins = plugins
        return self
    }

    @discardableResult
    open func addPlugins(block: (PluginHub) -> Void) -> Self {
        let plugins = self.plugins ?? PluginHub()
        block(plugins)
        self.plugins = plugins
        return self
    }

}

// MARK: Config `authentication`
extension WebAPIRequest {

    @discardableResult
    open func setRequireAuthentication(_ requireAuthentication: Bool) -> Self {
        self.requireAuthentication = requireAuthentication
        return self
    }

    @discardableResult
    open func setAuthentication(_ authentication: WebAPIAuthentication) -> Self {
        self.authentication = authentication
        return self
    }

}

// MARK: Config `queryItems`
extension WebAPIRequest {

    @discardableResult
    open func setQueryItems(_ queryItems: [URLQueryItem]) -> Self {
        self.queryItems = queryItems
        return self
    }

    @discardableResult
    open func setQueryItems(_ queryItems: [(name: String, value: String)]) -> Self {
        self.queryItems = queryItems.map { URLQueryItem(name: $0.name, value: $0.value) }
        return self
    }

    @discardableResult
    open func addQueryItem(name: String, value: String) -> Self {
        queryItems.append(URLQueryItem(name: name, value: value))
        return self
    }

}

// MARK: Config `headers`
extension WebAPIRequest {

    @discardableResult
    open func setHeaders(_ headers: [String: String]) -> Self {
        self.headers = headers
        return self
    }

    @discardableResult
    open func addHeader(key: String, value: String) -> Self {
        self.headers[key] = value
        return self
    }

    @discardableResult
    open func setHeaders(_ headers: [RequestHeaderKey: String]) -> Self {
        self.headers = [:]
        headers.forEach { self.headers[$0.rawValue] = $1 }
        return self
    }

    @discardableResult
    open func addHeader(key: RequestHeaderKey, value: String) -> Self {
        self.headers[key.rawValue] = value
        return self
    }

}

// MARK: Config `parameters` & `httpBody`
extension WebAPIRequest {

    @discardableResult
    open func setParameters(_ parameters: [String: Any]) -> Self {
        self.parameters = parameters
        return self
    }

    @discardableResult
    open func addParameter(key: String, value: Any) -> Self {
        parameters[key] = value
        return self
    }

    @discardableResult
    open func setParameterEncoding(_ parameterEncoding: ParameterEncoding) -> Self {
        self.parameterEncoding = parameterEncoding
        return self
    }

    @discardableResult
    open func setHTTPBody(_ httpBody: Data) -> Self {
        self.httpBody = httpBody
        return self
    }

}
