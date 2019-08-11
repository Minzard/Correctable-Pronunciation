//
//  MeanLessViewController.swift
//  Test3
//
//  Created by 차요셉 on 2019. 4. 2..
//  Copyright © 2019년 차요셉. All rights reserved.
// 63 140 39


import UIKit
import Speech
import AVFoundation
import Alamofire
import AVKit
import SwiftyJSON

class MeanLessViewController: UIViewController, SFSpeechRecognizerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate{
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    @IBOutlet weak var previewView: UIView!
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var Play: UIButton!
    @IBOutlet weak var Stop: UIButton!
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var joseph:String?
    
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
            //Step 9
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
        }
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.previewView.bounds
        }
    }
    
    
    
    @IBAction func VideoClick(_ sender: Any) {
        guard let path = Bundle.main.path(forResource: "시영", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
        player.play()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isHidden = true
        Play.isHidden = true
        Stop.isHidden = true
        speechRecognizer?.delegate = self
        button.layer.cornerRadius = 8
        nextButton.layer.cornerRadius = 8
        
        myView.layer.borderWidth = 2.5
        myView.layer.borderColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        myView.layer.cornerRadius = 6

        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        //        let pathArray = [dirPath, recordingName]
        //        let filePath = URL(string: pathArray.joined(separator: "/"))
        let filepath = NSURL(fileURLWithPath: dirPath + "/" + recordingName)
        
        
        // 녹음 품질 설정
        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                              AVEncoderBitRateKey: 16,
                              AVNumberOfChannelsKey: 2,
                              AVSampleRateKey: 44100.0] as [String : Any]
        
        // 공유 오디오 세션 인스턴스를 반환 받는다.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            // 현재 오디오 세션의 카테고리를 정한다. (재생, 녹음)
            try audioSession.setCategory(.record, mode: .default, options: [])
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            
            
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
    override func viewWillAppear(_ animated: Bool) {
        
        
    }

    @IBAction func Recordudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            Stop.isHidden = false
            audioRecorder?.record()
        }
    }
    
    @IBAction func StopAudio(_ sender: Any) {
        
        button.isHidden = true
        Play.isHidden = false
        nextButton.isHidden = false
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
        let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
        
        let request = SFSpeechURLRecognitionRequest(url: (audioRecorder?.url)!)
        
        recognizer?.recognitionTask(with: request, resultHandler: {(result, error) in self.textView.text = result?.bestTranscription.formattedString})
        joseph = textView.text!
        print(joseph!)
    }
    
    @IBAction func PlayAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            Stop.isEnabled = true
            button.isEnabled = false
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: (audioRecorder?.url)!)
                audioPlayer!.delegate=self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func next(_ sender: Any) {
       
        let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))

        let request = SFSpeechURLRecognitionRequest(url: (audioRecorder?.url)!)

        recognizer?.recognitionTask(with: request, resultHandler: {(result, error) in self.textView.text = result?.bestTranscription.formattedString})
        joseph = textView.text!
        print(joseph!)
        
        let parameters: Parameters = [
            "user": "차요셉",
            "label": "아어",
            "stt": joseph!
        ]

        Alamofire.request(
            "http://2e8318da.ngrok.io/api/vi/ddobakis/",
            method: .post, parameters: parameters,
            encoding: JSONEncoding.default)

        
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        button.isEnabled = true
        Stop.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
    
    // camera
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
        
        //Step12
    }
    
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "video", ofType:"m4v") else {
            debugPrint("video.m4v not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
}
