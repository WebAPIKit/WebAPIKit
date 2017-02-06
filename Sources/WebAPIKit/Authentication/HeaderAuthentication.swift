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

/// Authentication that set `Authorization` header field in http requests.
open class HeaderAuthentication: WebAPIAuthentication {

    open var value: String
    public init(value: String) {
        self.value = value
    }

    open func authenticate(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.setValue(value, forHTTPHeaderField: .authorization)
        return request
    }

}

open class BasicAuthentication: HeaderAuthentication {

    public init?(user: String, password: String) {
        guard let data = "\(user):\(password)".data(using: .utf8) else { return nil }
        super.init(value: "Basic " + data.base64EncodedString(options: []))
    }

}

open class BearerTokenAuthentication: HeaderAuthentication {

    public init(token: String) {
        super.init(value: "Bearer " + token)
    }

}

open class CustomTokenAuthentication: HeaderAuthentication {

    public init(token: String, format: String = "Token token=%@") {
        super.init(value: String(format: format, token))
    }

}
