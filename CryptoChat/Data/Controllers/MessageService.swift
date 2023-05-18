//
//  MessageService.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 18.05.2023.
//

import Foundation
import UIKit

public class MessageService{
    
    
    public static func send(host: String, pass: String, recipient: String, data: String, completion: ((Bool) -> Void)? = nil){
        let json: [String: Any] = [
            "recipient": recipient,
            "data": data,
            "pass": pass,
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: host + "/api/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion?(false)
                return
            }
            if let data = String(data: data, encoding: .utf8),
               data == "true"
            {
                print("send data: " + data)
                completion?(true)
                return
            }
            completion?(false)
        }
        task.resume()
    }
    
    public static func delete(host: String, pass: String, uuid: String, completion: ((Bool) -> Void)? = nil){
        let json: [String: Any] = [
            "uuid": uuid,
            "pass": pass,
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: host + "/api/v1/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion?(false)
                return
            }
            if let data = String(data: data, encoding: .utf8),
               data == "true"
            {
                print("send data: " + data)
                completion?(true)
                return
            }
            completion?(false)
        }
        task.resume()
    }
    
    public static func findMessages(host: String, pass: String, completion: (([MessageResponse]) -> Void)? = nil){
        let encodedUuid = UserManager.getUuid().addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let encodedPass = pass.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let url = URL(string: host + "/api/v1/messages"+"?recipient=\(encodedUuid!)&pass=\(encodedPass!)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                completion?([])
                return
            }
            let messages: [MessageResponse]? = try? JSONDecoder().decode([MessageResponse].self, from: data)
            print("messages", messages ?? [])
            completion?(messages ?? [])
        }
        task.resume()
    }
    
    public struct MessageResponse : Decodable {
        var uuid: String
        var recipient: String
        var data: String
        var createdDate: String
    }
}
