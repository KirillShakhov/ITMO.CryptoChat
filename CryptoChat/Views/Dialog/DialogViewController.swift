//
//  DialogViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 14.05.2023.
//

import UIKit

class DialogViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var messagesList: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var contextButton: UIButton!
    
    var dialog: Dialog?
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.messagesList.register(UINib(nibName: "MessageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MessageCollectionViewCell")
        self.messagesList.register(UINib(nibName: "ImageMessage", bundle: nil), forCellWithReuseIdentifier: "ImageMessage")

        self.messagesList.dataSource = self
        self.messagesList.delegate = self

        usernameLabel.text = dialog?.username
        if let image = dialog?.image {
            avatarImage.image = UIImage(data: image)
        }
        else{
            avatarImage.image = UIImage(named: "avatar_mock")
        }


        contextButton.addAction(UIAction(title: "", handler: {_ in
            print("defaultAction")
        }), for: .touchUpInside)
        contextButton.menu = addMenuItems()
    }
    
    func addMenuItems() -> UIMenu {
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Удалить", image: UIImage(systemName: "trash"), handler: {_ in
                self.delete()
            })
        ])
        return menuItems
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.dialog?.update(completion: {
                DispatchQueue.main.async{
                    self.messagesList.reloadData()
                }
            })
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }

    func scrollToLast(){
        let lastItemIndex = self.messagesList.numberOfItems(inSection: 0) - 1
        let indexPath:IndexPath = IndexPath(item: lastItemIndex, section: 0)
        self.messagesList.scrollToItem(at: indexPath, at: .bottom, animated: false)
    }
    
    func delete(){
        if let dialog = dialog{
            DialogsManager.shared.delete(dialog: dialog)
        }
        dismiss(animated: true)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func send(_ sender: Any) {
        if let text = textField.text,
           text != ""
        {
            textField.text = ""
            if let dialog = dialog {
                DialogsManager.shared.addMessage(dialog: dialog, me: true, type: .Text, state: .Send, data: text)
                let serviceMessage = ServiceMessage(type: .Text, data: text)
                dialog.send(message: serviceMessage)
                self.messagesList.reloadData()
                self.messagesList.performBatchUpdates(nil, completion: {
                    (result) in
                    self.scrollToLast()
                })
            }
        }
    }
    
    var imagePicker = UIImagePickerController()
    @IBAction func sendAttachment(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var pointOrigin: CGPoint?
    @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y = -keyboardHeight
                let screenSize: CGRect = UIScreen.main.bounds
                self.view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - keyboardHeight)
            }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        let screenSize: CGRect = UIScreen.main.bounds
        self.view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
}



extension DialogViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let message = dialog?.messages?.allObjects[indexPath.item] as? Message {
            if message.type == MessageType.Image{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageMessage", for: indexPath) as! ImageMessage
                if let message = dialog?.messages?.allObjects[indexPath.item] as? Message {
                    cell.message = message
                    cell.update()
                }
                return cell

            }
            else if message.type == MessageType.Text{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
                if let message = dialog?.messages?.allObjects[indexPath.item] as? Message {
                    cell.message = message
                    cell.update()
                }
                return cell
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
        if let message = dialog?.messages?.allObjects[indexPath.item] as? Message {
            cell.message = message
            cell.update()
        }
        return cell
    }
}

extension DialogViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dialog?.messages?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // click
    }
}

extension DialogViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if let message = dialog?.messages?.allObjects[indexPath.item] as? Message {
            if message.type == MessageType.Image{
                return CGSize(width: self.messagesList.visibleSize.width, height: 250.0)
            }
            return CGSize(width: self.messagesList.visibleSize.width, height: 70.0+CGFloat(((message.data?.count ?? 0)*5)))
        }
        return CGSize(width: 100.0, height: 100.0)
    }
}

extension DialogViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField
        {
        case self.textField:
            dismissKeyboard()
            break
        default:
            return false
        }
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension DialogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let base64 = pickedImage.jpegData(compressionQuality: 0.8)?.base64EncodedString()
        {
            if let dialog = dialog{
                DialogsManager.shared.addMessage(dialog: dialog, me: true, type: .Image, state: .Send, data: base64)
                let serviceMessage = ServiceMessage(type: .Image, data: base64)
                dialog.send(message: serviceMessage)
                self.messagesList.reloadData()
                self.messagesList.performBatchUpdates(nil, completion: {
                    (result) in
                    self.scrollToLast()
                })
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
