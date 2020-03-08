//
// Created by Mihael Bercic on 01/01/2020.
// Copyright (c) 2020 Regnum d.o.o. All rights reserved.
//

import Foundation
import UIKit

class NavigationBar: UIView {

    convenience init(_ backgroundColor: UIColor) {
        self.init()
        selectedIndicator.backgroundColor = backgroundColor
    }

    private var currentPage = 1
    private var maxPages    = 1

    private var icons      = [(UIImage, UIImage)]()
    private var imageViews = [UIImageView]()

    let iconSize:  CGFloat      = 30
    let spacing:   CGFloat      = 0
    let insetSize: Int          = -5
    let insets:    UIEdgeInsets = UIEdgeInsets(top: -6, left: -6, bottom: -6, right: -6)

    var selectedLeadingConstraint:  NSLayoutConstraint?
    var selectedTrailingConstraint: NSLayoutConstraint?

    private lazy var imageStackView = UIStackView().apply { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = spacing
        view.alignment = .center
        view.distribution = .fillEqually
    }

    private let selectedIndicator = UIView().apply { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 0
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        addSubview(selectedIndicator)
        addSubview(imageStackView)


        heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        backgroundColor = .darkText
        clipsToBounds = true
        layer.cornerRadius = 3

        imageStackView.connect {
            $0.topAnchor = topAnchor
            $0.bottomAnchor = bottomAnchor
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = rightAnchor
            $0.centerXAnchor = centerXAnchor
            $0.centerYAnchor = centerYAnchor
        }

        selectedIndicator.use { view in
            view.connect {
                $0.topAnchor = imageStackView.topAnchor
                $0.bottomAnchor = imageStackView.bottomAnchor
                $0.centerYAnchor = imageStackView.centerYAnchor
            }

            selectedLeadingConstraint = view.leadingAnchor.constraint(equalTo: imageStackView.leadingAnchor)
            selectedTrailingConstraint = view.trailingAnchor.constraint(equalTo: imageStackView.trailingAnchor)

            selectedLeadingConstraint?.isActive = true
            selectedTrailingConstraint?.isActive = true
        }

        widthAnchor.constraint(equalToConstant: CGFloat(maxPages) * (iconSize + spacing)).isActive = true

    }

    func scrollHorizontal(left: Bool = false) {
        if 1...maxPages ~= currentPage { setPage(page: currentPage + (left ? -1 : 1)) }
    }

    func initializeView(images: [(String, String)], initialPage: Int = 1, scrollView: UIScrollView) {
        maxPages = images.count
        for image in images {
            let initial  = (UIImage(named: image.0) ?? UIImage(systemName: "arrow.merge"))?.withAlignmentRectInsets(insets)
            let selected = (UIImage(named: image.1) ?? UIImage(systemName: "arrow.merge"))?.withAlignmentRectInsets(insets)

            icons.append((initial!, selected!))


            UIImageView(image: initial).use { view in
                imageStackView.addArrangedSubview(view)
                imageViews.append(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.connect {
                    $0.topAnchor = imageStackView.topAnchor
                    $0.bottomAnchor = imageStackView.bottomAnchor
                }
            }
        }
        setup()
        setPage(page: initialPage)
    }

    func setPage(page: Int) {

        currentPage = page
        let width = iconSize + spacing

        let currentPageNumber = CGFloat(currentPage - 1)
        let pageDifference    = CGFloat(maxPages - currentPage)

        let leftConstant:  CGFloat = currentPageNumber * (width)
        let rightConstant: CGFloat = pageDifference * (width)

        selectedLeadingConstraint?.constant = leftConstant
        selectedTrailingConstraint?.constant = -rightConstant

        let index     = currentPage - 1
        let imageView = imageStackView.subviews[index] as! UIImageView

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, animations: {
            self.layoutIfNeeded()
            for index in 0...self.imageViews.count - 1 { self.imageViews[index].image = self.icons[index].0 }
            imageView.image = self.icons[index].1
        })

    }

}



