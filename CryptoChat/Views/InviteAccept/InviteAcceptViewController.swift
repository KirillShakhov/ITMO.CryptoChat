//
//  InviteAcceptViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 13.05.2023.
//

import UIKit
import CryptoKit

class InviteAcceptViewController: UIViewController {

    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var serverLabel: UILabel!
    @IBOutlet weak var cryptoLabel: UILabel!
    var code: String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        hashLabel.text = ""
        usernameLabel.text = ""
        uuidLabel.text = ""
        serverLabel.text = ""
        cryptoLabel.text = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        if let result = JsonUtil.fromJsonArray(data: code),
            result.count >= 8,
           let expiredDate = dateFormatter.date(from: result[2]),
           Date() < expiredDate
        {
            usernameLabel.text = result[0]
            uuidLabel.text = "uuid: " + result[1]
            
            var hasher = Hasher()
            hasher.combine(code)
            let hash = hasher.finalize()
            hashLabel.text = String(hash)
            cryptoLabel.text = "crypto: " + result[3]
            serverLabel.text = "server: " + result[6]
            return
        }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: "QR неверного формата или устарел", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: {
                UIAlertAction in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    
    }
    
    
    
    @IBAction func accept(_ sender: Any) {
        if let error = InviteManager.acceptInvite(code: code){
            let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func decline(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
