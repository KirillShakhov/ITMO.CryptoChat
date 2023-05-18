//
//  DialogsController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import Foundation
import UIKit



public class DialogsManager {
    static var dialogs: [Dialog] = []
    
    public static func add(dialog: Dialog) {
        dialogs.append(dialog)
    }
    
    public static func findByRecipient(recipient: String) -> Dialog? {
        for dialog in dialogs {
            if recipient == dialog.recipient {
                return dialog
            }
        }
        return nil
    }
    
    public static func getData() -> Array<Dialog> {
        var list = [Dialog]()
        for dialog in dialogs {
            if dialog.recipient != nil {
                list.append(dialog)
            }
        }
        return list
    }
    
    public static func update(host: String, completion: (() -> Void)? = nil){
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
    }
}
