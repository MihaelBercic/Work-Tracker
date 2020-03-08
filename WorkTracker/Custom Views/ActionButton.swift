//
// Created by Mihael Bercic on 28/02/2020.
// Copyright (c) 2020 Mihael Bercic. All rights reserved.
//

import UIKit

class ActionButton: UIButton {

    @objc private var action: () -> () = {}

    @objc private func x() { action() }

    func onTap(_ block: @escaping () -> ()) { action = block }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addTarget(self, action: #selector(x), for: .touchUpInside)
        setTitleColor(.link, for: .normal)
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

}
