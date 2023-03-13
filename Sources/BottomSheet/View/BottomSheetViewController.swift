//
//  BottomSheetViewController.swift
//  
//
//  Created by Batuhan Baran on 12.03.2023.
//

import UIKit

final class BottomSheetViewController: UIViewController {

    private lazy var overlayViewController: UIViewController = {
        let viewController = UIViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    private var viewModel: BottomSheetViewModel
    private var contentViewController: UIViewController
    private var contentViewHeight = NSLayoutConstraint()
    
    init(contentViewController: UIViewController, viewModel: BottomSheetViewModel) {
        self.contentViewController = contentViewController
        self.viewModel = viewModel
        
        super.init(nibName: "BottomSheetViewController", bundle: .module)
        
        configure()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        // add overlayViewController
        addChild(overlayViewController)
        view.addSubview(overlayViewController.view)
        overlayViewController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            overlayViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            overlayViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            overlayViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            overlayViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
        
        // add contentViewController
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)
        
        contentViewHeight = contentViewController.view.heightAnchor.constraint(equalToConstant: .zero)
    
        NSLayoutConstraint.activate([
            contentViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            contentViewHeight
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentViewController.view.roundCorners(corners: [.topLeft, .topRight], radius: 12)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateContentViewHeight()
    }
    
    private func updateContentViewHeight() {
        self.contentViewHeight.constant = UIScreen.main.bounds.height / 2
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.overlayViewController.view.backgroundColor = UIColor.black.withAlphaComponent(self.viewModel.alpha)
        }, completion: nil)
    }
}
