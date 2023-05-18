//
//  MessageCollectionViewCell.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var viewMessage: UIView!
    
    var message: Message?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(){
        if let message = message {
            dateLabel.text = message.date.formatted()
            if message.type == MessageType.Text{
                textLabel.text = message.data
            }
            else{
                textLabel.text = "Вложение"
            }
            if (message.me){
                viewMessage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 60).isActive = true
                viewMessage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
        }
        else{
            dateLabel.text = ""
            textLabel.text = ""
        }
    }
}
