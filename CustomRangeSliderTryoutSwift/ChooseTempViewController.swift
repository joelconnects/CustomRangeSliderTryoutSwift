//
//  ChooseTempViewController.swift
//  BikeOrNot
//
//  Created by Joel Bell on 5/21/16.
//  Copyright © 2016 Joel Bell. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class ChooseTempViewController: UIViewController {
    
    var tempSliderBackgroundView: UIView!
    var tempSliderMovableView: UIView!
    var minSliderButtonView: UIView!
    var maxSliderButtonView: UIView!
    var minSliderButtonHighlightView: minView!
    var maxSliderButtonHighlightView: maxView!
    
    var minSliderButtonHighlightLabel: UILabel!
    var maxSliderButtonHighlightLabel: UILabel!
    
    var tempUnitLabel: UILabel!
    var minTempLabel: UILabel!
    var maxTempLabel: UILabel!
    
    var tempSliderBackgroundViewHeight: CGFloat!
    var tempSliderBackgroundViewWidth: CGFloat!
    var sliderButtonWidthAndHeight: CGFloat!
    
    var tempSliderMovableViewTopConstraint: NSLayoutConstraint!
    var tempSliderMovableViewBottomConstraint: NSLayoutConstraint!
    var minSliderBackgroundViewHeightConstraint: NSLayoutConstraint!
    var maxSliderBackgroundViewHeightConstraint: NSLayoutConstraint!
    
    let minButtonViewPanRec = UIPanGestureRecognizer()
    let maxButtonViewPanRec = UIPanGestureRecognizer()
    
    let maxTemp: CGFloat = 120
    let minTemp: CGFloat = 0
    
    var minDragStopPoint: CGFloat!
    var maxDragStopPoint: CGFloat!
    
    var minSliderStartCenterYPoint: CGFloat!
    var maxSliderStartCenterYPoint: CGFloat!
    
    var minButtonAnimationInProgress: Bool?
    var maxButtonAnimationInProgress: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        setUpView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addGradientLayerToSliderBackgroundView()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            if touch.view!.isEqual(minSliderButtonView) {
                
                addHighlightViewsForMinSliderButton()
                
            }
            
            if touch.view!.isEqual(maxSliderButtonView) {
                
                addHighlightViewsForMaxSliderButton()
                
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches ended")
        
        if let touch = touches.first {
            
            if touch.view!.isEqual(self.minSliderButtonView) {
                animateFadeOfSliderHighlightView(self.minSliderButtonHighlightView)
            }
            if touch.view!.isEqual(self.maxSliderButtonView) {
                animateFadeOfSliderHighlightView(self.maxSliderButtonHighlightView)
            }
        }
        
    }
    
}

// MARK: Set Up
extension ChooseTempViewController {
    
    func setUpView() {
        
        self.navigationItem.title = "Temperature Range"
        addBackgroundImageToView()
        addSliderBackgroundViews()
        addSliderTickMarksAndLabels()
        addTemperatureUnitLabel()
        addSliderButtons()
        addPanGesturesWithTargetsToSliderButtons()
        addTemperatureLabels()
        
    }
    
    func addBackgroundImageToView() {
        
        let blackWallImageView = UIImageView()
        blackWallImageView.translatesAutoresizingMaskIntoConstraints = false
        blackWallImageView.image = UIImage.init(named: "blackConcreteBg")
        view.addSubview(blackWallImageView)
        
        blackWallImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blackWallImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blackWallImageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        blackWallImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }
    
    func addSliderBackgroundViews() {
        
        let sliderViewHeightMultiplier: CGFloat = 0.6
        let screenHeight = UIScreen.main.bounds.height
        self.tempSliderBackgroundViewHeight = screenHeight * sliderViewHeightMultiplier
        self.tempSliderBackgroundViewWidth = 10.0
        self.sliderButtonWidthAndHeight = 30
        
        self.tempSliderBackgroundView = UIView()
        self.tempSliderBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.tempSliderBackgroundView.layer.cornerRadius = tempSliderBackgroundViewWidth / 2
        self.tempSliderBackgroundView.backgroundColor = UIColor.white
        self.tempSliderBackgroundView.layer.borderWidth = 1.0
        self.tempSliderBackgroundView.layer.borderColor = UIColor.darkGray.cgColor
        
        view.addSubview(self.tempSliderBackgroundView)
        
        self.tempSliderBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.tempSliderBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.tempSliderBackgroundView.widthAnchor.constraint(equalToConstant: self.tempSliderBackgroundViewWidth).isActive = true
        self.tempSliderBackgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: sliderViewHeightMultiplier).isActive = true
        
