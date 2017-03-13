//
//  TransitionManager.swift
//  navigation-transition
//
//  Created by Sinan Eren on 3/12/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Foundation
import UIKit

public func == <T:Equatable> (tuple1:(T.Type,T.Type),tuple2:(T.Type,T.Type)) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1)
}

public typealias ViewControllerTypePair = (UIViewController.Type,UIViewController.Type)

public enum TransitionType {
    case vertical
    case snapshot
    case none
}

extension TransitionType {
    func transition(operation: UINavigationControllerOperation) -> TransitionImplement? {
        switch self {
        case .vertical:
            return VerticalTransition(operation: operation)
        case .snapshot:
            return SnapshotTransition(operation: operation)
        default:
            return nil
        }
    }
}

struct UserDeterminedTransitions {
    static fileprivate(set) var transitionPairs: [TransitionType : [ViewControllerTypePair]] = [:]
    
    public func add(transitionPairArray: [TransitionType : [ViewControllerTypePair]]) {
        for (key,value) in transitionPairArray {
            UserDeterminedTransitions.transitionPairs.updateValue(value, forKey: key)
        }
    }
}

protocol CompareViewControllersToTransitions {}
extension CompareViewControllersToTransitions {
    
    fileprivate func transitionType(for viewControllerTypePair: ViewControllerTypePair) -> TransitionType? {
        let transitionType = UserDeterminedTransitions.transitionPairs.filter() { (key, value) -> Bool in
            return value.contains(where: { (type) -> Bool in
                return type == viewControllerTypePair
            })
        }
        return transitionType.first?.key
    }
}


final class TransitionManager: NSObject, UINavigationControllerDelegate, CompareViewControllersToTransitions {
    
    internal func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
                
        let type = transitionType(
            for: (type(of: fromVC),
                  type(of: toVC))
        )
        let transitionImplement = type?.transition(operation: operation)
        return transitionImplement
    }
}
