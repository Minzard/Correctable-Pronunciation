//
//  HistoryController.swift
//  Correctable-Pronunciation
//
//  Created by 차요셉 on 2020. 12. 15..
//  Copyright © 2020년 차요셉. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import Firebase
class HistoryController: UIViewController {
    var ref : DatabaseReference!
    @IBOutlet weak var MonthlyAverage: UILabel!
    @IBOutlet weak var WeeklyAverage: UILabel!
    @IBOutlet var weekView: WeekView!
    @IBOutlet weak var monthView: MonthView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var compareView: UIView!
    @IBOutlet weak var compareLabel: UILabel!
    var monthArr: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var weekArr: [Int] = [0,0,0,0,0,0,0]
    //Graph뷰 혹은 Counter뷰 볼것인지 결정하는 변수
    var isGraphViewShowing = true
    
    @IBAction func changeValueOfSegCon(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.transition(from: monthView, to: weekView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        case 1:
            UIView.transition(from: weekView, to: monthView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        default:
            print("Segcon 에러")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        indicatorView.startAnimating()
        readFirebaseDataBase()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLoad() {
        indicatorView.startAnimating()
        readFirebaseDataBase()
        super.viewDidLoad()
        setupGraphDisplay()
        compareLabel.text = ""
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
    func readFirebaseDataBase() {
        self.ref = Database.database().reference()
        guard var email = Auth.auth().currentUser?.email else {
            print("email 정보 없음")
            return
        }
        email = email.replacingOccurrences(of: ".", with: "_")
//                    self.ref.child("user_email").child(email).child("accuracy_list").setValue([self.accuracy])
        
        self.ref.child("user_email/\(email)/AccuracyList").observeSingleEvent(of: .value) { (snapshot) in
            switch snapshot.value{
            case .some(let x):
                let y = "\(x)"
                if y == "<null>" {
                    print("발음 연습을 하신 적이 없습니다.")
                } else {
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: snapshot.value!, options: .prettyPrinted)
                        let tempAccuracyList = try JSONDecoder().decode(AccuracyList.self, from: dataJSON)
                        if let mondayAccArr = tempAccuracyList.monday?.accuracyArr {
                            let countOfaccArr = mondayAccArr.count
                            let sumOfAccArr = mondayAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.weekArr[0] = sumOfAccArr / countOfaccArr
                        } else {
                            self.weekArr[0] = 0
                        }
                        if let tuesdayAccArr = tempAccuracyList.tuesday?.accuracyArr {
                            let countOfaccArr = tuesdayAccArr.count
                            let sumOfAccArr = tuesdayAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.weekArr[1] = sumOfAccArr / countOfaccArr
                        } else {
                            self.weekArr[1] = 0
                        }
                        if let wednesdayAccArr = tempAccuracyList.wednesday?.accuracyArr {
                            let countOfaccArr = wednesdayAccArr.count
                            let sumOfAccArr = wednesdayAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.weekArr[2] = sumOfAccArr / countOfaccArr
                        } else {
                            self.weekArr[2] = 0
                        }
                        if let thursdayAccArr = tempAccuracyList.thursday?.accuracyArr {
                            let countOfaccArr = thursdayAccArr.count
                            let sumOfAccArr = thursdayAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.weekArr[3] = sumOfAccArr / countOfaccArr
                        } else {
                            self.weekArr[3] = 0
                        }
                        if let fridayAccArr = tempAccuracyList.friday?.accuracyArr {
                            let countOfaccArr = fridayAccArr.count
                            let sumOfAccArr = fridayAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.weekArr[4] = sumOfAccArr / countOfaccArr
                        } else {
                            self.weekArr[4] = 0
                        }
                        if let saturdayAccArr = tempAccuracyList.saturday?.accuracyArr {
                            let countOfaccArr = saturdayAccArr.count
                            let sumOfAccArr = saturdayAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.weekArr[5] = sumOfAccArr / countOfaccArr
                        } else {
                            self.weekArr[5] = 0
                        }
                        if let sundayAccArr = tempAccuracyList.sunday?.accuracyArr {
                            let countOfaccArr = sundayAccArr.count
                            let sumOfAccArr = sundayAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.weekArr[6] = sumOfAccArr / countOfaccArr
                        } else {
                            self.weekArr[6] = 0
                        }
                        
                        if let janAccArr = tempAccuracyList.month?.jan {
                            let countOfaccArr = janAccArr.count
                            let sumOfAccArr = janAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[0] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[0] = 0
                        }
                        if let febAccArr = tempAccuracyList.month?.feb {
                            let countOfaccArr = febAccArr.count
                            let sumOfAccArr = febAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[1] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[1] = 0
                        }
                        if let marAccArr = tempAccuracyList.month?.mar {
                            let countOfaccArr = marAccArr.count
                            let sumOfAccArr = marAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[2] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[2] = 0
                        }
                        if let aprAccArr = tempAccuracyList.month?.apr {
                            let countOfaccArr = aprAccArr.count
                            let sumOfAccArr = aprAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[3] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[3] = 0
                        }
                        if let mayAccArr = tempAccuracyList.month?.may {
                            let countOfaccArr = mayAccArr.count
                            let sumOfAccArr = mayAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[4] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[4] = 0
                        }
                        if let junAccArr = tempAccuracyList.month?.jun {
                            let countOfaccArr = junAccArr.count
                            let sumOfAccArr = junAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[5] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[5] = 0
                        }
                        if let julAccArr = tempAccuracyList.month?.jul {
                            let countOfaccArr = julAccArr.count
                            let sumOfAccArr = julAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[6] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[6] = 0
                        }
                        if let augAccArr = tempAccuracyList.month?.aug {
                            let countOfaccArr = augAccArr.count
                            let sumOfAccArr = augAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[7] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[7] = 0
                        }
                        if let sepAccArr = tempAccuracyList.month?.sep {
                            let countOfaccArr = sepAccArr.count
                            let sumOfAccArr = sepAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[8] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[8] = 0
                        }
                        if let octAccArr = tempAccuracyList.month?.oct {
                            let countOfaccArr = octAccArr.count
                            let sumOfAccArr = octAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[9] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[9] = 0
                        }
                        if let novAccArr = tempAccuracyList.month?.nov {
                            let countOfaccArr = novAccArr.count
                            let sumOfAccArr = novAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[10] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[10] = 0
                        }
                        if let decAccArr = tempAccuracyList.month?.dec {
                            let countOfaccArr = decAccArr.count
                            let sumOfAccArr = decAccArr.reduce(0) { (result: Int, next: Int) -> Int in
                                return result + next
                            }
                            self.monthArr[11] = sumOfAccArr / countOfaccArr
                        } else {
                            self.monthArr[11] = 0
                        }
                        self.weekView.graphPoints = self.weekArr
                        self.monthView.graphPoints = self.monthArr
                        self.weekView.setNeedsDisplay()
                        self.monthView.setNeedsDisplay()
                        self.MonthlyAverage.text = "\(self.getAverage(self.monthArr))%"
                        self.WeeklyAverage.text = "\(self.getAverage(self.weekArr))%"
                        self.view.layoutIfNeeded()
                        self.indicatorView.stopAnimating()
                    }
                        
                     catch {
                        
                    }
                }
            case .none:
                print("none")
            }
        }
    }
    func getAverage(_ array: [Int]) -> Int {
        let sum = array.reduce(0) { (result: Int, next: Int) -> Int in
            return result + next
        }
        let countOfArray = array.count
        return sum / countOfArray
    }
}
