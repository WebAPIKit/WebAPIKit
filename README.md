**WebAPIKit** is a network abstraction layer to build web API clients. 

## Features

### Easy to setup 

```swift
final class GitHubAPI: WebAPIProvider {
    let baseURL = URL(string: "https://api.github.com")!
    func getUser(login: String, handler: @escaping ResultHandler) {
        makeRequest(path: "/users/\(login)").send(handler: handler)
    }
}
GitHubAPI().getUser(login: "WebAPIKit") {
    if case .success(let response) = $0, response.status.isSuccess {
        // Read from response.data and/or response.headers
    }
}

```

### Strong typed response

(Using [Marshal](https://github.com/utahiosmac/Marshal) for json parsing here but you can use any library as your choice)

```swift
struct User: ResponseJSONData {
    var login: String
    var name: String?
    init(json: [String: Any]) throws {
        login = try json.value(for: "login")
        name = try json.value(for: "name")
    }
}
extension GitHubAPI {
    func getUser(login: String, handler: @escaping (Result<User, WebAPIError>) -> Void) {
        makeRequest(path: "/users/\(login)").sendAndDecode(handler: handler)
    }
}
GitHubAPI().getUser(login: "WebAPIKit") {
    if case .success(let user) = $0 {
        // user is of type User
    }
}
```

### Plugins

```swift
final class GitHubAPI: WebAPIProvider {
    let baseURL = URL(string: "https://api.github.com")!
    let plugins = PluginHub()
        .addRequestProcessor(RequestHeaderSetter(key: .accept, value: "application/vnd.github.v3+json"))
        .addResponseProcessor(ResponseStatusValidator())
}
```

Requests can also have their own plugins: 

```swift
extension GitHubAPI {
    func getUser(login: String, handler: @escaping ResultHandler) {
        makeRequest(path: "/users/\(login)").addPlugin(MyRequestHook()).send(handler: handler)
    }
}
```

### Authentication

```swift
final class MyServerAPI: WebAPIProvider {
    let baseURL = URL(string: "https://my-server.com/api/v1")!
    let requireAuthentication = true
    var authentication: WebAPIAuthentication = NoneAuthentication()
}
class MyLoginController {
    func login(user: String, password: String) {
        myServer.authentication = BasicAuthentication(user: user, password: password)
    }
}
```

Requests will not be sent if `requireAuthentication` is true but there is no valid authentication. Except some endpoints may not require authentication. 

```swift 
extension MyServerAPI {
    func sayHi(message: String, handler: @escaping ResultHandler) {
        makeRequest(path: "/hi", method: .post)
            .addParameter(key: "message", value: message)
            .setRequireAuthentication(false)
            .send(handler: handler)
    }
}
```

### Stub

```swift
final class GitHubAPI: StubbableProvider {
    let baseURL = URL(string: "https://api.github.com")!
    var httpClient: HTTPClient? // Use Alamofire.SessionManager.default if not defined
}
// Stub for development
class SomeBusyClass {
    fucn someMethod() {
        let client = gitHub.stubClient()
        client.stub(path: "/users", method: .post).withStatus(.code201)
        client.stub(template: "/users/{login}").withTemplatedJSON { ["login": $0["login"]!, "name": "User"] }
        client.stub().withStatus(.code404) // All other requests will fail with 404
    }
}
// Stub for testing
class SomeTestCase {
    func testSomeMethod() {
        // ... After stub setup
        client.stub(path: "/users").withJSON([["login": "test", "name": "Tester"]])
        client.stub(path: "/users", method: .post).withStatus(.code201).withMode(.manual)

        // ... After some method calls
        XCTAssertTrue(client.hasConnection)
        
        client.lastConnection!.respond() // For POST /users. GET /users will respond with json data automatically
        // ... Verify success behaviour 

        XCTAssertFalse(client.hasActiveConnection) // No connection that is not yet responded to or canceled
    }
}
```

### Cancel requests

```swift
extension GitHubAPI {
    func getUser(login: String, handler: @escaping ResultHandler) -> Cancelable {
        return makeRequest(path: "/users/\(login)").send(handler: handler)
    }
}
class SomeClass {
    func someMethod() {
        let connection = gitHub.getUser(login: "WebAPIKit") { ... }
        
        // No longer needed now
        connection.cancel()
    }
}
```

## TODO

WebAPIKit is still working in progress. 

Before Release: 

- [ ] OAuth support
- [ ] Reactive Extensions (RxSwift & ReactiveSwift)
- [ ] Higher test coverage (currently 62.5%)
- [ ] Documentation
- [ ] Demo app [GitHubExplorer](https://github.com/evan-liu/GitHubExplorer)

Furture versions (or extension libraries): 

- [ ] Request queues
- [ ] REST resources
