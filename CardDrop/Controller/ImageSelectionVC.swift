//
//  ImageSelectionVC.swift
//  CardDrop
//
//  Created by Jonathan Go on 2018/12/05.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import UIKit

class ImageSelectionVC: UIViewController {

  var image: UIImage?
  var category: Category?
  
  let imageDataRequest = DataRequest<Image>(dataSource: "Images")
  var imageData = [Image]()
  
  var currentScrollViewPage = 0
  
  @IBOutlet var initialImageView: UIImageView!
  @IBOutlet var categoryLabel: UILabel!
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var backButton: UIButton!
  @IBOutlet var initialDimView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    initialDimView.alpha = 0
    backButton.alpha = 0
    
    if let avaiableImage = image, let availableCategory = category {
      initialImageView.image = avaiableImage
      categoryLabel.text = availableCategory.categoryName
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadData()
  }
  
  func loadData() {
    imageDataRequest.getData { [weak self] dataResult in
      switch dataResult {
      case .failure:
        print("Could not load images")
      case .success(let images):
        self?.imageData = images
        DispatchQueue.main.async {
          self?.setupUI()
        }
      }
    }
  }
  
  func setupUI() {
    
    UIView.animate(withDuration: 0.3) {
      self.initialDimView.alpha = 1
      self.backButton.alpha = 1
    }
    
    scrollView.delegate = self
    scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(imageData.count + 1)
    
    for (i, image) in imageData.enumerated() {
      let frame = CGRect(x: self.scrollView.frame.width * CGFloat(i + 1), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
      
      guard let photoView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as? PhotoView else { return }
      
      photoView.frame = frame
      photoView.imageView.image = UIImage(named: image.imageName)!
      photoView.photgrapherLabel.text = image.photographer
      photoView.descriptionLabel.text = image.description
      
      scrollView.addSubview(photoView)
    }
    
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageSelectionVC.didPressOnScrollView(recognizer:)))
    scrollView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc func didPressOnScrollView(recognizer: UITapGestureRecognizer) {
    if currentScrollViewPage != 0 {
      self.performSegue(withIdentifier: "toSendCard", sender: self)
    } else {
      scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
      currentScrollViewPage = 1
    }
  }
  
  @IBAction func backBtnPressed(_ sender: UIButton) {
    UIView.animate(withDuration: 0.3, animations: {
      self.scrollView.setContentOffset(CGPoint.zero, animated: false)
    }) { (success) in
      UIView.animate(withDuration: 0.2, animations: {
        self.initialDimView.alpha = 0
        self.backButton.alpha = 0
      }, completion: { (success) in
        self.navigationController?.popViewController(animated: true)
      })
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toSendCard" {
      guard let sendCardVC = segue.destination as? SendCardVC else { return }
      guard let imageToSend = UIImage(named: imageData[currentScrollViewPage - 1].imageName) else { return }
      sendCardVC.backgroundImage = imageToSend
      sendCardVC.modalTransitionStyle = .crossDissolve
    }
  }
}

extension ImageSelectionVC: Scaling {
  func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
    return initialImageView
  }
}

extension ImageSelectionVC: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    currentScrollViewPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
  }
}
