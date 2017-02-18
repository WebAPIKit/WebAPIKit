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
import Alamofire

public struct StubRequestMatcher {
    public let request: URLRequest
    public let provider: WebAPIProvider?
}

extension StubHTTPClient {

    @discardableResult
    public func stub(match: @escaping (StubRequestMatcher) -> Bool) -> StubResponder {
        return stub(responder: StubResponder {
            match(StubRequestMatcher(request: $0, provider: self.provider))
        })
    }

}

// MARK: Method

extension StubRequestMatcher {

    public func methodEqualTo(_ method: HTTPMethod) -> Bool {
        return request.httpMethod == method.rawValue
    }
}

// MARK: Path

extension StubRequestMatcher {

    public var requestPath: String? {
        guard let path = request.url?.path else {
            return nil
        }
        guard let basePath = provider?.baseURL.path, !basePath.isEmpty, basePath != "/" else {
            return path
        }
        return path.substring(from: basePath.endIndex)
    }

    public func pathEqualTo(_ path: String) -> Bool {
        return requestPath == path
    }

    public func pathHasPrefix(_ path: String) -> Bool {
        return requestPath?.hasPrefix(path) == true
    }

    public func pathHasSuffix(_ path: String) -> Bool {
        return requestPath?.hasSuffix(path) == true
    }

    public func pathContains(_ path: String) -> Bool {
        return requestPath?.contains(path) == true
    }

}

extension StubHTTPClient {

    public enum PathMatchMode {
        case equalTo, prefix, suffix, contains
    }

    @discardableResult
    public func stub(path: String, mode: PathMatchMode = .equalTo, method: HTTPMethod? = nil) -> StubResponder {
        return stub {
            if let method = method, !$0.methodEqualTo(method) {
                return false
            }

            switch mode {
            case .equalTo: return $0.pathEqualTo(path)
            case .prefix: return $0.pathHasPrefix(path)
            case .suffix: return $0.pathHasSuffix(path)
            case .contains: return $0.pathContains(path)
            }
        }
    }

}
