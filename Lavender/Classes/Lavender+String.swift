//
//  String+Lavender.swift
//  Lavender
//
//  Created by 范新 on 2018/5/31.
//

extension Lavender where Base == String {

    /// html wrap
    public var htmlWrapper: Base {
        return "<!DOCTYPE html><html><body>".appending(base).appending("</body></html>")
    }

    public var htmlToAttributedString: NSAttributedString? {
        guard let data = base.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }


    /// 检测字符串是否包含汉字
    ///
    /// - Returns: 是否
    public func isIncludeChinese() -> Bool {
        for ch in base.unicodeScalars {
            if (0x4e00 < ch.value && ch.value < 0x9fff) { return true }
        }
        return false
    }

    /// 将中文字符串转换为拼音
    ///
    /// - Parameter hasBlank: 是否带空格（默认不带空格）
    public func transformToPinyin(hasBlank: Bool = false) -> String {
        let stringRef = NSMutableString(string: base) as CFMutableString
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false) // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false) // 去掉音标
        let pinyin = stringRef as Base
        return hasBlank ? pinyin: pinyin.replacingOccurrences(of: " ", with: "")
    }

    /// 获取中文首字母
    ///
    /// - Parameter lowercased: 是否小写（默认大写）
    public func transformToPinyinHead(lowercased: Bool = false) -> String {
        let pinyin = self.transformToPinyin(hasBlank: true).capitalized // 字符串转换为首字母大写
        var headPinyinStr = ""
        for ch in pinyin {
            if ch <= "Z" && ch >= "A" {
                headPinyinStr.append(ch) // 获取所有大写字母
            }
        }
        return lowercased ? headPinyinStr.lowercased() : headPinyinStr
    }


}
