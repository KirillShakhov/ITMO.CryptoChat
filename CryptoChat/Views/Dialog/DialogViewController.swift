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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageCollectionViewCell", for: indexPath) as! MessageCollectionViewCell
//        let dialog = dialogs[indexPath.item]
//        cell.dialog = dialog
//        cell.update()
//        cell.kcal.text = String(format: "%.1f", recipe.kcal)
//        if(cell.imageURL != recipe.image){
//            cell.image.image = nil
//            cell.imageURL = recipe.image
//            cell.activityIndicator.isHidden = false
//            DispatchQueue.global().async {
//                if let data = try? Data(contentsOf: URL(string: recipe.image)!) {
//                    if let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            cell.image.image = image
//                            cell.activityIndicator.isHidden = true
//                        }
//                    }
//                }
//            }
//        }
//        cell.layer.shadowColor = UIColor.gray.cgColor
//        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        cell.layer.shadowRadius = 5.0
//        cell.layer.shadowOpacity = 1.0
//        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
}

extension DialogViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dialog?.messages.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let dialog = dialogs[indexPath.item]
//        let storyboard = UIStoryboard(name: "MessageCollectionViewCell", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(identifier: "MessageCollectionViewCell") as? MessageCollectionViewCell else { return }
//        vc.modalPresentationStyle = .popover
//        self.navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated:true)
    }
}

extension DialogViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//        if collectionView == self.chatList {
        return CGSize(width: self.messagesList.visibleSize.width, height: 70.0)
//        }
//        return CGSize(width: 100.0, height: 100.0)
    }
}
