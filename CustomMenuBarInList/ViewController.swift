//
//  ViewController.swift
//  CustomMenuBarinList
//
//  Created by Nitin Bhatia on 15/09/22.
//

import UIKit

let MARGIN_BAR : CGFloat = -6 //this variable will be used to take bottom bar to center of cell
let NUMBER_OF_CELL = 10
let INTERNAL_BAR_VISIBLE = true

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //outlets
    @IBOutlet weak var listViewCollectionView: UICollectionView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var fullViewCollectionView: UICollectionView!
    
    //variables
    var leftAnchorForBottomBar : NSLayoutConstraint?
    var oldOffset : CGFloat = 0
    var currentIndex : IndexPath = IndexPath(item: 0, section: 0)
    var didSelectTapped : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if INTERNAL_BAR_VISIBLE {
            barView.removeFromSuperview()
        }
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //this build contains both inner and outer bar view, that is why adding condition
        if INTERNAL_BAR_VISIBLE == false {
            barView.translatesAutoresizingMaskIntoConstraints = false
            let cell = listViewCollectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as! ListCollectionViewCell
            leftAnchorForBottomBar = barView.leftAnchor.constraint(equalTo: cell.leftAnchor)
            leftAnchorForBottomBar?.isActive = true
            barView.bottomAnchor.constraint(equalTo: listViewCollectionView.bottomAnchor, constant: 2).isActive = true
            barView.widthAnchor.constraint(equalTo: listViewCollectionView.widthAnchor, multiplier: 1/9).isActive = true
            barView.heightAnchor.constraint(equalToConstant: 4).isActive = true
            leftAnchorForBottomBar?.constant = 4
            barView.layer.cornerRadius = 2
            helpScrolling(IndexPath(row: 0, section: 0))
        }
        
        //just to provide smoothness, visiting cells
        listViewCollectionView.scrollToItem(at: IndexPath(row: NUMBER_OF_CELL - 1, section: 0), at: .right, animated: false)
        listViewCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NUMBER_OF_CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == listViewCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ListCollectionViewCell
            cell.imgData.image = UIImage(named: "img_\(indexPath.row + 1)")
            cell.imgData.layer.cornerRadius = 15
           
            if indexPath == currentIndex {
                cell.barView.isHidden = false
            } else {
                cell.barView.isHidden = true
            }
            
            if !INTERNAL_BAR_VISIBLE {
                cell.barView.isHidden = true
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! ListCollectionViewCell
        cell.imgData.image = UIImage(named: "img_\(indexPath.row + 1)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !INTERNAL_BAR_VISIBLE {
            return
        }
        if collectionView == fullViewCollectionView {
            currentIndex = indexPath
            if !didSelectTapped {
                updateBarView()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == fullViewCollectionView {
             helpScrolling(indexPath)
        }
    }
    
    func helpScrolling(_ index: IndexPath) {
        if !INTERNAL_BAR_VISIBLE {
            return
        }
        if didSelectTapped {
            didSelectTapped = false
            return
        }
        
        if index > currentIndex {
            if index.row - 2 >= 0 && listViewCollectionView.indexPathsForVisibleItems.contains(IndexPath(row:index.row - 2,section: 0)) == false {
                listViewCollectionView.scrollToItem(at: IndexPath(row:index.row - 2,section: 0), at: .left, animated: true)
            }
        } else {
            if currentIndex.row + 2 < listViewCollectionView.numberOfItems(inSection: 0) && listViewCollectionView.indexPathsForVisibleItems.contains(IndexPath(row:currentIndex.row + 2,section: 0)) == false {
                listViewCollectionView.scrollToItem(at: IndexPath(row:currentIndex.row + 2,section: 0), at: .left, animated: true)
            }
        }
    }
   
   
    
    func updateBarView() {

        if !INTERNAL_BAR_VISIBLE {
            return
        }
        if let cell = listViewCollectionView.cellForItem(at: currentIndex) as? ListCollectionViewCell {
            cell.barView.isHidden = false
        }
        let filtered = listViewCollectionView.indexPathsForVisibleItems.filter({
            return $0 != currentIndex
        })
        
        filtered.forEach({
            (listViewCollectionView.cellForItem(at: $0) as? ListCollectionViewCell)?.barView.isHidden = true
        })
        
      
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == fullViewCollectionView {
            return CGSize(width: view.frame.width, height: collectionView.frame.size.height)
        }
       
        
        return CGSize(width: 50, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == listViewCollectionView {
            return 5
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView == listViewCollectionView {
            return 10
        }
        return 0
    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if INTERNAL_BAR_VISIBLE {
            return
        }
 
        if scrollView == listViewCollectionView {
            return
        }

        if scrollView.contentOffset.x < oldOffset {
            debugPrint("right")
            currentIndex = IndexPath(row: currentIndex.row - 1, section: 0)
            if currentIndex.row < 0 {
                return
            }
            var tempCC = IndexPath(row: currentIndex.row - 2, section: 0)
            
            if tempCC.row < 0 {
                tempCC.row = 0
            }
           
            if tempCC.row >= 0 && listViewCollectionView.indexPathsForVisibleItems.contains(tempCC) == false {
                listViewCollectionView.scrollToItem(at: tempCC, at: .left, animated: true)
            }
            
            let cell = listViewCollectionView.cellForItem(at: currentIndex) as! ListCollectionViewCell
            leftAnchorForBottomBar?.constant = cell.frame.origin.x + MARGIN_BAR
            
        } else if scrollView.contentOffset.x == oldOffset {
            debugPrint("old scroll")
        }  else {
            debugPrint("left")

            var tempCC = IndexPath(row: currentIndex.row + 2, section: 0)
            
            if tempCC.row > (NUMBER_OF_CELL - 1) {
                tempCC.row = NUMBER_OF_CELL
            }
           
            if (tempCC.row < NUMBER_OF_CELL - 2 && listViewCollectionView.cellForItem(at: tempCC) as? ListCollectionViewCell == nil) || listViewCollectionView.indexPathsForVisibleItems.contains(tempCC) == false  {
                if tempCC.row < NUMBER_OF_CELL {
                    listViewCollectionView.scrollToItem(at: tempCC, at: .right, animated: true)
                }
            }
            if currentIndex.row < (NUMBER_OF_CELL) {
                currentIndex = IndexPath(row: currentIndex.row + 1, section: 0)
                
                if let cell = listViewCollectionView.cellForItem(at: currentIndex) as? ListCollectionViewCell {
                    leftAnchorForBottomBar?.constant = cell.frame.origin.x + MARGIN_BAR
                }
            }
        }
        oldOffset = scrollView.contentOffset.x
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == listViewCollectionView {
            currentIndex = indexPath
            if INTERNAL_BAR_VISIBLE {
                didSelectTapped = true
                updateBarView()
            } else {
                let cell = listViewCollectionView.cellForItem(at: currentIndex) as! ListCollectionViewCell
                leftAnchorForBottomBar?.constant = cell.frame.origin.x + MARGIN_BAR
            }
//            let rect = (fullViewCollectionView.layoutAttributesForItem(at: indexPath)?.frame)!
//            fullViewCollectionView.scrollRectToVisible(rect, animated: true)
            fullViewCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)

        }
    }
}

