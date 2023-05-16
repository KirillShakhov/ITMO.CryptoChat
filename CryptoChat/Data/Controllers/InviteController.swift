//
//  InviteController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation


public class InviteController{
    
    
    public static func createInvite() -> String? {
        let inviteUuid = UUID().uuidString
        
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let theCalendar = Calendar.current
        let dateExpired = theCalendar.date(byAdding: dayComponent, to: Date())
        
        if let dateExpired = dateExpired?.formatted(),
           let aesKey = AES256.generate256bitKey(),
           let hmacKey = AES256.generate256bitKey()
        {
            let invite = Invite(uuid: inviteUuid, userUuid: UserController.getUuid(), dateExpired: dateExpired, aesKey: aesKey, hmacKey: hmacKey)
                            
            let data = [
                invite.dateExpired,
                invite.uuid,
                invite.userUuid,
                invite.aesKey,
                invite.hmacKey
            ]
                    
            return JsonUtil.toJson(data: data)
        }
        return nil
    }
}
