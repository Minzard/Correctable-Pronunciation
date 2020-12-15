//
//  MeanLessViewController.swift
//  Test3
//
//  Created by 차요셉 on 2020. 12. 12..
//  Copyright © 2020년 차요셉. All rights reserved.
// 63 140 39


import UIKit
import Speech
import AVFoundation
import AVKit
import MBCircularProgressBar
import Firebase

class MeanLessViewController: UIViewController, SFSpeechRecognizerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    var dayArr = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    var monthArr = ["jan","feb","mar","apr","may","jun","jul","aug","sep","opt","dec","nov"]
    var ref : DatabaseReference!
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var wordArr: [String?] = []
    var currentIndex: Int?
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var currentWord: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var Play: UIButton!
    @IBOutlet weak var Stop: UIButton!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var wordView: UIView!
    @IBOutlet weak var secondViewNextbt: UIButton!
    @IBOutlet weak var secondViewOneMorebt: UIButton!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var dividedLabel: UILabel!
    @IBOutlet weak var dividedSTTLabel: UILabel!
    
    func initButton() {
        let btArr: [UIButton?] = [button,nextButton,Play,Stop,secondViewNextbt,secondViewOneMorebt]
        btArr.forEach {
            $0?.layer.borderColor = UIColor.darkGray.cgColor
            $0?.layer.borderWidth = 0.5
            $0?.layer.cornerRadius = 9
            if $0 == nextButton || $0 == Play || $0 == Stop {
                $0?.isHidden = true
            }
        }
    }
    // 음성인식 설정
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var joseph:String?
    var accuracy: Int?
    var colorCode: String?
    var dividedSTT: String?
    var dividedLB: String?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        // ios 10 이상부턴 .builtInWideAngleCamera
        guard let frontCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: AVMediaType.video,
            position: .front)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.previewView.bounds
            self.videoView.layer.cornerRadius = 9
            self.videoView.clipsToBounds = true
            self.previewView.layer.cornerRadius = 9
            self.previewView.clipsToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        initButton()
        self.progressView.value = 0
        currentWord.text = "'\(wordArr[0] ?? "")'"
        // videoView's cornerRidus 설정
        self.videoView.layer.cornerRadius = 9
        // previewView's cornerRidus 설정
        self.previewView.layer.cornerRadius = 9
        // wordView 테두리 설정
        wordView.layer.borderWidth = 1
        wordView.layer.borderColor = UIColor(red: 209/255, green: 209/255, blue: 214/255, alpha: 1).cgColor
        wordView.layer.cornerRadius = 9
        // imageView 에 이미지 넣기
        let imageName = "썸네일.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.frame = self.videoView.bounds
        self.videoView.addSubview(imageView)
        // 음성인식 델리게이트 설정
        speechRecognizer?.delegate = self
        // 녹음 설정
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        //        let pathArray = [dirPath, recordingName]
        //        let filePath = URL(string: pathArray.joined(separator: "/"))
        let filepath = NSURL(fileURLWithPath: dirPath + "/" + recordingName)
        // 녹음 품질 설정
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                              AVNumberOfChannelsKey: 1,
                              AVSampleRateKey: 44100.0] as [String : Any]
        // 공유 오디오 세션 인스턴스를 반환 받는다.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // 현재 오디오 세션의 카테고리를 정한다. (재생, 녹음)
            try audioSession.setCategory(.playAndRecord, mode: .default, policy: .default, options: .defaultToSpeaker)
        } catch {
            print("audioSession error: \(error.localizedDescription)")
        }
        // audioRecorder 인스턴스 생성
        do {
            try audioRecorder = AVAudioRecorder(url: filepath as URL, settings: recordSettings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("audioSession Error: \(error.localizedDescription)")
        }
        
    }
    // 영상 재생 탭제츠처
    @IBAction func VideoClick(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "아아", ofType:"MOV") else {
            debugPrint("video.m4v not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        playerLayer.videoGravity = .resize
        self.videoView.layer.addSublayer(playerLayer)
        
        player.play()
        videoView.layer.cornerRadius = 6
    }
    // 녹음 버튼
    @IBAction func Recordudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            Stop.isHidden = false
            audioRecorder?.record()
        }
    }
    // 멈춤 버튼
    @IBAction func StopAudio(_ sender: Any) {
        button.isHidden = true
        Play.isHidden = false
        nextButton.isHidden = false
        Stop.isHidden = true
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
        let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
        let request = SFSpeechURLRecognitionRequest(url: (audioRecorder?.url)!)
        recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                                        self.joseph = result?.bestTranscription.formattedString})
    }
    // 재생 버튼
    @IBAction func PlayAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            button.isEnabled = false
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer?.delegate=self
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = 3
                audioPlayer?.play()
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
        }
    }
    // 다음 버튼
    @IBAction func next(_ sender: Any) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE,MM,dd"
        let currentDateString: String = dateFormatter.string(from: date)
        let dateFormAry = currentDateString.components(separatedBy: ",")
        guard let dayOfWeek = dateFormAry.first?.lowercased() else { return }
        let month = Int(dateFormAry[1]) ?? 1
        let day = Int(dateFormAry.last ?? "1") ?? 1
        let dateSize = (month * 30) + day
        
        let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
        let request = SFSpeechURLRecognitionRequest(url: (audioRecorder?.url)!)
        recognizer?.recognitionTask(with: request, resultHandler: {(result, error) in self.joseph = result?.bestTranscription.formattedString})
        let parameters: [String: Any] = [
            "user": Auth.auth().currentUser?.email ?? "",
            "label": "\(wordArr[0] ?? "")",
            "stt": joseph ?? ""
        ]
        PronunciationRequest.sharedInstance.request(ServerURL.URL1,parameters: parameters) { (data, error) in
            if error == nil, let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(Pronunciation.self, from: data)
                    self.accuracy = decodedResponse.accuracy
                    self.colorCode = decodedResponse.colorCode
                    self.dividedSTT = decodedResponse.dividedSTT
                    self.dividedLB = decodedResponse.dividedLabel
                    let attributedStr = NSMutableAttributedString(string: self.dividedSTT ?? "")
                    if self.dividedSTT?.count != self.colorCode?.count {
                        if let dividedSTT = self.dividedSTT, let colorCode = self.colorCode {
                            for (index, _) in dividedSTT.enumerated() {
                                let colorCodeIndex = colorCode.index(colorCode.startIndex, offsetBy:index)
                                if colorCode[colorCodeIndex] == "0" {
                                    attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(index...index))
                                }
                            }
                        }
                    } else {
                        if let colorCode = self.colorCode {
                            for (index, character) in colorCode.enumerated() {
                                if character == "0" {
                                    attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(index...index))
                                }
                            }
                        }
                    }
                    
                    self.dividedLabel.text = self.dividedLB
                    self.dividedSTTLabel.attributedText = attributedStr
                    
                    UIView.animate(withDuration: 2.0) {
                        self.progressView.value = CGFloat(self.accuracy ?? 0)
                    }
                    guard var email = Auth.auth().currentUser?.email else {
                        print("email 정보 없음")
                        return
                    }
                    email = email.replacingOccurrences(of: ".", with: "_")
                    self.ref.child("user_email/\(email)/AccuracyList").observeSingleEvent(of: .value, with: { (snapshot) in
                        switch snapshot.value{
                        case .some(let x):
                            let y = "\(x)"
                            if y == "<null>" {
                                if month == 1 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/jan").setValue([self.accuracy ?? 0])
                                } else if month == 2 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/feb").setValue([self.accuracy ?? 0])
                                } else if month == 3 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/mar").setValue([self.accuracy ?? 0])
                                } else if month == 4 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/apr").setValue([self.accuracy ?? 0])
                                } else if month == 5 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/may").setValue([self.accuracy ?? 0])
                                } else if month == 6 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/jun").setValue([self.accuracy ?? 0])
                                } else if month == 7 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/jul").setValue([self.accuracy ?? 0])
                                } else if month == 8 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/aug").setValue([self.accuracy ?? 0])
                                } else if month == 9 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/sep").setValue([self.accuracy ?? 0])
                                } else if month == 10 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/opt").setValue([self.accuracy ?? 0])
                                } else if month == 11 {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/nov").setValue([self.accuracy ?? 0])
                                } else {
                                    self.ref.child("user_email/\(email)/AccuracyList/month/dec").setValue([self.accuracy ?? 0])
                                }
                                if dayOfWeek == "monday" {
                                    self.ref.child("user_email/\(email)/AccuracyList/monday/accuracyArr").setValue([self.accuracy ?? 0])
                                    self.ref.child("user_email/\(email)/AccuracyList/monday/date").setValue(dateSize)
                                } else if dayOfWeek == "tuesday" {
                                    self.ref.child("user_email/\(email)/AccuracyList/tuesday/accuracyArr").setValue([self.accuracy ?? 0])
                                    self.ref.child("user_email/\(email)/AccuracyList/tuesday/date").setValue(dateSize)
                                } else if dayOfWeek == "wednesday" {
                                    self.ref.child("user_email/\(email)/AccuracyList/wednesday/accuracyArr").setValue([self.accuracy ?? 0])
                                    self.ref.child("user_email/\(email)/AccuracyList/wednesday/date").setValue(dateSize)
                                } else if dayOfWeek == "thursday" {
                                    self.ref.child("user_email/\(email)/AccuracyList/thursday/accuracyArr").setValue([self.accuracy ?? 0])
                                    self.ref.child("user_email/\(email)/AccuracyList/thursday/date").setValue(dateSize)
                                } else if dayOfWeek == "friday" {
                                    self.ref.child("user_email/\(email)/AccuracyList/friday/accuracyArr").setValue([self.accuracy ?? 0])
                                    self.ref.child("user_email/\(email)/AccuracyList/friday/date").setValue(dateSize)
                                } else if dayOfWeek == "saturday" {
                                    self.ref.child("user_email/\(email)/AccuracyList/saturday/accuracyArr").setValue([self.accuracy ?? 0])
                                    self.ref.child("user_email/\(email)/AccuracyList/saturday/date").setValue(dateSize)
                                } else {
                                    self.ref.child("user_email/\(email)/AccuracyList/sunday/accuracyArr").setValue([self.accuracy ?? 0])
                                    self.ref.child("user_email/\(email)/AccuracyList/sunday/date").setValue(dateSize)
                                }
                            } else {
                                do {
                                    let dataJSON = try JSONSerialization.data(withJSONObject: snapshot.value!, options: .prettyPrinted)
                                    let tempAccuracyList = try JSONDecoder().decode(AccuracyList.self, from: dataJSON)
//                                    var tempAccuracyLis2t = snapshot.value as? NSArray
//                                    self.ref.child("user_email/\(email)/accuracy_list").setValue(tempAccuracyList2?.adding(self.accuracy ?? 0))
                                    if month == 1 {
                                        let tempOfArr = tempAccuracyList.month?.jan as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/jan").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 2 {
                                        let tempOfArr = tempAccuracyList.month?.feb as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/feb").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 3 {
                                        let tempOfArr = tempAccuracyList.month?.mar as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/mar").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 4 {
                                        let tempOfArr = tempAccuracyList.month?.apr as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/apr").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 5 {
                                        let tempOfArr = tempAccuracyList.month?.may as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/may").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 6 {
                                        let tempOfArr = tempAccuracyList.month?.jun as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/jun").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 7 {
                                        let tempOfArr = tempAccuracyList.month?.jul as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/jul").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 8 {
                                        let tempOfArr = tempAccuracyList.month?.aug as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/aug").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 9 {
                                        let tempOfArr = tempAccuracyList.month?.sep as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/sep").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 10 {
                                        let tempOfArr = tempAccuracyList.month?.oct as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/oct").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else if month == 11 {
                                        let tempOfArr = tempAccuracyList.month?.nov as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/nov").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    } else {
                                        let tempOfArr = tempAccuracyList.month?.dec as NSArray?
                                        self.ref.child("user_email/\(email)/AccuracyList/month/dec").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                    }
                                    if dayOfWeek == "monday" {
                                        let tempOfArr = tempAccuracyList.monday?.accuracyArr as NSArray?
                                        if dateSize == tempAccuracyList.monday?.date {
                                            self.ref.child("user_email/\(email)/AccuracyList/monday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/monday/accuracyArr").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                        } else {
                                            self.ref.child("user_email/\(email)/AccuracyList/monday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/monday/accuracyArr").setValue([self.accuracy ?? 0])
                                        }
                                    } else if dayOfWeek == "tuesday" {
                                        let tempOfArr = tempAccuracyList.tuesday?.accuracyArr as NSArray?
                                        if dateSize == tempAccuracyList.tuesday?.date {
                                            self.ref.child("user_email/\(email)/AccuracyList/tuesday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/tuesday/accuracyArr").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                        } else {
                                            self.ref.child("user_email/\(email)/AccuracyList/tuesday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/tuesday/accuracyArr").setValue([self.accuracy ?? 0])
                                        }
                                    } else if dayOfWeek == "wednesday" {
                                        let tempOfArr = tempAccuracyList.wednesday?.accuracyArr as NSArray?
                                        if dateSize == tempAccuracyList.wednesday?.date {
                                            self.ref.child("user_email/\(email)/AccuracyList/wednesday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/wednesday/accuracyArr").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                        } else {
                                            self.ref.child("user_email/\(email)/AccuracyList/wednesday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/wednesday/accuracyArr").setValue([self.accuracy ?? 0])
                                        }
                                    } else if dayOfWeek == "thursday" {
                                        let tempOfArr = tempAccuracyList.monday?.accuracyArr as NSArray?
                                        if dateSize == tempAccuracyList.monday?.date {
                                            self.ref.child("user_email/\(email)/AccuracyList/thursday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/thursday/accuracyArr").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                        } else {
                                            self.ref.child("user_email/\(email)/AccuracyList/thursday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/thursday/accuracyArr").setValue([self.accuracy ?? 0])
                                        }
                                    } else if dayOfWeek == "friday" {
                                        let tempOfArr = tempAccuracyList.friday?.accuracyArr as NSArray?
                                        if dateSize == tempAccuracyList.friday?.date {
                                            self.ref.child("user_email/\(email)/AccuracyList/friday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/friday/accuracyArr").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                        } else {
                                            self.ref.child("user_email/\(email)/AccuracyList/friday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/friday/accuracyArr").setValue([self.accuracy ?? 0])
                                        }
                                    } else if dayOfWeek == "saturday" {
                                        let tempOfArr = tempAccuracyList.saturday?.accuracyArr as NSArray?
                                        if dateSize == tempAccuracyList.saturday?.date {
                                            self.ref.child("user_email/\(email)/AccuracyList/saturday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/saturday/accuracyArr").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                        } else {
                                            self.ref.child("user_email/\(email)/AccuracyList/saturday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/saturday/accuracyArr").setValue([self.accuracy ?? 0])
                                        }
                                    } else {
                                        let tempOfArr = tempAccuracyList.sunday?.accuracyArr as NSArray?
                                        if dateSize == tempAccuracyList.sunday?.date {
                                            self.ref.child("user_email/\(email)/AccuracyList/sunday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/sunday/accuracyArr").setValue(tempOfArr?.adding(self.accuracy ?? 0))
                                        } else {
                                            self.ref.child("user_email/\(email)/AccuracyList/sunday/date").setValue(dateSize)
                                            self.ref.child("user_email/\(email)/AccuracyList/sunday/accuracyArr").setValue([self.accuracy ?? 0])
                                        }
                                    }
                                } catch {
                                    
                                }
                            }
                        case .none:
                            print("none")
                        }
                      }) { (error) in
                        print(error.localizedDescription)
                    }
                    self.firstView.isHidden = true
                    self.secondView.isHidden = false
                    if self.wordArr.count == 1 {
                        self.secondViewNextbt.setTitle("완료", for: .normal)
                    }
                } catch {
                    print("decode 에러")
                }
            } else {
                print("error 발생")
            }
        }
    }
    @IBAction func touchUpOneMorebt(_ sender: Any) {
        self.progressView.value = 0
        firstViewInit()
    }
    @IBAction func touchUpNextWordbt(_ sender: Any) {
        self.progressView.value = 0
        if wordArr.count == 1 {
            self.navigationController?.popViewController(animated: true)
            return
        }
        wordArr.removeFirst()
        currentWord.text = wordArr[0] ?? ""
        firstViewInit()
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        button.isEnabled = true
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    // 카메라 세팅
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
    }
    func firstViewInit() {
        self.firstView.isHidden = false
        self.secondView.isHidden = true
        self.button.isHidden = false
        self.Play.isHidden = true
        self.nextButton.isHidden = true
        self.Stop.isHidden = true
    }
}
