protocol XXX {
    func test()
    func porno()
}

class Me {
    var delegate: XXX?

    init() {
        if self is XXX {
            print("Setting delegate to self...")
            delegate = self as? XXX
            delegate?.porno()
            delegate?.test()
        }
    }
}

class HuHu: Me, XXX {

    func porno() {
        print("THIS IS PORTN")
    }

}

extension HuHu {
    func test() { print("THIS IS TEST") }

}

