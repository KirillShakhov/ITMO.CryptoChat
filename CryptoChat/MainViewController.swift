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
        
    }
    
    @IBAction func ScanQr(_ sender: Any) {
//        guard let popoverContent = storyboard?.instantiateViewController(identifier: "ScannerViewController") as? ScannerViewController else { return }
//
//        popoverContent.modalPresentationStyle = .popover
//        var popover = popoverContent.popoverPresentationController
//        if let popover = popoverContent.popoverPresentationController {
//            let viewForSource = sender as! UIView
//            popover.sourceView = viewForSource
//            // the position of the popover where it's showed
//            popover.sourceRect = viewForSource.bounds
//            // the size you want to display
//            popoverContent.preferredContentSize = CGSizeMake(200,500)
//            popover.delegate = self
//        }
//        self.present(popoverContent, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "ScannerView", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "ScannerView") as? ScannerView else { return }
        vc.modalPresentationStyle = .popover
        present(vc, animated:true)
    }
}

