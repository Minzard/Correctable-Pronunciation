import UIKit
import Speech
import AVFoundation
import Alamofire
import AVKit

class MeanLessViewController5: UIViewController, SFSpeechRecognizerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var Play: UIButton!
    @IBOutlet weak var Stop: UIButton!

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var wordView: UIView!

    // 음성인식 설정
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
            self.videoView.layer.cornerRadius = 9
            self.videoView.clipsToBounds = true
            
            self.previewView.layer.cornerRadius = 9
            self.previewView.clipsToBounds = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // videoView's cornerRidus 설정
        self.videoView.layer.cornerRadius = 9
        self.videoView.clipsToBounds = true
        
        // previewView's cornerRidus 설정
        self.previewView.layer.cornerRadius = 9
        self.previewView.clipsToBounds = true
        
        // wordView 테두리 설정
        wordView.layer.borderWidth = 2
        wordView.layer.borderColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1).cgColor
        wordView.layer.cornerRadius = 9
        
        // imageView 에 이미지 넣기
        let imageName = "아어썸네일3.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.frame = self.videoView.bounds
        self.videoView.addSubview(imageView)
        
        // 버튼 UI 초기화
        nextButton.isHidden = true
        Play.isHidden = true
        Stop.isHidden = true
        button.layer.cornerRadius = 9
        nextButton.layer.cornerRadius = 9
        Play.layer.cornerRadius = 9
        Stop.layer.cornerRadius = 9
        
        // 음성인식 델리게이트 설정
        speechRecognizer?.delegate = self
        // 녹음 설정
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
    
    @IBAction func videoClick(_ sender: Any) {
        
        guard let path = Bundle.main.path(forResource: "아어", ofType:"mp4") else {
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
    
    
    
    @IBAction func recordAudio(_ sender: Any) {
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
            "label": "어",
            "stt": joseph!
        ]

        Alamofire.request(
            "http://ec2-15-164-228-174.ap-northeast-2.compute.amazonaws.com:8080/api/vi/ddobakis/",
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
    
    
    // 카메라 세팅
    func setupLivePreview() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
    }
}
