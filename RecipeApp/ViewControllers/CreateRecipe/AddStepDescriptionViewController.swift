//
//  AddStepDescriptionViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/30/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class AddStepDescriptionViewController: UIViewController {
    
    @IBOutlet weak var stepDescription: UITextView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordStepAudioButton: UIButton!
    @IBOutlet weak var stepAudioButton: UIButton!
    @IBOutlet weak var enableAudioInstruction: UISwitch!
    @IBOutlet weak var textDescriptionView: UIStackView!
    @IBOutlet weak var audioDescriptionView: UIStackView!
    
    var steps:[CookingStep]?
    var stepNumber = 0;
    let placeholderText = "Please Enter a Description for this Cooking Step Here"
    
    
    // variables needed for speech recognition and transcribing
    var audioEngine = AVAudioEngine()
    var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    var speechRecognitionTask = SFSpeechRecognitionTask()
    var speechRecognitionStarted = false
    
    var recorder:AVAudioRecorder?
    var recordingSession:AVAudioSession!
    var meterTimer:Timer?
    var recoderApc0:Float = 0
    var recorderPeak0:Float = 0
    var audioURL:URL?
    var stepAudio:NSData? = nil
    
    var audioPlaying: Bool  = false
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
        stepNumber = (steps?.count)!
        self.title = "Step:\(stepNumber)"
        stepAudioButton.isHidden = true
        if enableAudioInstruction.isOn {
            textDescriptionView.isHidden = true
            audioDescriptionView.isHidden = false
        } else {
            textDescriptionView.isHidden = false
            audioDescriptionView.isHidden = true
        }
        
        stepAudioButton.isHidden = true
        stepDescription.delegate = self
        stepDescription.text = placeholderText
        stepDescription.textColor = UIColor.lightGray
		
		self.hideKeyboardWhenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onenableAudioInstructionChanged(_ sender: UISwitch) {
        if sender.isOn {
            textDescriptionView.isHidden = true
            audioDescriptionView.isHidden = false
        } else {
            textDescriptionView.isHidden = false
            audioDescriptionView.isHidden = true
        }
    }
    
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDescriptionNext(_ sender: UIButton) {
        let cookingStep = steps?[stepNumber-1]
        if enableAudioInstruction.isOn {
            if let audio = stepAudio {
                cookingStep?.setAudioData(with: audio)
            }
        } else {
            if let stepDesc = stepDescription.text {
                cookingStep?.desc = stepDesc
            } else {
                print("step description is not present")
                stepDescription.becomeFirstResponder()
            }
        }
        performSegue(withIdentifier: "AddStepPictureSegue", sender: nil)
    }
    
    @IBAction func speechButtonTapped(_ sender: UIButton) {
        if speechRecognitionStarted {
            self.micButton.setImage(#imageLiteral(resourceName: "mic"), for: .normal)
            self.micButton.stopFlash()
            audioEngine.stop()
            
            if let node = audioEngine.inputNode {
                node.removeTap(onBus: 0)
            }
            speechRecognitionRequest.endAudio() // Added line to mark end of recording
            speechRecognitionStarted = false
        } else {
            self.micButton.setImage(#imageLiteral(resourceName: "mic green"), for: .normal)
            self.micButton.flash()
            self.recordAndRecognizeSpeech()
        }
    }
    
    @IBAction func onRecordAudioTapped(_ sender: UIButton) {
        let audioFileName = String("step\(stepNumber)")
        sender.flash()
        let status = self.record(filename: audioFileName!)
        if status {
            print("record successful")
        } else {
            print("record error")
        }
    }
    
    @IBAction func onStopRecordAudio(_ sender: UIButton) {
        recordStepAudioButton.stopFlash()
        finishRecording()
        stepAudio = NSData(contentsOf:audioURL!)
        if stepAudio == nil {
            print("Error: UNable to convert Audio URL to NSData")
            stepAudioButton.isHidden = true
        } else {
            let data = stepAudio as Data?
            stepAudioButton.isHidden = false
            do {
                try self.audioPlayer = AVAudioPlayer(data: data!)
                self.audioPlayer?.delegate = self
            } catch {
                print("Unable to create audio player:", error.localizedDescription)
            }
        }
    }
    
    @IBAction func onAudioPlayTapped(_ sender: Any) {
        stepAudioButton.setImage(#imageLiteral(resourceName: "speaker_on"), for: .normal)
        stepAudioButton.flash()
        audioPlayer?.play()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! AddStepPictureViewController
        destVC.steps = steps
    }
}

extension AddStepDescriptionViewController: SFSpeechRecognizerDelegate {
    func recordAndRecognizeSpeech() {
        guard let node = audioEngine.inputNode else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        // configure the node
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, _ AVAudioTime) in
            self.speechRecognitionRequest.append(buffer)
        }
        // prepare and start the recording
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        // checks to make sure the recognizer is available for the device and for the locale
        guard let myRecognizer = SFSpeechRecognizer() else {
            // A recognizer is not supported for the current locale
            let alertController = UIAlertController()
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            alertController.title = "A recognizer is not supported for the current locale"
            present(alertController, animated: true, completion: nil)
            return
        }
        if !myRecognizer.isAvailable {
            // A Recognizer is not available right now
            let alertController = UIAlertController()
            // create an OK action
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            // add the OK action to the alert controller
            alertController.addAction(OKAction)
            alertController.title = "A Recognizer is not available right now"
            present(alertController, animated: true, completion: nil)
            return
        }
        speechRecognitionStarted = true
        speechRecognitionTask = (speechRecognizer?.recognitionTask(with: speechRecognitionRequest, resultHandler: { (result: SFSpeechRecognitionResult?, error: Error?) in
            if let result = result {
                let instructionString = result.bestTranscription.formattedString
                self.stepDescription.text = instructionString
            } else if let error = error {
                print(error)
            }
        }))!
    }
}

