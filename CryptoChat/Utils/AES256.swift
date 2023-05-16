//
//  AES.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//
import Foundation
import CommonCrypto

public class AES256{
    private var key: String
    private var iv: String
    
    init(key: String, iv: String){
        self.key = key
        self.iv = iv
    }
    
    func aesEncrypt(_ text: String) -> String? {
        var textEncrypt = text
        if textEncrypt.count < 16 {
            textEncrypt.append(String(repeating: " ", count: 16 - textEncrypt.count))
        }
        guard
            let data = textEncrypt.data(using: .utf8),
            let key = Data(base64Encoded: key, options: .ignoreUnknownCharacters),
            let iv = Data(base64Encoded: iv, options: .ignoreUnknownCharacters),
            let encrypt = data.encryptAES256(key: key, iv: iv)
            else { return nil }
        let base64Data = encrypt.base64EncodedData()
        return String(data: base64Data, encoding: .utf8)
    }

    func aesDecrypt(_ crypt: String) -> String? {
        guard
            let data = Data(base64Encoded: crypt),
            let key = Data(base64Encoded: key, options: .ignoreUnknownCharacters),
            let iv = Data(base64Encoded: iv, options: .ignoreUnknownCharacters),
            let decrypt = data.decryptAES256(key: key, iv: iv)
            else { return nil }
        return String(data: decrypt, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    internal static func generateSymmetricEncryptionKey() -> String? {
        var keyData = Data(count: 32)
        let result = keyData.withUnsafeMutableBytes {
          SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!)
        }
        guard result == errSecSuccess else { return nil }
        return keyData.base64EncodedString()
      }
}

public extension Data {
    func encryptAES256(key: Data, iv: Data, options: Int = kCCOptionPKCS7Padding) -> Data? {
        // No option is needed for CBC, it is on by default.
        return aesCrypt(operation: kCCEncrypt,
                        algorithm: kCCAlgorithmAES,
                        options: options,
                        key: key,
                        initializationVector: iv,
                        dataIn: self)
    }

    func decryptAES256(key: Data, iv: Data, options: Int = kCCOptionPKCS7Padding) -> Data? {
        guard count > kCCBlockSizeAES128 else { return nil }
        return aesCrypt(operation: kCCDecrypt,
                        algorithm: kCCAlgorithmAES,
                        options: options,
                        key: key,
                        initializationVector: iv,
                        dataIn: self)
    }

    private func aesCrypt(operation: Int,
                          algorithm: Int,
                          options: Int,
                          key: Data,
                          initializationVector: Data,
                          dataIn: Data) -> Data? {
        return initializationVector.withUnsafeBytes { ivUnsafeRawBufferPointer in
            return key.withUnsafeBytes { keyUnsafeRawBufferPointer in
                return dataIn.withUnsafeBytes { dataInUnsafeRawBufferPointer in
                    // Give the data out some breathing room for PKCS7's padding.
                    let dataOutSize: Int = dataIn.count + kCCBlockSizeAES128 * 2
                    let dataOut = UnsafeMutableRawPointer.allocate(byteCount: dataOutSize, alignment: 1)
                    defer { dataOut.deallocate() }
                    var dataOutMoved: Int = 0
                    let status = CCCrypt(CCOperation(operation),
                                         CCAlgorithm(algorithm),
                                         CCOptions(options),
                                         keyUnsafeRawBufferPointer.baseAddress, key.count,
                                         ivUnsafeRawBufferPointer.baseAddress,
                                         dataInUnsafeRawBufferPointer.baseAddress, dataIn.count,
                                         dataOut, dataOutSize,
                                         &dataOutMoved)
                    guard status == kCCSuccess else { return nil }
                    return Data(bytes: dataOut, count: dataOutMoved)
                }
            }
        }
    }
}
