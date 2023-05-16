//
//  ViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 13.05.2023.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var CreateQrButton: UIButton!
    @IBOutlet weak var ScanButton: UIButton!
    @IBOutlet weak var chatList: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    private let refreshControl = UIRefreshControl()
    var username: String = ""
    var avatar: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatList.register(UINib(nibName: "ChatViewCell", bundle: nil), forCellWithReuseIdentifier: "ChatViewCell")

        self.chatList.dataSource = self
        self.chatList.delegate = self

        refreshControl.layer.zPosition = -1
        self.chatList.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateChats(_:)), for: .valueChanged)
        
        refreshControl.tintColor = UIColor.systemPink.withAlphaComponent(0.4)
        refreshControl.attributedTitle = NSAttributedString(string: "Update chats ...")

        //
        usernameLabel.text = username
        avatarImage.image = avatar
    }
    
    @objc private func updateChats(_ sender: Any) {
//        if(findField.text == nil || findField.text == ""){
//            recipes = RecipeModel.getRecipes()
//        }else{
//            recipes = RecipeModel.getRecipes(find: findField.text!)
//        }
        self.refreshControl.endRefreshing()
//        recipeList.reloadData()
        print("Updated")
    }

    @IBAction func CreateQr(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreatorQr", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "CreatorQr") as? CreatorQrViewController else { return }
        vc.modalPresentationStyle = .popover
        present(vc, animated:true)
    }
    
    @IBAction func ScanQr(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ScannerView", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "ScannerView") as? ScannerViewController else { return }
        vc.modalPresentationStyle = .popover
        present(vc, animated:true)
    }
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatViewCell", for: indexPath) as! ChatViewCell
//        let recipe = recipes[indexPath.item]
//        cell.title.text = recipe.name
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

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Dialog", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "Dialog") as? DialogViewController else { return }
        vc.modalPresentationStyle = .popover
        self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated:true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == self.chatList {
            return CGSize(width: self.chatList.visibleSize.width, height: 70.0)
        }
        return CGSize(width: 100.0, height: 100.0)
    }
}
