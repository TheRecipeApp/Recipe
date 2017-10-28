//
//  NewRecipeViewController.swift
//  RecipeApp
//
//  Created by Cesar Cavazos on 10/15/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import Speech
import AVFoundation

class NewRecipeViewController: UIViewController {

	@IBOutlet weak var ingredientTextField: UITextField!
	@IBOutlet weak var amountTextField: UITextField!
	@IBOutlet weak var unitsTextField: UITextField!
	@IBOutlet weak var stepNumberLabel: UILabel!
	@IBOutlet weak var ingredientsTable: UITableView!
	@IBOutlet weak var stepDescriptionTextView: UITextView!
	@IBOutlet weak var micButton: UIButton!
	@IBOutlet weak var stepImageView: UIImageView!
	@IBOutlet weak var doneButton: UIButton!
	
	private var stepNumber = 1
	var steps = [CookingStep]()
	var stepIngredients = [String]()
	var stepIngredientAmounts = [String]()
	var stepIngredientUnits = [String]()
	var stepNotSaved = false
	var stepImageUploaded = false
	
	// image picker
	let imagePickerController = UIImagePickerController()
	var recipeImageUploaded = false

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

	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		ingredientsTable.delegate = self
		ingredientsTable.dataSource = self
		ingredientsTable.estimatedRowHeight = 50
		ingredientsTable.rowHeight = UITableViewAutomaticDimension
		let nibName = UINib(nibName: "IngredientsTableViewCell", bundle: nil)
		ingredientsTable.register(nibName, forCellReuseIdentifier: "IngredientsTableViewCell")

		stepNumberLabel.text = String("\(stepNumber)")
		stepDescriptionTextView.delegate = self

