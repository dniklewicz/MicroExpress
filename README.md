<h2>µExpress
  <img src="http://zeezide.com/img/MicroExpressIcon1024.png"
       align="right" width="100" height="100" />
</h2>

![Swift 4](https://img.shields.io/badge/swift-4-blue.svg)
![Swift 5](https://img.shields.io/badge/swift-5-blue.svg)
![macOS](https://img.shields.io/badge/os-macOS-green.svg?style=flat)
![tuxOS](https://img.shields.io/badge/os-tuxOS-green.svg?style=flat)

A micro server framework on top of
[SwiftNIO](https://github.com/apple/swift-nio).

It adds an Express like API on top of the 
low level [SwiftNIO](https://github.com/apple/swift-nio/tree/2.12.0) API.
```swift
import MicroExpress

let app = Express()

app.get("/moo") { req, res, next in
  res.send("Muhhh")
}
app.get("/json") { _, res, _ in
  res.json([ "a": 42, "b": 1337 ])
}
app.get("/") { _, res, _ in
  res.send("Homepage")
}

app.listen(1337)
```


This package is part of the 
[Always Right Institute](http://www.alwaysrightinstitute.com)'s
blog series about the 
[Swift Server Workgroup](https://swift.org/server-apis/)'s
offical Swift
[HTTP API](https://github.com/swift-server/http).

- Blog series:
  - Part 3 [µExpress](https://www.alwaysrightinstitute.com/microexpress-nio2/)
  - Part 4 [µExpress/NIO Templates](https://www.alwaysrightinstitute.com/microexpress-nio-templates)
  - Old:
    - Part 1 [Using the Swift Server API 0.1.0](https://www.alwaysrightinstitute.com/http-010/)
    - Part 2 [µExpress](https://www.alwaysrightinstitute.com/microexpress/)
    - Part 3 [µExpress/NIO](https://www.alwaysrightinstitute.com/microexpress-nio)

Please checkout [Part 3](https://www.alwaysrightinstitute.com/microexpress-nio2)
of our blog series to learn what this is about.
This is a tiny framework, for a more full featured, *synchronous*
Express-like API in Swift, have a look at 
[ExExpress](https://github.com/modswift/ExExpress)
(as used in [ApacheExpress](http://apacheexpress.io)).
[Noze.io](http://noze.io) comes w/ an *asynchronous* variant (but is using
Dispatch, not SwiftNIO - stay tuned).

**Note:** There is [Macro.swift](https://github.com/Macro-swift), 
a more capable (and maintained) version of this.


## Using the Package

Micro Hello World in 5 minutes (or in 30s using the 
[swift-xcode image](#swift-xcode) below):

```shell
$ mkdir MicroHelloWorld && cd MicroHelloWorld
$ swift package init --type executable
```

Update `Package.swift` to include the dependency:
```swift
// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "MicroHelloWorld",
  dependencies: [
    .package(url: "https://github.com/NozeIO/MicroExpress.git", 
             from: "0.5.3")
  ],
  targets: [
    .target(name: "MicroHelloWorld",
            dependencies: [ "MicroExpress" ])
  ]
)
```

Change the `main.swift` from `print("Hello World")` into:
```swift
import MicroExpress

let app = Express()

app.get("/") { req, res, next in
  res.send("Hello World")
}

app.listen(1337)
```

```shell
$ swift build
$ swift run
```

Done. Access via: [http://localhost:1337/](http://localhost:1337/)


## Building the Package

### Xcode 11

Using Xcode 11 one can just open the `Package.swift` file.

### macOS / Linux Command Line

```shell
$ swift build
Fetching https://github.com/apple/swift-nio.git
Fetching https://github.com/AlwaysRightInstitute/mustache.git
Completed resolution in 5.97s
Cloning https://github.com/AlwaysRightInstitute/mustache.git
Resolving https://github.com/AlwaysRightInstitute/mustache.git at 0.5.9
Cloning https://github.com/apple/swift-nio.git
Resolving https://github.com/apple/swift-nio.git at 2.12.0
[100/100] Merging module MicroExpress
```

### Linux via macOS Docker

```shell
$ docker run --rm \
  -v "${PWD}:/src" \
  -v "${PWD}/.docker.build:/src/.build" \
  swift:5.1.3 \
  bash -c 'cd /src && swift build'
Unable to find image 'swift:5.1.3' locally
5.1.3: Pulling from library/swift
2746a4a261c9: Pull complete 
...
b5d1069a5aa4: Pull complete 
Digest: sha256:72d7e583452031ae88251263649fc56ea79f98f4147474080426fb5c1ff904aa
Status: Downloaded newer image for swift:5.1.3
Fetching https://github.com/apple/swift-nio.git
...
[99/99] Compiling MicroExpress Express.swift
[100/100] Merging module MicroExpress
```


### Links

- [SwiftNIO](https://github.com/apple/swift-nio)
- JavaScript Originals
  - [Connect](https://github.com/senchalabs/connect)
  - [Express.js](http://expressjs.com/en/starter/hello-world.html)
- Swift Apache
  - [mod_swift](http://mod-swift.org)
  - [ApacheExpress](http://apacheexpress.io)
- [Swiftmon/S](https://github.com/NozeIO/swiftmons)

### Who

**MicroExpress** is brought to you by
the
[Helge Heß](https://helgehess.eu)
and
[ZeeZide](https://zeezide.de).
We like 
[feedback](https://twitter.com/ar_institute), 
GitHub stars, 
cool [contract work](http://zeezide.com/en/services/services.html),
presumably any form of praise you can think of.

There is a `#microexpress` channel on the 
[Noze.io Slack](http://slack.noze.io/). Feel free to join!


### Want a Video Tutorial?

_(this one is still using SwiftXcode instead of the Xcode 11 SPM support)_

<img src="http://zeezide.com/img/swift-nio-cows.gif" />
