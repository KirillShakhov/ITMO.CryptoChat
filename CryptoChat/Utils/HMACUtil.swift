//
//  HMAC.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation
import CryptoKit

public class HMACUtil{
    static func hmac() -> String {
        
        let secretPassword = "mypass".data(using: .utf8)!

        let hkdfResultKey = HKDF<SHA256>.deriveKey(inputKeyMaterial: SymmetricKey(data: secretPassword), outputByteCount: 256)

        print("The generated key size (in bytes): ",hkdfResultKey.bitCount/8)

        let trustfulMessage = "The message that would be verified by the authentication code".data(using: .utf8)!

        let authenticationCode = HMAC<SHA256>.authenticationCode(for: trustfulMessage, using: hkdfResultKey)

        print("\(authenticationCode.description)")
        return "nil"
    }
}
