//  PresentationController.swift
//  GymSheet
//
//  Created by Manish Singh on 8/23/20.
//  Copyright © 2020 ManishSingh. All rights reserved.
//

import UIKit

enum PresentationDirection {
    case left
    case right
    case top
    case bottom
}

// MARK: - Interactor
/// The purpose of this class is to add pan gesture the presented view to let the downward slide interaction be there when a user
/// wants to dismiss the view controller from the top to bottom slide gesture.
class GestureInteractor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

// MARK: - Animator
/// The purpose of this animator implemenation is to show animation while the view controller dimisses.
class CustomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }

        let containerView = transitionContext.containerView

        let screenBounds = containerView.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       animations: {
                        fromVC.view.frame = finalFrame},completion: { _ in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        )
    }
}

// MARK: - PresentationController
class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    //    private var interactionController: InteractionController?
    //
    //    init(interactionController: InteractionController?) {
    //        self.interactionController = interactionController
    //    }

    var interactor: GestureInteractor?
}

extension CustomTransitionDelegate {
    func presentationController( forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController( presentedViewController: presented, presenting: presenting, direction: .bottom)
        interactor = presentationController.interactor

        return presentationController
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimationController()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor!.hasStarted ? interactor : nil
    }
}

class PresentationController: UIPresentationController, UIGestureRecognizerDelegate, UIAdaptivePresentationControllerDelegate {

    private var direction: PresentationDirection

    /// Dimming view
    private var dimminingView: UIView?

    // interactor
    var interactor: GestureInteractor?

    override func presentationTransitionWillBegin() {
        guard let containerView = containerView,
            let dimminingView = dimminingView else {
                return
        }

        super.presentationTransitionWillBegin()

        containerView.insertSubview(dimminingView, at:0)

        let height = frameOfPresentedViewInContainerView.height+10

        NSLayoutConstraint.activate([
            //dimminingView.heightAnchor.constraint(equalToConstant: height),
            dimminingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimminingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimminingView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            dimminingView.rightAnchor.constraint(equalTo: containerView.rightAnchor)
        ])

        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimminingView.alpha = 1.0
            return
        }

        coordinator.animate(alongsideTransition: {
            (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
            dimminingView.alpha = 1.0
        }, completion:nil)
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator,
            let dimmingView = dimminingView else {
                dimminingView?.alpha = 0.0
                return
        }

        coordinator.animate(alongsideTransition: {
            (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
            dimmingView.alpha = 0.0
        }, completion:{ _ in
            dimmingView.removeFromSuperview()
        })
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        switch direction {
        case .left, .right:
            return CGSize(width: parentSize.width*(2.0/3.0), height: 400)
        case .bottom, .top:
            let presentedViewWidth = min(parentSize.width, 400)
            return CGSize(width: parentSize.width, height: 400)
        }
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        //        var frame: CGRect = .zero
        //        frame.size = size(forChildContentContainer: presentedViewController,
        //                          withParentContainerSize: containerView!.bounds.size)

        // First try
        //        switch direction {
        //        case .right:
        //            frame.origin.x = containerView!.frame.width*(1.0/3.0)
        //        case .bottom:
        //            frame.origin.y = containerView!.frame.height*(1.0/3.0)
        //        default:
        //            frame.origin = .zero
        //        }
        //        return frame
        // second try
        //        return CGRect(x: 0, y: 0, width: 400, height: 400)

        // third try
        guard let containerView = containerView, let presentedView = presentedView else { return .zero }

        let inset: CGFloat = 0
        let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)
        let targetWidth = safeAreaFrame.width - 2 * inset
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height

        var frame = safeAreaFrame
        frame.origin.x += inset

        // this value for the origin for the bottom works.
        frame.origin.y += frame.size.height - targetHeight - inset
        frame.size.width = targetWidth
        frame.size.height = targetHeight

        return frame
    }

    override var shouldPresentInFullscreen: Bool {
        return false
    }

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?,
         direction: PresentationDirection) {
        self.direction = direction

        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)

        //presentedView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        presentedView?.translatesAutoresizingMaskIntoConstraints = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didStartPanGesture(_:)))
        presentedViewController.view.addGestureRecognizer(panGesture)

        interactor = GestureInteractor()

        setupDimmingView()
    }

    @objc func didStartPanGesture(_ gestur: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.1
        let presentedView = presentedViewController.view

        // convert y-position to downward pull progress (percentage)
        let translation = gestur.translation(in: (presentedView))
        let verticalMovement = translation.y / (presentedView?.bounds.height)!
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)


        guard let interactor = interactor else { return }

        switch gestur.state {
        case .began:
            interactor.hasStarted = true
            presentedViewController.dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
}

private extension PresentationController {
    func setupDimmingView() {
        dimminingView = UIView()
        dimminingView?.translatesAutoresizingMaskIntoConstraints = false
        dimminingView?.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimminingView?.alpha = 0.0

        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOutside(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        dimminingView?.addGestureRecognizer(gesture)
    }

    @objc func tapOutside(_ gestur: UITapGestureRecognizer) {
        if gestur.state == .ended {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
}

