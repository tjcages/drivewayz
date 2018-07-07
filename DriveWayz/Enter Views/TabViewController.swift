//
//  PageViewController.swift
//  DriveWayz
//
//  Created by Tyler Jordan Cagle on 6/21/18.
//  Copyright © 2018 COAD. All rights reserved.
//

import UIKit
import Firebase

class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    
    var rightArrow: UIButton!
    var leftArrow: UIButton!
    
    lazy var bottomTabBarController: UIView = {
        
        let containerBar = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height: 50))
        containerBar.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.isUserInteractionEnabled = false
        blurView.alpha = 0.9
        containerBar.addSubview(blurView)
        
        blurView.leftAnchor.constraint(equalTo: containerBar.leftAnchor).isActive = true
        blurView.rightAnchor.constraint(equalTo: containerBar.rightAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: containerBar.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerBar.bottomAnchor).isActive = true
        
        leftArrow = UIButton(type: .custom)
        let arrowLeftImage = UIImage(named: "Expand")
        let tintedLeftImage = arrowLeftImage?.withRenderingMode(.alwaysTemplate)
        leftArrow.setImage(tintedLeftImage, for: .normal)
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        leftArrow.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        leftArrow.tintColor = Theme.PRIMARY_COLOR
        leftArrow.addTarget(self, action: #selector(tabBarRight), for: .touchUpInside)
        containerBar.addSubview(leftArrow)
        
        leftArrow.leftAnchor.constraint(equalTo: blurView.leftAnchor, constant: 32).isActive = true
        leftArrow.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        leftArrow.heightAnchor.constraint(equalToConstant: 40).isActive = true
        leftArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        rightArrow = UIButton(type: .custom)
        let arrowRightImage = UIImage(named: "Expand")
        let tintedRightImage = arrowRightImage?.withRenderingMode(.alwaysTemplate)
        rightArrow.setImage(tintedRightImage, for: .normal)
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        rightArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        rightArrow.tintColor = Theme.PRIMARY_COLOR
        rightArrow.addTarget(self, action: #selector(tabBarRight), for: .touchUpInside)
        containerBar.addSubview(rightArrow)
        
        rightArrow.rightAnchor.constraint(equalTo: blurView.rightAnchor, constant: -32).isActive = true
        rightArrow.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        rightArrow.heightAnchor.constraint(equalToConstant: 40).isActive = true
        rightArrow.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        return containerBar
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.view.addSubview(bottomTabBarController)
        
        bottomTabBarController.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomTabBarController.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomTabBarController.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomTabBarController.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        setupPageControl()

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                return self.pages.last
            } else {
                // go to previous page in array
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex < self.pages.count - 1 {
                // go to next page in array
                return self.pages[viewControllerIndex + 1]
            } else {
                // wrap to first page in array
                return self.pages.first
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.index(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupPageControl() {
        
        self.delegate = self
        let initialPage = 0
        let page1 = MapViewController()
        let page2 = AirbnbExploreController()
        let page3 = MessageTableViewController()
        
        // add the individual viewControllers to the pageViewController
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
//        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        // pageControl
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = Theme.PRIMARY_DARK_COLOR
        self.pageControl.pageIndicatorTintColor = Theme.PRIMARY_COLOR
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        self.bottomTabBarController.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.centerYAnchor.constraint(equalTo: self.bottomTabBarController.centerYAnchor).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -200).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.view.bringSubview(toFront: bottomTabBarController)
    }
    
    @objc func tabBarRight() {
        print("hello")
    }
    
    @objc func handleLogout() {
        self.performSegue(withIdentifier: "loginView", sender: self)
    }

}


















