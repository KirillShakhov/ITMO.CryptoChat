//
//  PasswordViewController.swift
//  CryptoChat
//
//  Created by Кирилл Шахов on 15.05.2023.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var dot1: UIImageView!
    @IBOutlet weak var dot2: UIImageView!
    @IBOutlet weak var dot3: UIImageView!
    @IBOutlet weak var dot4: UIImageView!
    
    private var code: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dot1.image = UIImage(systemName: "dot.square")
        dot2.image = UIImage(systemName: "dot.square")
        dot3.image = UIImage(systemName: "dot.square")
        dot4.image = UIImage(systemName: "dot.square")
    }
    
    private func click(_ number: Int32){
        code += String(number)
        updateDots()
        if (code.count >= 4){
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "FirstSettings", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "FirstSettings") as! FirstSettingsViewController
                vc.modalPresentationStyle = .fullScreen
                self.parent?.dismiss(animated: false)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    private func updateDots(){
        if (code.count == 0){
            dot1.image = UIImage(systemName: "dot.square")
            dot2.image = UIImage(systemName: "dot.square")
            dot3.image = UIImage(systemName: "dot.square")
            dot4.image = UIImage(systemName: "dot.square")
        }
        else if (code.count == 1){
            dot1.image = UIImage(systemName: "dot.square.fill")
            dot2.image = UIImage(systemName: "dot.square")
            dot3.image = UIImage(systemName: "dot.square")
            dot4.image = UIImage(systemName: "dot.square")
        }
        else if (code.count == 2){
            dot1.image = UIImage(systemName: "dot.square.fill")
            dot2.image = UIImage(systemName: "dot.square.fill")
            dot3.image = UIImage(systemName: "dot.square")
            dot4.image = UIImage(systemName: "dot.square")
        }
        else if (code.count == 3){
            dot1.image = UIImage(systemName: "dot.square.fill")
            dot2.image = UIImage(systemName: "dot.square.fill")
            dot3.image = UIImage(systemName: "dot.square.fill")
            dot4.image = UIImage(systemName: "dot.square")
        }
        else {
            dot1.image = UIImage(systemName: "dot.square.fill")
            dot2.image = UIImage(systemName: "dot.square.fill")
            dot3.image = UIImage(systemName: "dot.square.fill")
            dot4.image = UIImage(systemName: "dot.square.fill")
        }
    }
    
    @IBAction func click1(_ sender: Any) {
        click(1)
    }
    
    @IBAction func click2(_ sender: Any) {
        click(2)
    }
    @IBAction func click3(_ sender: Any) {
        click(3)
    }
    @IBAction func click4(_ sender: Any) {
        click(4)
    }
    @IBAction func click5(_ sender: Any) {
        click(5)
    }
    @IBAction func click6(_ sender: Any) {
        click(6)
    }
    @IBAction func click7(_ sender: Any) {
        click(7)
    }
    @IBAction func click8(_ sender: Any) {
        click(8)
    }
    @IBAction func click9(_ sender: Any) {
        click(9)
    }
    @IBAction func click0(_ sender: Any) {
        click(0)
    }
    @IBAction func clickDelete(_ sender: Any) {
        if (code.count <= 0) {
            return
        }
        code.remove(at: code.index(before: code.endIndex))
        updateDots()
    }
    @IBAction func clickFaceId(_ sender: Any) {
        
    }
}
