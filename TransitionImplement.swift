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
    var operation : UINavigationControllerOperation = .none

    init(operation: UINavigationControllerOperation) {
        self.operation = operation
    }

    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) { }
}

final class VerticalTransition: TransitionImplement {

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        guard let from = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let to = transitionContext.view(forKey: UITransitionContextViewKey.to)
            else { return }

        containerView.addSubview(to)
        var verticalDelta: CGFloat = 0

        switch operation {
        case .push:
            verticalDelta = -containerView.frame.size.height
        case .pop:
            verticalDelta = containerView.frame.size.height
        default:
            break
        }

        to.transform = CGAffineTransform(translationX: 0, y: -verticalDelta)

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

final class SnapshotTransition: TransitionImplement {

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let from = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let to = transitionContext.view(forKey: UITransitionContextViewKey.to)
            else { return }

        to.alpha = 0.5
        containerView.addSubview(to)
        containerView.sendSubview(toBack: to)

        let snapshotView = from.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = from.frame
        containerView.addSubview(snapshotView!)

        from.removeFromSuperview()

        UIView.animate(
            withDuration: duration,
            animations: {
                snapshotView?.frame = from.frame.insetBy(dx: from.frame.size.width / 2, dy: from.frame.size.height / 2)
                to.alpha = 1.0
            },
            completion: { (finished) in
                snapshotView?.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        )
    }
}
