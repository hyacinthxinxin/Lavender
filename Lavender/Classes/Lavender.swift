
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

// MARK:- 自定义打印方法
func logger<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName):\(lineNum):(\(funcName))==>\(message)")
}
