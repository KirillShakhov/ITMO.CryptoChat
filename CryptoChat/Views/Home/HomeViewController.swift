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
    
    let userNotificationCenter = UNUserNotificationCenter.current()

    private let refreshControl = UIRefreshControl()
        
    var dialogs: [Dialog] = []
    var timer: Timer?

    private var isNotifyGranted: Bool = true
    
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
        self.userNotificationCenter.delegate = self
        self.requestNotificationAuthorization(complete: { granted in
            self.isNotifyGranted = granted
        })
//        self.sendNotification(title: "Title", text: "message")
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
        vc.homeVC = self
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

extension HomeViewController: UNUserNotificationCenterDelegate{
    func requestNotificationAuthorization(complete: @escaping (Bool) -> Void) {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .sound)

        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
                complete(false)
                return
            }
            complete(success)
        }
    }

    func sendNotification(title: String, text: String, timeInterval: TimeInterval = 1) {
        if !isNotifyGranted { return }
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = text
        notificationContent.badge = NSNumber(value: 3)

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)

        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
