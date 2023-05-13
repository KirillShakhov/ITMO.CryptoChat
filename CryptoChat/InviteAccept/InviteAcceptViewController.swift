//
//  InviteAcceptViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 13.05.2023.
//

import UIKit

class InviteAcceptViewController: UIViewController {

    var code: String = ""
    
    @IBOutlet weak var textResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textResult.text = code
    }
    

    @IBAction func decline(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
