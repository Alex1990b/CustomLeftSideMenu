//
//  LeftSideMenyViewController.swift
//  CustomSideMenu
//
//  Created by Sasha on 13.12.18.
//  Copyright © 2018 Sasha. All rights reserved.
//

import UIKit

protocol SideMenuDraggable: class {
    func dragChanged(with offset: CGFloat)
    func dragEnded(with offset: CGFloat)
    func dragFinished()
}

final class LeftSideMenyViewController: UIViewController {
    
    //MARK: Variables
    private var dragBeginning = TimeInterval()
    weak var delegate: SideMenuDraggable?
    
    //MARK: LeftSideMenyViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRecognizers()
    }
}

//MARK: @IBActions

private extension LeftSideMenyViewController {
    
    @objc func handleDragges(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        guard translation.x < 0 else { return }
        
        switch sender.state {
        case .began:   dragBeginning = ProcessInfo.processInfo.systemUptime
        case .changed: delegate?.dragChanged(with: translation.x)
        case.ended:
            let difference = ProcessInfo.processInfo.systemUptime - dragBeginning
            difference > 0.1 ? delegate?.dragChanged(with: translation.x) : delegate?.dragFinished()
            
        default: break }
    }
}

//MARK: Private methods

private extension LeftSideMenyViewController {
    func addRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleDragges))
        view.addGestureRecognizer(panGestureRecognizer)
    }
}
