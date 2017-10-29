//
//  StepDetailsViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 10/19/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import AVFoundation

class StepDetailsViewController: UIViewController {
	@IBOutlet weak var ingredientsTable: UITableView!
	@IBOutlet weak var stepDescription: UITextView!
	@IBOutlet weak var stepImage: UIImageView!
	@IBOutlet weak var stepAudio: UIButton!

	var audioPlaying: Bool  = false
	var step: CookingStep?
	var audioPlayer: AVAudioPlayer?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		ingredientsTable.delegate = self
		ingredientsTable.dataSource = self
		ingredientsTable.estimatedRowHeight = 50
		ingredientsTable.rowHeight = UITableViewAutomaticDimension
		let nibName = UINib(nibName: "IngredientsTableViewCell", bundle: nil)
		ingredientsTable.register(nibName, forCellReuseIdentifier: "IngredientsTableViewCell")
		
		audioPlayer?.delegate = self

        // Do any additional setup after loading the view.
		stepDescription.text = step?.desc
		setupStepImage()
		setupStepAudio()
    }
	
	func setupStepAudio() {
		if let audioFile = step?.stepAudio {
			stepAudio.isHidden = false
			audioFile.getDataInBackground(block: { (data: Data?, error: Error?) in
				if error == nil {
					if let audioData = data {
						do {
							try self.audioPlayer = AVAudioPlayer(data: audioData)
							self.audioPlayer?.delegate = self
						} catch {
							print("Unable to create audio player:", error.localizedDescription)
						}
					}
				}
			})
		} else {
			stepAudio.isHidden = true
		}
	}
	
	func setupStepImage() {
		let imageFile = step?.stepImage
		imageFile?.getDataInBackground(block: { (data: Data?, error: Error?) in
			if error == nil {
				if let imageData = data {
					self.stepImage.image = UIImage(data: imageData)
					self.stepImage.contentMode = .scaleAspectFit
				}
			}
		})
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func onAudioPlayTapped(_ sender: Any) {
		stepAudio.setImage(#imageLiteral(resourceName: "speaker_on"), for: .normal)
		stepAudio.flash()
		audioPlayer?.play()
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension StepDetailsViewController : UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (step?.ingredients?.count)!
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as! IngredientsTableViewCell
		cell.ingredientNameLabel.text = step?.ingredients?[indexPath.row]
		if let amount = step?.ingredientAmounts[indexPath.row] {
			cell.ingredientAmountLabel.text = String("\(amount)")
		}
		cell.ingredientUnitsLabel.text = step?.ingredientUnits[indexPath.row]
		return cell
	}
}

extension StepDetailsViewController : AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		stepAudio.stopFlash()
		stepAudio.setImage(#imageLiteral(resourceName: "speaker_off"), for: .normal)
	}
}

