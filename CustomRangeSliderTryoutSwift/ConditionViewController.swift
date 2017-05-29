//
//  ConditionViewController.swift
//  BikeOrNot
//
//  Created by Joel Bell on 6/14/16.
//  Copyright © 2016 Joel Bell. All rights reserved.
//

import UIKit

class ConditionViewController: UIViewController {
    
    var testArcView: TestArcView!
    
    let sliderButtonPanGestureRec = UIPanGestureRecognizer()
    
    var sliderButton: UIView!
    
    var sliderButtonLeadingConstraint: NSLayoutConstraint!
    var sliderButtonBottomConstraint: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.testArcView = TestArcView()
        self.testArcView.translatesAutoresizingMaskIntoConstraints = false
        self.testArcView.backgroundColor = UIColor.gray
        
        view.addSubview(self.testArcView)
        
        self.testArcView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.testArcView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.testArcView.widthAnchor.constraint(equalToConstant: 320).isActive = true
        self.testArcView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.sliderButton = UIView()
        self.sliderButton.translatesAutoresizingMaskIntoConstraints = false
        self.sliderButton.layer.cornerRadius = 30 / 2
        self.sliderButton.backgroundColor = UIColor.gray
        self.sliderButton.layer.borderColor = UIColor.white.cgColor
        self.sliderButton.layer.borderWidth = 1.0

        view.addSubview(self.sliderButton)
        
        self.sliderButtonLeadingConstraint = self.sliderButton.leadingAnchor.constraint(equalTo: self.testArcView.leadingAnchor, constant: -15)
        self.sliderButtonBottomConstraint =  self.sliderButton.bottomAnchor.constraint(equalTo: self.testArcView.bottomAnchor, constant: 15)
        self.sliderButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.sliderButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.sliderButtonLeadingConstraint.isActive = true
        self.sliderButtonBottomConstraint.isActive = true
        
        self.sliderButtonPanGestureRec.addTarget(self, action: #selector(ConditionViewController.handleSliderButtonDrag(_:)))
        self.sliderButton.addGestureRecognizer(self.sliderButtonPanGestureRec)
        
        print("end of view did load")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let percent:CGFloat = 0.2
        
        let myFloat = getBezierYIntercept(percent, p1: self.testArcView.p1, c1: self.testArcView.cp1, c2: self.testArcView.cp2, p2: self.testArcView.p2)
        
        let xPosition = self.testArcView.bounds.size.width * percent
        
        let convertedPoint = view.convert(CGPoint(x: xPosition,y: myFloat), from: self.testArcView)
        
        let leadingConstant = self.sliderButtonLeadingConstraint.constant
        let bottomConstant =  self.sliderButtonBottomConstraint.constant
        
        self.sliderButtonLeadingConstraint.constant = xPosition + leadingConstant
        self.sliderButtonBottomConstraint.constant = -(self.testArcView.bounds.size.height - myFloat - bottomConstant)
        
        
        print("end of view did appear")
        
    }
    
    func handleSliderButtonDrag(_ sender:UIPanGestureRecognizer) {
        
//        if self.minDragStopPoint == nil {
//            self.minDragStopPoint = sender.view!.center.y
//        }
        
        let translation = sender.translation(in: view)
//        let newCenterY = sender.view!.center.y + translation.y
        
//        if newCenterY > self.minDragStopPoint {
//            if self.minSliderButtonHighlightView.alpha > 0 {
//                animateFadeOfSliderHighlightView(self.minSliderButtonHighlightView)
//            }
//            return
//            
//        } else if newCenterY - self.maxSliderButtonView.center.y <= self.sliderButtonWidthAndHeight {
//            if self.minButtonAnimationInProgress == nil {
//                self.minButtonAnimationInProgress = true
//                animateFadeOfSliderHighlightView(self.minSliderButtonHighlightView)
//            }
//            return
//        } else {
//            if self.minSliderButtonHighlightView.alpha == 0 {
//                addHighlightViewsForMinSliderButton()
//            }
//        }
        
//        let heightDifference = self.minDragStopPoint - newCenterY
//        let adjustedHeight = self.tempSliderBackgroundViewHeight - self.tempSliderBackgroundViewWidth
//        let temp = (self.maxTemp * heightDifference) / adjustedHeight
//        self.minSliderButtonHighlightLabel.text = "\(Int(temp))°"
//        self.minTempLabel.text = " \(Int(temp))°"
        
//        self.tempSliderMovableViewBottomConstraint.constant = -heightDifference
//        sender.view!.center = CGPointMake(sender.view!.center.x, newCenterY)
//        sender.setTranslation(CGPointZero, inView: view)
//        setColorOfViewFromPoint(CGPointMake(sender.view!.center.x, newCenterY), viewToUpdate: self.minSliderButtonHighlightView)
        
//        self.minSliderBackgroundViewHeightConstraint.constant = heightDifference
        
        if sender.state == .ended {
//            animateFadeOfSliderHighlightView(self.minSliderButtonHighlightView)
            
        }
        
    }
    
    func getBezierYIntercept(_ percent: CGFloat, p1: CGPoint, c1: CGPoint, c2: CGPoint, p2: CGPoint) -> CGFloat {
        
        let b1: (CGFloat) -> (CGFloat) = { t in
            return t*t*t
        }
        let b2: (CGFloat) -> (CGFloat) = { t in
            return 3*t*t*(1-t)
        }
        let b3: (CGFloat) -> (CGFloat) = { t in
            return 3*t*(1-t)*(1-t)
        }
        let b4: (CGFloat) -> (CGFloat) = { t in
            return (1-t)*(1-t)*(1-t)
        }
        
        //        let xPos = p1.x*b1(percent) + c1.x*b2(percent) + c2.x*b3(percent) + p2.x*b4(percent)
        let yPos = p1.y*b1(percent) + c1.y*b2(percent) + c2.y*b3(percent) + p2.y*b4(percent)
        
        return yPos
        
    }
    
    
    
}

// MARK: Custom Views
class TestArcView: UIView {
    
    var fillColor: UIColor!
    var p1: CGPoint!
    var p2: CGPoint!
    var cp1: CGPoint!
    var cp2: CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.fillColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        self.p1 = CGPoint(x: 0, y: rect.height)
        self.p2 = CGPoint(x: rect.width, y: rect.height)
        
        let controlMultiplier: CGFloat = rect.width * 0.25
        self.cp1 = CGPoint(x: controlMultiplier, y: rect.height - controlMultiplier)
        self.cp2 = CGPoint(x: rect.width - controlMultiplier, y: rect.height - controlMultiplier)
        
        let path = UIBezierPath()
        path.move(to: self.p1)
        path.addCurve(to: self.p2, controlPoint1: self.cp1, controlPoint2: self.cp2)
        
        UIColor.black.setStroke()
        path.lineWidth = 1
        path.stroke()
        
        
    }
    
    
    
}