		// image picker
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			print("Camera is available 📸")
			imagePickerController.sourceType = .camera
		} else {
			print("Camera 🚫 available so we will use photo library instead")
			imagePickerController.sourceType = .photoLibrary
		}
		
		doneButton.layer.cornerRadius = 3
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func onCancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func clearIngredient(_ sender: Any) {
		clearIngregientLabels()
	}
	
	private func clearAll() {
		clearIngregientLabels()
		stepIngredientUnits.removeAll()
		stepIngredientAmounts.removeAll()
		stepIngredients.removeAll()
		stepDescriptionTextView.text = ""
		stepNotSaved = false
		stepImageView.image = UIImage(named: "upload_image.png")
		stepImageUploaded = false

	}
	
	private func clearIngregientLabels() {
		ingredientTextField.text = ""
		amountTextField.text = ""
		unitsTextField.text = ""
	}
	
	@IBAction func addIngredient(_ sender: Any) {
		if let name = ingredientTextField.text {
			let ingredient = name
			stepIngredients.append(ingredient)
			if let amountStr = amountTextField.text {
				stepIngredientAmounts.append(amountStr)
			}
			else {
				print("InvalidAmount")
				stepIngredients.removeLast()
				amountTextField.becomeFirstResponder()
				stepNotSaved = true
			}
			if let units = unitsTextField.text {
				stepIngredientUnits.append(units)
				ingredientTextField.becomeFirstResponder()
				ingredientsTable.reloadData()
				stepNotSaved = true
			} else {
				print("Invalid Units")
				stepIngredients.removeLast()
				stepIngredientAmounts.removeLast()
				unitsTextField.becomeFirstResponder()
			}
		} else {
			print("Invalid Ingredient Name")
			ingredientTextField.becomeFirstResponder()
		}
		clearIngregientLabels()
	}
	
	@IBAction func onSave(_ sender: UIButton) {
		if let stepDesc = stepDescriptionTextView.text {
			let cookingStep = CookingStep()
			cookingStep.desc = stepDesc
			cookingStep.ingredients = stepIngredients
			cookingStep.ingredientAmounts = stepIngredientAmounts
			cookingStep.ingredientUnits = stepIngredientUnits
			if let audio = stepAudio {
				cookingStep.setAudioData(with: audio)
				stepAudio = nil
			}
			if stepImageUploaded {
				cookingStep.setImage(with: stepImageView.image)
			}
			steps.append(cookingStep)
			clearAll()
			stepNumber = stepNumber + 1
			stepNumberLabel.text = String("\(stepNumber)")
			ingredientsTable.reloadData()
			ingredientTextField.becomeFirstResponder()
			stepNotSaved = false
		} else {
			print("step description is not present")
			stepDescriptionTextView.becomeFirstResponder()
		}
	}
	
	@IBAction func onIngredientChanged(_ sender: UITextField) {
		if !(ingredientTextField.text?.isEmpty)! {
			stepNotSaved = true
		}
	}
	
	@IBAction func onAmountChanged(_ sender: Any) {
		if !((amountTextField.text?.isEmpty)!) {
			stepNotSaved = true
		}
	}
	
	@IBAction func onUnitsChanged(_ sender: Any) {
		if !(unitsTextField.text?.isEmpty)! {
			stepNotSaved = true
		}
	}
	
	@IBAction func onDone(_ sender: UIButton) {
		if stepNotSaved {
			presentAlert(alertTitle: "Step Not Saved, Clear Current Step?", showCancel: true)
		} else if steps.count == 0 {
			presentAlert(alertTitle: "No Steps in Recipe Yet, Cannot Proceed", showCancel: false)
		} else {
			performSegue(withIdentifier: "RecipeSummarySegue", sender: nil)
		}
	}
	
	private func presentAlert(alertTitle:String, showCancel: Bool) {
		let alertController = UIAlertController()
		// Alert Saying Step Not Saved
		print(alertTitle)
		// create a cancel action
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			// handle cancel response here. Doing nothing will dismiss the view.
		}
		// add the cancel action to the alertController
		if (showCancel) {
			alertController.addAction(cancelAction)
		}
		
		// create an OK action
		let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
			// handle response here.
			self.clearAll()
		}
		// add the OK action to the alert controller
		alertController.addAction(OKAction)
		alertController.title = alertTitle
		present(alertController, animated: true, completion: nil)
	}
	
	@IBAction func speechButtonTapped(_ sender: UIButton) {
		if speechRecognitionStarted {
			self.micButton.setImage(#imageLiteral(resourceName: "mic"), for: .normal)
			audioEngine.stop()
			
			if let node = audioEngine.inputNode {
				node.removeTap(onBus: 0)
			}
			speechRecognitionRequest.endAudio() // Added line to mark end of recording
			speechRecognitionStarted = false
		} else {
			self.micButton.setImage(#imageLiteral(resourceName: "mic green"), for: .normal)
			self.recordAndRecognizeSpeech()
		}
	}
	
	@IBAction func onTap(_ sender: UITapGestureRecognizer) {
		present(imagePickerController, animated: true, completion: nil)
		stepImageUploaded = true
	}
	
	@IBAction func onRecordAudioTapped(_ sender: Any) {
		let audioFileName = String("step\(stepNumber)")
		print(audioFileName)
		let status = self.record(filename: audioFileName!)
		if status {
			print("record successful")
		} else {
			print("record error")
		}
	}
	
	@IBAction func onStopRecordAudio(_ sender: Any) {
		finishRecording()
		stepNotSaved = true
		stepAudio = NSData(contentsOf:audioURL!)
		if stepAudio == nil {
			print("Error: UNable to convert Audio URL to NSData")
		}
	}
	
	// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
		let recipeSummaryViewController = segue.destination as! RecipeSummaryViewController
        // Pass the selected object to the new view controller.
		recipeSummaryViewController.cookingSteps = steps
    }

}

extension NewRecipeViewController : UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView!) {
		stepNotSaved = true
	}
}

extension NewRecipeViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if (stepIngredients.count > 0) {
			return stepIngredients.count
		} else {
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = ingredientsTable.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as! IngredientsTableViewCell
		cell.customInit(name: stepIngredients[indexPath.row], amount: stepIngredientAmounts[indexPath.row], units: stepIngredientUnits[indexPath.row])
		return cell
	}
}

extension NewRecipeViewController: SFSpeechRecognizerDelegate {
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
				self.stepDescriptionTextView.text = instructionString
			} else if let error = error {
				print(error)
			}
		}))!
	}
}

extension NewRecipeViewController : AVAudioRecorderDelegate {
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

extension NewRecipeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		// Get the image captured by the UIImagePickerController
		let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
		
		self.stepImageView.contentMode = .center
		self.stepImageView.contentMode = .scaleAspectFit
		self.stepNotSaved = true
		if editedImage != nil {
			self.stepImageView.image = editedImage
		} else {
			self.stepImageView.image = originalImage
		}
		
		// Dismiss UIImagePickerController to go back to your original view controller
		dismiss(animated: true, completion: nil)
	}
}


