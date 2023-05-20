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
    
    public static func GetHost() -> String {
        let defaults = UserDefaults.standard
        if let host = defaults.string(
            forKey: "host"
        ) {
            return host
        }
        return "http://192.168.0.103:8080"
    }
    
    public static func setHost(host: String) -> Bool {
        var hostString = host
        if hostString.last == "/" {
            hostString = String(hostString.dropLast())
        }
        if !verifyUrl(urlString: hostString) {
            return false
        }
        let defaults = UserDefaults.standard
        defaults.set(
            hostString,
            forKey: "host"
        )
        return true
    }
    
    private static func verifyUrl(urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
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
