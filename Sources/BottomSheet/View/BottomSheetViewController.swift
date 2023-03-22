//
//  BottomSheetViewController.swift
//  
//
//  Created by Batuhan Baran on 12.03.2023.
//

import UIKit

public protocol BottomSheetViewDelegate: AnyObject {
    func bottomSheetViewDidAppear()
    func bottomSheetViewDidDisappear()
}

public extension BottomSheetViewDelegate {
    func bottomSheetViewDidAppear() { }
    func bottomSheetViewDidDisappear() { }
}

public final class BottomSheetViewController: UIViewController {

    // MARK: - Private properties
    private lazy var overlayViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    private lazy var dragIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.5
        view.layer.masksToBounds = true
        view.backgroundColor = presentable.dragIndicatorColor
        return view
    }()
    
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    private var halfHeight: CGFloat {
        screenHeight / 2
    }
    
    private var fullHeight: CGFloat = .zero
    
    private var panGestureRecognizer = UIPanGestureRecognizer()
    
    private var presentable: BottomSheetViewPresentable
    
    private var contentViewController: UIViewController
    private var contentViewHeight = NSLayoutConstraint()
     
    private var currentSize: BottomSheetSize
    
    // MARK: - Public properties
    public weak var delegate: BottomSheetViewDelegate?
    
    // MARK: - Initializers
    public init(contentViewController: UIViewController, presentable: BottomSheetViewPresentable) {
        self.contentViewController = contentViewController
        self.presentable = presentable
        self.currentSize = presentable.size
        
        super.init(nibName: "BottomSheetViewController", bundle: .module)
        self.modalPresentationStyle = .overCurrentContext

        addChilds()
        addDragIndicator()
        addTapGesture()
        addPanGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
    }

    // MARK: - Public methods
    public override func viewDidLayoutSubviews() {
        guard presentable.shouldRoundTopCorners else { return }
        
        super.viewDidLayoutSubviews()
        
        contentViewController.view.roundCorners(corners: [.topLeft, .topRight], radius: presentable.cornerRadius)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.delegate?.bottomSheetViewDidDisappear()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.delegate?.bottomSheetViewDidAppear()
        
        calculateFullHeight()
        updateContentViewHeight(with: currentSize)
    }
    
    // MARK: - Private methods
    private func addChilds() {
        /// Validate the content is a UIViewController
        assert(contentViewController.superclass == UIViewController.self, "The content must be inherit from UIViewController!")
        
        addChild(overlayViewController)
        view.addSubview(overlayViewController.view)
        overlayViewController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            overlayViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            overlayViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            overlayViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            overlayViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        
        contentViewHeight = contentViewController.view.heightAnchor.constraint(equalToConstant: .zero)
        contentViewHeight.isActive = true
        
        contentViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        contentViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        contentViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }

    private func addTapGesture() {
        guard presentable.shouldCloseIfTouchDimmedArea else { return }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOverylayView))
        overlayViewController.view.addGestureRecognizer(tapRecognizer)
        overlayViewController.view.isUserInteractionEnabled = true
    }
    
    private func addPanGesture() {
        guard presentable.isUserInteractionEnabled else { return }
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        contentViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func addDragIndicator() {
        guard presentable.showDragIndicator else { return }
        
        contentViewController.view.addSubview(dragIndicator)
        
        dragIndicator.widthAnchor.constraint(equalToConstant: 56).isActive = true
        dragIndicator.heightAnchor.constraint(equalToConstant: 5).isActive = true
        dragIndicator.topAnchor.constraint(equalTo: contentViewController.view.topAnchor, constant: 8).isActive = true
        dragIndicator.centerXAnchor.constraint(equalTo: contentViewController.view.centerXAnchor).isActive = true
    }
    
    private func calculateFullHeight() {
        if let presentingViewController {
            if presentingViewController.isMember(of: UINavigationController.self),
               let navigationController = presentingViewController as? UINavigationController,
               let topViewController = navigationController.topViewController {
                self.fullHeight = screenHeight - topViewController.topBarHeight
            } else {
                self.fullHeight = screenHeight - presentingViewController.topBarHeight
            }
        }
    }
    
    private func updateContentViewHeight(with currentSize: BottomSheetSize) {
        self.currentSize = currentSize
        
        switch currentSize {
        case .full:
            self.contentViewHeight.constant = self.fullHeight
            
        case .half:
            self.contentViewHeight.constant = halfHeight
            
        case .fix(let pct):
            if pct <= 0.0 || pct >= 1.0 {
                assertionFailure("\(pct) -> is not suitable. Percentage should be between 0.0 & 1.0")
            } else {
                self.contentViewHeight.constant = screenHeight * pct
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.overlayViewController.view.backgroundColor = UIColor.black.withAlphaComponent(self.presentable.alpha)
        }, completion: nil)
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.contentViewController.view.frame.origin.y -= -self.contentViewHeight.constant
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.overlayViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { _ in
            self.dismiss(animated: false)
        }
    }
    
    @objc
    private func didTapOverylayView() {
        animateDismissView()
    }
    
    @objc
    private func didPan(_ sender: UIPanGestureRecognizer) {
        let velocityY = sender.velocity(in: contentViewController.view).y / 80
        let direction = BottomSheetDirection(velocityY)
        
        switch sender.state {
        case .changed:
            guard direction != .up else {
                break
            }
            
            self.contentViewHeight.constant -= velocityY
            
        case .ended:
            switch currentSize {
            case .full:
                if self.contentViewHeight.constant <= (self.fullHeight - self.fullHeight / 3) {
                    animateDismissView()
                } else {
                    updateContentViewHeight(with: .full)
                }
                
            case .half:
                if self.contentViewHeight.constant <= (self.halfHeight / 2) {
                    animateDismissView()
                } else {
                    updateContentViewHeight(with: .half)
                }

            case .fix(pct: let pct):
                if self.contentViewHeight.constant <= (screenHeight * pct / 2) {
                    animateDismissView()
                } else {
                    updateContentViewHeight(with: .fix(pct: pct))
                }
            }
            
        default:
            break
            
        }
    }
}
