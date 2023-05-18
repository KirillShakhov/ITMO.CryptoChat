//
//  Dialog.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation
import UIKit

public class Dialog{
    var username: String
    var image: UIImage?
    var messages: Array<Message>
    
    var recipient: String?
    var dateExpired: Date?
    var aesKey: String
    var hmacKey: String
    var server: String
    var serverKey: String

    init(username: String = "", image: UIImage? = nil, messages: Array<Message> = [], recipient: String? = nil, dateExpired: Date? = nil, aesKey: String, hmacKey: String, server: String, serverKey: String) {
        self.username = username
        self.image = image
        self.messages = messages
        self.recipient = recipient
        self.dateExpired = dateExpired
        self.aesKey = aesKey
        self.hmacKey = hmacKey
        self.server = server
        self.serverKey = serverKey
    }
    
    public func send(message: Message){
        print("send1")
        if let recipient = recipient{
            print("send2")
            MessageService.send(host: server, pass: serverKey, recipient: recipient, data: message.data)
        }
    }
    
    public func add(message: Message){
        messages.append(message)
    }
}
