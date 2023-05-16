//
//  Message.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation

public enum MessageType{
    case Text
    case Image
}

public enum MessageState{
    case Send
    case Error
    case Delivered
}

public struct Message{
    var type: MessageType
    var state: MessageState
    var data: String
    var date: Date
    
    init(type: MessageType, state: MessageState, data: String, date: Date) {
        self.type = type
        self.state = state
        self.data = data
        self.date = date
    }
}
