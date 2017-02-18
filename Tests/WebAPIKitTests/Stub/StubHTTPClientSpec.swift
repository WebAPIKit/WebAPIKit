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

class StubHTTPClientSpec: QuickSpec {

    override func spec() {

        let request = URLRequest(url: URL(string: "/")!)
        var result: (data: Data?, response: HTTPURLResponse?, error: Error?)?
        var client: StubHTTPClient!
        beforeEach {
            client = StubHTTPClient()
        }
        afterEach {
            result = nil
        }

        func send() {
            _ = client.send(request, queue: nil) { data, response, error in
                result = (data, response, error)
            }
        }

        context("when there are matched responder") {
            it("connect responder") {
                client.stub().withStatus(.code201)
                send()
                expect(result?.response?.statusCode) == 201
            }
        }

        context("when there is no matched responder but passthroughClient") {
            it("send to passthroughClient") {
                let passthroughClient = client
                client = StubHTTPClient(passthroughClient: passthroughClient)
                send()
                expect(client.hasConnection) == false
                expect(passthroughClient?.hasConnection) == true
            }
        }

        context("when there is no matched responder or passthroughClient") {
            it("respond `200 OK` by default") {
                send()
                expect(result?.data).to(beNil())
                expect(result?.response?.statusCode) == 200
                expect(result?.error).to(beNil())
            }
        }

    }

}
