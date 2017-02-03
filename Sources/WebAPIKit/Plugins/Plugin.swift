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

public protocol WebAPIPlugin {
}

public protocol RequestProcessor: WebAPIPlugin {
    func processRequest(_ request: URLRequest) throws -> URLRequest
}

public protocol RequestObserver: WebAPIPlugin {
    func didSentRequest(_ request: URLRequest)
}

public final class PluginHub {

    var requestProcessors = [RequestProcessor]()
    var requestObservers = [RequestObserver]()

    @discardableResult
    func add(_ plugin: WebAPIPlugin) -> Self {
        if let plugin = plugin as? RequestProcessor {
            requestProcessors.append(plugin)
        }
        if let plugin = plugin as? RequestObserver {
            requestObservers.append(plugin)
        }
        return self
    }

    @discardableResult
    func addRequestProcessor(_ plugin: RequestProcessor) -> Self {
        requestProcessors.append(plugin)
        return self
    }

    @discardableResult
    func addRequestObserver(_ plugin: RequestObserver) -> Self {
        requestObservers.append(plugin)
        return self
    }

}
