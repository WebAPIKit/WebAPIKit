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
import Result

public typealias WebAPIResult = Result<WebAPIResponse, WebAPIError>

public struct WebAPIResponse {

    public let status: StatusCode
    public let headers: [AnyHashable : Any]
    public let data: Data?
    public init(status: StatusCode = .code200, headers: [AnyHashable : Any] = [:], data: Data? = nil) {
        self.status = status
        self.headers = headers
        self.data = data
    }

}

public enum ResponseDecodeError: Error {
    case noData, invalidData(Any), unsupported
}

public protocol ResponseData {
    static func decode(_ data: Data) throws -> Self
    static func decodeList(_ data: Data) throws -> [Self]
}

extension ResponseData {
    public static func decode(_ data: Data) throws -> Self {
        throw ResponseDecodeError.unsupported
    }
    public static func decodeList(_ data: Data) throws -> [Self] {
        throw ResponseDecodeError.unsupported
    }
}

extension ResponseData {

    public static func map(_ result: WebAPIResult) -> Result<Self, WebAPIError> {
        return mapResult(result, transform: decode)
    }

    public static func mapList(_ result: WebAPIResult) -> Result<[Self], WebAPIError> {
        return mapResult(result, transform: decodeList)
    }

    private static func mapResult<T>(_ result: WebAPIResult, transform: (Data) throws -> T) -> Result<T, WebAPIError> {
        return result.flatMap { response in
            guard let data = response.data else {
                return .failure(.invalidResponse(ResponseDecodeError.noData))
            }
            do {
                return .success(try transform(data))
            } catch {
                return .failure(.invalidResponse(error))
            }
        }
    }

}

public protocol ResponseJSONData: ResponseData {
    associatedtype JSONType
    init(json: JSONType) throws
}

extension ResponseJSONData {
    public static func decode(_ data: Data) throws -> Self {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONType else {
            throw ResponseDecodeError.invalidData(data)
        }
        return try self.init(json: json)
    }
    public static func decodeList(_ data: Data) throws -> [Self] {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [JSONType] else {
            throw ResponseDecodeError.invalidData(data)
        }
        return try json.map { try self.init(json: $0) }
    }
}
