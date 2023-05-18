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
    var dialog: Dialog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messagesList.register(UINib(nibName: "MessageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MessageCollectionViewCell")
        self.messagesList.register(UINib(nibName: "ImageMessage", bundle: nil), forCellWithReuseIdentifier: "ImageMessage")

        self.messagesList.dataSource = self
        self.messagesList.delegate = self

        usernameLabel.text = dialog?.username
        if let image = dialog?.image {
            avatarImage.image = image
        }
        else{
            avatarImage.image = UIImage(named: "avatar_mock")
        }
    }

    func scrollToLast(){
        let lastItemIndex = self.messagesList.numberOfItems(inSection: 0) - 1
        let indexPath:IndexPath = IndexPath(item: lastItemIndex, section: 0)
        self.messagesList.scrollToItem(at: indexPath, at: .bottom, animated: false)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func send(_ sender: Any) {
        if let text = textField.text{
            textField.text = ""
            let message = Message(me: true, type: .Text, state: .Send, data: text)
            let serviceMessage = ServiceMessage(type: .Text, data: text)
            dialog?.messages.append(message)
            dialog?.send(message: serviceMessage)
        }
    }
}

extension DialogViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let message = dialog?.messages[indexPath.item] {
            if message.type == MessageType.Image{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageMessage", for: indexPath) as! ImageMessage
                if let message = dialog?.messages[indexPath.item] {
                    cell.message = message
                    cell.update()
                }
                return cell

            }
            else if message.type == MessageType.Text{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
                if let message = dialog?.messages[indexPath.item] {
                    cell.message = message
                    cell.update()
                }
                return cell
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
        if let message = dialog?.messages[indexPath.item] {
            cell.message = message
            cell.update()
        }
        return cell
    }
}

extension DialogViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dialog?.messages.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // click
    }
}

extension DialogViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if let message = dialog?.messages[indexPath.item] {
            if message.type == MessageType.Image{
                return CGSize(width: self.messagesList.visibleSize.width, height: 250.0)

            }
            return CGSize(width: self.messagesList.visibleSize.width, height: 70.0+CGFloat((message.data.count*5)))
        }
        return CGSize(width: 100.0, height: 100.0)
    }
}
