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

import Quick
import Nimble
@testable import WebAPIKit

class WebAPIRequestSpec: QuickSpec {

    override func spec() {

        var provider: StubProvider!
        var request: WebAPIRequest!
        beforeEach {
            provider = StubProvider()
            request = provider.makeRequest(path: "test")
        }

        describe("toURLRequest()") {

            it("check requireAuthentication of request then provider") {
                request.requireAuthentication = false
                provider.requireAuthentication = false
                expect { try request.toURLRequest() }.toNot(throwError())

                request.requireAuthentication = false
                provider.requireAuthentication = true
                expect { try request.toURLRequest() }.toNot(throwError())

                request.requireAuthentication = true
                provider.requireAuthentication = false
                expect { try request.toURLRequest() }.to(throwError(AuthenticationError.missing))

                request.requireAuthentication = true
                provider.requireAuthentication = true
                expect { try request.toURLRequest() }.to(throwError(AuthenticationError.missing))

                request.requireAuthentication = nil
                provider.requireAuthentication = false
                expect { try request.toURLRequest() }.toNot(throwError())

                request.requireAuthentication = nil
                provider.requireAuthentication = true
                expect { try request.toURLRequest() }.to(throwError(AuthenticationError.missing))
            }

            it("use authentication of request over provider") {
                request.requireAuthentication = true
                provider.authentication = StubAuthentication()
                expect { try request.toURLRequest() }.to(throwError(AuthenticationError.invalid))

                let requestAuth = StubAuthentication()
                requestAuth.isValid = true
                request.authentication = requestAuth
                expect { try request.toURLRequest() }.toNot(throwError())
            }

        }

    }

}

private final class StubAuthentication: WebAPIAuthentication {
    var isValid = false
    func authenticate(_ request: URLRequest) throws -> URLRequest {
        guard isValid else { throw AuthenticationError.invalid }
        return request
    }
}

private final class StubProvider: WebAPIProvider {
    let baseURL = URL(string: "http://test.stub")!
    var requireAuthentication = false
    var authentication: WebAPIAuthentication?
}
