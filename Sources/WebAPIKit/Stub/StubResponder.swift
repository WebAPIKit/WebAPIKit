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

/// A stub responder that handle matched connections.
open class StubResponder: StubConnectionLogger {

    public typealias Match = (URLRequest) -> Bool
    public typealias Stub = (Data?, HTTPURLResponse?, Error?)
    public typealias Factory = (StubConnection) -> Stub

    public enum Mode {
        case immediate
        case sync(DispatchQueue?)
        case async(DispatchQueue?)
        case delay(TimeInterval, DispatchQueue?)
        case manual
    }

    public var match: Match
    public var connections = [StubConnection]()

    public var mode: Mode = .immediate

    public var factory: Factory?

    public var error: Error?
    public var data: Data?
    public var status: StatusCode?
    public var headers: [String: String]?

    public init(match: @escaping Match = { _ in true }) {
        self.match = match
    }

    open func connect(_ connection: StubConnection) {
        connections.append(connection)
        connection.responder = self
        switch mode {
        case .immediate:
            respond(to: connection)
        case .sync(let queue):
            (queue ?? connection.queue ?? .main).sync {
                self.respond(to: connection)
            }
        case .async(let queue):
            (queue ?? connection.queue ?? .main).async {
                self.respond(to: connection)
            }
        case .delay(let seconds, let queue):
            let when = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            (queue ?? connection.queue ?? .main).asyncAfter(deadline: when) {
                self.respond(to: connection)
            }
        case .manual: break
        }
    }

    open func respond(to connection: StubConnection) {
        guard connection.isActive else { return }

        let stub = makeStub(for: connection)
        connection.respond(data: stub.0, response: stub.1, error: stub.2)
    }

    open func makeStub(for connection: StubConnection) -> Stub {
        if let factory = factory {
            return factory(connection)
        }
        if let error = error {
            return (nil, nil, error)
        }
        return (data, makeResponse(for: connection), nil)
    }

    open func makeResponse(for connection: StubConnection) -> HTTPURLResponse? {
        let url = connection.request.url ?? URL(string: "http://test.stub")!
        let statusCode = (status ?? .code200).rawValue
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: headers)
    }

}
