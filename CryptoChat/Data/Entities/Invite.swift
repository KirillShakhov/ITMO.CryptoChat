//
//  Invite.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation


public struct Invite : Codable{
    var uuid: String
    var userUuid: String
    var dateExpired: String
    
    init(uuid: String, userUuid: String, dateExpired: String) {
        self.uuid = uuid
        self.userUuid = userUuid
        self.dateExpired = dateExpired
    }
}
