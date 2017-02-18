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

class StatusCodeSpec: QuickSpec {

    override func spec() {

        it("read category from value range") {
            expect(StatusCode(-1).category).to(beNil())
            expect(StatusCode(0).category).to(beNil())
            expect(StatusCode(90).category).to(beNil())

            expect(StatusCode(100).category) == StatusCode.Category.informational
            expect(StatusCode(299).category) == StatusCode.Category.success
            expect(StatusCode(300).category) == StatusCode.Category.redirection
            expect(StatusCode(499).category) == StatusCode.Category.clientError
            expect(StatusCode(500).category) == StatusCode.Category.serverError

            expect(StatusCode(600).category).to(beNil())
            expect(StatusCode(1000).category).to(beNil())
        }

        it("is success if it has category being neither clientError nor serverError") {
            expect(StatusCode(0).isSuccess) == false

            expect(StatusCode(100).isSuccess) == true
            expect(StatusCode(200).isSuccess) == true
            expect(StatusCode(300).isSuccess) == true

            expect(StatusCode(400).isSuccess) == false
            expect(StatusCode(500).isSuccess) == false

            expect(StatusCode(600).isSuccess) == false
        }

    }

}
