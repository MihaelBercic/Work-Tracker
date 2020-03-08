//
//  ViewController.swift
//  Events
//
//  Created by Mihael Bercic on 01/01/2020.
//  Copyright © 2020 Regnum d.o.o. All rights reserved.
//

import UIKit

let sharedDataManager: DataManager = DataManager()
let hexColor:          String      = randomFlatColor
let sharedAppColor:    UIColor     = UIColor(hex: hexColor)

var loadStoredEntries: [Entry] { sharedDataManager.fetchData(request: Entry.fetchRequest()) }
var loadStoredClients: [Client] { sharedDataManager.fetchData(request: Client.fetchRequest()) }

let sharedClientsProperty = Observable<[Client]>([])


class SwipeApplicationController: CUIViewController, UIScrollViewDelegate, ViewSetup {

    // Constants
    private let startPage:           Int           = 0
    private let pageScrollView:      UIScrollView  = UIScrollView()
    private let stackView:           UIStackView   = UIStackView()
    private let bottomNavigationBar: NavigationBar = NavigationBar(sharedAppColor)

    // Variables
    private var previousPageXOffset: CGFloat       = 0.0
    private var startPoint:          CGPoint       = CGPoint()

    private let pages: [(CUIViewController, (String, String))] = [
        (OverviewController(), ("Penguin", "PenguinSelected")),
        (SettingsController(), ("Settings", "SettingsSelected"))
    ]

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToPage(startPage)
    }
}

// Custom
extension SwipeApplicationController {

    func scrollToPage(_ page: Int) {
        bottomNavigationBar.setPage(page: page + 1)
        pageScrollView.setContentOffset(CGPoint(x: page * Int(pageScrollView.frame.size.width), y: 0), animated: false)
        previousPageXOffset = pageScrollView.contentOffset.x
    }

    @objc private func onNavigationTap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: bottomNavigationBar)
        let page  = Int(point.x / (bottomNavigationBar.iconSize + bottomNavigationBar.spacing))
        scrollToPage(page)
    }

}

// On Init
extension SwipeApplicationController {
    func onInit() {
        print(hexColor)
        view.backgroundColor = .systemBackground
        pageScrollView.delegate = self
    }
}

// Hierarchy
extension SwipeApplicationController {
    func setHierarchy() {
        view.addSubview(pageScrollView)
        view.addSubview(bottomNavigationBar)
        pageScrollView.addSubview(stackView)
    }
}

// Constraints
extension SwipeApplicationController {
    func setConstraints() {
        pageScrollView.connect {
            $0.topAnchor = view.safeAreaLayoutGuide.topAnchor
            $0.leftAnchor = view.safeAreaLayoutGuide.leftAnchor
            $0.rightAnchor = view.safeAreaLayoutGuide.rightAnchor
            $0.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        stackView.connect {
            $0.topAnchor = pageScrollView.topAnchor
            $0.bottomAnchor = pageScrollView.bottomAnchor
            $0.leftAnchor = pageScrollView.leftAnchor
            $0.rightAnchor = pageScrollView.rightAnchor
        }
        bottomNavigationBar.use { bar in
            bar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onNavigationTap)))
            bar.connect {
                $0.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
                $0.bottomConstant = -20
                $0.centerXAnchor = view.centerXAnchor
            }
        }
        pages.map { $0.0 }.forEach { controller in
            stackView.addArrangedSubview(controller.view)
            addChild(controller)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            controller.view.connect {
                $0.topAnchor = self.view.safeAreaLayoutGuide.topAnchor
                $0.bottomAnchor = self.view.safeAreaLayoutGuide.bottomAnchor
                $0.widthAnchor = self.view.safeAreaLayoutGuide.widthAnchor
            }
        }
    }
}

// Subviews
extension SwipeApplicationController {
    func modifySubviews() {
        bottomNavigationBar.initializeView(images: self.pages.map { $0.1 }, scrollView: pageScrollView)
        pageScrollView.use { this in
            this.translatesAutoresizingMaskIntoConstraints = false
            this.showsHorizontalScrollIndicator = false
            this.showsVerticalScrollIndicator = false
            this.bounces = false
            this.isPagingEnabled = true
        }
    }
}

// ScrollViewDelegate
extension SwipeApplicationController {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) { startPoint = scrollView.contentOffset }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset = targetContentOffset.pointee
        if targetOffset.x != previousPageXOffset { bottomNavigationBar.scrollHorizontal(left: targetOffset.x < previousPageXOffset) }
        previousPageXOffset = targetOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let distance = scrollView.contentOffset.x - startPoint.x
        let isLeft   = distance > 0

        bottomNavigationBar.use { bar in
            if scrollView.isDragging {
                let velocity   = scrollView.panGestureRecognizer.velocity(in: scrollView).x
                let constant   = -velocity * 0.3 / scrollView.frame.size.width
                let constraint = isLeft ? bar.selectedTrailingConstraint : bar.selectedLeadingConstraint

                constraint?.constant += constant
            } else {
                doTheJigglyThingOnTheCorrectPage(scrollView)
            }
        }

    }

    private func doTheJigglyThingOnTheCorrectPage(_ scrollView: UIScrollView) {
        bottomNavigationBar.setPage(page: Int(round(max(scrollView.contentOffset.x / scrollView.frame.size.width, 0)) + 1))
    }

}

func clearEntries() {
    sharedDataManager.fetchData(request: Entry.fetchRequest()).forEach { entry in
        print(entry)
        sharedDataManager.context.delete(entry)
    }
    sharedDataManager.saveContext()

}