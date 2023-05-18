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
    
    public func send(message: ServiceMessage){
        if let recipient = recipient,
           let data = JsonUtil.toJson(data: message),
           let iv = AES256.generate256bitKey(),
           let encryptedData = AES256(key: self.aesKey, iv: iv).aesEncrypt(data),
            let hash = HMACUtil.hmac(data: iv+encryptedData, pass: hmacKey)
        {
            MessageService.send(host: server, pass: serverKey, recipient: recipient, data: hash+iv+encryptedData)
        }
    }
    
    public func add(message: Message){
        messages.append(message)
    }
    
    public func update(completion: (() -> Void)? = nil){
        MessageService.findMessages(host: server, pass: serverKey, completion: {messages in
            for m in messages {
                if m.data.count < 64 {
                    continue
                }
                let metadata = String(m.data.prefix(108))
                
                let messageHash = String(metadata.prefix(64))
                let messageIv = String(metadata.suffix(44))
                
                let messageData = String(m.data.suffix(m.data.count-108))
                
                let hash = HMACUtil.hmac(data: messageIv+messageData, pass: self.hmacKey)
                if hash != messageHash { continue }
                
                let aes = AES256(key: self.aesKey, iv: messageIv)
                let decryptedData = aes.aesDecrypt(messageData)
                
                if let data = decryptedData?.data(using: .utf8),
                   let serviceMessage = try? JSONDecoder().decode(ServiceMessage.self, from: data){
                    if serviceMessage.type == .UpdateDialog{
                        if let serviceData = serviceMessage.data.data(using: .utf8),
                            let array = try? JSONDecoder().decode([String].self, from: serviceData)
                        {
                            self.username = array[0]
                            self.recipient = array[1]
                            let dataDecoded : Data = Data(base64Encoded: array[2], options: .ignoreUnknownCharacters)!
                            self.image = UIImage(data: dataDecoded)
                            self.dateExpired = nil
                        }
                    }
                    else if serviceMessage.type == .Text{
                        let message = Message(me: false, type: .Text, state: .Delivered, data: serviceMessage.data)
                        self.messages.append(message)
                    }
                    else if serviceMessage.type == .Image{
                        let message = Message(me: false, type: .Image, state: .Delivered, data: serviceMessage.data)
                        self.messages.append(message)
                    }
                    print("m delete ", m.uuid)
                    MessageService.delete(host: self.server, pass: self.serverKey, uuid: m.uuid)
                }
            }
            completion?()
        })
    }
}
