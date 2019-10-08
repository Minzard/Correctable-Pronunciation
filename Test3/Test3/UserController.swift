//
//  UserController.swift
//  Test3
//
//  Created by 차요셉 on 2019. 3. 20..
//  Copyright © 2019년 차요셉. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class UserController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    
    var recorder : AVAudioRecorder!
    var player : AVAudioPlayer!
    let setting = [
        AVSampleRateKey : 44100,
        AVLinearPCMBitDepthKey:16
    ]
    let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                      FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
    var aUrl : NSURL!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        

}
    
    @IBAction func record(_ sender: Any) {
        stopButton.isEnabled = true
        recordButton.isEnabled = false
        recorder = getAudio()
        if recorder.prepareToRecord() {
            print("record start")
            recorder.record(forDuration: 10)
        }
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        recordButton.isEnabled = true
        if nil != recorder && recorder.isRecording {
            print("record stop")
            recorder.stop()
            
            print("이제이거돌아간다")
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY.MM.dd.hh.mm.DD"
            let fileName = String(format: "%@.wav", formatter.string(from: NSDate() as Date))
            print("fileName : \(fileName)")
            let filePath = docPath.appendingPathComponent(fileName)
            print(filePath)
            print("위에 파일주소")
            let url = NSURL(fileURLWithPath: filePath)
            
            
            let storageRef = Storage.storage().reference().child("audio")
            
            
            let mountainsRef = storageRef.child("images/mountains.jpg")
            
            // Create file metadata including the content type
            let metadata = StorageMetadata()
            metadata.contentType = "audio/wav"
            
            
            // Upload file and metadata
            let uploadTask = storageRef.putFile(from: url as URL, metadata: metadata)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) { }
    // 디코더 에러 발생하면 호출
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Player Decode Error")
    }
    // 시간 제한으로 녹음 종료하면 호출
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Record Success")
    }
    
    // 녹음중 에러 발생하면 호출
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
    func getAudio() -> AVAudioRecorder{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd.hh.mm.DD"
        let fileName = String(format: "%@.wav", formatter.string(from: NSDate() as Date))
        print("fileName : \(fileName)")
        let filePath = docPath.appendingPathComponent(fileName)
        let url = NSURL(fileURLWithPath: filePath)
        
        aUrl = url
        
        return try! AVAudioRecorder(url: url as URL, settings: setting)
    }

}
