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

/// Wrapper for http request header keys.
public struct RequestHeaderKey: RawValueWrapper {

    public let rawValue: String
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

}

// MARK: Common used keys
extension RequestHeaderKey {

    /// Content types that are acceptable for the response.
    /// - `Accept: text/plain`
    public static let accept = RequestHeaderKey("Accept")

    /// Authentication credentials for HTTP authentication.
    /// - `Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==`
    public static let authorization = RequestHeaderKey("Authorization")

    /// The MIME type of the body of the request (used with `POST` and `PUT` requests).
    /// - `Content-Type: application/json`
    public static let contentType = RequestHeaderKey("Content-Type")

    /// Allows a `304 Not Modified` to be returned if content is unchanged.
    /// - `If-None-Match: "737060cd8c284d8af7ad3082f209582d"`
    public static let ifNoneMatch = RequestHeaderKey("If-None-Match")

    /// Request only part of an entity. Bytes are numbered from 0.
    /// - `Range: bytes=500-999`
    public static let range = RequestHeaderKey("Range")

}
