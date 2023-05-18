//
//  ServiceMessage.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 18.05.2023.
//

import Foundation

public enum ServiceMessageType : Codable {
    case UpdateDialog
    case Text
    case Image
    case Delivered
    case DeliveryError
}

public class ServiceMessage : Codable {
    var type: ServiceMessageType
    var data: String

    init(type: ServiceMessageType, data: String) {
        self.type = type
        self.data = data
    }
}
