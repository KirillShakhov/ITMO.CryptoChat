//
//  SettingsViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 19.05.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var realImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serverField: UITextField!
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        if let image = UserManager.getAvatar() {
            self.imageView.image = image
        }
        else{
            self.imageView.image = UIImage(named: "avatar_mock")
        }
        
        self.serverField.text = UserManager.GetHost()
        self.nameField.text = UserManager.getUsername()
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
                realImageView.isHidden = true
            }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        let screenSize: CGRect = UIScreen.main.bounds
        self.view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        realImageView.isHidden = false
    }
    
    @IBAction func deleteAllData(_ sender: Any) {
        let serviceMessage = ServiceMessage(type: .DialogDelete, data: "")
        for dialog in DialogsManager.shared.getData() {
            if dialog.recipient != nil{
                dialog.send(message: serviceMessage)
            }
        }
        DialogsManager.shared.deleteAllData()
        UserManager.deleteAllData()
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

    }
    
    @IBAction func changeImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
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
        if let username = nameField.text,
           username != ""
        {
            UserManager.setUsername(name: username)
        }
        else{
            let alert = UIAlertController(title: "Имя пользователя", message: "Не может быть пустым", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if let image = self.imageView.image {
            UserManager.setAvatar(image: image)
        }
        var avatarData = "nil"
        if let avatar = UserManager.getAvatar(),
           let jpegAvatar = avatar.jpegData(compressionQuality: 0.2)
        {
            avatarData = jpegAvatar.base64EncodedString()
        }
        if let json = JsonUtil.toJson(data: [UserManager.getUsername(), UserManager.getUuid(),avatarData])
        {
            let serviceMessage = ServiceMessage(type: .UpdateDialog, data: json)
            for dialog in DialogsManager.shared.getData() {
                if dialog.recipient != nil{
                    dialog.send(message: serviceMessage)
                }
            }
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
