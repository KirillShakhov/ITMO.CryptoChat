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
        if let invite = InviteController.createInvite(){
            let image = generateQRCode(from: invite)
            qrImage.image = image
            scanMe.isHidden = false
            return
        }
        let alert = UIAlertController(title: "Ошибка", message: "Ошибка при создании приглашения", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func generateQRCode(from string: String) -> UIImage? {
//        let data = string.data(using: String.Encoding.ascii)
//        if let filter = CIFilter(name: "CIQRCodeGenerator") {
//            filter.setValue(data, forKey: "inputMessage")
//            let transform = CGAffineTransform(scaleX: 10, y: 10)
//
//            if let output = filter.outputImage?.transformed(by: transform) {
//                return UIImage(ciImage: output)
//            }
//        }
        
        let doc = QRCode.Document(utf8String: string, errorCorrection: .high)
//        doc.design.shape.offPixels = QRCode.PixelShape.Horizontal(insetFraction: 0.4, cornerRadiusFraction: 1)
//
//        if (dateExpiredSelect.selectedSegmentIndex == 0){
//            doc.design.shape.onPixels = QRCode.PixelShape.Circle()
//
//            doc.design.shape.eye = QRCode.EyeShape.BarsHorizontal()
//            doc.design.style.onPixels = QRCode.FillStyle.Solid(UIColor.systemGreen.cgColor)
//            doc.design.style.offPixels = QRCode.FillStyle.Solid(UIColor.systemGreen.withAlphaComponent(0.4).cgColor)
//        }
//        else{
//            doc.design.shape.onPixels = QRCode.PixelShape.Pointy()
//
//            doc.design.shape.eye = QRCode.EyeShape.Edges()
//
//            doc.design.style.onPixels = QRCode.FillStyle.Solid(UIColor.systemPink.cgColor)
//            doc.design.style.offPixels = QRCode.FillStyle.Solid(UIColor.systemPink.withAlphaComponent(0.4).cgColor)
//        }
        
        doc.design.shape.onPixels = QRCode.PixelShape.Circle()
        doc.design.shape.eye = QRCode.EyeShape.Squircle()
        
        let generated = doc.cgImage(CGSize(width: 500, height: 500))!
        let image:UIImage = UIImage.init(cgImage: generated)
        return image
//        return nil
    }
}