extension AddStepDescriptionViewController : AVAudioRecorderDelegate {
    func setup() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try recordingSession.setActive(true)
            
            // We need to request permissions from the user otherwise we will be recording silence
            recordingSession.requestRecordPermission({ (allowed: Bool) in
                if allowed {
                    print("Mic Authorized")
                } else {
                    print("Mic not authorized")
                }
            })
        } catch {
            print("Failed to set category", error.localizedDescription)
        }
    }
    
    // Start the record session
    func record(filename: String) -> Bool {
        let url = getUserPath().appendingPathComponent(filename + ".m4a")
        audioURL = URL.init(fileURLWithPath: url.path)
        
        let recordSettings:[String:Any] = [
            AVFormatIDKey:NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey:12000.0,
            AVNumberOfChannelsKey:1,
            AVSampleRateKey:44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioURL!, settings: recordSettings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            
            self.meterTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer: Timer) in
                // Here we should always update the recorder meter values so we can track the voice loudness
                if let recorder = self.recorder {
                    recorder.updateMeters()
                    self.recoderApc0 = recorder.averagePower(forChannel: 0)
                    self.recorderPeak0 = recorder.peakPower(forChannel: 0)
                }
            })
            
            recorder?.record()
            print("Recording")
            
            return true
        } catch {
            print("Error Recording")
            return false
        }
    }
    
    // Stop the recorder
    func finishRecording() {
        self.recorder?.stop()
        self.meterTimer?.invalidate()
    }
    
    // Get the path for the folder we will be saving the file to
    func getUserPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Audio Manager did Finish Recording")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error Encoding", error?.localizedDescription ?? "")
    }
    
}

extension AddStepDescriptionViewController : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stepAudioButton.stopFlash()
        stepAudioButton.setImage(#imageLiteral(resourceName: "speaker_off"), for: .normal)
    }
}

extension UIButton {
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1000
        
        layer.add(flash, forKey: nil)
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: "pulse")
    }
    
    func stopFlash() {
        layer.removeAllAnimations()
    }
}

extension AddStepDescriptionViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if stepDescription.textColor == UIColor.lightGray {
            stepDescription.text = nil
            stepDescription.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if stepDescription.text.isEmpty {
            stepDescription.text = placeholderText
            stepDescription.textColor = UIColor.lightGray
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



