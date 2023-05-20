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
    var message: Message?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(){
        if let message = message {
            dateLabel.text = message.date?.formatted()
            if message.type == MessageType.Text{
                textLabel.text = message.data
            }
            else{
                textLabel.text = "Вложение"
            }
        }
        else{
            dateLabel.text = ""
            textLabel.text = ""
        }
    }
}
