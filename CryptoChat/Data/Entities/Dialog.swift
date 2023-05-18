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
        if let recipient = recipient,
            let hash = HMACUtil.hmac(data: message.data, pass: hmacKey)
        {
            print("hash", hash)
            print("testdata1",message.data)

            MessageService.send(host: server, pass: serverKey, recipient: recipient, data: hash+message.data)
        }
//           let iv = AES256.generate256bitKey(){
//            let aes = AES256(key: self.aesKey, iv: iv)
//            if let encryptedData = aes.aesEncrypt(message.data){
        
//            }
        
    }
    
    public func add(message: Message){
        messages.append(message)
    }
    
    public func update(completion: (() -> Void)? = nil){
        MessageService.findMessages(host: server, pass: serverKey, completion: {messages in
            for m in messages{
                if m.data.count < 64 {
                    continue
                }
                let messageHash = String(m.data.prefix(64))
                let messageData = String(m.data.suffix(m.data.count-64))
                print("testdata2", messageData)
                let hash = HMACUtil.hmac(data: messageData, pass: self.hmacKey)
                if hash != messageHash
                {
                    print("not auth")
                    continue
                }
                print("auth complete")

//                let secureData = m.data.suffix(m.data.count - 44)
//                let aes = AES256(key: self.aesKey, iv: String(iv))
//                let decryptedData = aes.aesDecrypt(secureData)
//                print("decryptedData", decryptedData)
                if let data = m.data.data(using: .utf8),
                   let serviceMessage = try? JSONDecoder().decode(ServiceMessage.self, from: data){
                    if serviceMessage.type == .UpdateDialog{
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
