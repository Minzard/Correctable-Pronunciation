//
//  HomeController.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020. 12. 10..
//  Copyright © 2020년 차요셉. All rights reserved.
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
}
