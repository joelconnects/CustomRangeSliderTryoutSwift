//
//  ViewController.swift
//  BikeOrNot
//
//  Created by Joel Bell on 5/19/16.
//  Copyright © 2016 Joel Bell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var minButton: UIButton!
    @IBOutlet weak var maxButton: UIButton!
    @IBOutlet weak var minTempLabel: UILabel!
    
    var sliderViewLeadingConstraint: NSLayoutConstraint!
    var sliderViewTrailingConstraint: NSLayoutConstraint!
    
    var sliderTotalWidth: CGFloat!
    
    let minButtonPanRec = UIPanGestureRecognizer()
    let maxButtonPanRec = UIPanGestureRecognizer()
    
    var thermostatSlider: UIView!
    
    let fahrenheitMax: CGFloat = 100
    let buttonWidth: CGFloat = 30.0
    let labelWidth: CGFloat = 50.0
    let sliderPadding: CGFloat = 50.0
    
    /*
 x/100 = 1/300
 
 Total width - remaining width = width removed
 
 300 - 200 = 100
 */
    func updateTempForMinButton() {
        
        let sliderRemainingWidth = sliderView.frame.size.width
        let difference = sliderTotalWidth - sliderRemainingWidth
        let temp = (fahrenheitMax * difference) / sliderTotalWidth
//        minButton.setTitle("\(Int(temp))", forState: .Normal)
        minTempLabel.text! = "\(Int(temp))"
        
        print(temp)
        
    }
    
    func updateTempForMaxButton() {
        
        //
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ForecastAPI.getLocalWeatherData { (results) in
//            let current = CurrentWeather.init(conditions: results)
//            print(current.temperature)
//        }
        
        
        minButtonPanRec.addTarget(self, action: #selector(ViewController.draggedMinButton(_:)))
        minButton.addGestureRecognizer(minButtonPanRec)
        
        maxButtonPanRec.addTarget(self, action: #selector(ViewController.draggedMaxButton(_:)))
        maxButton.addGestureRecognizer(maxButtonPanRec)
        
        view.removeConstraints(view.constraints)
        
        // Add contstraints to minTempLabel
        minTempLabel.backgroundColor = UIColor.gray
        minTempLabel.layer.cornerRadius = buttonWidth/2
        let minTempLabelBottomConstraint = NSLayoutConstraint(item: minTempLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: sliderView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let minTempLabelTrailingConstraint = NSLayoutConstraint(item: minTempLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: sliderView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: labelWidth/2)
        let minTempLabelWidthConstraint = NSLayoutConstraint(item: minTempLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: minTempLabel, attribute: NSLayoutAttribute.width, multiplier: 0, constant: labelWidth)
        let minTempLabelHeightConstraint = NSLayoutConstraint(item: minTempLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: minTempLabel, attribute: NSLayoutAttribute.height, multiplier: 0, constant: labelWidth)
        NSLayoutConstraint.activate([minTempLabelBottomConstraint, minTempLabelTrailingConstraint, minTempLabelWidthConstraint, minTempLabelHeightConstraint])
        
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add contstraints to minButton
        minButton.backgroundColor = UIColor.red
        minButton.layer.cornerRadius = buttonWidth/2
        let minButtonTopConstraint = NSLayoutConstraint(item: minButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: sliderView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 20)
        let minButtonTrailingConstraint = NSLayoutConstraint(item: minButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: sliderView, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: buttonWidth/2)
        let minButtonWidthConstraint = NSLayoutConstraint(item: minButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: minButton, attribute: NSLayoutAttribute.width, multiplier: 0, constant: buttonWidth)
        let minButtonHeightConstraint = NSLayoutConstraint(item: minButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: minButton, attribute: NSLayoutAttribute.height, multiplier: 0, constant: buttonWidth)
        NSLayoutConstraint.activate([minButtonTopConstraint, minButtonTrailingConstraint, minButtonWidthConstraint, minButtonHeightConstraint])
        
        minButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add contstraints to maxButton
        maxButton.backgroundColor = UIColor.red
        maxButton.layer.cornerRadius = buttonWidth/2
        let maxButtonTopConstraint = NSLayoutConstraint(item: maxButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: sliderView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 20)
        let maxButtonTrailingConstraint = NSLayoutConstraint(item: maxButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: sliderView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: buttonWidth/2)
        let maxButtonWidthConstraint = NSLayoutConstraint(item: maxButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: maxButton, attribute: NSLayoutAttribute.width, multiplier: 0, constant: buttonWidth)
        let maxButtonHeightConstraint = NSLayoutConstraint(item: maxButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: maxButton, attribute: NSLayoutAttribute.height, multiplier: 0, constant: buttonWidth)
        NSLayoutConstraint.activate([maxButtonTopConstraint, maxButtonTrailingConstraint, maxButtonWidthConstraint, maxButtonHeightConstraint])
        
        maxButton.translatesAutoresizingMaskIntoConstraints = false
    
        // Add constraints to slider view
        let sliderViewTopConstraint = NSLayoutConstraint(item: sliderView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 100)
        let sliderViewHeightConstraint = NSLayoutConstraint(item: sliderView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.height, multiplier: 0, constant:50)
        sliderViewLeadingConstraint = NSLayoutConstraint(item: sliderView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 50)
        sliderViewTrailingConstraint = NSLayoutConstraint(item: sliderView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: -50)
        NSLayoutConstraint.activate([sliderViewTopConstraint, sliderViewHeightConstraint, sliderViewLeadingConstraint, sliderViewTrailingConstraint])
        
        
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add thermostat slider view
        thermostatSlider = UIView.init()
        thermostatSlider.backgroundColor = UIColor.green
        view.addSubview(thermostatSlider)
        
        let thermostatSliderTopConstraint = NSLayoutConstraint(item: thermostatSlider, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: sliderView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 100)
        let thermostatSliderBottomConstraint = NSLayoutConstraint(item: thermostatSlider, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -20)
        let thermostatSliderLeadingConstraint = NSLayoutConstraint(item: thermostatSlider, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 200)
        let thermostatSliderTrailingConstraint = NSLayoutConstraint(item: thermostatSlider, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: -200)
        NSLayoutConstraint.activate([thermostatSliderTopConstraint, thermostatSliderBottomConstraint, thermostatSliderLeadingConstraint, thermostatSliderTrailingConstraint])
        
        thermostatSlider.translatesAutoresizingMaskIntoConstraints = false
        
        //design the path
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 1))
        path.addLine(to: CGPoint(x: -10, y: 1))
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.0
        
        thermostatSlider.layer.addSublayer(shapeLayer)
        
        print("end of view did load")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sliderTotalWidth = sliderView.frame.size.width
        
        

    }
    
    func draggedMinButton(_ sender:UIPanGestureRecognizer){
        
        let maxButtonX = maxButton.frame.origin.x
        
        self.view.bringSubview(toFront: sender.view!)
        let translation = sender.translation(in: self.view)
        
        
        
        // TO DO: need to change 50 to percentage or constant, can't stay static
        if sender.view!.center.x < 50.1 && translation.x < 0.1 {
            sender.setTranslation(CGPoint.zero, in: self.view)
        } else {
            print("\n\nsender center x: \(sender.view!.center.x)\ntranslation x: \(translation.x)\n\n")
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y)
            sliderViewLeadingConstraint.constant = sender.view!.center.x
            self.updateTempForMinButton()
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    
    }
    
    func draggedMaxButton(_ sender:UIPanGestureRecognizer){
//        self.view.bringSubviewToFront(sender.view!)
//        let translation = sender.translationInView(self.view)
//        
//        
//        
//        // TO DO: need to change 50 to percentage or constant, can't stay static
//        if sender.view!.center.x < 50.1 && translation.x < 0.1 {
//            sender.setTranslation(CGPointZero, inView: self.view)
//        } else {
//            print("\n\nsender center x: \(sender.view!.center.x)\ntranslation x: \(translation.x)\n\n")
//            sender.view!.center = CGPointMake(sender.view!.center.x + translation.x, sender.view!.center.y)
//            sliderViewLeadingConstraint.constant = sender.view!.center.x
//            sender.setTranslation(CGPointZero, inView: self.view)
//        }
//        
//        if sender.state == UIGestureRecognizerState.Began {
//            
//            minButton.setTitle("", forState: .Normal)
//            
//        }
//        
//        if sender.state == UIGestureRecognizerState.Ended {
//            
//            self.updateTempForMinButton()
//            
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