        let minSliderBackgroundView = UIView()
        minSliderBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        minSliderBackgroundView.layer.cornerRadius = self.tempSliderBackgroundViewWidth / 2
        minSliderBackgroundView.backgroundColor = UIColor.clear
        minSliderBackgroundView.layer.borderWidth = 1.0
        minSliderBackgroundView.layer.borderColor = UIColor.darkGray.cgColor
        
        view.addSubview(minSliderBackgroundView)
        
        self.minSliderBackgroundViewHeightConstraint = minSliderBackgroundView.heightAnchor.constraint(equalTo: tempSliderBackgroundView.heightAnchor, multiplier: 0, constant: 0)
        minSliderBackgroundView.bottomAnchor.constraint(equalTo: self.tempSliderBackgroundView.bottomAnchor).isActive = true
        minSliderBackgroundView.leadingAnchor.constraint(equalTo: self.tempSliderBackgroundView.leadingAnchor).isActive = true
        minSliderBackgroundView.trailingAnchor.constraint(equalTo: self.tempSliderBackgroundView.trailingAnchor).isActive = true
        minSliderBackgroundViewHeightConstraint.isActive = true
        
        let maxSliderBackgroundView = UIView()
        maxSliderBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        maxSliderBackgroundView.layer.cornerRadius = self.tempSliderBackgroundViewWidth / 2
        maxSliderBackgroundView.backgroundColor = UIColor.clear
        maxSliderBackgroundView.layer.borderWidth = 1.0
        maxSliderBackgroundView.layer.borderColor = UIColor.darkGray.cgColor
        
        view.addSubview(maxSliderBackgroundView)
        
        self.maxSliderBackgroundViewHeightConstraint = maxSliderBackgroundView.heightAnchor.constraint(equalTo: tempSliderBackgroundView.heightAnchor, multiplier: 0, constant: 0)
        maxSliderBackgroundView.topAnchor.constraint(equalTo: self.tempSliderBackgroundView.topAnchor).isActive = true
        maxSliderBackgroundView.leadingAnchor.constraint(equalTo: self.tempSliderBackgroundView.leadingAnchor).isActive = true
        maxSliderBackgroundView.trailingAnchor.constraint(equalTo: self.tempSliderBackgroundView.trailingAnchor).isActive = true
        self.maxSliderBackgroundViewHeightConstraint.isActive = true
        
        self.tempSliderMovableView = UIView()
        self.tempSliderMovableView.translatesAutoresizingMaskIntoConstraints = false
        self.tempSliderMovableView.layer.cornerRadius = self.tempSliderBackgroundViewWidth / 2
        self.tempSliderMovableView.backgroundColor = UIColor.clear
        
        view.addSubview(self.tempSliderMovableView)
        
