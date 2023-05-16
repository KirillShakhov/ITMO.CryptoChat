//
//  UserController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation

public class UserController{
    
    public static func getUuid() -> String {
        return UUID().uuidString
    }
}
