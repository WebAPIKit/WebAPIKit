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

/// HTTP status code wrapper.
public struct StatusCode: RawValueWrapper {

    public let rawValue: Int
    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }

}

// MARK: `Category` and `isSuccess`
extension StatusCode {

    public enum Category {
        /// 1xx
        case informational
        /// 2xx
        case success
        /// 3xx
        case redirection
        /// 4xx
        case clientError
        /// 5xx
        case serverError
    }

    public static let errorCategories: Set<Category> = [.clientError, .serverError]

    var category: Category? {
        if rawValue >= 600 { return nil }
        if rawValue >= 500 { return .serverError }
        if rawValue >= 400 { return .clientError }
        if rawValue >= 300 { return .redirection }
        if rawValue >= 200 { return .success }
        if rawValue >= 100 { return .informational }
        return nil
    }

    /// If http status code is considered success (has category being neither `clientError` nor `serverError`).
    var isSuccess: Bool {
        if let category = category {
            return !StatusCode.errorCategories.contains(category)
        }
        return false
    }

}

// MARK: Common used codes
extension StatusCode {

    /// `200 OK`. The standard response for successful HTTP requests.
    public static let code200 = StatusCode(200)

    /// `201 Created`. The request has been fulfilled and a new resource has been created.
    public static let code201 = StatusCode(201)

    /// `202 Accepted`. The request has been accepted but has not been processed yet.
    /// This code does not guarantee that the request will process successfully.
    public static let code202 = StatusCode(202)

    /// `204 No content`. The server accepted the request but is not returning any content.
    /// This is often used as a response to a `DELETE` request.
    public static let code204 = StatusCode(204)

    /// `304 Not modified`.
    /// The resource has not been modified since the version specified in `If-Modified-Since` or `If-Match` headers.
    /// The resource will not be returned in response body.
    public static let code304 = StatusCode(304)

    /// `400 Bad request`. The request could not be fulfilled due to the incorrect syntax of the request.
    public static let code400 = StatusCode(400)

    /// `401 Unauthorized`. The requester is not authorized to access the resource.
    /// This is similar to `403` but is used in cases where authentication is expected
    /// but has failed or has not been provided.
    public static let code401 = StatusCode(401)

    /// `403 Forbidden`.
    /// The request was formatted correctly but the server is refusing to supply the requested resource.
    /// Unlike `401`, authenticating will not make a difference in the server's response.
    public static let code403 = StatusCode(403)

    /// `404 Not found`. The resource could not be found.
    /// This is often used as a catch-all for all invalid URIs requested of the server.
    public static let code404 = StatusCode(404)

    /// `405 Method not allowed`.  The resource was requested using a method that is not allowed.
    /// For example, requesting a resource via a `POST` method when the resource only supports the `GET` method.
    public static let code405 = StatusCode(405)

    /// `409 Conflict`. The request cannot be completed due to a conflict in the request parameters.
    public static let code409 = StatusCode(409)

    /// `410 Gone`. The resource is no longer available at the requested URI and no redirection will be given.
    public static let code410 = StatusCode(410)

    /// `500 Internal server error`. A generic status for an error in the server itself.
    public static let code500 = StatusCode(500)

    /// `503 Service unavailable`. The server is down and is not accepting requests.
    public static let code503 = StatusCode(503)

}
