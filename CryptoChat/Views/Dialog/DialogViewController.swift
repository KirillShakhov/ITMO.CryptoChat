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
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func send(_ sender: Any) {
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
