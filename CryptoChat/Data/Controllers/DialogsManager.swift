//
//  DialogsController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation
import UIKit
import CoreData


public class DialogsManager {
    public static let shared = DialogsManager()
    private var context: NSManagedObjectContext?
    
    init(){
        DispatchQueue.main.async {
            self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        }
    }
    
    public func add(username: String? = nil, recipient: String? = nil, aesKey: String, hmacKey: String, server: String, serverKey: String, dateExpired: Date? = nil) -> Dialog? {
        guard let context = self.context else { return nil }
        let dialog = Dialog(context: context)
        dialog.username = username
        dialog.recipient = recipient
        dialog.aesKey = aesKey
        dialog.hmacKey = hmacKey
        dialog.server = server
        dialog.serverKey = serverKey
        DispatchQueue.main.async {
            do {
                try context.save()
            }
            catch {
                // Handle Error
            }
        }
        return dialog
    }

    public func save() {
        guard let context = self.context else { return }
        DispatchQueue.main.async {
            do {
                try context.save()
            }
            catch {
                // Handle Error
            }
        }
    }
    
    public func addMessage(dialog: Dialog, me: Bool, type: MessageType, state: MessageState, data: String) -> Message? {
        guard let context = self.context else { return nil }
        let message = Message(context: context)
        message.me = me
        message.type = type
        message.state = state
        message.data = data
        dialog.addToMessages(message)
        DispatchQueue.main.async {
            do {
                try context.save()
            }
            catch {
                // Handle Error
            }
        }
        return message
    }
    
    public func delete(dialog: Dialog){
        guard let context = self.context else { return }
        context.delete(dialog)
        DispatchQueue.main.async {
            do {
                try context.save()
            }
            catch {
                // Handle Error
            }
        }
    }
    
    public func findByRecipient(recipient: String) -> Dialog? {
        guard let context = self.context else { return nil }
        if let dialogs = try? context.fetch(Dialog.fetchRequest()){
            for dialog in dialogs {
                if recipient == dialog.recipient {
                    return dialog
                }
            }
        }
        return nil
    }
    
    public func getData() -> Array<Dialog> {
        guard let context = self.context else { return [] }
        if let dialogs = try? context.fetch(Dialog.fetchRequest()){
            var list = [Dialog]()
            for dialog in dialogs {
                if dialog.recipient != nil {
                    list.append(dialog)
                }
            }
            return list
        }
        return []
    }
    
    public func update(host: String, completion: (() -> Void)? = nil){
        guard let context = self.context else { return }
        if let dialogs = try? context.fetch(Dialog.fetchRequest()){
            let dispatchGroup = DispatchGroup()
            for dialog in dialogs {
                if dialog.server == host{
                    dispatchGroup.enter()
                    dialog.update(completion: {
                        dispatchGroup.leave()
                    })
                }
            }
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion?()
            }
            return
        }
        completion?()
    }
}