        self.tempSliderMovableViewTopConstraint = self.tempSliderMovableView.topAnchor.constraint(equalTo: self.tempSliderBackgroundView.topAnchor)
        self.tempSliderMovableViewBottomConstraint = self.tempSliderMovableView.bottomAnchor.constraint(equalTo: self.tempSliderBackgroundView.bottomAnchor)
        self.tempSliderMovableView.leadingAnchor.constraint(equalTo: self.tempSliderBackgroundView.leadingAnchor).isActive = true
        self.tempSliderMovableView.trailingAnchor.constraint(equalTo: self.tempSliderBackgroundView.trailingAnchor).isActive = true
        self.tempSliderMovableViewTopConstraint.isActive = true
        self.tempSliderMovableViewBottomConstraint.isActive = true
        
    }
    
    func addSliderTickMarksAndLabels() {
        
        let pathDistance: CGFloat = 30
        let pathPadding: CGFloat = 10
        let lineWidth: CGFloat = 0.5
        
        for i in Int(minTemp)...Int(maxTemp) {
            
            if i % 10 == 0 {
                
                let adjustedTempSliderBackgroundViewHeight = self.tempSliderBackgroundViewHeight - self.tempSliderBackgroundViewWidth
                var convertedYOrigin = ((CGFloat(i) * adjustedTempSliderBackgroundViewHeight) / self.maxTemp) + self.tempSliderBackgroundViewWidth / 2
                
                if i == Int(self.minTemp) {
                    convertedYOrigin += lineWidth
                } else if i == Int(self.maxTemp) {
                    convertedYOrigin -= lineWidth
                }
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: -pathPadding, y: convertedYOrigin))
                path.addLine(to: CGPoint(x: -pathDistance, y: convertedYOrigin))
                
                let shapeLayer = CAShapeLayer()
                shapeLayer.path = path.cgPath
                shapeLayer.strokeColor = UIColor.white.cgColor
                shapeLayer.lineWidth = lineWidth
                
                self.tempSliderBackgroundView.layer.addSublayer(shapeLayer)
                
                let tempLabel = UILabel()
                tempLabel.translatesAutoresizingMaskIntoConstraints = false
                tempLabel.font = tempLabel.font.withSize(14)
                tempLabel.text = ("\(Int(self.maxTemp) - i)")
                tempLabel.textColor = UIColor.white
                let tempLabelHeight = tempLabel.intrinsicContentSize.height
                
                view.addSubview(tempLabel)
                
                tempLabel.topAnchor.constraint(equalTo: self.tempSliderBackgroundView.topAnchor, constant: convertedYOrigin - tempLabelHeight / 2).isActive = true
                tempLabel.trailingAnchor.constraint(equalTo: self.tempSliderBackgroundView.leadingAnchor, constant: -(pathDistance + pathPadding)).isActive = true
                
            }
            
        }
        
    }
    
    func addTemperatureUnitLabel() {
        
        self.tempUnitLabel = UILabel()
        self.tempUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        self.tempUnitLabel.text = "°F"
        self.tempUnitLabel.numberOfLines = 0
        self.tempUnitLabel.font = tempUnitLabel.font.withSize(16)
        self.tempUnitLabel.textColor = UIColor.white
        self.tempUnitLabel.textAlignment = .center
        
        view.addSubview(self.tempUnitLabel)
        
        self.tempUnitLabel.topAnchor.constraint(equalTo: self.tempSliderBackgroundView.bottomAnchor, constant: 15).isActive = true
        self.tempUnitLabel.centerXAnchor.constraint(equalTo: self.tempSliderBackgroundView.centerXAnchor).isActive = true
        
    }
    
    func addSliderButtons() {
        
        self.minSliderButtonView = UIView()
        self.minSliderButtonView.translatesAutoresizingMaskIntoConstraints = false
        self.minSliderButtonView.layer.cornerRadius = self.sliderButtonWidthAndHeight / 2
        self.minSliderButtonView.backgroundColor = UIColor.gray
        self.minSliderButtonView.layer.borderColor = UIColor.white.cgColor
        self.minSliderButtonView.layer.borderWidth = 1.0
        self.minSliderButtonView.alpha = 0.5
        
        view.addSubview(self.minSliderButtonView)
        
        self.minSliderButtonView.centerXAnchor.constraint(equalTo: self.tempSliderMovableView.centerXAnchor).isActive = true
        self.minSliderButtonView.bottomAnchor.constraint(equalTo: self.tempSliderMovableView.bottomAnchor, constant: self.tempSliderBackgroundViewWidth).isActive = true
        self.minSliderButtonView.widthAnchor.constraint(equalToConstant: self.sliderButtonWidthAndHeight).isActive = true
        self.minSliderButtonView.heightAnchor.constraint(equalToConstant: self.sliderButtonWidthAndHeight).isActive = true
        
        self.maxSliderButtonView = UIView()
        self.maxSliderButtonView.translatesAutoresizingMaskIntoConstraints = false
        self.maxSliderButtonView.layer.cornerRadius = self.sliderButtonWidthAndHeight / 2
        self.maxSliderButtonView.backgroundColor = UIColor.gray
        self.maxSliderButtonView.layer.borderColor = UIColor.white.cgColor
        self.maxSliderButtonView.layer.borderWidth = 1.0
        
        view.addSubview(maxSliderButtonView)
        
        self.maxSliderButtonView.centerXAnchor.constraint(equalTo: self.tempSliderMovableView.centerXAnchor).isActive = true
        self.maxSliderButtonView.topAnchor.constraint(equalTo: self.tempSliderMovableView.topAnchor, constant: -self.tempSliderBackgroundViewWidth).isActive = true
        self.maxSliderButtonView.widthAnchor.constraint(equalToConstant: self.sliderButtonWidthAndHeight).isActive = true
        self.maxSliderButtonView.heightAnchor.constraint(equalToConstant: self.sliderButtonWidthAndHeight).isActive = true
        
    }
    
    func addPanGesturesWithTargetsToSliderButtons() {
        
        self.minButtonViewPanRec.addTarget(self, action: #selector(ChooseTempViewController.handleMinButtonDrag(_:)))
        self.minSliderButtonView.addGestureRecognizer(self.minButtonViewPanRec)
        
        self.maxButtonViewPanRec.addTarget(self, action: #selector(ChooseTempViewController.handleMaxButtonDrag(_:)))
        self.maxSliderButtonView.addGestureRecognizer(self.maxButtonViewPanRec)
        
    }
    
    func addTemperatureLabels() {
        
        let minHeaderLabel = UILabel()
        minHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        minHeaderLabel.text = "MINIMUM:"
        minHeaderLabel.font = UIFont (name: "StencilArmyWWI", size: 20)
        minHeaderLabel.textColor = UIColor.gray
        minHeaderLabel.textAlignment = .center
        
        view.addSubview(minHeaderLabel)
        
        minHeaderLabel.topAnchor.constraint(equalTo: self.tempSliderBackgroundView.bottomAnchor, constant: 60).isActive = true
        minHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        minHeaderLabel.trailingAnchor.constraint(equalTo: self.tempSliderBackgroundView.leadingAnchor, constant: 0).isActive = true
        
        let maxHeaderLabel = UILabel()
        maxHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        maxHeaderLabel.text = "MAXIMUM:"
        maxHeaderLabel.font = UIFont (name: "StencilArmyWWI", size: 20)
        maxHeaderLabel.textColor = UIColor.gray
        maxHeaderLabel.textAlignment = .center
        
        view.addSubview(maxHeaderLabel)
        
        maxHeaderLabel.topAnchor.constraint(equalTo: self.tempSliderBackgroundView.bottomAnchor, constant: 60).isActive = true
        maxHeaderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        maxHeaderLabel.leadingAnchor.constraint(equalTo: self.tempSliderBackgroundView.trailingAnchor, constant:0).isActive = true
        
        self.minTempLabel = UILabel()
        self.minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        self.minTempLabel.text = " 0°"
        self.minTempLabel.font = UIFont (name: "HelveticaNeue-Light", size: 26)
        self.minTempLabel.textColor = UIColor.white
        self.minTempLabel.textAlignment = .center
        
        view.addSubview(self.minTempLabel)
        
        self.minTempLabel.topAnchor.constraint(equalTo: minHeaderLabel.bottomAnchor, constant: 0).isActive = true
        self.minTempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.minTempLabel.trailingAnchor.constraint(equalTo: self.tempSliderBackgroundView.leadingAnchor, constant: 0).isActive = true
        
        self.maxTempLabel = UILabel()
        self.maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        self.maxTempLabel.text = " 120°"
        self.maxTempLabel.font = UIFont (name: "HelveticaNeue-Light", size: 26)
        self.maxTempLabel.textColor = UIColor.white
        self.maxTempLabel.textAlignment = .center
        
        view.addSubview(self.maxTempLabel)
        
        self.maxTempLabel.topAnchor.constraint(equalTo: maxHeaderLabel.bottomAnchor, constant: 0).isActive = true
        self.maxTempLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.maxTempLabel.leadingAnchor.constraint(equalTo: self.tempSliderBackgroundView.trailingAnchor, constant: 0).isActive = true
        
        
    }
    
    func addGradientLayerToSliderBackgroundView() {
        
        let layer = CAGradientLayer()
        layer.frame = self.tempSliderBackgroundView.bounds
        layer.colors = [UIColor(red: 0.498, green: 0, blue: 0, alpha: 1.0).cgColor,
                        UIColor.red.cgColor,
                        UIColor.yellow.cgColor,
                        UIColor.green.cgColor,
                        UIColor.cyan.cgColor,
                        UIColor.blue.cgColor,
                        UIColor.purple.cgColor]
        self.tempSliderBackgroundView.layer.addSublayer(layer)
        layer.cornerRadius  = self.tempSliderBackgroundViewWidth / 2
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.7
        animation.fromValue = 0.0
        animation.toValue = 1.0
        layer.add(animation, forKey: "opacity")
        
    }
    
}

// MARK: Gesture Handling
extension ChooseTempViewController {
    
    func handleMinButtonDrag(_ sender:UIPanGestureRecognizer) {
        
        if self.minDragStopPoint == nil {
            self.minDragStopPoint = sender.view!.center.y
        }
        
        let translation = sender.translation(in: view)
        let newCenterY = sender.view!.center.y + translation.y
        
        if newCenterY > self.minDragStopPoint {
            if self.minSliderButtonHighlightView.alpha > 0 {
                animateFadeOfSliderHighlightView(self.minSliderButtonHighlightView)
            }
            return
            
        } else if newCenterY - self.maxSliderButtonView.center.y <= self.sliderButtonWidthAndHeight {
            if self.minButtonAnimationInProgress == nil {
                self.minButtonAnimationInProgress = true
                animateFadeOfSliderHighlightView(self.minSliderButtonHighlightView)
            }
            return
        } else {
            if self.minSliderButtonHighlightView.alpha == 0 {
                addHighlightViewsForMinSliderButton()
            }
        }
        
        let heightDifference = self.minDragStopPoint - newCenterY
        let adjustedHeight = self.tempSliderBackgroundViewHeight - self.tempSliderBackgroundViewWidth
        let temp = (self.maxTemp * heightDifference) / adjustedHeight
        self.minSliderButtonHighlightLabel.text = "\(Int(temp))°"
//        self.minTempLabel.text = " \(Int(temp))°"
        
        self.tempSliderMovableViewBottomConstraint.constant = -heightDifference
        sender.view!.center = CGPoint(x: sender.view!.center.x, y: newCenterY)
        sender.setTranslation(CGPoint.zero, in: view)
        setColorOfViewFromPoint(CGPoint(x: sender.view!.center.x, y: newCenterY), viewToUpdate: self.minSliderButtonHighlightView)
        
        print("height difference: \(heightDifference)")
        self.minSliderBackgroundViewHeightConstraint.constant = heightDifference
        
        if sender.state == .ended {
            animateFadeOfSliderHighlightView(self.minSliderButtonHighlightView)
            
        }
        
    }
    
    func handleMaxButtonDrag(_ sender:UIPanGestureRecognizer) {
        
        if self.maxDragStopPoint == nil {
            self.maxDragStopPoint = sender.view!.center.y
        }
        
        let translation = sender.translation(in: view)
        let newCenterY = sender.view!.center.y + translation.y
        
        if newCenterY < self.maxDragStopPoint {
            if self.maxSliderButtonHighlightView.alpha > 0 {
                animateFadeOfSliderHighlightView(self.maxSliderButtonHighlightView)
            }
            return
        } else if self.minSliderButtonView.center.y - newCenterY <= self.sliderButtonWidthAndHeight {
            if self.maxButtonAnimationInProgress == nil {
                self.maxButtonAnimationInProgress = true
                animateFadeOfSliderHighlightView(self.maxSliderButtonHighlightView)
            }
            return
        } else {
            if self.maxSliderButtonHighlightView.alpha == 0 {
                addHighlightViewsForMaxSliderButton()
            }
        }
        
        let heightDifference = newCenterY - self.maxDragStopPoint
        let adjustedHeight = self.tempSliderBackgroundViewHeight - self.tempSliderBackgroundViewWidth
        let temp = round(self.maxTemp - ((self.maxTemp * heightDifference) / adjustedHeight))
        self.maxSliderButtonHighlightLabel.text = "\(Int(temp))°"
//        self.maxTempLabel.text = " \(Int(temp))°"
        
        self.maxSliderBackgroundViewHeightConstraint.constant = heightDifference
        
        self.tempSliderMovableViewTopConstraint.constant = heightDifference
        sender.view!.center = CGPoint(x: sender.view!.center.x, y: newCenterY)
        sender.setTranslation(CGPoint.zero, in: view)
        setColorOfViewFromPoint(CGPoint(x: sender.view!.center.x, y: newCenterY), viewToUpdate: self.maxSliderButtonHighlightView)
        
        if sender.state == .ended {
            animateFadeOfSliderHighlightView(self.maxSliderButtonHighlightView)
        }
        
    }
    
}

// MARK: Highlighting
extension ChooseTempViewController {
    
    func addHighlightViewsForMinSliderButton() {
        
        let minViewHeight: CGFloat = 100;
        let minViewYOrigin = self.minSliderButtonView.center.y - minViewHeight / 2
        let minViewWidth = self.minSliderButtonView.center.x
        let convertedPoint = view.convert(self.minSliderButtonView.center, to: self.tempSliderBackgroundView)
        let colorAtPoint = getPixelColorAtPoint(convertedPoint)
        let minRect = CGRect(x: 0, y: minViewYOrigin, width: minViewWidth, height: minViewHeight)
        
        self.minSliderButtonHighlightView = minView.init(frame: minRect)
        self.minSliderButtonHighlightView.alpha = 0
        self.minSliderButtonHighlightView.fillColor = colorAtPoint
        self.minSliderButtonHighlightView.backgroundColor = UIColor.clear
        
        self.minSliderButtonHighlightView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(self.minSliderButtonHighlightView, belowSubview: self.tempSliderBackgroundView)
        
        self.minSliderButtonHighlightView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.minSliderButtonHighlightView.centerYAnchor.constraint(equalTo: self.minSliderButtonView.centerYAnchor).isActive = true
        self.minSliderButtonHighlightView.widthAnchor.constraint(equalToConstant: minViewWidth).isActive = true
        self.minSliderButtonHighlightView.heightAnchor.constraint(equalToConstant: minViewHeight).isActive = true
        
        self.minSliderButtonHighlightLabel = UILabel()
        self.minSliderButtonHighlightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.minSliderButtonHighlightLabel.alpha = 0
        
        let adjustedHeight = self.tempSliderBackgroundViewHeight - self.tempSliderBackgroundViewWidth
        let temp = self.maxTemp - (self.maxTemp * (convertedPoint.y - (self.tempSliderBackgroundViewWidth / 2))) / adjustedHeight
        if temp < 0 {
            self.minSliderButtonHighlightLabel.text = "0°"
        } else {
            self.minSliderButtonHighlightLabel.text = "\(Int(temp))°"
        }
        self.minSliderButtonHighlightLabel.font = UIFont (name: "StencilArmyWWI", size: 40)
        self.minSliderButtonHighlightLabel.textColor = UIColor.white
        self.minSliderButtonHighlightLabel.textAlignment = .left
        
        view.addSubview(self.minSliderButtonHighlightLabel)
        
        self.minSliderButtonHighlightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        self.minSliderButtonHighlightLabel.centerYAnchor.constraint(equalTo: self.minSliderButtonView.centerYAnchor).isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.minSliderButtonHighlightView.alpha = 1
            self.minSliderButtonHighlightLabel.alpha = 1
        })
        
    }
    
    func addHighlightViewsForMaxSliderButton() {
        
        let maxViewHeight: CGFloat = 100;
        let maxViewYOrigin = self.maxSliderButtonView.center.y - maxViewHeight / 2
        let maxViewWidth = self.maxSliderButtonView.center.x
        let convertedPoint = view.convert(self.maxSliderButtonView.center, to: self.tempSliderBackgroundView)
        let colorAtPoint = getPixelColorAtPoint(convertedPoint)
        let maxRect = CGRect(x: 0, y: maxViewYOrigin, width: maxViewWidth, height: maxViewHeight)
        
        if self.maxSliderStartCenterYPoint == nil {
            self.maxSliderStartCenterYPoint = convertedPoint.y
        }
        
        self.maxSliderButtonHighlightView = maxView.init(frame: maxRect)
        self.maxSliderButtonHighlightView.alpha = 0
        self.maxSliderButtonHighlightView.fillColor = colorAtPoint
        self.maxSliderButtonHighlightView.backgroundColor = UIColor.clear
        
        self.maxSliderButtonHighlightView.translatesAutoresizingMaskIntoConstraints = false
        
        view.insertSubview(self.maxSliderButtonHighlightView, belowSubview: self.tempSliderBackgroundView)
        
        self.maxSliderButtonHighlightView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.maxSliderButtonHighlightView.centerYAnchor.constraint(equalTo: self.maxSliderButtonView.centerYAnchor).isActive = true
        self.maxSliderButtonHighlightView.widthAnchor.constraint(equalToConstant: maxViewWidth).isActive = true
        self.maxSliderButtonHighlightView.heightAnchor.constraint(equalToConstant: maxViewHeight).isActive = true
        
        self.maxSliderButtonHighlightLabel = UILabel()
        self.maxSliderButtonHighlightLabel.translatesAutoresizingMaskIntoConstraints = false
        self.maxSliderButtonHighlightLabel.alpha = 0
        
        let adjustedHeight = self.tempSliderBackgroundViewHeight - self.tempSliderBackgroundViewWidth
        if convertedPoint.y < maxSliderStartCenterYPoint {
            self.maxSliderButtonHighlightLabel.text = "120°"
            
        } else {
            let temp = self.maxTemp - (self.maxTemp * (convertedPoint.y - self.maxSliderStartCenterYPoint)) / adjustedHeight
            self.maxSliderButtonHighlightLabel.text = "\(Int(temp))°"
        }
        
        self.maxSliderButtonHighlightLabel.font = UIFont (name: "StencilArmyWWI", size: 40)
        self.maxSliderButtonHighlightLabel.textColor = UIColor.white
        self.maxSliderButtonHighlightLabel.textAlignment = .right
        
        view.addSubview(self.maxSliderButtonHighlightLabel)
        
        self.maxSliderButtonHighlightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        self.maxSliderButtonHighlightLabel.centerYAnchor.constraint(equalTo: self.maxSliderButtonView.centerYAnchor).isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.maxSliderButtonHighlightView.alpha = 1
            self.maxSliderButtonHighlightLabel.alpha = 1
        })
        
    }
    
    func animateFadeOfSliderHighlightView(_ view: UIView) {
        
        var highlightView: UIView!
        var highlightLabel: UILabel!
        
        if let minView = self.minSliderButtonHighlightView {
            
            if view == self.minSliderButtonHighlightView {
                
                highlightView = minView
                highlightLabel = self.minSliderButtonHighlightLabel
            }
            
        }
        
        if let maxView = self.maxSliderButtonHighlightView {
            
            if view == self.maxSliderButtonHighlightView {
                
                highlightView = maxView
                highlightLabel = self.maxSliderButtonHighlightLabel
            }
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            highlightView.alpha = 0
            highlightLabel.alpha = 0
            }, completion: { (value: Bool) in
                highlightView.removeFromSuperview()
                highlightLabel.removeFromSuperview()
                if view.isEqual(self.minSliderButtonHighlightView) {
                    self.minButtonAnimationInProgress = nil
                }
                if view.isEqual(self.maxSliderButtonHighlightView) {
                    self.maxButtonAnimationInProgress = nil
                }
                
        })
    }

    func setColorOfViewFromPoint(_ point: CGPoint, viewToUpdate: UIView) {
        
        let convertedPoint = view.convert(point, to: self.tempSliderBackgroundView)
        let color = getPixelColorAtPoint(convertedPoint)
        
        if let minView = self.minSliderButtonHighlightView {
            
            if viewToUpdate == self.minSliderButtonHighlightView {
                
                minView.fillColor = color
                minView.setNeedsDisplay()
            }
            
        }
        
        if let maxView = self.maxSliderButtonHighlightView {
            
            if viewToUpdate == self.maxSliderButtonHighlightView {
                
                maxView.fillColor = color
                maxView.setNeedsDisplay()
            }
            
        }
        
        
        
    }

    func getPixelColorAtPoint(_ point:CGPoint)->UIColor
    {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.translateBy(x: -point.x, y: -point.y)
        self.tempSliderBackgroundView.layer.render(in: context!)
        let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0, green: CGFloat(pixel[1])/255.0, blue: CGFloat(pixel[2])/255.0, alpha: 0.5)
        
        pixel.deallocate(capacity: 4)
        return color
    }
    
}


// MARK: Utility
extension ChooseTempViewController {
    
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
}

// MARK: Custom Views
class minView: UIView {
    
    var fillColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.fillColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height/2))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.close()
        
        self.fillColor.withAlphaComponent(0.6).setFill()
        path.fill()
        
    }
    
}

class maxView: UIView {
    
    var fillColor: UIColor!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.fillColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.close()
        
        self.fillColor.withAlphaComponent(0.6).setFill()
        path.fill()
        
    }
    
}



