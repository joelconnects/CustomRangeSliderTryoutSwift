//
//  SpectrumTest.swift
//  BikeOrNot
//
//  Created by Joel Bell on 5/29/16.
//  Copyright © 2016 Joel Bell. All rights reserved.
//

import UIKit


class SpectrumViewController: UIViewController {
    
    var spectrumView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spectrumView = UIView()
        spectrumView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(spectrumView)
        
        spectrumView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spectrumView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spectrumView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        spectrumView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let layer = CAGradientLayer()
        layer.frame = spectrumView.bounds
        layer.colors = [UIColor.brown.cgColor,
                        UIColor.red.cgColor,
                        UIColor.yellow.cgColor,
                        UIColor.green.cgColor,
                        UIColor.cyan.cgColor,
                        UIColor.blue.cgColor,
                        UIColor.purple.cgColor]
        spectrumView.layer.addSublayer(layer)
        
        
        let testLabel = UILabel()
        testLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(testLabel)
        
        testLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        testLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        testLabel.font = UIFont (name: "StencilArmyWWI", size: 26)
        testLabel.text = "Choose Temperature Range"
        
        
        
    }
    
    
    
    

}

