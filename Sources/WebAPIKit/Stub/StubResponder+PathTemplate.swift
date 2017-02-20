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

/// A stub responder that handle matched connections with path template.
open class PathTemplateResponder: StubResponder {

    public let template: StubPathTemplate
    public init(template: StubPathTemplate, match: @escaping Match) {
        self.template = template
        super.init(match: match)
    }

    public typealias TemplatedFactory = (StubPathTemplate.VariableValues, StubConnection) -> Stub
    public var templatedFactory: TemplatedFactory?

    open override func makeStub(for connection: StubConnection) -> Stub {
        if let templatedFactory = templatedFactory {
            return templatedFactory(templateVariables(for: connection), connection)
        }
        return super.makeStub(for: connection)
    }

    open func templateVariables(for connection: StubConnection) -> [String: String] {
        if let path = connection.request.url?.path {
            return template.parse(path)
        }
        return [:]
    }

}

// MARK: Match
extension StubHTTPClient {

    @discardableResult
    public func stub(template: String, match: @escaping (StubRequestMatcher) -> Bool) -> PathTemplateResponder {
        let template = StubPathTemplate(template)
        let responder = PathTemplateResponder(template: template) {
            let matcher = StubRequestMatcher(request: $0, provider: self.provider)
            guard let path = matcher.requestPath, template.match(path) else { return false }
            return match(matcher)
        }
        stub(responder: responder)
        return responder
    }

    @discardableResult
    public func stub(template: String, method: HTTPMethod? = nil) -> PathTemplateResponder {
        return stub(template: template) { matcher in
            if let method = method {
                return matcher.methodEqualTo(method)
            } else {
                return true
            }
        }
    }

}

// MARK: Response
extension PathTemplateResponder {

    @discardableResult
    public func withTemplatedFactory(_ templatedFactory: @escaping TemplatedFactory) -> Self {
        self.templatedFactory = templatedFactory
        return self
    }

    /// Stub data according to path template variable values, or 404 if no data.
    @discardableResult
    public func withTemplatedData(_ block: @escaping (StubPathTemplate.VariableValues) -> Data?) -> Self {
        return withTemplatedFactory { values, connection in
            guard let data = block(values) else {
                return (nil, connection.makeResponse(status: .code404), nil)
            }
            return (data, self.makeResponse(for: connection), nil)
        }
    }

    /// Stub json data according to path template variable values, or 404 if no data.
    @discardableResult
    public func withTemplatedJSON(_ block: @escaping (StubPathTemplate.VariableValues) -> Any?) -> Self {
        return withTemplatedData {
            block($0).flatMap { try? JSONSerialization.data(withJSONObject: $0, options: []) }
        }
    }

    /// Stub data from file url according to path template variable values, or 404 if no data.
    @discardableResult
    public func withTemplatedFile(_ block: @escaping (StubPathTemplate.VariableValues) -> URL?) -> Self {
        return withTemplatedData {
            block($0).flatMap { try? Data(contentsOf: $0) }
        }
    }

}
