//
//  JsonUtil.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation


public class JsonUtil{
    public static func toJson(data: Encodable) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(data)
            return String(data: jsonData, encoding: .utf8)!
        } catch {
            print(error)
            return nil
        }
    }
    
    public static func fromJsonArray(data: String) -> [String]? {
        do {
            let jsonData = data.data(using: .utf8)!
            let tableData = try JSONDecoder().decode([String].self, from: jsonData)
            return tableData
        }
        catch {
            print (error)
            return nil
        }
    }
}
