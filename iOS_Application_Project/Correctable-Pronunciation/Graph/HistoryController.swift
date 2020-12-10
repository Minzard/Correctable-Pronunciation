//
//  HistoryController.swift
//  Test3
//
//  Created by 차요셉 on 2020. 12. 15..
//  Copyright © 2019년 차요셉. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class HistoryController: UIViewController {

   
    @IBOutlet weak var MonthlyAverage: UILabel!
    @IBOutlet weak var WeeklyAverage: UILabel!
    @IBOutlet weak var graphView: Graph_View!
    @IBOutlet weak var counterView: Counter_View!
    @IBOutlet weak var stackView: UIStackView!
    
    //Graph뷰 혹은 Counter뷰 볼것인지 결정하는 변수
    var isGraphViewShowing = true
    
    // 탭 제스쳐 액션메소드
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        if(isGraphViewShowing) {
            // graphView에서 CounterView로 변경
            UIView.transition(from: graphView, to: counterView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
           
        } else {
            // CounterView에서 graphView로 변경
            UIView.transition(from: counterView, to: graphView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
            
            setupGraphDisplay()
        }
        isGraphViewShowing = !isGraphViewShowing
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGraphDisplay()
        
        // Do any additional setup after loading the view.
    }
    // 라벨 처리하는 함수
    func setupGraphDisplay() {
        
        // 현재 날짜를 알려주는 변수
        let today = Date()
        let calendar = Calendar.current
        
        // 요일을 알파벳형식으로 포맷하는 과정 ex) 일(일요일) 월(월요일)
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        formatter.locale = Locale(identifier: "ko")
        // 정렬된 라벨에 알파벳 형식의 요일을 삽입
        for i in 0...6 {
            if let date = calendar.date(byAdding: .day, value: +i, to: today),
                let label = stackView.arrangedSubviews[0 + i] as? UILabel {
                label.text = formatter.string(from: date)
            }
    
        }
    }
}
