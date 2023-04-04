// swift-tools-version:5.0
//
//  Package.swift
//  MicroExpress
//
//  Created by Helge Hess on 09.03.18.
//  Copyright © 2018-2019 ZeeZide. All rights reserved.
//
import PackageDescription

let package = Package(
    name: "MicroExpress",

    products: [
        .library(name: "MicroExpress", targets: ["MicroExpress"])
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-nio-http2.git", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.32.2")
    ],

    targets: [
        .target(name: "MicroExpress",
                dependencies: [
                    .product(name: "NIOHTTP2", package: "swift-nio-http2"),
                    .product(name: "NIOFoundationCompat", package: "swift-nio")
                ])
    ]
)
