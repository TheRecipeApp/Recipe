//
//  StepDetailsViewController.swift
//  RecipeApp
//
//  Created by Vijayanand on 12/11/17.
//  Copyright © 2017 The Recipe App. All rights reserved.
//

import UIKit
import AVFoundation

class StepDetailsViewController: UIViewController {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var ingredientsTable: UITableView!
	@IBOutlet weak var stepDescription: UITextView!
	@IBOutlet weak var stepAudio: UIButton!
	@IBOutlet weak var pageControl: UIPageControl!
	
	var steps: [CookingStep]?
	var step: CookingStep?
	var audioPlayer: AVAudioPlayer?
	var stepNumber = 1;
	var stepImages = [UIImageView]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		ingredientsTable.delegate = self
		ingredientsTable.dataSource = self
		ingredientsTable.estimatedRowHeight = 50
		ingredientsTable.rowHeight = UITableViewAutomaticDimension
		let nibName = UINib(nibName: "IngredientsTableViewCell", bundle: nil)
		ingredientsTable.register(nibName, forCellReuseIdentifier: "IngredientsTableViewCell")
		ingredientsTable.separatorStyle = UITableViewCellSeparatorStyle.none
		
		// Do any additional setup after loading the view.
		print("step number: \(stepNumber)")
		
		step = steps?[stepNumber-1]
		stepDescription.text = step?.desc
		setupStepAudio()
		
		ingredientsTable.reloadData()
		scrollView.delegate = self
		scrollView.isPagingEnabled = true
		pageControl.currentPage = 0
		pageControl.numberOfPages = (steps?.count)!
		view.bringSubview(toFront: pageControl)
		setupStepImages()
		setupScrollView()
	}
	
	func setupStepImages() {
		if let count = steps?.count {
			for i in 0 ..< count {
				let imageView = UIImageView()
				step = steps?[i]
				setupStepImage(imageView: imageView)
				stepImages.append(imageView)
			}
		}
	}
	
	func setupScrollView() {
		if let count = steps?.count {
			scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250.0)
			scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(count), height: 250.0)
			for i in 0 ..< stepImages.count {
				stepImages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: 250.0)
				scrollView.addSubview(stepImages[i])
			}
		}
	}
	
	func setupStepAudio() {
		print("step: \(String(describing: step))")
		print("step audio: \(String(describing: step?.stepAudio))")
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
	
	func setupStepImage(imageView: UIImageView) {
		let imageFile = step?.stepImage
		imageFile?.getDataInBackground(block: { (data: Data?, error: Error?) in
			if error == nil {
				if let imageData = data {
					imageView.image = UIImage(data:imageData)
				}
			}
		})
	}
	
	@IBAction func onCancel(_ sender: Any) {
		dismiss(animated: true, completion: nil)
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

extension StepDetailsViewController : UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let pageIndex = Int(round(scrollView.contentOffset.x/view.frame.width))
		step = steps?[pageIndex]
		pageControl.currentPage = pageIndex
		setupStepAudio()
		stepDescription.text = step?.desc
		ingredientsTable.reloadData()
	}
}
