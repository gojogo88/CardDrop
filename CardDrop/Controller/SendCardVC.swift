//
//  SendCardVC.swift
//  CardDrop
//
//  Created by Jonathan Go on 2018/12/06.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import UIKit

class SendCardVC: UIViewController {

  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var textContainerView: UIView!
  @IBOutlet var quoteLabel: UILabel!
  @IBOutlet var authorLabel: UILabel!
  
  var backgroundImage: UIImage?
  let quoteDataRequest = DataRequest<Quote>(dataSource: "Quotes")
  
    override func viewDidLoad() {
        super.viewDidLoad()

      guard let image = backgroundImage else { return }
      backgroundImageView.image = image
      
      loadData()
    }
  
  func loadData() {
    quoteDataRequest.getData { [weak self] dataResult in
      switch dataResult {
      case .failure:
        print("Could not load images.")
      case .success(let quotes):
        let randomNumber = Int.random(in: 0 ..< quotes.count)
        DispatchQueue.main.async {
          self?.authorLabel.text = quotes[randomNumber].author
          self?.quoteLabel.text = quotes[randomNumber].quote
        }
      }
    }
  }

  @IBAction func backBtnPressed(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func shareCardBtnPressed(_ sender: UIButton) {
  }
  
}

extension UIView {
  func screenshot() -> UIImage {
    return UIGraphicsImageRenderer(size: bounds.size).image(actions: { _ in
      drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
    })
  }
}
