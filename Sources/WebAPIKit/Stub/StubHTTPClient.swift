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

/// Stub http client sends requests to `StubHTTPServer`.
open class StubHTTPClient: HTTPClient, StubConnectionLogger {

    public var passthroughClient: HTTPClient?
    public init(passthroughClient: HTTPClient? = nil) {
        self.passthroughClient = passthroughClient
    }

    public var responders = [StubResponder]()
    public var connections = [StubConnection]()

    open func send(_ urlRequest: URLRequest, queue: DispatchQueue?, handler: @escaping HTTPHandler) -> Cancelable {

        var targetResponder: StubResponder?
        for responder in responders {
            if responder.match(urlRequest) {
                targetResponder = responder
                break
            }
        }

        if targetResponder == nil, let passthroughClient = passthroughClient {
            return passthroughClient.send(urlRequest, queue: queue, handler: handler)
        }

        let connection = StubConnection(request: urlRequest, queue: queue, handler: handler)
        connections.append(connection)
        targetResponder?.connect(connection)
        return connection
    }

}

extension StubHTTPClient {

    /// Create a `StubHTTPServer` that handles all requests.
    public func stub() -> StubResponder {
        let responder = StubResponder()
        responders.append(responder)
        return responder
    }

}
