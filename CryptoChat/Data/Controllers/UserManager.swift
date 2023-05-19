//
//  UserController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation
import UIKit

public class UserManager{
    public static func getUsername() -> String? {
        let defaults = UserDefaults.standard
        if let userData = defaults.string(
            forKey: "user"
        ) {
            return userData
        }
        return nil
    }
    
    public static func setUsername(name: String){
        let defaults = UserDefaults.standard
        defaults.set(
            name,
            forKey: "user"
        )
    }
    
    public static func getAvatar() -> UIImage? {
        let defaults = UserDefaults.standard
        if let avatarData = defaults.string(forKey: "avatar"),
           avatarData != "nil"
        {
            let dataDecoded : Data = Data(base64Encoded: avatarData, options: .ignoreUnknownCharacters)!
            return UIImage(data: dataDecoded)
        }
        return UIImage(named: "avatar_mock")
    }
    
    public static func setAvatar(image: UIImage?) {
        let defaults = UserDefaults.standard
        if let strBase64 = image?.jpegData(compressionQuality: 0.8)?.base64EncodedString(options: .lineLength64Characters) {
            defaults.set(
                strBase64,
                forKey: "avatar"
            )
        }
        else{
            defaults.set(
                "nil",
                forKey: "avatar"
            )
        }
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
    
    public static func deleteAllData(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}
