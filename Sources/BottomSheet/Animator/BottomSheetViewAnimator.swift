//
//  BottomSheetViewAnimator.swift
//  
//
//  Created by Batuhan Baran on 7.04.2023.
//

import UIKit

final class BottomSheetViewAnimator: NSObject {
    
    enum AnimationType {
        case present
        case dismiss
    }
    
    private let animationType: AnimationType
    
    init(animationType: AnimationType) {
        self.animationType = animationType
    }
}

extension BottomSheetViewAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        .zero
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch animationType {
        case .present:
            setLayout(with: transitionContext, for: toViewController.view)
            presentAnimation(with: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            guard let bottomSheetViewController = fromViewController as? BottomSheetViewController else { return }
            bottomSheetViewController.animateDismissView { _ in
                transitionContext.completeTransition(true)
            }
        }
    }
    
    private func setLayout(with transitionContext: UIViewControllerContextTransitioning, for view: UIView) {
        transitionContext.containerView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: transitionContext.containerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: transitionContext.containerView.trailingAnchor),
            view.topAnchor.constraint(equalTo: transitionContext.containerView.topAnchor),
            view.bottomAnchor.constraint(equalTo: transitionContext.containerView.bottomAnchor)
        ])
    }
    
    private func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut) {
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
}
