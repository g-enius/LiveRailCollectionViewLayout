//
//  ViewController.swift
//  collectionViewPOC
//
//  Created by Charles on 12/02/20.
//  Copyright © 2020 SKY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var initialContentOffset = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        (self.collectionView.collectionViewLayout as! LiveRailCollectionViewLayout).delegate = self
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        

        self.collectionView.isDirectionalLockEnabled = true
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 1
        
        var label = cell.viewWithTag(1005) as! UILabel?
        if label == nil {
            label = UILabel(frame: CGRect.init(x: 10, y: 10, width: 30, height: 30))
            label!.tag = 1005
            cell.addSubview(label!)
        }
        
        label!.text = "\(indexPath.item)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 150
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height:100)
    }
}

extension ViewController: LiveRailCollectionViewDelegateLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout: LiveRailCollectionViewLayout,
                        sizeAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout: LiveRailCollectionViewLayout,
                        insetsForItemAtIndexPath: IndexPath) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}

extension ViewController: UIScrollViewDelegate {
   
    enum ScrollDirection : Int {
        case none
        case crazy
        case left
        case right
        case up
        case down
        case horizontal
        case vertical
    }
    
    func determineScrollDirection(_ scrollView: UIScrollView) -> ScrollDirection {
        var scrollDirection: ScrollDirection

        // If the scrolling direction is changed on both X and Y it means the
        // scrolling started in one corner and goes diagonal. This will be
        // called ScrollDirectionCrazy

        if initialContentOffset.x != scrollView.contentOffset.x && initialContentOffset.y != scrollView.contentOffset.y {
            scrollDirection = .crazy
        } else {
            if initialContentOffset.x > (scrollView.contentOffset.x) {
                scrollDirection = .left
            } else if initialContentOffset.x < (scrollView.contentOffset.x) {
                scrollDirection = .right
            } else if initialContentOffset.y > (scrollView.contentOffset.y) {
                scrollDirection = .up
            } else if initialContentOffset.y < (scrollView.contentOffset.y) {
                scrollDirection = .down
            } else {
                scrollDirection = .none
            }
        }

        return scrollDirection
    }

    func determineScrollDirectionAxis(_ scrollView: UIScrollView) -> ScrollDirection {
        let scrollDirection = determineScrollDirection(scrollView)

        switch scrollDirection {
        case .left, .right:
            return .horizontal
        case .up, .down:
            return .vertical
        default:
            return .none
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        initialContentOffset = scrollView.contentOffset
    }
       
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("*** scrollViewDidScroll called")
        let scrollDirection = determineScrollDirectionAxis(scrollView)
       
        if scrollDirection == .vertical {
            print("Scrolling direction: vertical")
        } else if scrollDirection == .horizontal {
            print("Scrolling direction: horizontal")
        } else {
            var newOffset: CGPoint = CGPoint.zero
            if abs(scrollView.contentOffset.x) > abs(scrollView.contentOffset.y) {
                newOffset = CGPoint.init(x: scrollView.contentOffset.x, y: initialContentOffset.y)
            } else {
                newOffset = CGPoint.init(x: initialContentOffset.x, y: scrollView.contentOffset.y)
            }
            
            // Setting the new offset to the scrollView makes it behave like a proper
            // directional lock, that allows you to scroll in only one direction at any given time
            scrollView.contentOffset = newOffset
            print("*** set content offset")
//            var scrollBounds = scrollView.bounds;
//            scrollBounds.origin = newOffset;
//            scrollView.bounds = scrollBounds;
        }
    }
}

