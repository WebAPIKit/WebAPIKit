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
@testable import WebAPIKit

class StubResponderSpec: QuickSpec {

    override func spec() {

        let url = URL(string: "http://test.stub")!
        let request = URLRequest(url: url)

        var connection: StubConnection!
        var responder: StubResponder!
        var result: (Data?, HTTPURLResponse?, Error?)?
        beforeEach {
            connection = StubConnection(request: request, queue: nil) {
                result = ($0, $1, $2)
            }
            responder = StubResponder()
        }

        it("should respond `200 OK` by default") {
            responder.connect(connection)
            expect(result?.1?.statusCode) == 200
        }

        it("should use factory") {
            let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
            responder.withFactory { (nil, response, nil) }
                .connect(connection)
            expect(result?.1?.statusCode) == 400
        }

        it("should check error") {
            responder.withError(WebAPIError.noResponse).connect(connection)
            switch result?.2 {
            case WebAPIError.noResponse?: break
            default: fail()
            }
        }

        it("should use configs") {
            responder
                .withStatus(.code400)
                .withHeader(.allow, value: "NA")
                .withJSON([0, 1])
                .connect(connection)

            guard let data = result?.0, let response = result?.1 else {
                return fail("no response")
            }
            guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [Int] else {
                return fail("no json")
            }
            expect(json) == [0, 1]
            expect(response.statusCode) == 400
            expect(response.value(forHeaderKey: .allow)) == "NA"
        }

    }

}
