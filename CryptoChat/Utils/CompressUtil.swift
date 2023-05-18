//
//  CompressUtil.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation


public class CompressUtil{
    public static func zip(data: Data) -> Data? {
        do {
            let compressedData = try (data as NSData).compressed(using: .zlib)
            return compressedData as Data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
