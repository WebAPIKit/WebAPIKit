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

class RequestConfigSpec: QuickSpec {

    override func spec() {

        let api = TestAPI()
        var request: WebAPIRequest!
        beforeEach {
            request = api.makeRequest(path: "test")
        }

        it("config http client") {
            let client1 = StubHTTPClient()
            let client2 = StubHTTPClient()

            request.setHttpClient(client1)
            request.send { _ in }
            expect(client1.connections.count) == 1
            expect(client2.connections.count) == 0

            request.setHttpClient(client2)
            request.send { _ in }

            expect(client1.connections.count) == 1
            expect(client2.connections.count) == 1
        }

    }

}

private final class TestAPI: WebAPIProvider {
    let baseURL = URL(string: "http://test.api/v1")!
}
