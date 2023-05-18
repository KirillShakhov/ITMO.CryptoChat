//
//  MessageService.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 18.05.2023.
//

import Foundation

public class MessageService{
    
    
    public static func send(host: String, pass: String, recipient: String, data: String, handler: @escaping (_ status: Bool) -> Void = {status in }){
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
                handler(false)
                return
            }
            if let data = String(data: data, encoding: .utf8),
               data == "true"
            {
                print("send data: " + data)
                handler(true)
            }
            else{
                print("send data: false")
                handler(false)
            }
        }
        task.resume()
    }
}
