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
        return "kirill"
    }
    
    public static func getAvatar() -> UIImage {
        return UIImage(named: "avatar_example")!
    }
    
    public static func getUuid() -> String {
        return UUID().uuidString
    }
}
