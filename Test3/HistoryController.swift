//
//  HistoryController.swift
//  Test3
//
//  Created by 차요셉 on 2019. 3. 31..
//  Copyright © 2019년 차요셉. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class HistoryController: UIViewController {

    @IBOutlet weak var progressView: MBCircularProgressBarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.value=0
    }
    

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 4.0) {
            self.progressView.value=60.0
        }
    }
    
}
