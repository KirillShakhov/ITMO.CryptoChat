//
//  ImageMessage.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 16.05.2023.
//

import UIKit

class ImageMessage: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var dateView: UIView!
    var message: Message?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(){
        if let data = message?.data{
            let dataDecoded : Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
            image.image = UIImage(data: dataDecoded)
        }
        dateLabel.text = message?.date.formatted()
        
        if message?.me ?? false {
            viewMessage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
            viewMessage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        }
        dateView.leftAnchor.constraint(equalTo: viewMessage.leftAnchor, constant: 10).isActive = true
        viewMessage.layoutIfNeeded()

    }
}
