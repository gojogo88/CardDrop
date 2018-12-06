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
}

extension ImageSelectionVC: Scaling {
  func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
    return initialImageView
  }
}
