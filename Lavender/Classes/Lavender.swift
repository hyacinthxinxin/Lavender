
public final class Lavender<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol LavenderCompatible {
    associatedtype CompatibleType
    var lv: CompatibleType { get }
}

public extension LavenderCompatible {
    public var lv: Lavender<Self> {
        return Lavender(self)
    }
}

extension UIView: LavenderCompatible { }
extension String: LavenderCompatible { }


