//
//  LavenderUtil.swift
//  Lavender
//
//  Created by 范新 on 2018/6/4.
//

import Foundation

/// LavenderUtil 简写
public typealias LVU = LavenderUtil

public struct LavenderUtil {

    /// 自定义打印方法
    ///
    /// - Parameters:
    ///   - message: 打印的信息
    ///   - file: 文件名
    ///   - funcName: 方法名
    ///   - lineNum: 行号
    public static func logging<T>(_ object: T, fileName: String = #file, lineNum: Int = #line, funcName: String = #function) {
        #if DEBUG
        print("\(Date()) \(fileName.components(separatedBy: "/").last ?? "") [line: \(lineNum)] :: \(funcName) ==> \(object)")
        #endif
    }

    /// 延迟执行
    ///
    /// - Parameters:
    ///   - seconds: 延迟时间 秒
    ///   - completion: 方法回调
    public static func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }


    /// 从链接中获取参数的值
    ///
    /// - Parameters:
    ///   - path: 链接
    ///   - param: 参数名称
    /// - Returns: 参数值
    public static func getQueryStringParameter(path: String?, param: String) -> String? {
        guard let path = path, let url = URLComponents(string: path) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }


    /// 屏幕截图
    ///
    /// - Parameters:
    ///   - view: 当前的视图
    ///   - isWriteToSavedPhotosAlbum: 是否保存到系统相册
    /// - Returns: 截取的图片
    public static func screenCapture(_ view: UIView? = nil, _ isWriteToSavedPhotosAlbum: Bool = false) -> UIImage? {
        let captureView = (view ?? (UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first))!
        UIGraphicsBeginImageContextWithOptions(captureView.frame.size, false, 0.0)
        captureView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if isWriteToSavedPhotosAlbum { UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil) }
        return image
    }


    /// 系统设置和键盘是否为简体中文
    ///
    /// - Returns: 结果
    public static func isSystemChineseHans() -> Bool {
        //zh-Hans-CN
        return Locale.preferredLanguages.first(where: { $0.contains("zh-Hans")}) != nil
    }

}
