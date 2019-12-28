//
//  MeanLessViewController2.swift
//  Test3
//
//  Created by 차요셉 on 2019. 4. 8..
//  Copyright © 2019년 차요셉. All rights reserved.
//
import MBCircularProgressBar
import AVFoundation
import UIKit
import Alamofire
import SwiftyJSON
class MeanLessViewController2: UIViewController {
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var myView: UIView!
    var table:Character?
    var dstt:String?
    var color:String?
    var accuracy:Int?
    @IBOutlet weak var firstView: UILabel!
    @IBOutlet weak var secondView: UILabel!
    @IBOutlet weak var thirdView: UILabel!
    @IBOutlet weak var fourthView: UILabel!
    @IBOutlet weak var fifthView: UILabel!
    @IBOutlet weak var sixthView: UILabel!
    

    
    @IBAction func dismissModal(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
//    self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.value=0
        myView.layer.borderWidth = 2.5
        myView.layer.borderColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        myView.layer.cornerRadius = 6

                Alamofire.request(
                    "http://ec2-15-164-228-174.ap-northeast-2.compute.amazonaws.com:8080/api/vi/ddobakis/").responseJSON { response in
                    print("Result: \(response.result)")                         // response serialization result
                    
                    if let json = response.result.value {
                        print("JSON: \(json)") // serialized json response
                    
                        guard let jsonArray = json as? [[String: Any]] else {
                            return
                        }
                        print(jsonArray)
                        print(jsonArray[jsonArray.index(before: jsonArray.endIndex)])
                        var asdf = jsonArray[jsonArray.index(before: jsonArray.endIndex)]
                        
                 //-----------------------------------------------------/
                        self.dstt=(asdf["divided_stt"]! as! String)
                        
                        
                        var DSTT = self.dstt!
                        print(DSTT)
                 //-----------------------------------------------------/
                        self.color=(asdf["color"]! as! String)
                        var COLOR = self.color!
                        print(COLOR)
                   //-----------------------------------------------------/
                        self.accuracy=(asdf["accuracy"]! as! Int)
                        var ACCURACY = self.accuracy!
                       
                        print(ACCURACY)
                        
                        self.firstView.text=String(DSTT[DSTT.index(DSTT.startIndex, offsetBy: 0)])
                        self.secondView.text=String(DSTT[DSTT.index(DSTT.startIndex, offsetBy: 1)])
        //                self.thirdView.text=String(DSTT[DSTT.index(DSTT.startIndex, offsetBy: 2)])
                        self.fourthView.text=String(DSTT[DSTT.index(DSTT.startIndex, offsetBy: 2)])
//                        self.fifthView.text=String(DSTT[DSTT.index(DSTT.startIndex, offsetBy: 3)])
        //                self.sixthView.text=String(DSTT[DSTT.index(DSTT.startIndex, offsetBy: 5)])
                        
                        if (COLOR[COLOR.index(COLOR.startIndex, offsetBy: 0)] == "0") {
                            self.firstView.textColor = UIColor.red
                        } else {self.firstView.textColor = UIColor.black}
                        
                        if (COLOR[COLOR.index(COLOR.startIndex, offsetBy: 1)] == "0") {
                            self.secondView.textColor = UIColor.red
                        } else {self.secondView.textColor = UIColor.black}
                        
        //                if (COLOR[COLOR.index(COLOR.startIndex, offsetBy: 2)] == "0") {
        //                    self.thirdView.textColor = UIColor.red
        //                } else {self.thirdView.textColor = UIColor.black}
                        
                        if (COLOR[COLOR.index(COLOR.startIndex, offsetBy: 2)] == "0") {
                            self.fourthView.textColor = UIColor.red
                        } else {self.fourthView.textColor = UIColor.black}
                        
//                        if (COLOR[COLOR.index(COLOR.startIndex, offsetBy: 4)] == "0") {
//                            self.fifthView.textColor = UIColor.red
//                        } else {self.fifthView.textColor = UIColor.black}
                        
        //                if (COLOR[COLOR.index(COLOR.startIndex, offsetBy: 5)] == "0") {
        //                    self.sixthView.textColor = UIColor.red
        //                } else {self.sixthView.textColor = UIColor.black}
                    
                        UIView.animate(withDuration: 4.0) {
                            self.progressView.value=CGFloat(ACCURACY)
                        }
                    }
                    
                    
                }
    }
    
}
