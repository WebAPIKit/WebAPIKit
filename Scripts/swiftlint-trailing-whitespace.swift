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

let fileManager = FileManager.default
let regExp = try! NSRegularExpression(pattern: " +$", options: [.anchorsMatchLines])

@available (OSX 10.11, *)
func main() {
    let pwdURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
    let scriptURL = URL(fileURLWithPath: #file, relativeTo: pwdURL)
    let rootURL = scriptURL.appendingPathComponent("../../")
    ["Sources", "Tests", "Scripts"].forEach {
        cleanDir(rootURL.appendingPathComponent($0))
    }
}

@available (OSX 10.11, *)
func clean(at url: URL) {
    var isDir = ObjCBool(false)
    fileManager.fileExists(atPath: url.path, isDirectory: &isDir)
    if isDir.boolValue {
        cleanDir(url)
    } else {
        cleanFile(url)
    }
}

@available (OSX 10.11, *)
func cleanDir(_ url: URL) {
    do {
        try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).forEach(clean)
    } catch {
        print(error)
    }
}

@available (OSX 10.11, *)
func cleanFile(_ url: URL) {
    do {
        let text = try String(contentsOf: url)
        let range = NSRange(location: 0, length: text.utf16.count)
        let result = regExp.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        if result != text {
            try result.write(to: url, atomically: true, encoding: .utf8)
            print("Cleaned: \(url)")
        }
    } catch {
        print(error)
    }
}

if #available(OSX 10.11, *) {
    main()
} else {
    print("Only available on OS X 10.11 or newer")
    exit(1)
}
