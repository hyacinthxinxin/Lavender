//
//  UIView+Lavender.swift
//  Lavender
//
//  Created by 范新 on 2018/5/31.
//

extension Lavender where Base: UIView {

    public func applyThemeBackgroundColor() {
        base.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1)
    }


    /// 从xib加载控件
    public func setupRootViewFromNib() {
        let nib = UINib(nibName: String(describing: type(of: base)), bundle: Bundle(for: type(of: base)))
        guard let rootView = nib.instantiate(withOwner: base, options: nil)[0] as? UIView else {
            fatalError("出错了，必须有一个同名的xib文件，并且File's Owner为自己")
        }
        rootView.frame = base.bounds
        rootView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        base.addSubview(rootView)
    }

}
