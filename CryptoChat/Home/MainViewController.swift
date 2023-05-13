//
//  ViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 13.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var CreateQrButton: UIButton!
    
    @IBOutlet weak var ScanButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func CreateQr(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreatorQr", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "CreatorQr") as? CreatorQrViewController else { return }
        vc.modalPresentationStyle = .popover
        present(vc, animated:true)
    }
    
    @IBAction func ScanQr(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ScannerView", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "ScannerView") as? ScannerViewController else { return }
        vc.modalPresentationStyle = .popover
        present(vc, animated:true)
    }
}

