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

/// Wrapper for http response header keys.
public struct ResponseHeaderKey: RawValueWrapper {

    public let rawValue: String
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

}

extension HTTPURLResponse {

    /// Get header response header value by key as `ResponseHeaderKey`.
    func value(forHeaderKey key: ResponseHeaderKey) -> String? {
        return self.allHeaderFields[key.rawValue] as? String
    }

}

// MARK: Common used keys
extension ResponseHeaderKey {

    /// Valid actions for a specified resource. To be used for a 405 Method not allowed.
    /// - `Allow: GET, HEAD`
    public static let allow = ResponseHeaderKey("Allow")

    /// Where in a full body message this partial message belongs.
    /// - `Content-Range: bytes 21010-47021/47022`
    public static let contentRange = ResponseHeaderKey("Content-Range")

    /// An identifier for a specific version of a resource, often a message digest.
    /// - `ETag: "737060cd8c284d8af7ad3082f209582d"`
    public static let eTag = ResponseHeaderKey("ETag")

    /// An HTTP cookie.
    /// - `Set-Cookie: UserID=JohnDoe; Max-Age=3600; Version=`
    public static let setCookie = ResponseHeaderKey("Set-Cookie")

}
