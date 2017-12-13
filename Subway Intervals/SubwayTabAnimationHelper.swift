//
//  SubwayTabAnimationHelper.swift
//  Subway Intervals
//
//  Created by Joel Davis on 11/23/15.
//  Copyright © 2015 Joel Davis. All rights reserved.
//

import Foundation
import UIKit

class SubwayTabAnimationHelper : NSObject
{
    

    func tabBarController(_ tabBarController: UITabBarController,
            animationControllerForTransitionFromViewController
            fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return SubwayTabSwitchAnimationController();
    }
    
}

class SubwayTabSwitchAnimationController : NSObject, UIViewControllerAnimatedTransitioning
{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
//        rForKey:UITransitionContextFromViewControllerKey];
//        UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        UIView* toView = toVC.view;
        let fromVC = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.from )
        let toVC = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.to )
        
        let toView = toVC!.view;
        let fromView = fromVC!.view;
        
        let toItemTab = toVC?.tabBarItem!
        print( "TO TAB ITEM: \(toItemTab!.tag)")

        let fromItemTab = fromVC?.tabBarItem!
        print( "FROM TAB ITEM: \(fromItemTab!.tag)")
        
        let animDirection : CGFloat = (toItemTab!.tag > fromItemTab!.tag) ? 1.0 : -1.0;

        // Inform the background art that we're switching tabs
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let backgroundArtVC = appDelegate.window?.rootViewController as! BackgroundArtViewController
        
        backgroundArtVC.switchToImage( toItemTab!.tag )
        
        
        
        let containerView = transitionContext.containerView;
        
        containerView.addSubview( toView! );
        
        let finalFrame = transitionContext.finalFrame( for: toVC! )
        toView?.frame = finalFrame.offsetBy(dx: animDirection * 320.0, dy: 0.0 )
        
//        toView.frame = transitionContext.finalFrameForViewController( toVC! )
        
        // Fade
//        toView.alpha = 0.0
//
        UIView.animate( withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseOut,
            animations: {
//                toView.alpha = 1.0;
                toView?.frame = finalFrame
                fromView?.frame = (fromView?.frame.offsetBy(dx: animDirection * -320.0, dy: 0.0 ))!;
            }, completion: { finished in
                print("done with transition.." )

                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        
    }
}
