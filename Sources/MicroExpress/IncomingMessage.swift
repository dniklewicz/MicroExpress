// File: IncomingMessage.swift - create this in Sources/MicroExpress

import Foundation
import NIOHTTP1

open class IncomingMessage {
    public let remoteAddress: String?
    public let header: HTTPRequestHead
    public var userInfo = [ String: Any ]()
    public var body: Data?

    init(remoteAddress: String?, header: HTTPRequestHead) {
        self.remoteAddress = remoteAddress
        self.header = header
    }
}
