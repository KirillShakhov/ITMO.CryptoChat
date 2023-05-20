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
    @IBOutlet weak var serverField: UITextField!
    var imagePicker = UIImagePickerController()

    private var uuid: String = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        serverField.delegate = self
        nameField.delegate = self
        uuidLabel.text = "uuid: "+uuid
        
        let tapOnAvatar = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        avatarView.addGestureRecognizer(tapOnAvatar)
        avatarImage.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y = -keyboardHeight
                let screenSize: CGRect = UIScreen.main.bounds
                self.view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - keyboardHeight)
                avatarView.isHidden = true
            }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        let screenSize: CGRect = UIScreen.main.bounds
        self.view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        avatarView.isHidden = false
    }

    @IBAction func create(_ sender: Any) {
        if serverField.text == "" {
            let alert = UIAlertController(title: "Адрес сервера", message: "Не может быть пустым", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if !UserManager.setHost(host: serverField.text ?? ""){
            let alert = UIAlertController(title: "Адрес сервера", message: "Введенный вами адрес сервера недействителен или недоступен", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if nameField.text == "" {
            let alert = UIAlertController(title: "Имя пользователя", message: "Не может быть пустым", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let username = nameField.text else { return }
        UserManager.setUsername(name: username)
        if let image = avatarImage.image{
            UserManager.setAvatar(image: image)
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
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
            case self.serverField:
                self.nameField.becomeFirstResponder()
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
