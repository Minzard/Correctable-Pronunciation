//
//  HomeController.swift
//  Test3
//
//  Created by 차요셉 on 2019. 3. 20..
//  Copyright © 2019년 차요셉. All rights reserved.
//

import UIKit
import Firebase
class HomeController: UIViewController {

    @IBOutlet weak var userlabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let email = Auth.auth().currentUser?.email else {return}
        userlabel.text = "\(email)님"
        // Do any additional setup after loading the view.
    }

    @IBAction func LogOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
