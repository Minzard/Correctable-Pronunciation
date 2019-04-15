//
//  MeanLessViewController2.swift
//  Test3
//
//  Created by 차요셉 on 2019. 4. 8..
//  Copyright © 2019년 차요셉. All rights reserved.
//

import UIKit

class MeanLessViewController2: UIViewController {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        button.layer.cornerRadius = 8
        
        myView.layer.borderWidth = 2.5
        myView.layer.borderColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        myView.layer.cornerRadius = 6
        
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
