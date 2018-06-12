
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
extension UIImage: LavenderCompatible { }
extension UIViewController: LavenderCompatible { }


/// 内部资源文件获取
class LavenderBundle {

    static var frameworkBundle: Bundle {
        return Bundle(for: LavenderBundle.self)
    }

    static var resourceBundle: Bundle? {
        return Bundle(path: frameworkBundle.bundlePath+"/com.xiaoxiangyeyu.haycinth.Lavender.bundle")
    }

}
