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
        sleep(1)
//        goToView(name: "Main", withIdentifier: "Main")
        StoryBoardManager.goToView(self, name: "FirstSettings", withIdentifier: "FirstSettings")
//        }
    }
}
