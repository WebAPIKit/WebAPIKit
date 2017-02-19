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

class SenderSpec: QuickSpec {

    override func spec() {

        var api: TestAPI!
        var client: StubHTTPClient!
        var result: WebAPIResult?
        beforeEach {
            api = TestAPI()
            client = api.stubClient(using: StubHTTPClient())
            result = nil
        }

        it("send to http client") {
            client.stub(path: "/users")
            api.getUsers().send { result = $0 }
            expect(result).notTo(beNil())
        }

        it("can be canceled") {
            let stub = client.stub(path: "/users").withMode(.manual)
            let task = api.getUsers().send { result = $0 }
            task.cancel()
            stub.lastConnection?.respond()
            expect(result).to(beNil())
        }

    }

}

private final class TestAPI: StubbableProvider {
    let baseURL = URL(string: "http://test.api/v1")!
    var httpClient: HTTPClient?

    func getUsers() -> WebAPIRequest {
        return makeRequest(path: "/users")
    }
}
