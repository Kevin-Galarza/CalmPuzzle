//
//  ViewControllerContainment.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 5/21/24.
//

import UIKit

extension UIViewController {
    
    func presentFullScreenModal(childViewController child: UIViewController, animated: Bool = true) {
       child.modalPresentationStyle = .fullScreen
       present(child, animated: animated)
   }
    
    func presentBottomSheetModal(childViewController child: UIViewController, animated: Bool = true) {
        child.modalPresentationStyle = .formSheet
        present(child, animated: animated)
    }

//    func presentBottomSheetModal(childViewController child: UIViewController, animated: Bool = true) {
//        let presentationController = BottomSheetPresentationController(presentedViewController: child, presenting: self)
//        child.transitioningDelegate = presentationController
//        child.modalPresentationStyle = .custom
//        present(child, animated: animated)
//    }
    
    func addFullScreen(childViewController child: UIViewController) {
        guard child.parent == nil else {
          return
        }

        addChild(child)
        view.addSubview(child.view)

        child.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
          view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
          view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
          view.topAnchor.constraint(equalTo: child.view.topAnchor),
          view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
        ]
        constraints.forEach { $0.isActive = true }
        view.addConstraints(constraints)

        child.didMove(toParent: self)
    }

    func remove(childViewController child: UIViewController?) {
        guard let child = child else {
          return
        }

        guard child.parent != nil else {
          return
        }

        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

class BottomSheetPresentationController: UIPresentationController, UIViewControllerTransitioningDelegate {
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let height: CGFloat = containerView.bounds.height / 2
        return CGRect(x: 0, y: containerView.bounds.height - height, width: containerView.bounds.width, height: height)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
        setupGestureRecognizer()
    }

    private func setupGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        presentedView?.addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: self.containerView?.window)

        switch recognizer.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y - initialTouchPoint.y > 0 {
                presentedView?.frame.origin.y = touchPoint.y - initialTouchPoint.y
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.presentingViewController.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.presentedView?.frame.origin.y = 0
                })
            }
        default:
            break
        }
    }
}
