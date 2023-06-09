//
//  NotifyManager.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 18.05.2023.
//

import Foundation
import UserNotifications

public class NotifyManager{
    private static var hashes: [String: String] = [UserManager.GetHost():""]
    
    public static func add(host: String){
        if hashes[host] != nil {
            return
        }
        updateByHost(host: host)
    }
    
    public static func update(completion: (() -> Void)? = nil){
        let dispatchGroup = DispatchGroup()
        for (host, _) in hashes {
            dispatchGroup.enter()
            updateByHost(host: host, completion: {
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            completion?()
        }
    }
    
    public static func updateByHost(host: String, completion: (() -> Void)? = nil){
        let json: [String: Any] = ["recipient": UserManager.getUuid()]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: host + "/api/v1/notify")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let hash = String(data: data, encoding: .utf8){
                if hashes[host] != hash {
                    DialogsManager.shared.updateByHost(host: host, completion: {
                        print("dialog updates")
                        completion?()
                    })
                }
                else{
                    completion?()
                }
                hashes[host] = hash
                return
            }
            completion?()
        }
        task.resume()
    }
}
