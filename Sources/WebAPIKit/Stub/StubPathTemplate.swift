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

/// A url path template contains variables as `{name}`. Like "/api/v{version}/{owner}/{repo}/tags".
public struct StubPathTemplate {

    fileprivate var variables: [String]
    fileprivate var pattern: String?

    fileprivate let template: String
    public init(_ template: String) {
        self.template = template

        var variables = [String]()
        var pattern = template as NSString

        // swiftlint:disable:next force_try
        let regExp = try! NSRegularExpression(pattern: "\\{\\w*?\\}", options: [])
        for match in regExp.matches(in: template, options: [], range: template.nsRange).reversed() {
            let range = match.range
            guard range.length > 2 else { continue }

            let nameRange = NSRange(location: range.location + 1, length: range.length - 2)
            variables.append(pattern.substring(with: nameRange))

            pattern = pattern.replacingCharacters(in: range, with: "(\\w*?)") as NSString
        }

        self.variables = variables.reversed()
        self.pattern = pattern as String
    }

}

extension StubPathTemplate {

    /// Check if a path matches the template.
    public func match(_ path: String) -> Bool {
        guard let pattern = pattern else { return false }
        let regExp = try? NSRegularExpression(pattern: "^\(pattern)$", options: [])
        return regExp?.firstMatch(in: path, options: [], range: path.nsRange) != nil
    }

    public typealias VariableValues = [String: String]
    /// Parse variables from a path.
    public func parse(_ path: String) -> VariableValues {
        var data = [String: String]()

        guard variables.count > 0 else { return data }

        guard let pattern = pattern else { return data }
        let regExp = try? NSRegularExpression(pattern: "\(pattern)$", options: [])
        guard let match = regExp?.firstMatch(in: path, options: [], range: path.nsRange) else { return data }

        let nsPath = path as NSString
        for i in 1 ..< match.numberOfRanges {
            data[variables[i - 1]] = nsPath.substring(with: match.rangeAt(i))
        }

        return data
    }

}

private extension String {
    var nsRange: NSRange {
        return NSRange(location: 0, length: characters.count)
    }
}
