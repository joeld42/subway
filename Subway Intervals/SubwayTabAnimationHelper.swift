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
    

    func tabBarController(tabBarController: UITabBarController,
            animationControllerForTransitionFromViewController
            fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return SubwayTabSwitchAnimationController();
    }
    
}

class SubwayTabSwitchAnimationController : NSObject, UIViewControllerAnimatedTransitioning
{
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2;
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
//        rForKey:UITransitionContextFromViewControllerKey];
//        UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        UIView* toView = toVC.view;
        let fromVC = transitionContext.viewControllerForKey( UITransitionContextFromViewControllerKey )
        let toVC = transitionContext.viewControllerForKey( UITransitionContextToViewControllerKey )
        
        let toView = toVC!.view;
        let fromView = fromVC!.view;
        
        let toItemTab = toVC?.tabBarItem!
        print( "TO TAB ITEM: \(toItemTab!.tag)")

        let fromItemTab = fromVC?.tabBarItem!
        print( "FROM TAB ITEM: \(fromItemTab!.tag)")
        
        let animDirection : CGFloat = (toItemTab!.tag > fromItemTab!.tag) ? 1.0 : -1.0;

        
        let containerView = transitionContext.containerView();
        
        containerView?.addSubview( toView );
        
        let finalFrame = transitionContext.finalFrameForViewController( toVC! )
        toView.frame = CGRectOffset( finalFrame, animDirection * 320.0, 0.0 )
        
//        toView.frame = transitionContext.finalFrameForViewController( toVC! )
        
        // Fade
//        toView.alpha = 0.0
//
        UIView.animateWithDuration( transitionDuration(transitionContext), delay: 0.0, options: .CurveEaseOut,
            animations: {
//                toView.alpha = 1.0;
                toView.frame = finalFrame
                fromView.frame = CGRectOffset( fromView.frame, animDirection * -320.0, 0.0 );
            }, completion: { finished in
                print("done with transition.." )

                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        
    }
}