//
//  ChatViewCell.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 14.05.2023.
//

import UIKit

class ChatViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lastLabel: UILabel!
    
    var dialog: Dialog?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(){
        usernameLabel.text = dialog?.username
        if let last = dialog?.messages?.allObjects.last,
           let last = last as? Message
        {
            dateLabel.text = last.date?.formatted()
            if last.type == MessageType.Text {
                lastLabel.text = last.data
            }
            else{
                lastLabel.text = "Вложение"
            }
        }
        else{
            dateLabel.text = ""
            lastLabel.text = ""
        }
        if let image = dialog?.image {
            avatarImage.image = UIImage(data: image)
        }
        else{
            avatarImage.image = UIImage(named: "avatar_mock")
        }
    }

}
