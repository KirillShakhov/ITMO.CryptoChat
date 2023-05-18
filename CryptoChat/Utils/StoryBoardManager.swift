//
//  StoryBoardManager.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 15.05.2023.
//

import UIKit

public class StoryBoardManager{
    static func goToView(_ controller: UIViewController, name: String, withIdentifier: String){
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: withIdentifier) as UIViewController
        vc.modalPresentationStyle = .fullScreen
        controller.dismiss(animated: false)
        controller.present(vc, animated: true, completion: nil)
    }
}
