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
        return UIImage(named: "avatar_example")!
    }
    
    public static func getUuid() -> String {
        let defaults = UserDefaults.standard
        if let uuidData = defaults.string(
            forKey: "uuid"
        ) {
            return uuidData
        }
        var uuid = UUID().uuidString
        defaults.set(
            uuid,
            forKey: "uuid"
        )
        return uuid
    }
}
