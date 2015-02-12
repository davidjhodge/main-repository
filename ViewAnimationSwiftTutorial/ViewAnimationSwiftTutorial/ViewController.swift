//
//  ViewController.swift
//  ViewAnimationSwiftTutorial
//
//  Created by David Hodge on 1/24/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var fabricTop: UIImageView!
    @IBOutlet weak var fabricBottom: UIImageView!
    @IBOutlet weak var basketTop: UIImageView!
    @IBOutlet weak var basketBottom: UIImageView!
    @IBOutlet weak var bug: UIImageView!
    
    var isBugDead = false
    let tap: UIGestureRecognizer?
    let squishPlayer: AVAudioPlayer
    required init(coder aDecoder: NSCoder) {
        

        let squishPath = NSBundle.mainBundle().pathForResource("squish", ofType: "caf")
        let squishURL = NSURL(fileURLWithPath: squishPath!)
        squishPlayer = AVAudioPlayer(contentsOfURL: squishURL, error: nil)
        squishPlayer.prepareToPlay()
    
        super.init(coder: aDecoder)
        
        tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))

    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        UIView.animateWithDuration(0.7, delay: 1.0, options: .CurveEaseOut, animations: {
            
            var basketTopFrame = self.basketTop.frame
            basketTopFrame.origin.y -= basketTopFrame.size.height
            
            var basketBottomFrame = self.basketBottom.frame
            basketBottomFrame.origin.y += basketBottomFrame.size.height
            
            self.basketTop.frame = basketTopFrame
            self.basketBottom.frame = basketBottomFrame
            }, completion: { finished in
                println("Basket doors opened!")
        })
        
        UIView.animateWithDuration(1.0, delay: 1.2, options: .CurveEaseOut, animations: {
            
            var fabricBottomFrame = self.fabricBottom.frame
            fabricBottomFrame.origin.y += fabricBottomFrame.size.height
            
            var fabricTopFrame = self.fabricTop.frame
            fabricTopFrame.origin.y -= fabricTopFrame.size.height
            
            self.fabricTop.frame = fabricTopFrame
            self.fabricBottom.frame = fabricBottomFrame
        
            }, completion: {finished in
                println("Napkins opened!")
        })
        
        moveBugLeft()
        view.addGestureRecognizer(tap!)
    }
    
    //Bug Motion methods
    func moveBugLeft() {
        if isBugDead { return }
        
        UIView.animateWithDuration(1.0,
            delay: 2.0, options: .CurveEaseInOut | .AllowUserInteraction, animations: {
                self.bug.center = CGPoint(x: 75, y: 200)
            }, completion: {finished in
                println("Bug moved left!")
                self.faceBugRight()
                
        })
    }
    
    func faceBugRight() {
        if isBugDead { return }
        
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseInOut | .AllowUserInteraction, animations: {
            
            self.bug.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            }, completion: { finished in
                println("Bug faced right!")
                self.moveBugRight()
        })
    }
    
    func moveBugRight() {
        if isBugDead { return }
        
        UIView.animateWithDuration(1.0,
            delay: 2.0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                self.bug.center = CGPoint(x: 230, y: 250)
            },
            completion: { finished in
                println("Bug moved right!")
                self.faceBugLeft()
        })
    }
    
    func faceBugLeft() {
        if isBugDead { return }
        
        UIView.animateWithDuration(1.0,
            delay: 0.0,
            options: .CurveEaseInOut | .AllowUserInteraction,
            animations: {
                self.bug.transform = CGAffineTransformMakeRotation(0.0)
            },
            completion: { finished in
                println("Bug faced left!")
                self.moveBugLeft()
        })
    }
    
    //Handle Squash tap
    func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.locationInView(bug.superview)
        
        //Must check presentation layer because during an animation, the presentation layer changes only. The view frame doesn't reset til the end
        if bug.layer.presentationLayer().frame.contains(tapLocation) {
            println("Bug squished!")

            if isBugDead { return }
            view.removeGestureRecognizer(tap!)
            isBugDead = true
            squishPlayer.play()
            
            UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut | .BeginFromCurrentState, animations: {
                self.bug.transform = CGAffineTransformMakeScale(1.25,0.75)
                }, completion: { finished in
                    UIView.animateWithDuration(2.0, delay: 2.0, options: nil, animations: {
                        self.bug.alpha = 0
                        }, completion: { finished in
                            self.bug.removeFromSuperview()
                        })
            })
            
        } else {
            println("You missed the bug!")
        }
    }


}

