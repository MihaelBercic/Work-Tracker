//
// Created by Mihael Bercic on 26/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class ClientCircularView: UIView {

    private let label = UILabel().apply {
        $0.textAlignment = .center
        $0.textColor = .white
    }

}

// Custom
extension ClientCircularView {
    func setup(_ client: Client, clientSize: CGFloat) {
        layer.cornerRadius = clientSize / 2
        backgroundColor = UIColor(hex: client.color)
        label.text = getInitials(client.name)
        addSubview(label)
        setConstraints(clientSize)
    }

    private func getInitials(_ string: String) -> String { String(string.filter { char in char.isUppercase }.prefix(2)) }

    private func setConstraints(_ clientSize: CGFloat) {
        label.connect {
            $0.topAnchor = topAnchor
            $0.leftAnchor = leftAnchor
            $0.rightAnchor = rightAnchor
            $0.bottomAnchor = bottomAnchor
        }

        connect {
            $0.widthConstant = clientSize
            $0.heightConstant = clientSize
        }
    }
}
