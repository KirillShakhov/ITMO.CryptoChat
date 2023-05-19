//
//  Message+CoreDataProperties.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 19.05.2023.
//
//

import Foundation
import CoreData

public class Message: NSManagedObject {
    public override var description: String {
        return "Message"
    }
}

extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var me: Bool
    @NSManaged public var type: MessageType
    @NSManaged public var state: MessageState
    @NSManaged public var data: String?
    @NSManaged public var date: Date?
}

extension Message : Identifiable {

}
