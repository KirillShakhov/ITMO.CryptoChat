//
//  InviteController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation


public class InviteController{
    
    
    public static func createInvite() -> String {
        let userUuid = UserController.getUuid()
        let inviteUuid = UUID().uuidString
        
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let theCalendar = Calendar.current
        let dateExpired = theCalendar.date(byAdding: dayComponent, to: Date())
        
        if let key = AES256.generateSymmetricEncryptionKey(),
           let iv = AES256.generateSymmetricEncryptionKey()
        {
            print("key "+key)
            let aes = AES256(key: key, iv: iv)
            let crypt = aes.aesEncrypt("1") ?? "nil"
            print("encrypt "+crypt)
            print("dencrypt "+(aes.aesDecrypt(crypt) ?? "nil"))
        }
        
        let invite = Invite(uuid: inviteUuid, userUuid: userUuid, dateExpired: dateExpired?.formatted() ?? "nil")
        
        let data = [
            invite.uuid,
            invite.dateExpired,
            invite.userUuid
        ]
        do {
            let jsonData = try JSONEncoder().encode(data)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString
        } catch { print(error) }
        return "nil"
    }
}
