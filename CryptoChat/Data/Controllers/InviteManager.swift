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
}
