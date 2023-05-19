//
//  SettingsViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 19.05.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serverField: UITextField!
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        let tapOnAvatar = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.imageView.addGestureRecognizer(tapOnAvatar)
        
        self.serverField.text = UserManager.GetHost()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }

    
    
    @IBAction func deleteAllData(_ sender: Any) {
        DialogsManager.shared.deleteAllData()
        UserManager.deleteAllData()
        let serviceMessage = ServiceMessage(type: .DialogDelete, data: "")
        for dialog in DialogsManager.shared.getData() {
            if dialog.recipient != nil{
                dialog.send(message: serviceMessage)
            }
        }
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)

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
            var avatarData = "nil"
            if let avatar = UserManager.getAvatar(),
               let jpegAvatar = avatar.jpegData(compressionQuality: 0.1)
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
        
            dismiss(animated: true)
        }
        else{
            let alert = UIAlertController(title: "Имя пользователя", message: "Не может быть пустым", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
