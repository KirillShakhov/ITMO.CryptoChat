//
//  FirstSettingsViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 15.05.2023.
//

import UIKit

class FirstSettingsViewController: UIViewController {

    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    var imagePicker = UIImagePickerController()

    private var uuid: String = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameField.delegate = self
        uuidLabel.text = "uuid: "+uuid
        
        let tapOnAvatar = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        avatarView.addGestureRecognizer(tapOnAvatar)
        avatarImage.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func create(_ sender: Any) {
//        uuid = UUID().uuidString
//        uuidLabel.text = "uuid: "+uuid
        
        
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
        
//        var test1 = "Привет    "
//        var key = "12ra5678901234567890123456789012"
//        var iv = "abcdefghijklmnop123"
//        var res1 = test1.aesEncrypt(key: key, iv: iv)
//        print(res1 ?? "nil")
//
//        print(res1?.aesDecrypt(key: key, iv: iv) ?? "nil")
        
        
        if (nameField.text == "") {
            let alert = UIAlertController(title: "Имя пользователя", message: "Не может быть пустым", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(
            nameField.text,
            forKey: "user"
        )
        if let strBase64 = avatarImage.image?.pngData()?.base64EncodedString(options: .lineLength64Characters) {
            print(strBase64)
            defaults.set(
                strBase64,
                forKey: "avatar"
            )
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }

    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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


extension FirstSettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.avatarImage.image = pickedImage
            self.avatarImage.isHidden = false
            self.plusImage.isHidden = true
        }

        dismiss(animated: true, completion: nil)
    }
}
