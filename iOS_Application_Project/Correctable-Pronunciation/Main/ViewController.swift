//
//  ViewController.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020. 12. 12..
//  Copyright © 2020년 차요셉. All rights reserved.
//
import UIKit
import Firebase
class ViewController: UIViewController { 
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func signin(_ sender: Any) {
        
        if self.email.text == "" {
            print("아이디가 입력되지 않았습니다")
            return
        }
        else {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            if error != nil {
                Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!) { [weak self] user, error in
                    guard let self = self else { return }
                    if user == nil || error != nil {
                        let alert = UIAlertController(title: "알림", message: "아이디 또는 패스워드가\n 잘못되었습니다.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    self.performSegue(withIdentifier: "Home", sender: nil)
                }
            }
            else {
                let alert = UIAlertController(title: "알림", message: "회원가입완료", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.performSegue(withIdentifier: "Home", sender: nil)
            }
        }
        }
    }
}
