//
//  BackgroundArtViewController.swift
//  Subway Intervals
//
//  Created by Joel Davis on 11/24/15.
//  Copyright © 2015 Joel Davis. All rights reserved.
//

import Foundation
import UIKit

class BackgroundArtViewController : UIViewController
{
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var blurEffectView: UIVisualEffectView!
    
    override func viewDidLoad() {
        // After we load the background view, load the main view controller as a child VC
        let storyboard = UIStoryboard( name: "Main", bundle: nil )
        let mainVC = storyboard.instantiateInitialViewController()
        
        self.addChildViewController(mainVC!)
        self.view.addSubview( mainVC!.view )
        mainVC?.didMove(toParentViewController: self)
        
//        UIView .animateWithDuration(3.0) { () -> Void in
//            self.blurEffectView.effect = UIBlurEffect( style: UIBlurEffectStyle.Light )
////            self.blurEffectView.contentView.backgroundColor = UIColor( red: 1.0, green: 0.0, blue: 0.0, alpha: 0.2 )
//        }
    }
    
    func switchToTab( _ tabIndex : Int )
    {
        
    }
    
    @IBAction func testButtonPushed(_ sender: AnyObject)
    {
        print("test button pressed...");
        
    
        
    }
    
    func switchToImage( _ imgNum : Int )
    {
        print("Switch To Image.... \(imgNum)");
        
        var targetImageName : String?;
        switch imgNum
        {
        case 0:
            targetImageName="piano1.jpeg";
            
        case 1:
            targetImageName = "accordian.jpeg";
            
        default:
            targetImageName = "globe_bw.jpg";	
            
        }
        
        if (targetImageName != nil)
        {
            backgroundImageView.image = UIImage.init(named: targetImageName! );
        }
//        self.blurEffectView.effect = nil;
//        UIView .animateWithDuration( 3.0, animations: { () -> Void in
//            self.blurEffectView.effect = UIBlurEffect( style: UIBlurEffectStyle.Dark )
//            }) { ( isAnimated: Bool ) -> Void in
//                UIView.animateWithDuration( 3.0, animations: { () -> Void in
//                    self.blurEffectView.effect = nil;
//                })
//        }
    }
}
