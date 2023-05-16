//
//  LoadingAuthViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 15.05.2023.
//

import UIKit

class LoadingAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let defaults = UserDefaults.standard
//        if defaults.string(forKey: "token") != nil {
//            let result = Sender.querySyncGetJSON(path: "/users")
//            print(result)
//            if(result.code == 200) {
//                goToView(name: "Main", withIdentifier: "MainViewController")
//            }
//            else{
//                print("Не достоин")
//                defaults.removeObject(forKey: "token")
//                goToView(name: "Auth", withIdentifier: "Auth")
//            }
//        }
//        else{
        sleep(0)
//        goToView(name: "Main", withIdentifier: "Main")
//        StoryBoardManager.goToView(self, name: "FirstSettings", withIdentifier: "FirstSettings")
//        StoryBoardManager.goToView(self, name: "Password", withIdentifier: "Password")
        
        let defaults = UserDefaults.standard
        if let userData = defaults.string(
            forKey: "user"
        ) {
            var avatar: UIImage? = nil
            if let avatarData = defaults.string(
                forKey: "avatar"
            ) {
                let dataDecoded : Data = Data(base64Encoded: avatarData, options: .ignoreUnknownCharacters)!
                avatar = UIImage(data: dataDecoded)
            }
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
            vc.username = userData
            vc.avatar = avatar
            vc.modalPresentationStyle = .fullScreen
            dismiss(animated: false)
            present(vc, animated: true, completion: nil)
        }
        else{
            StoryBoardManager.goToView(self, name: "FirstSettings", withIdentifier: "FirstSettings")
        }
    }
}
