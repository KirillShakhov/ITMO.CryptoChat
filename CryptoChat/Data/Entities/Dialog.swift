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
    
    public func update(completion: (() -> Void)? = nil){
        MessageService.findMessages(host: server, pass: serverKey, completion: {messages in
            for m in messages{
                print("mestest", m)
                if let data = m.data.data(using: .utf8),
                   let serviceMessage = try? JSONDecoder().decode(ServiceMessage.self, from: data){
                    
                    print("serviceMessage", serviceMessage)
                    
                    if serviceMessage.type == .UpdateDialog{
                        
                        print("serviceMessage UpdateDialog")

                        if let serviceData = serviceMessage.data.data(using: .utf8),
                            let array = try? JSONDecoder().decode([String].self, from: serviceData)
                        {
                            print("array", array)
                            self.username = array[0]
                            self.recipient = array[1]
                            let dataDecoded : Data = Data(base64Encoded: array[2], options: .ignoreUnknownCharacters)!
                            self.image = UIImage(data: dataDecoded)
                            self.dateExpired = nil
                        }
                    }
                }
            }
            completion?()
        })
    }
}
