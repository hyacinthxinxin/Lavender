//
//  Lavender+FileManager.swift
//  Lavender
//
//  Created by 范新 on 2018/6/27.
//

import Foundation

public extension Lavender where Base: FileManager {


    /// 获取文件大小
    ///
    /// - Parameter path: 路径
    /// - Returns: 文件大小
    func fileSize(atPath path: String) -> Int64 {
        do {
            let fileAttributes = try base.attributesOfItem(atPath: path)
            let fileSizeNumber = fileAttributes[FileAttributeKey.size] as? NSNumber
            let fileSize = fileSizeNumber?.int64Value
            return fileSize!
        } catch {
            return 0
        }
    }


    /// 获取文件夹大小
    ///
    /// - Parameter path: 路径
    /// - Returns: 文件夹大小
    func folderSize(atPath path: String) -> Int64 {
        var size : Int64 = 0
        do {
            let files = try base.subpathsOfDirectory(atPath: path)
            for i in 0 ..< files.count {
                size += fileSize(atPath: path.appending("/"+files[i]))
            }
        } catch {
        }
        return size
    }


    /// 文件大小转换为字符
    ///
    /// - Parameter size: 文件大小
    /// - Returns: 字符描述
    func format(size: Int64) -> String {
        let folderSizeStr = ByteCountFormatter.string(fromByteCount: size, countStyle: ByteCountFormatter.CountStyle.file)
        return folderSizeStr
    }

    

}
