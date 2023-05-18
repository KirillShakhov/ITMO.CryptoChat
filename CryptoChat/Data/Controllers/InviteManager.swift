//
//  InviteController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation


public class InviteManager {
    public static func createInvite(hours: Int) -> String? {
        var dayComponent = DateComponents()
        dayComponent.day = hours
        let theCalendar = Calendar.current
        if let dateExpired = theCalendar.date(byAdding: dayComponent, to: Date()),
           let aesKey = AES256.generate256bitKey(),
           let hmacKey = AES256.generate256bitKey(),
           let serverKey = AES256.generate256bitKey()
        {
            let dialog = Dialog(dateExpired: dateExpired, aesKey: aesKey, hmacKey: hmacKey, server: ServerManager.GetHost(), serverKey: serverKey)
            dialog.dateExpired = dateExpired
            DialogsManager.add(dialog: dialog)
            let data = [
                UserManager.getUsername(),
                UserManager.getUuid(),
                dialog.dateExpired?.formatted(),
                "aes",
                dialog.aesKey,
                dialog.hmacKey,
                dialog.server,
                dialog.serverKey,
            ]
            return JsonUtil.toJson(data: data)
        }
        return nil
    }
    public static func acceptInvite(code: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        if let result = JsonUtil.fromJsonArray(data: code),
            result.count >= 8,
           let expiredDate = dateFormatter.date(from: result[2]),
           Date() < expiredDate
        {
            let dialog = Dialog(username: result[0], recipient: result[1], aesKey: result[4], hmacKey: result[5], server: result[6], serverKey: result[7])
            if dialog.recipient != nil,
                let finded = DialogsManager.findByRecipient(recipient: dialog.recipient!)
            {
                if finded.dateExpired == nil {
                    return "Диалог с этим пользователем уже существует"
                }
                finded.aesKey = dialog.aesKey
                finded.hmacKey = dialog.hmacKey
                finded.server = dialog.server
                finded.serverKey = dialog.serverKey
                finded.username = dialog.username
                finded.recipient = dialog.recipient
                var dayComponent = DateComponents()
                dayComponent.day = 24
                let theCalendar = Calendar.current
                if let dateExpired = theCalendar.date(byAdding: dayComponent, to: Date()){
                    finded.dateExpired = dateExpired
                }
            }
            else{
                DialogsManager.add(dialog: dialog)
            }
            NotifyManager.updateByHost(host: dialog.server)
            var avatarData = "nil"
            if let avatar = UserManager.getAvatar(),
               let jpegAvatar = avatar.jpegData(compressionQuality: 0.1)
            {
                avatarData = jpegAvatar.base64EncodedString()
            }
            if let json = JsonUtil.toJson(data: [UserManager.getUsername(), UserManager.getUuid(),avatarData]),
               let data = JsonUtil.toJson(data: ServiceMessage(type: .UpdateDialog, data: json))
            {
                let message = Message(me: true, type: MessageType.Service, state: .Send, data: data)
                dialog.send(message: message)
            }
            return nil
        }
        return "Неверный формат qr кода или срок действия истек"
    }
}
