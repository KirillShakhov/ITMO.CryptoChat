//
//  ServiceMessage.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 18.05.2023.
//

import Foundation

public enum ServiceMessageType{
    case AcceptInvite
    case Delivered
    case DeliveryError
}

public class ServiceMessage{
    var type: ServiceMessageType
    var data: String
    
    init(type: ServiceMessageType, data: String) {
        self.type = type
        self.data = data
    }
}
