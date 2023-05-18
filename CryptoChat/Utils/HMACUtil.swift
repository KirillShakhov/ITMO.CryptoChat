//
//  HMAC.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation
import CryptoKit

public class HMACUtil{
    static func hmac(data: String, pass: String) -> String? {
        let secretPassword = pass.data(using: .utf8)!
        let hkdfResultKey = HKDF<SHA256>.deriveKey(inputKeyMaterial: SymmetricKey(data: secretPassword), outputByteCount: 256)
        guard let trustfulMessage = data.data(using: .utf8) else { return nil }
        let authenticationCode = HMAC<SHA256>.authenticationCode(for: trustfulMessage, using: hkdfResultKey)
        return Data(authenticationCode).map { String(format: "%02hhx", $0) }.joined()
    }
}
