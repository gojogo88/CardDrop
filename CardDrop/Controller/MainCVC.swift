//
//  MainCVC.swift
//  CardDrop
//
//  Created by Jonathan Go on 2018/12/05.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import UIKit

class MainCVC: UICollectionViewController {

  let categoryDataRequest = DataRequest<Category>(dataSource: "Categories")
  var categoryData = [Category]()
  
  var selectedIndexPath: IndexPath?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      loadData()

    }
  
  func loadData() {
    categoryDataRequest.getData { [weak self] dataResult in
      switch dataResult {
      case .failure:
        print("Could not load categories.")
      case .success(let categories):
        self?.categoryData = categories
        self?.collectionView.reloadData()
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toDetail" {
      let category = sender as! Category
      guard let image = UIImage(named: category.categoryImageName) else { return }
      
      let imageSelectionVC = segue.destination as! ImageSelectionVC
      imageSelectionVC.image = image
      imageSelectionVC.category = category
    }
  }
  
}

// MARK: UICollectionViewDataSource
extension MainCVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? CategoryCollectionViewCell else { fatalError("Could not create proper category cell for collection view") }
      
      let category = categoryData[indexPath.item]
      guard let image = UIImage(named: category.categoryImageName) else {
        fatalError("Could not load image for cell") }
      cell.backgroundImageView.image = image
      cell.categoryLabel.text = category.categoryName
      return cell
    }
}

// MARK: UICollectionViewDelegate
extension MainCVC {
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    cell.layer.cornerRadius = 14
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let category = categoryData[indexPath.item]
    selectedIndexPath = indexPath
    self.performSegue(withIdentifier: "toDetail", sender: category)
    
  }
}


// MARK: UICollectionViewLayoutDelegate
extension MainCVC: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  }
}

// MARK: - Transitioning Animation Delegate
extension MainCVC: Scaling {
  func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
    if let indexPath = selectedIndexPath {
      guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return nil }
      return cell.backgroundImageView
    }
    return nil
  }
}
