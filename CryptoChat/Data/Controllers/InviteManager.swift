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
            if let dialog = DialogsManager.shared.add(aesKey: aesKey, hmacKey: hmacKey, server: UserManager.GetHost(), serverKey: serverKey, dateExpired: dateExpired){
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
                let dateExpiredFormatted = dateFormatter.string(from: dateExpired)
                var data: [String] = [
                    UserManager.getUsername() ?? "no name",
                    UserManager.getUuid(),
                    dateExpiredFormatted,
                    "aes",
                    dialog.aesKey!,
                    dialog.hmacKey!,
                    dialog.server!,
                    dialog.serverKey!,
                ]
                var hashData = ""
                for d in data{
                    hashData += d
                }
                data.append(hashData.sha256())
                return JsonUtil.toJson(data: data)
            }
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
            var dialog: Dialog? = nil
            if let finded = DialogsManager.shared.findByRecipient(recipient: result[1])
            {
                if finded.dateExpired == nil {
                    return "Диалог с этим пользователем уже существует"
                }
                finded.aesKey = result[4]
                finded.hmacKey = result[5]
                finded.server = result[6]
                finded.serverKey = result[7]
                finded.username = result[0]
                finded.recipient = result[1]
                var dayComponent = DateComponents()
                dayComponent.day = 24
                let theCalendar = Calendar.current
                if let dateExpired = theCalendar.date(byAdding: dayComponent, to: Date()){
                    finded.dateExpired = dateExpired
                }
                dialog = finded
                DialogsManager.shared.save()
            }
            else{
                dialog = DialogsManager.shared.add(username: result[0], recipient: result[1], aesKey: result[4], hmacKey: result[5], server: result[6], serverKey: result[7])
            }
            if let server = dialog?.server{
                NotifyManager.updateByHost(host: server)
            }
            var avatarData = "nil"
            if let avatar = UserManager.getAvatar(),
               let jpegAvatar = avatar.jpegData(compressionQuality: 0.1)
            {
                avatarData = jpegAvatar.base64EncodedString()
            }
            if let json = JsonUtil.toJson(data: [UserManager.getUsername(), UserManager.getUuid(),avatarData])
            {
                let serviceMessage = ServiceMessage(type: .AcceptInvite, data: json)
                dialog?.send(message: serviceMessage)
            }
            DialogsManager.shared.save()
            return nil
        }
        return "Неверный формат qr кода или срок действия истек"
    }
}
