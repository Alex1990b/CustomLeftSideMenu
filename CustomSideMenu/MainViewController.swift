//
//  ViewController.swift
//  CustomSideMenu
//
//  Created by Sasha on 13.12.18.
//  Copyright © 2018 Sasha. All rights reserved.
//

import UIKit





class ViewController: UIViewController {

  @IBOutlet weak var leftMenuContainerView: UIView!
    @IBOutlet weak var leftMenuLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var overlayView: UIView!
    
 
  private var leftMenuWidth: CGFloat {
    return view.frame.width * 0.6
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    closeLeftMenu()
    children.forEach { ($0 as? LeftSideMenyViewController)?.delegate = self }
  }
    
  @IBAction func showLeftMenuButtonTapped(_ sender: UIBarButtonItem) {
   leftMenuLeadingConstraint.constant = leftMenuLeadingConstraint.constant < 0 ? 0 : -leftMenuWidth
    UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
    }
  }
    
}

private extension ViewController {
    func closeLeftMenu() {
        leftMenuLeadingConstraint.constant = -leftMenuWidth
        overlayView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension ViewController: SideMenuDraggable {
    func viewSwiped() {
        closeLeftMenu()
    }
    
    func viewFinishedDragging(with translitionX: CGFloat) {
        
        guard translitionX != 0 else { return }
        
        leftMenuLeadingConstraint.constant = translitionX.magnitude <= (leftMenuWidth / 2)
        ? 0
        : -leftMenuWidth
        overlayView.alpha =  leftMenuLeadingConstraint.constant == 0 ? 0.3 : 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    

    
    func viewWasDragged(with translitionX: CGFloat) {
        leftMenuLeadingConstraint.constant = translitionX
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}

