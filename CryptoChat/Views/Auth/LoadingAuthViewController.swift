//
//  LoadingAuthViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 15.05.2023.
//

import UIKit

class LoadingAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserManager.getUsername() != nil {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
            vc.modalPresentationStyle = .fullScreen
            dismiss(animated: false)
            present(vc, animated: true, completion: nil)
        }
        else{
            let storyboard = UIStoryboard(name: "FirstSettings", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FirstSettings") as UIViewController
            vc.modalPresentationStyle = .fullScreen
            dismiss(animated: false)
            present(vc, animated: true, completion: nil)
        }
    }
}
