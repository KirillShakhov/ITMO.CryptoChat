//
//  Dialog.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation
import UIKit

public struct Dialog{
    var username: String
    var image: UIImage?
    var messages: Array<Message>
    
    init(username: String, image: UIImage?, messages: Array<Message>) {
        self.username = username
        self.image = image
        self.messages = messages
    }
}
