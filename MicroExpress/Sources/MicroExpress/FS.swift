//
//  FS.swift
//  MicroExpress
//
//  Created by Helge Hess on 20.03.18.
//  Copyright © 2018 ZeeZide GmbH. All rights reserved.
//

import NIO

public enum fs {

    static let threadPool: BlockingIOThreadPool = {
        let tp = BlockingIOThreadPool(numberOfThreads: 4)
        tp.start()
        return tp
    }()

    static let fileIO = NonBlockingFileIO(threadPool: threadPool)

    public static
    func readFile(_ path: String,
                  eventLoop: EventLoop? = nil,
                  maxSize: Int = 1024 * 1024,
                  _ cb: @escaping ( Error?, ByteBuffer? ) -> Void) {
        let eventLoop = eventLoop
            ?? MultiThreadedEventLoopGroup.currentEventLoop
            ?? loopGroup.next()

        func emit(error: Error? = nil, result: ByteBuffer? = nil) {
            if eventLoop.inEventLoop { cb(error, result) } else { eventLoop.execute { cb(error, result) } }
        }

        threadPool.submit {
            assert($0 == .active, "unexpected cancellation")

            let fh: NIO.FileHandle
            do { // Blocking:
                fh = try NIO.FileHandle(path: path)
            } catch { return emit(error: error) }

            fileIO.read(fileHandle: fh, byteCount: maxSize,
                        allocator: ByteBufferAllocator(),
                        eventLoop: eventLoop)
                .map { try? fh.close(); emit(result: $0) }
                .whenFailure { try? fh.close(); emit(error: $0) }
        }
    }
}
