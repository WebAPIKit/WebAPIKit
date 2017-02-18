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
import Quick
import Nimble
import WebAPIKit

class StubHTTPClientStubSpec: QuickSpec {

    override func spec() {

        let request = URLRequest(url: URL(string: "http://test.stub/api/v1/users/1?x=1&y=2")!)
        var client: StubHTTPClient!
        beforeEach {
            client = StubHTTPClient()
        }

        it("compare url path and http method") {
            expect(client.stub(path: "/api/v1/users/1/v").match(request)) == false
            expect(client.stub(path: "/api/v1/users/1").match(request)) == true
            expect(client.stub(path: "/api/v1/users").match(request)) == false
            expect(client.stub(path: "users/1").match(request)) == false

            expect(client.stub(path: "/api/v1/users/1/v", mode: .prefix).match(request)) == false
            expect(client.stub(path: "/api/v1/users/1", mode: .prefix).match(request)) == true
            expect(client.stub(path: "/api/v1/users", mode: .prefix).match(request)) == true
            expect(client.stub(path: "users/1", mode: .prefix).match(request)) == false

            expect(client.stub(path: "/api/v1/users/1/v", mode: .suffix).match(request)) == false
            expect(client.stub(path: "/api/v1/users/1", mode: .suffix).match(request)) == true
            expect(client.stub(path: "/api/v1/users", mode: .suffix).match(request)) == false
            expect(client.stub(path: "users/1", mode: .suffix).match(request)) == true

            expect(client.stub(path: "/api/v1/users/1/v", mode: .contains).match(request)) == false
            expect(client.stub(path: "/api/v1/users/1", mode: .contains).match(request)) == true
            expect(client.stub(path: "/api/v1/users", mode: .contains).match(request)) == true
            expect(client.stub(path: "/users/1", mode: .contains).match(request)) == true
            expect(client.stub(path: "/users", mode: .contains).match(request)) == true

            expect(client.stub(path: "/users", mode: .contains, method: .post).match(request)) == false

            expect(client.stub { $0.pathContains("users") && $0.methodEqualTo(.get) } .match(request)) == true
            expect(client.stub { $0.pathContains("users") && $0.methodEqualTo(.post) } .match(request)) == false
        }

    }

}
