//
//  ViewController.swift
//  What's Poppin?
//
//  Created by David Hodge on 1/24/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let capacity = 200
    var headCount = 0
    var percentageIncrementFactor: CGFloat { return CGFloat(1.0/Double(capacity)) }
    var progressCircleLayer = CAShapeLayer()
    
    @IBOutlet weak var progressCircle: UIView!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var headCountLabel: UILabel!
    @IBOutlet weak var headCountView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Configure Navigation Bar
        var navFont: UIFont = UIFont(name: "HelveticaNeue-Light", size: 25)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: navFont]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = "Bar Counter"
        
        self.headCountLabel.text = String(headCount)
      
        createProgressCircle()
        
        //Configure ++ -- Buttons
        self.incrementButton.layer.cornerRadius = 0.5 * self.incrementButton.bounds.size.width
        self.decrementButton.layer.cornerRadius = 0.5 * self.decrementButton.bounds.size.width
        self.headCountView.layer.cornerRadius = 0.5 * self.headCountView.bounds.size.width
    }
    
    func createProgressCircle()
    {
        let centerPoint = CGPoint (x: self.progressCircle.bounds.width / 2, y: self.progressCircle.bounds.width / 2);
        let circleRadius : CGFloat = self.progressCircle.bounds.width / 2 * 1.1;
        
        var circlePath = UIBezierPath(arcCenter: centerPoint, radius: circleRadius, startAngle: CGFloat(-0.5 * M_PI), endAngle: CGFloat(1.5 * M_PI), clockwise: true);
        
        progressCircleLayer = CAShapeLayer ();
        progressCircleLayer.path = circlePath.CGPath;
        progressCircleLayer.strokeColor = UIColor.whiteColor().CGColor;
        progressCircleLayer.fillColor = UIColor.clearColor().CGColor;
        progressCircleLayer.lineWidth = 4;
        
        progressCircleLayer.strokeStart = 0;
        progressCircleLayer.strokeEnd = 0;
        
        self.progressCircle.layer.addSublayer(progressCircleLayer);
        
    }
    
    @IBAction func increment(sender: AnyObject) {
        updateProgressCircle(0) //0 stands for increment
    }
    @IBAction func decrement(sender: AnyObject) {
        updateProgressCircle(1) //1 stands for decrement
    }
    
    func updateProgressCircle(change: Int)
    {
        switch change {
        case 0: //Increment
            if (headCount < capacity) {
                println("Increment")
                self.headCount++
                self.headCountLabel.text = String(headCount)
                progressCircleLayer.strokeEnd += percentageIncrementFactor
                println("Stroke End: \(progressCircleLayer.strokeEnd), Head Count: \(headCount)")
            }
        case 1: //Decrement
            if (headCount > 0) {
                println("Decrement")
                self.headCount--
                self.headCountLabel.text = String(headCount)
                progressCircleLayer.strokeEnd -= percentageIncrementFactor
                println("Stroke End: \(progressCircleLayer.strokeEnd), Head Count: \(headCount)")
            }
            
        default:
            println("Head count did not change.")
        }
    }
}

