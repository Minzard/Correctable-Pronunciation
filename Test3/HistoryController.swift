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

   
    @IBOutlet weak var graphView: Graph_View!
    @IBOutlet weak var counterView: Counter_View!
    var isGraphViewShowing = true
    
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        if(isGraphViewShowing) {
            UIView.transition(from: graphView, to: counterView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            UIView.transition(from: counterView, to: graphView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            setupGraphDisplay()
        }
        isGraphViewShowing = !isGraphViewShowing
       
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupGraphDisplay() {
        let maxDayIndex = 7
        graphView.graphPoints[graphView.graphPoints.count - 1] = 7
        graphView.setNeedsDisplay()
//        maxLabel.text = "\(graphView.graphPoints.max()!)"
        
        let average = graphView.graphPoints.reduce(0, +)
//        averageWaterDrunk.text = "\(average)"
        
        let today = Date()
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        
//        for i in 0...maxDayIndex {
//            if let date = calendar.date(byAdding: .day, value: -i, to: today),
//                let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
//                label.text = formatter.string(from: date)
//            }
//            
//        }
    }
}
