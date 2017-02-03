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

/// Abstract protocol for all plugins.
public protocol WebAPIPlugin {
}

/// Plugin to process requests before send out.
public protocol RequestProcessor: WebAPIPlugin {
    func processRequest(_ request: URLRequest) throws -> URLRequest
}

/// Plugin as a hook before sending requests out.
public protocol RequestHook: WebAPIPlugin {
    func willSendRequest(_ request: URLRequest)
}

public final class PluginHub {

    var requestProcessors = [RequestProcessor]()
    var requestHooks = [RequestHook]()

    @discardableResult
    func add(_ plugin: WebAPIPlugin) -> Self {
        if let plugin = plugin as? RequestProcessor {
            requestProcessors.append(plugin)
        }
        if let plugin = plugin as? RequestHook {
            requestHooks.append(plugin)
        }
        return self
    }

    @discardableResult
    func addRequestProcessor(_ plugin: RequestProcessor) -> Self {
        requestProcessors.append(plugin)
        return self
    }

    @discardableResult
    func addRequestHook(_ plugin: RequestHook) -> Self {
        requestHooks.append(plugin)
        return self
    }

}
