//
//  FirstSettingsViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 15.05.2023.
//

import UIKit

class FirstSettingsViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameField.delegate = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
extension FirstSettingsViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
            switch textField
            {
            case self.nameField:
                dismissKeyboard()
                break
            default:
                return false
            }
            return true
        }
}
