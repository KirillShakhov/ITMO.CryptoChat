//
//  Message.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation

public enum MessageType{
    case Service
    case Text
    case Image
}

public enum MessageState{
    case Send
    case Error
    case Delivered
}

public struct Message{
    var me: Bool
    var type: MessageType
    var state: MessageState
    var data: String
    var date: Date
    
    init(me: Bool, type: MessageType, state: MessageState, data: String, date: Date = Date()) {
        self.me = me
        self.type = type
        self.state = state
        self.data = data
        self.date = date
    }
}
