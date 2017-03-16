//
//  TransitionImplement.swift
//  navigation-transition
//
//  Created by Sinan Eren on 3/12/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Foundation
import UIKit

class TransitionImplement: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.8
    fileprivate var isPush = false

    init(operation: UINavigationControllerOperation) {
        guard operation != .none else { return }
        isPush = operation.rawValue % 2 != 0
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
}

final class VerticalTransition: TransitionImplement {

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        guard let from = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let to = transitionContext.view(forKey: UITransitionContextViewKey.to)
            else { return }

        var verticalDelta: CGFloat = 0
        let containerHeight = containerView.frame.size.height
        verticalDelta = isPush ? -1 * containerHeight : containerHeight

        to.transform = CGAffineTransform(translationX: 0, y: -verticalDelta)
        containerView.addSubview(to)

        UIView.animate(
            withDuration: duration,
            animations: {
                from.transform = CGAffineTransform(translationX: 0, y: verticalDelta)
                to.transform = CGAffineTransform.identity
            },
            completion: { finished in
                from.removeFromSuperview()
                from.transform = CGAffineTransform.identity
                transitionContext.completeTransition(true)
            }
        )
    }
}

final class ZoomTransition: TransitionImplement {

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        guard let from = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let to = transitionContext.view(forKey: UITransitionContextViewKey.to)
            else { return }

        let viewToPresent = isPush ? to : from
        let viewCenterFrame = CGRect(x: containerView.center.x, y: containerView.center.y, width: 1, height: 1)
        let initialFrame = isPush ? viewCenterFrame : viewToPresent.frame
        let finalFrame = isPush ? viewToPresent.frame : viewCenterFrame

        let xScaleFactor = isPush ? (initialFrame.width / finalFrame.width) : (finalFrame.width / initialFrame.width)
        let yScaleFactor = isPush ? (initialFrame.height / finalFrame.height) : (finalFrame.height / initialFrame.height)
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)


        if isPush {
            viewToPresent.transform = scaleTransform
            viewToPresent.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            viewToPresent.clipsToBounds = true
        }

        containerView.addSubview(to)
        containerView.bringSubview(toFront: viewToPresent)

        UIView.animate(
            withDuration: duration,
            animations: {
                viewToPresent.transform = self.isPush ? CGAffineTransform.identity : scaleTransform
                viewToPresent.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }, completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}
