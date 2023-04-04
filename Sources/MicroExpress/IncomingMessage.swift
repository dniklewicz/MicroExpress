// File: IncomingMessage.swift - create this in Sources/MicroExpress

import Foundation
import NIOHTTP1

open class IncomingMessage {
    public let header: HTTPRequestHead
    public var userInfo = [ String: Any ]()
    public var body: Data?

    init(header: HTTPRequestHead) {
        self.header = header
    }
}
