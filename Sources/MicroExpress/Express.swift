// File: Express.swift - create this in Sources/MicroExpress

import Foundation
import NIO
import NIOFoundationCompat
import NIOHTTP1

let loopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

open class Express: Router {

    override public init() {}

    private func createServerBootstrap(_ backlog: Int) -> ServerBootstrap {
        let reuseAddrOpt = ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET),
                                                 SO_REUSEADDR)
        let bootstrap = ServerBootstrap(group: loopGroup)
            .serverChannelOption(ChannelOptions.backlog, value: Int32(backlog))
            .serverChannelOption(reuseAddrOpt, value: 1)

            .childChannelInitializer { channel in
                return channel.pipeline.configureHTTPServerPipeline().flatMap {
                    _ in
                    channel.pipeline.addHandler(HTTPHandler(router: self))
                }
            }

            .childChannelOption(ChannelOptions.socket(
                                    IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(reuseAddrOpt, value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead,
                                value: 1)
        return bootstrap
    }

    open func listen(unixSocket: String = "express.socket",
                     backlog: Int    = 256) {
        let bootstrap = self.createServerBootstrap(backlog)

        do {
            let serverChannel =
                try bootstrap.bind(unixDomainSocketPath: unixSocket)
                .wait()
            print("Server running on:", socket)

            try serverChannel.closeFuture.wait() // runs forever
        } catch {
            fatalError("failed to start server: \(error)")
        }
    }

    open func listen(_ port: Int    = 1337,
                     _ host: String = "localhost",
                     _ backlog: Int    = 256) {
        let bootstrap = self.createServerBootstrap(backlog)

        do {
            let serverChannel =
                try bootstrap.bind(host: host, port: port)
                .wait()
            print("Server running on:", serverChannel.localAddress!)

            try serverChannel.closeFuture.wait() // runs forever
        } catch {
            fatalError("failed to start server: \(error)")
        }
    }

    final class HTTPHandler: ChannelInboundHandler {
        typealias InboundIn = HTTPServerRequestPart

        let router: Router
        private var incomingMessage: IncomingMessage?

        init(router: Router) {
            self.router = router
        }

        func channelRead(context: ChannelHandlerContext, data: NIOAny) {
            let reqPart = self.unwrapInboundIn(data)
            
            switch reqPart {
            case .head(let header):
                incomingMessage = IncomingMessage(remoteAddress: context.remoteAddress?.ipAddress, header: header)
            case let .body(buffer):
                guard let request = incomingMessage else { break }
                let data = buffer.getData(at: buffer.readerIndex, length: buffer.readableBytes)
                if request.body != nil, let data = data {
                    request.body?.append(data)
                } else {
                    request.body = data
                }
            case .end:
                let res = ServerResponse(channel: context.channel)
                // trigger Router
                if let req = incomingMessage {
                    router.handle(request: req, response: res) {
                        (_: Any...) in // the final handler
                        res.status = .notFound
                        res.send("No middleware handled the request!")
                    }
                }
            }
        }

        func errorCaught(context: ChannelHandlerContext, error: Error) {
            print("socket error, closing connection:", error)
            context.close(promise: nil)
        }
    }
}
