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
import Alamofire
import WebAPIKit

class StubResponderPathTemplateSpec: QuickSpec {

    override func spec() {

        let provider = StubProvider()
        var client: StubHTTPClient!
        beforeEach {
            client = StubHTTPClient(provider: provider)
        }

        it("match path template") {
            let stub = client.stub(template: "/users/{id}")
            expect(stub.match(provider.request(path: "/users/1"))) == true
            expect(stub.match(provider.request(path: "/users"))) == false
            expect(stub.match(provider.request(path: "/repos/1"))) == false

            let postStub = client.stub(template: "/users/{id}", method: .post)
            expect(postStub.match(provider.request(path: "/users/1"))) == false
            expect(postStub.match(provider.request(path: "/users/1", method: .put))) == false
            expect(postStub.match(provider.request(path: "/users/1", method: .post))) == true
        }

    }

}

private final class StubProvider: WebAPIProvider {
    let baseURL = URL(string: "http://test.stub/api/v1")!
    func request(path: String, method: HTTPMethod = .get) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
