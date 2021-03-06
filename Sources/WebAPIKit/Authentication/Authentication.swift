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

/// Authentication to authenticate `URLRequest` and validate `HTTPURLResponse`.
public protocol WebAPIAuthentication: class {

    /// If there is valid authentication.
    var isValid: Bool { get }

    /// Authenticate a `URLRequest`.
    func authenticate(_ request: URLRequest) throws -> URLRequest

    /// Validate response and return an error if fails.
    func validate(status: StatusCode, response: HTTPURLResponse) -> WebAPIError?

}

/// Authentication that can refresh after expires.
public protocol RefreshableAuthentication: WebAPIAuthentication {

    /// If can refresh after expires.
    var canRefresh: Bool { get }

    /// Refresh authentication after expires.
    func refresh(completionHandler: @escaping (Bool) -> Void)

}

// MARK: Default implementations
extension WebAPIAuthentication {
    public var isValid: Bool { return true }
    public func authenticate(_ request: URLRequest) throws -> URLRequest {
        return request
    }
    public func validate(status: StatusCode, response: HTTPURLResponse) -> WebAPIError? {
        if status == .code401 {
            return .authentication(.failed)
        }
        return nil
    }
}
