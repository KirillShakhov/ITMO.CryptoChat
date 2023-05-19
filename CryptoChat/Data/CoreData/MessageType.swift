//
//  MessageType.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 19.05.2023.
//

import Foundation

@objc public enum MessageType: Int16
{
    case Service  = 0
    case Text     = 1
    case Image    = 2
}
