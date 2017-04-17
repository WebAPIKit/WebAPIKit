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

/// A type defines requests to a web api provider.
public protocol WebAPIProvider: class {

    /// Server base url. **Required**.
    var baseURL: URL { get }

    /// Default: URLEncoding
    var parameterEncoding: ParameterEncoding { get }
    
    var plugins: PluginHub { get }

    var requireAuthentication: Bool { get }
    /// **Note**: Need to be `Optional`.
    var authentication: WebAPIAuthentication? { get }

    /// **Note**: Need to be `Optional`.
    var httpClient: HTTPClient? { get }
}

// MARK: Default implementations
extension WebAPIProvider {
    public var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    public var requireAuthentication: Bool { return false }
    public var authentication: WebAPIAuthentication? { return nil }
    public var plugins: PluginHub { return PluginHub.default }
    public var httpClient: HTTPClient? { return nil }
}

// MARK: Utility methods
extension WebAPIProvider {

    public func makeRequest(path: String, method: HTTPMethod = .get) -> WebAPIRequest {
        return WebAPIRequest(provider: self, path: path, method: method)
    }

}
