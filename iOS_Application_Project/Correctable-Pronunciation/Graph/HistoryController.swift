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
    @IBOutlet weak var compareWeekView: UIView!
    @IBOutlet weak var compareWeekLabel: UILabel!
    @IBOutlet weak var compareMonthView: UIView!
    @IBOutlet weak var compareMonthLabel: UILabel!
    
    var currentMonth: Int = {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE,MM,dd"
        let currentDateString: String = dateFormatter.string(from: date)
        let dateFormAry = currentDateString.components(separatedBy: ",")
        return Int(dateFormAry[1]) ?? 1
    }()
    var currentWeek: String = {
        let today = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        formatter.locale = Locale(identifier: "ko")
        guard let date = calendar.date(byAdding: .day, value: 0, to: today) else { return "" }
        return formatter.string(from: date)
    }()
    var monthArr: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0]
    var weekArr: [Int] = [0,0,0,0,0,0,0]
    var changeOfMonth: Int?
    var changeOfWeek: Int?
    //Graph뷰 혹은 Counter뷰 볼것인지 결정하는 변수
    var isGraphViewShowing = true
    
    @IBAction func changeValueOfSegCon(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.transition(from: monthView, to: weekView, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            UIView.transition(from: compareMonthView, to: compareWeekView, duration: 1.0, options: [.showHideTransitionViews], completion: nil)
        case 1:
            UIView.transition(from: weekView, to: monthView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            UIView.transition(from: compareWeekView, to: compareMonthView, duration: 1.0, options: [.showHideTransitionViews], completion: nil)
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
    }
    // 라벨 처리하는 함수
    func getToday() -> String {
        let today = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        formatter.locale = Locale(identifier: "ko")
        guard let date = calendar.date(byAdding: .day, value: 0, to: today) else { return "" }
        return formatter.string(from: date)
        // 정렬된 라벨에 알파벳 형식의 요일을 삽입
    }
    func readFirebaseDataBase() {
        self.ref = Database.database().reference()
        guard var email = Auth.auth().currentUser?.email else {
            print("email 정보 없음")
            return
        }
        email = email.replacingOccurrences(of: ".", with: "_")
        self.ref.child("user_email/\(email)/AccuracyList").observeSingleEvent(of: .value) { (snapshot) in
            switch snapshot.value{
            case .some(let x):
                let y = "\(x)"
                if y == "<null>" {
                    self.indicatorView.stopAnimating()
                    let alert = UIAlertController(title: "알림", message: "발음 연습을 하신 적이 없습니다.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
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
                        self.MonthlyAverage.text = "\(String(format: "%.1f",  self.getAverage(self.monthArr)))%"
                        self.WeeklyAverage.text = "\(String(format: "%.1f",  self.getAverage(self.weekArr)))%"

                        if self.currentWeek == "월" {
                            self.changeOfWeek = self.weekArr[0] - self.weekArr[6]
                        } else if self.currentWeek == "화" {
                            self.changeOfWeek = self.weekArr[1] - self.weekArr[0]
                        } else if self.currentWeek == "수" {
                            self.changeOfWeek = self.weekArr[2] - self.weekArr[1]
                        } else if self.currentWeek == "목" {
                            self.changeOfWeek = self.weekArr[3] - self.weekArr[2]
                        } else if self.currentWeek == "금" {
                            self.changeOfWeek = self.weekArr[4] - self.weekArr[3]
                        } else if self.currentWeek == "토" {
                            self.changeOfWeek = self.weekArr[5] - self.weekArr[4]
                        } else {
                            self.changeOfWeek = self.weekArr[6] - self.weekArr[5]
                        }
                        self.changeOfMonth = self.monthArr[self.currentMonth - 1] - self.monthArr[self.currentMonth - 2]
                        var text = "오늘: \(self.getToday())요일\n어제보다 \(self.changeOfWeek ?? 0)% 변화가 있었습니다."
                        var range = (text as NSString).range(of: "\(self.changeOfWeek ?? 0)")
                        if self.changeOfWeek ?? 0 > 0 {
                            text = "오늘: \(self.getToday())요일\n어제보다 +\(self.changeOfWeek ?? 0)% 변화가 있었습니다."
                            range = (text as NSString).range(of: "+\(self.changeOfWeek ?? 0)")
                        }
                        
                        var attributedString = NSMutableAttributedString(string: text)
                        if self.changeOfWeek ?? 0 >= 0 {
                            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
                        } else {
                            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                        }
                        self.compareWeekLabel.attributedText = attributedString
                        text = "지난 달보다 \(self.changeOfMonth ?? 0)% 변화가 있었습니다."
                        range = (text as NSString).range(of: "\(self.changeOfMonth ?? 0)")
                        if self.changeOfMonth ?? 0 > 0 {
                            text = "지난 달보다 +\(self.changeOfMonth ?? 0)% 변화가 있었습니다."
                            range = (text as NSString).range(of: "+\(self.changeOfMonth ?? 0)")
                        }
                        attributedString = NSMutableAttributedString(string: text)
                        if self.changeOfMonth ?? 0 >= 0 {
                            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
                        } else {
                            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                        }
                        self.compareMonthLabel.attributedText = attributedString
                        self.view.layoutIfNeeded()
                        self.indicatorView.stopAnimating()
                    } catch {
                        
                    }
                }
            case .none:
                print("none")
            }
        }
    }
    func getAverage(_ array: [Int]) -> Double {
        let sum = array.reduce(0) { (result: Int, next: Int) -> Int in
            return result + next
        }
        let countOfArray = array.count
        return Double(sum) / Double(countOfArray)
    }
}
