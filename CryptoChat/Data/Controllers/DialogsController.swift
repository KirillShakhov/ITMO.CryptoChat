//
//  DialogsController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation
import UIKit



public class DialogsController{
    public static func getData() -> Array<Dialog> {
        var list = [Dialog]()
        
        list.append(Dialog(username: "Даня", image: nil, messages: [
            Message(type: MessageType.Text, state: MessageState.Delivered, data: "String123123123", date: Date.now)
        ]))
        list.append(Dialog(username: "Вася", image: UIImage(named: "avatar_example"), messages: [
            Message(type: MessageType.Text, state: MessageState.Delivered, data: "Привет, где ты?", date: Date.now),
            Message(type: MessageType.Text, state: MessageState.Delivered, data: "Я жду", date: Date.now)
        ]))
        let defaults = UserDefaults.standard
        if let userData = defaults.string(
            forKey: "user"
        ) {
            if let avatarData = defaults.string(
                forKey: "avatar"
            ) {
                list.append(Dialog(username: "Алиса", image: nil, messages: [
                    Message(type: MessageType.Text, state: MessageState.Delivered, data: "Жду тебя", date: Date.now),
                    Message(type: MessageType.Image, state: MessageState.Delivered, data: avatarData, date: Date.now),
                ]))
            }
        }

        return list
    }
}
