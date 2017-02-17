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

/// A stub type to handle a http request.
open class StubConnection: Cancelable {

    public var request: URLRequest
    public var queue: DispatchQueue?
    public var handler: HTTPHandler
    public init(request: URLRequest, queue: DispatchQueue?, handler: @escaping HTTPHandler) {
        self.request = request
        self.queue = queue
        self.handler = handler
    }

    public var responder: StubResponder?
    public var isResponded = false
    public var isCanceled = false

    open func cancel() {
        guard !isActive else { return }

        isCanceled = true
    }

    open func respond(data: Data?, response: HTTPURLResponse?, error: Error?) {
        guard !isActive else { return }

        handler(data, response, error)
        isResponded = true
    }

    open func respond() {
        if let responder = responder {
            responder.respond(to: self)
        } else {
            respond(data: nil, response: nil, error: nil)
        }
    }

}

extension StubConnection {

    /// If the connection is not yet responded to or canceled.
    var isActive: Bool {
        return !isResponded && !isCanceled
    }

}

/// A type that log all connections.
public protocol StubConnectionLogger {
    /// All logged connections.
    var connections: [StubConnection] { get }
}

extension StubConnectionLogger {

    /// If there is any connection logged.
    public var hasConnection: Bool {
        return connections.count > 0
    }

    /// The last connection that is not sent to `passthroughClient`.
    public var lastConnection: StubConnection? {
        return connections.last
    }

    /// If there is any connection that is not yet responded to or canceled.
    public var hasActiveConnection: Bool {
        for connection in connections {
            if connection.isActive {
                return true
            }
        }
        return false
    }

}
