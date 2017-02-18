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
import WebAPIKit

class RawValueWrappersSpec: QuickSpec {

    override func spec() {

        it("should be Equatable") {

            expect(StatusCode.code201 == StatusCode(rawValue: 201)).to(beTrue())
            expect(StatusCode.code201 != .code202).to(beTrue())

            expect(RequestHeaderKey.accept == "Accept").to(beTrue())
            expect(RequestHeaderKey.accept != "").to(beTrue())

            expect(200 == StatusCode.code200).to(beTrue())
            expect(201 != StatusCode.code200).to(beTrue())
        }

        it("should be Hashable") {
            var headers = [ResponseHeaderKey: String]()
            headers[.eTag] = "e01"
            expect(headers[.eTag]) == "e01"
            headers[.eTag] = "e02"
            expect(headers[.eTag]) == "e02"
        }

    }

}
