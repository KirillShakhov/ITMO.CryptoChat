//
//  CreatorQrViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 13.05.2023.
//

import UIKit
import QRCode

class CreatorQrViewController: UIViewController {


    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var dateExpiredSelect: UISegmentedControl!
    @IBOutlet var generateButton: UIView!
    
    @IBOutlet weak var scanMe: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanMe.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func generateCode(_ sender: Any) {
        
        var hours = 1
        if dateExpiredSelect.selectedSegmentIndex == 1 {
            hours = 24
        }
        
        if let invite = InviteManager.createInvite(hours: hours){
            let image = generateQRCode(from: invite)
            qrImage.image = image
            scanMe.isHidden = false
            return
        }
        let alert = UIAlertController(title: "Ошибка", message: "Ошибка при создании приглашения", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
    let doc = QRCode.Document(utf8String: string, errorCorrection: .low)

    doc.design.shape.onPixels = QRCode.PixelShape.Circle()
    doc.design.shape.eye = QRCode.EyeShape.Squircle()
    
    let generated = doc.cgImage(CGSize(width: 500, height: 500))!
    let image:UIImage = UIImage.init(cgImage: generated)
    return image

    }
}
