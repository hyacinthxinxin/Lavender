//
//  LavenderBundle.swift
//  Lavender
//
//  Created by 范新 on 2018/5/31.
//


class LavenderBundle {

    public static var frameworkBundle: Bundle {
        return Bundle(for: LavenderBundle.self)
    }

    public static var resourceBundle: Bundle? {
        return Bundle(path: frameworkBundle.bundlePath+"/com.xiaoxiangyeyu.haycinth.Lavender.bundle")
    }

}
