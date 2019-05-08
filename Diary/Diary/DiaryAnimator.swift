//
//  DiaryAnimator.swift
//  Diary
//
//  Created by TaoTao on 2019/5/8.
//  Copyright © 2019 TaoTao. All rights reserved.
//

import UIKit

class DiaryAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var operation: UINavigationController.Operation!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let fromView = fromVC?.view
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = toVC?.view
        toView?.alpha = 0
        if operation == UINavigationController.Operation.pop {
            toView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        } else {
            toView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }
        containerView.insertSubview(toView!, aboveSubview: fromView!)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut, animations: {
            if self.operation == UINavigationController.Operation.pop {
                fromView?.transform = CGAffineTransform(scaleX: 3.3, y: 3.3)
            } else {
                toView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            toView?.alpha = 1
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
    

}
