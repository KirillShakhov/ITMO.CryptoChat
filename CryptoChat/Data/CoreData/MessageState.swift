//
//  MessageState.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 19.05.2023.
//

import Foundation

@objc public enum MessageState: Int16
{
    case Send      = 0
    case Error     = 1
    case Delivered = 2
}
