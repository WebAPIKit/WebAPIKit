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

/// Errors used by WebAPIKit.
public enum WebAPIError: Error {

    /// Errors related to authentication.
    public enum AuthenticationError {

        /// Required authentication is missing in both request and provider.
        case missing

        /// Authentication is invalid (request not sent).
        case invalid

        /// Server failed authentication (normally 401 Unauthorized).
        case failed

    }
    case authentication(AuthenticationError)

    case invalidRequest(Error)

    case sendFailed(Error)

    case noResponse

    case invalidResponse(Error)

}

extension WebAPIError.AuthenticationError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .missing: return "Endpoint requires authentication. Request not sent. "
        case .invalid: return "Authentication is invalid. Request not sent."
        case .failed: return "Server failed the authentication."
        }
    }
}

extension WebAPIError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .authentication(let error): return "Authentication error: \(error)"
        case .invalidRequest(let error): return "Invalid request: \(error)"
        case .sendFailed(let error): return "Send request failed: \(error)"
        case .noResponse: return "No response received"
        case .invalidResponse(let error): return "Invalid response: \(error)"
        }
    }
}
