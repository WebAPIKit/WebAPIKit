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

import Alamofire

//==========================================================
// MARK: - Import Alamofire Types
//==========================================================
public typealias AFError = Alamofire.AFError
public typealias HTTPMethod = Alamofire.HTTPMethod
public typealias HTTPHeaders = Alamofire.HTTPHeaders
public typealias Parameters = Alamofire.Parameters
public typealias ParameterEncoding = Alamofire.ParameterEncoding
public typealias URLEncoding = Alamofire.URLEncoding
public typealias SessionManager = Alamofire.SessionManager

//==========================================================
// MARK: - Utility Types & Extensions
//==========================================================

/// A wrapper for `Hashable` raw value, normaly utilty structs for `String` keys or `Int` values.
public protocol RawValueWrapper: RawRepresentable, Hashable {
    associatedtype RawValue: Hashable
    init(_: RawValue)
}

extension RawValueWrapper {

    public init(rawValue: RawValue) {
        self.init(rawValue)
    }

    public var hashValue: Int {
        return rawValue.hashValue
    }

    public static func == (lhs: RawValue, rhs: Self) -> Bool {
        return lhs == rhs.rawValue
    }

    public static func == (lhs: Self, rhs: RawValue) -> Bool {
        return lhs.rawValue == rhs
    }

    public static func != (lhs: RawValue, rhs: Self) -> Bool {
        return lhs != rhs.rawValue
    }

    public static func != (lhs: Self, rhs: RawValue) -> Bool {
        return lhs.rawValue != rhs
    }

}

/// A type that can be canceled.
public protocol Cancelable {
    func cancel()
}
