//
//  String+Lavender.swift
//  Lavender
//
//  Created by 范新 on 2018/5/31.
//

extension Lavender where Base == String {

    public func addLavenderPrefix() -> Base {
        return "hello, this is lavender" + base
    }

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
    
}
