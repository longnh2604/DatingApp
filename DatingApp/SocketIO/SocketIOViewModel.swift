//
//  SocketIOViewModel.swift
//  DatingApp
//
//  Created by LongNH8 on 14/5/25.
//

import Foundation
import SocketIO
import Combine

class SocketIOViewModel: ObservableObject {
    @Published var messages: [String] = []
    private var socketManager = SocketIOManager.shared

    private var serverURL: URL {
        // Replace with your actual socket server URL
        URL(string: "http://your-server.com:3000")!
    }

    init() {
        connect()
    }

    deinit {
        disconnect()
    }

    func connect() {
        socketManager.establishConnection(to: serverURL, with: [.log(true), .compress])
        addSocketHandlers()
    }

    func disconnect() {
        socketManager.closeConnection()
    }

    func sendMessage(_ message: String) {
        socketManager.emit(event: "message", with: [message])
    }

    private func addSocketHandlers() {
        socketManager.on(event: "message") { [weak self] data, ack in
            guard let self = self else { return }
            if let message = data.first as? String {
                DispatchQueue.main.async {
                    self.messages.append(message)
                }
            }
        }
    }
}
