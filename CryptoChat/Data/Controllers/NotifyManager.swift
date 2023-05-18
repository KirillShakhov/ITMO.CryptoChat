//
//  NotifyManager.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 18.05.2023.
//

import Foundation

public class NotifyManager{
    private static var hashes: [String: String] = [:]
    
    public static func add(host: String){
        if hashes[host] != nil {
            return
        }
        updateByHost(host: host)
    }
    
    public static func update(){
        for (host, _) in hashes {
            updateByHost(host: host)
        }
    }
    
    public static func updateByHost(host: String){
        let json: [String: Any] = ["recipient": UserManager.getUuid()]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: host + "/api/v1/notify")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let hash = String(data: data, encoding: .utf8){
                print("hash: " + hash)
                if hashes[host] != hash {
                    DialogsManager.update(host: host)
                }
                hashes[host] = hash
            }
        }
        task.resume()
    }
}
