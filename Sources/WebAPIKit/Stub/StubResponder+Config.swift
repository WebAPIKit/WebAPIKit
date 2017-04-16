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

extension StubResponseConfigurer {

    @discardableResult
    public func withError(_ error: Error) -> Self {
        response.error = error
        return self
    }

    @discardableResult
    public func withData(_ data: Data) -> Self {
        response.data = data
        return self
    }

    @discardableResult
    public func withStatus(_ status: StatusCode) -> Self {
        response.status = status
        return self
    }

    @discardableResult
    public func withHeaders(_ headers: [String: String]) -> Self {
        response.headers = headers
        return self
    }

    @discardableResult
    public func withHeaders(_ headers: [ResponseHeaderKey: String]) -> Self {
        var mapped = [String: String]()
        headers.forEach { mapped[$0.rawValue] = $1 }
        response.headers = mapped
        return self
    }

    @discardableResult
    public func withHeader(_ key: ResponseHeaderKey, value: String) -> Self {
        var headers = response.headers ?? [String: String]()
        headers[key.rawValue] = value
        response.headers = headers
        return self
    }

    @discardableResult
    public func withJSON(_ json: Any, options: JSONSerialization.WritingOptions = []) -> Self {
        do {
            response.data = try JSONSerialization.data(withJSONObject: json, options: options)
        } catch {
            print(error)
        }
        return self
    }

    /// Stub data from a file
    @discardableResult
    public func withFileURL(_ url: URL) -> Self {
        do {
            response.data = try Data(contentsOf: url)
        } catch {
            print(error)
        }
        return self
    }

    /// Stub data from json file
    @discardableResult
    public func withJSONFile(_ name: String, in bundle: Bundle? = nil) -> Self {
        if let url = (bundle ?? Bundle.main).url(forResource: name, withExtension: "json") {
            return withFileURL(url)
        }
        return self
    }

}

extension StubResponder {
    @discardableResult
    public func withMode(_ mode: Mode) -> Self {
        self.mode = mode
        return self
    }
    
    @discardableResult
    public func withFactory(_ factory: @escaping Factory) -> Self {
        self.factory = factory
        return self
    }
    
}
