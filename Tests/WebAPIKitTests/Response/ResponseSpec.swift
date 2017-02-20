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

class WebAPIResponseDataSpec: QuickSpec {

    struct User: ResponseJSONData {
        let id: Int // swiftlint:disable:this variable_name
        init(json: [String: Any]) throws {
            guard let id = json["id"] as? Int else {
                throw ResponseDecodeError.invalidData(json)
            }
            self.id = id
        }
    }

    override func spec() {

        it("map json data") {
            let json1 = ["id": 1]
            let data1 = try? JSONSerialization.data(withJSONObject: json1, options: [])
            switch User.map(.success(WebAPIResponse(data: data1))) {
            case .success(let user): expect(user.id) == 1
            case .failure(let error): fail("\(error)")
            }

            let json2 = ["id": 2]
            let data12 = try? JSONSerialization.data(withJSONObject: [json1, json2], options: [])
            switch User.mapList(.success(WebAPIResponse(data: data12))) {
            case .success(let users): expect(users.map { $0.id }) == [1, 2]
            case .failure(let error): fail("\(error)")
            }
        }

    }

}
