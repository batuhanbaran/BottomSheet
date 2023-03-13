//
//  BottomSheetViewPresentable.swift
//  
//
//  Created by Batuhan Baran on 13.03.2023.
//

import UIKit

public protocol BottomSheetViewPresentable: AnyObject {
    
    var properties: BottomSheetProperties { get set }
    var scrollView: UIScrollView? { get }
    
    func present(_ contentViewController: UIViewController)
}

public extension BottomSheetViewPresentable {
    
    func present(_ contentViewController: UIViewController) {
        let bottomSheetViewController = build(for: contentViewController)
        bottomSheetViewController.modalPresentationStyle = .fullScreen
        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        if let keyWindow = UIWindow.key {
            keyWindow.addSubview(bottomSheetViewController.view)
            
            NSLayoutConstraint.activate([
                bottomSheetViewController.view.trailingAnchor.constraint(equalTo: keyWindow.trailingAnchor),
                bottomSheetViewController.view.leadingAnchor.constraint(equalTo: keyWindow.leadingAnchor),
                bottomSheetViewController.view.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor),
                bottomSheetViewController.view.topAnchor.constraint(equalTo: keyWindow.topAnchor)
            ])
        }
    }
    
    private func build(for contentViewController: UIViewController) -> BottomSheetViewController {
        let viewModel = BottomSheetViewModel(properties: properties)
        return BottomSheetViewController(contentViewController: contentViewController, viewModel: viewModel)
    }
}
