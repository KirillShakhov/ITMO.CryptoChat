//
//  Dialog+CoreDataProperties.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 19.05.2023.
//
//

import Foundation
import CoreData

public class Dialog: NSManagedObject {
    
}

extension Dialog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dialog> {
        return NSFetchRequest<Dialog>(entityName: "Dialog")
    }

    @NSManaged public var username: String?
    @NSManaged public var image: Data?
    @NSManaged public var recipient: String?
    @NSManaged public var dateExpired: Date?
    @NSManaged public var aesKey: String?
    @NSManaged public var hmacKey: String?
    @NSManaged public var server: String?
    @NSManaged public var serverKey: String?
    @NSManaged public var messages: NSSet?
}

// MARK: Generated accessors for messages
extension Dialog {

    @objc(insertObject:inMessagesAtIndex:)
    @NSManaged public func insertIntoMessages(_ value: Message, at idx: Int)

    @objc(removeObjectFromMessagesAtIndex:)
    @NSManaged public func removeFromMessages(at idx: Int)

    @objc(insertMessages:atIndexes:)
    @NSManaged public func insertIntoMessages(_ values: [Message], at indexes: NSIndexSet)

    @objc(removeMessagesAtIndexes:)
    @NSManaged public func removeFromMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInMessagesAtIndex:withObject:)
    @NSManaged public func replaceMessages(at idx: Int, with value: Message)

    @objc(replaceMessagesAtIndexes:withMessages:)
    @NSManaged public func replaceMessages(at indexes: NSIndexSet, with values: [Message])

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSOrderedSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSOrderedSet)

}

extension Dialog : Identifiable {

}
