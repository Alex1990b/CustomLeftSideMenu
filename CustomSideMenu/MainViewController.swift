//
//  ViewController.swift
//  CustomSideMenu
//
//  Created by Sasha on 13.12.18.
//  Copyright © 2018 Sasha. All rights reserved.
//

import UIKit

protocol ViewAnimatable where Self: UIViewController {
    func animateLayoutIfNeeded(with duration: TimeInterval)
}

extension ViewAnimatable {
    func animateLayoutIfNeeded(with duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

final class MainViewController: UIViewController, ViewAnimatable {
    
    //MARK: @IBOutlets
    
    @IBOutlet private weak var leftMenuContainerView: UIView!
    @IBOutlet private weak var leftMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var overlayView: UIView!
    
    //MARK: Variables
    
    private var leftMenuWidth: CGFloat {
        return view.frame.width * 0.6
    }
    
    //MARK: Constants
    
    private let overlayViewMaxAlpha: CGFloat = 0.5
    private let overlayViewMinAlpha: CGFloat = 0
    
    //MARK: MainViewController Life Cycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeLeftMenu()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(overlayViewDidTapped))
        overlayView.addGestureRecognizer(tapGestureRecognizer)
        children.forEach { ($0 as? LeftSideMenyViewController)?.delegate = self }
    }
}

//MARK: @IBActions

private extension MainViewController {
    @IBAction func showLeftMenuButtonTapped(_ sender: UIBarButtonItem) {
        leftMenuLeadingConstraint.constant = leftMenuLeadingConstraint.constant < 0 ? 0 : -leftMenuWidth
        overlayView.alpha =  leftMenuLeadingConstraint.constant == 0 ? overlayViewMaxAlpha : overlayViewMinAlpha
        animateLayoutIfNeeded()
    }
    
    @objc func overlayViewDidTapped() {
        closeLeftMenu()
    }
}

//MARK: Private methods

private extension MainViewController {
    func closeLeftMenu() {
        leftMenuLeadingConstraint.constant = -leftMenuWidth
        overlayView.alpha = 0
        animateLayoutIfNeeded()
    }
}

//MARK: SideMenuDelegate

extension MainViewController: SideMenuDraggable {
    func dragFinished() {
        closeLeftMenu()
    }
    
    func dragChanged(with offset: CGFloat) {
        leftMenuLeadingConstraint.constant = offset
        
        // needed to change alpha depending on the position of the menu
        let currentOffsetInPercent = (offset * 100) / (leftMenuWidth)
        let currentAlphaOffset = (0.5 * currentOffsetInPercent) / 100
        print(currentAlphaOffset)
        
        overlayView.alpha =  overlayViewMaxAlpha - currentAlphaOffset.magnitude
        animateLayoutIfNeeded()
    }
    
    func dragEnded(with offset: CGFloat) {

        if  offset.magnitude <= (leftMenuWidth / 2) {
             leftMenuLeadingConstraint.constant = 0
        } else {
            leftMenuLeadingConstraint.constant =  -leftMenuWidth
        }
       
        overlayView.alpha =  leftMenuLeadingConstraint.constant == 0 ? overlayViewMaxAlpha : overlayViewMinAlpha
        animateLayoutIfNeeded()
    }
}

