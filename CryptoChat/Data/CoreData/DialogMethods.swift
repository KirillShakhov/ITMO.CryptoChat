//
//  DialogMethods.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 19.05.2023.
//

import Foundation
import UIKit


extension Dialog{
    public func send(message: ServiceMessage){
        if let recipient = recipient,
           let data = JsonUtil.toJson(data: message),
           let iv = AES256.generate256bitKey(),
           let aesKey = self.aesKey,
           let hmacKey = self.hmacKey,
           let server = self.server,
           let serverKey = self.serverKey,
           let encryptedData = AES256(key: aesKey, iv: iv).aesEncrypt(data),
            let hash = HMACUtil.hmac(data: iv+encryptedData, pass: hmacKey)
        {
            MessageService.send(host: server, pass: serverKey, recipient: recipient, data: hash+iv+encryptedData)
        }
    }

    public func add(message: Message){
        addToMessages(message)
    }

    public func update(completion: (() -> Void)? = nil){
        if let server = self.server,
           let serverKey = self.serverKey,
           let hmacKey = self.hmacKey,
           let aesKey = self.aesKey
        {
            MessageService.findMessages(host: server, pass: serverKey, completion: {messages in
                for m in messages {
                    if m.data.count < 64 {
                        continue
                    }
                    let metadata = String(m.data.prefix(108))
                    
                    let messageHash = String(metadata.prefix(64))
                    let messageIv = String(metadata.suffix(44))
                    
                    let messageData = String(m.data.suffix(m.data.count-108))
                    
                    let hash = HMACUtil.hmac(data: messageIv+messageData, pass: hmacKey)
                    if hash != messageHash { continue }
                    
                    let aes = AES256(key: aesKey, iv: messageIv)
                    let decryptedData = aes.aesDecrypt(messageData)
                    
                    if let data = decryptedData?.data(using: .utf8),
                       let serviceMessage = try? JSONDecoder().decode(ServiceMessage.self, from: data){
                        if serviceMessage.type == .UpdateDialog || serviceMessage.type == .AcceptInvite{
                            if let serviceData = serviceMessage.data.data(using: .utf8),
                               let array = try? JSONDecoder().decode([String].self, from: serviceData)
                            {
                                self.username = array[0]
                                self.recipient = array[1]
                                if array[2] != "nil"{
                                    let dataDecoded : Data = Data(base64Encoded: array[2], options: .ignoreUnknownCharacters)!
                                    self.image = dataDecoded
                                }
                                self.dateExpired = nil
                                if serviceMessage.type == .AcceptInvite{
                                    var avatarData = "nil"
                                    if let avatar = UserManager.getAvatar(),
                                       let jpegAvatar = avatar.jpegData(compressionQuality: 0.1)
                                    {
                                        avatarData = jpegAvatar.base64EncodedString()
                                    }
                                    if let json = JsonUtil.toJson(data: [UserManager.getUsername(), UserManager.getUuid(),avatarData])
                                    {
                                        let serviceMessage = ServiceMessage(type: .UpdateDialog, data: json)
                                        self.send(message: serviceMessage)
                                    }
                                }
                            }
                        }
                        else if serviceMessage.type == .DialogDelete{
                            DialogsManager.shared.delete(dialog: self)
                        }
                        else if serviceMessage.type == .Text{
                            DialogsManager.shared.addMessage(dialog: self, me: false, type: .Text, state: .Delivered, data: serviceMessage.data)
                        }
                        else if serviceMessage.type == .Image{
                            DialogsManager.shared.addMessage(dialog: self, me: false, type: .Image, state: .Delivered, data: serviceMessage.data)
                        }
                        MessageService.delete(host: server, pass: serverKey, uuid: m.uuid)
                    }
                }
                completion?()
            })
        }
    }
}
