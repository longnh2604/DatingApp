//
//  SocketIOManager.swift
//  DatingApp
//
//  Created by LongNH8 on 14/5/25.
//

import Foundation
import SocketIO

class SocketIOManager {
    static let shared = SocketIOManager()

    private var manager: SocketManager?
    private var socket: SocketIOClient?

    private init() {}

    /// Connect to the socket server
    func establishConnection(to url: URL, with config: SocketIOClientConfiguration = []) {
        if manager == nil || socket == nil {
            manager = SocketManager(socketURL: url, config: config)
            socket = manager?.defaultSocket
        }

        socket?.on(clientEvent: .connect) { data, ack in
            print("Socket connected: \(data)")
        }

        socket?.on(clientEvent: .disconnect) { data, ack in
            print("Socket disconnected")
        }

        socket?.on(clientEvent: .error) { data, ack in
            print("Socket error: \(data)")
        }

        socket?.connect()
    }

    /// Disconnect socket connection
    func closeConnection() {
        socket?.disconnect()
    }

    /// Emit data
    func emit(event: String, with items: [Any]) {
        socket?.emit(event, items)
    }

    /// Listen to events
    func on(event: String, callback: @escaping ([Any], SocketAckEmitter) -> Void) {
        socket?.on(event, callback: callback)
    }

    /// Remove a specific event listener
    func off(event: String) {
        socket?.off(event)
    }
}
