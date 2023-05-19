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
    
    var message: Message?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(){
        if let data = self.message?.data{
            let dataDecoded : Data = Data(base64Encoded: data, options: .ignoreUnknownCharacters)!
            DispatchQueue.main.async {
                self.image.image = UIImage(data: dataDecoded)
            }
        }
        DispatchQueue.main.async {
            self.dateLabel.text = self.message?.date?.formatted()
        }
    }
}
