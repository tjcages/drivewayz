//
//  MainMenu.swift
//  DriveWayz
//
//  Created by Tyler J. Cagle on 2/28/20.
//  Copyright © 2020 COAD. All rights reserved.
//

import UIKit

public enum ViewExpandingState {
    case fullyExpanded
    case middle
    case fullyCollapsed
}

public class MainMenuView: UIView {
    
    public var fastExpandingTime: Double = 0.2
    public var slowExpandingTime: Double = 0.3
    public var minimalYPosition: CGFloat

    private let maximalYPosition: CGFloat
    private var currentExpandedState: ViewExpandingState = .middle
    private var startedDraggingOnSearchBar = false
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.bounces = false
        
        return view
    }()

    public init(){
        
        let windowFrame = UIWindow().frame
        let visibleHeight:CGFloat = 160
        let frame = CGRect(
            x: 0, y: windowFrame.height - visibleHeight,
            width: windowFrame.width, height: windowFrame.height)
        self.minimalYPosition = windowFrame.height - frame.height
        self.maximalYPosition = frame.origin.y
        
        super.init(frame: frame)

        backgroundColor = .clear
        
        setupViews()
    }

    public required init?(coder aDecoder: NSCoder) {
        minimalYPosition = 0
        maximalYPosition = phoneHeight
        
        super.init(coder: aDecoder)
    }

    private func setupViews() {
        
        addSubview(scrollView)
        scrollView.contentSize = CGSize(width: phoneWidth, height: phoneHeight * 2)
        scrollView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        let dragGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userDidPan))
        dragGestureRecognizer.delegate = self
        addGestureRecognizer(dragGestureRecognizer)
        
    }

    @objc private func userDidPan(_ sender: UIPanGestureRecognizer){
        let senderView = sender.view
        let loc = sender.location(in: senderView)
        let tappedView = senderView?.hitTest(loc, with: nil)

        if sender.state == .began {
            var viewToCheck:UIView? = tappedView
            while viewToCheck != nil {
                if viewToCheck is UISearchBar{
                    startedDraggingOnSearchBar = true
                    break
                }
                viewToCheck = viewToCheck?.superview
            }
        }

        if sender.state == .ended{
            startedDraggingOnSearchBar = false
            let currentYPosition = frame.origin.y
            let toTopDistance = abs(Int32(currentYPosition))
            let toBottomDistance = abs(Int32(currentYPosition  - maximalYPosition))
            let toCenterDistance = abs(Int32(currentYPosition - (phoneHeight - 200)))
            
            let sortedDistances = [toTopDistance, toBottomDistance, toCenterDistance].sorted()
            if sortedDistances[0] == toTopDistance {
                toggleExpand(.fullyExpanded, fast: true)
            }else if sortedDistances[0] == toBottomDistance {
                toggleExpand(.fullyCollapsed, fast: true)
            }else{
                toggleExpand(.middle, fast: true)
            }
        } else {
            let translation = sender.translation(in: self)

            var destinationY = self.frame.origin.y + translation.y
            if destinationY < minimalYPosition {
                destinationY = minimalYPosition
            }else if destinationY > maximalYPosition {
                destinationY = maximalYPosition
            }
            self.frame.origin.y = destinationY

            sender.setTranslation(CGPoint.zero, in: self)
        }
    }

    private func animationDuration(fast:Bool) -> Double {
        if fast {
            return fastExpandingTime
        }else{
            return slowExpandingTime
        }
    }

    public func toggleExpand(_ state: ViewExpandingState, fast:Bool = false){
        let duration = animationDuration(fast: fast)
        UIView.animate(withDuration: duration) {
            switch state{
            case .fullyExpanded:
                self.frame.origin.y = self.minimalYPosition
                self.scrollView.isScrollEnabled = true
            case .middle:
                self.frame.origin.y = phoneHeight - 280
                self.scrollView.isScrollEnabled = false
            case .fullyCollapsed:
                self.frame.origin.y = self.maximalYPosition
                self.scrollView.isScrollEnabled = false
            }
        }
        self.currentExpandedState = state
    }
}

extension MainMenuView: UIGestureRecognizerDelegate{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
