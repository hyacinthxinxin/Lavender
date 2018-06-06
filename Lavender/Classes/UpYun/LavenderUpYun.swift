//
//  LavenderUpYun.swift
//  Lavender
//
//  Created by 范新 on 2018/6/5.
//

import Foundation

public struct LavenderUpYun {

    init(bucketName: String, operatorName: String, password: String) {

    }

    fileprivate static let upYunFormUploader = UpYunFormUploader()

    fileprivate static let bucketName = "fanxin-lavender"
    fileprivate static let operatorName = "fanxin"
    fileprivate static let password = "aini1234"

    public static func upload(imageData: Data, successBlock: UpLoaderSuccessBlock? = nil, failureBlock: UpLoaderFailureBlock? = nil) {
        upYunFormUploader.upload(withBucketName: bucketName, operator: operatorName, password: password, fileData: imageData, fileName: nil, saveKey: "xxxx", otherParameters: nil, success: successBlock, failure: failureBlock, progress: nil)
    }

    public static func upload(_ fileData: Data, fileName: String? = nil, saveKey: String, otherParameters: [AnyHashable: Any]? = nil, successBlock: UpLoaderSuccessBlock? = nil, failureBlock: UpLoaderFailureBlock? = nil, progressBlock: UpLoaderProgressBlock? = nil) {
        upYunFormUploader.upload(withBucketName: bucketName, operator: operatorName, password: password, fileData: fileData, fileName: fileName, saveKey: "authentication/"+saveKey, otherParameters: otherParameters, success: { (response, responseBody) in
            if let success = successBlock {
                success(response, responseBody)
            }
        }, failure: { (error, response, responseBody) in
            if let failure = failureBlock {
                failure(error, response, responseBody)
            }
        }) { (completedBytesCount, totalBytesCount) in
            if let progress = progressBlock {
                progress(completedBytesCount, totalBytesCount)
            }
        }
    }


}
