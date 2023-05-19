//
//  ViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 13.05.2023.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController {
    @IBOutlet weak var CreateQrButton: UIButton!
    @IBOutlet weak var ScanButton: UIButton!
    @IBOutlet weak var chatList: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    private let refreshControl = UIRefreshControl()
        
    var dialogs: [Dialog] = []
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatList.register(UINib(nibName: "ChatViewCell", bundle: nil), forCellWithReuseIdentifier: "ChatViewCell")

        self.chatList.dataSource = self
        self.chatList.delegate = self

        refreshControl.layer.zPosition = -1
        self.chatList.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateChats(_:)), for: .valueChanged)
        
        refreshControl.tintColor = UIColor.systemPink.withAlphaComponent(0.4)
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление чатов ...")
        
        refreshControl.beginRefreshing()
        
        //
        usernameLabel.text = UserManager.getUsername()
        if let avatar = UserManager.getAvatar(){
            avatarImage.image = avatar
        }
        else {
            avatarImage.image = UIImage(systemName: "avatar_mock")
        }
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound]) {(accepted, error) in
//            if !accepted {
//                print("Notification access denied")
//            }
//        }
//
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//
//        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
//        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
//
//        center.setNotificationCategories([category])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateChats(self)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateChats(self)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc private func updateChats(_ sender: Any) {
        NotifyManager.update(completion: {
            self.refreshControl.endRefreshing()
            self.dialogs = DialogsManager.shared.getData()
            self.chatList.reloadData()
        })
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
    
    
    @IBAction func openSettings(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "Settings") as? SettingsViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated:true)
    }
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatViewCell", for: indexPath) as! ChatViewCell
        let dialog = dialogs[indexPath.item]
        cell.dialog = dialog
        cell.update()
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
        return dialogs.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dialog = dialogs[indexPath.item]
        let storyboard = UIStoryboard(name: "Dialog", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "Dialog") as? DialogViewController else { return }
        vc.dialog = dialog
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated:true)
        vc.messagesList.reloadData()
        vc.messagesList.performBatchUpdates(nil, completion: {
            (result) in
            vc.scrollToLast()
        })
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


extension HomeViewController: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        print("userNotificationCenter willPresent")
        completionHandler( [.badge, .sound])
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("Do what ever you want")

    }

}
