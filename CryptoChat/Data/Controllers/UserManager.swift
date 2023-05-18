//
//  UserController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation
import UIKit

public class UserManager{
    public static func getUsername() -> String {
        let defaults = UserDefaults.standard
        if let userData = defaults.string(
            forKey: "user"
        ) {
            return userData
        }
        return ""
    }
    
    public static func getAvatar() -> UIImage? {
        let defaults = UserDefaults.standard
        if let avatarData = defaults.string(forKey: "avatar")
        {
            let dataDecoded : Data = Data(base64Encoded: avatarData, options: .ignoreUnknownCharacters)!
            return UIImage(data: dataDecoded)
        }
        return UIImage(named: "avatar_mock")!
    }
    
    public static func getUuid() -> String {
        let defaults = UserDefaults.standard
        if let uuidData = defaults.string(
            forKey: "uuid"
        ) {
            return uuidData
        }
        let uuid = UUID().uuidString
        defaults.set(
            uuid,
            forKey: "uuid"
        )
        return uuid
    }
}
