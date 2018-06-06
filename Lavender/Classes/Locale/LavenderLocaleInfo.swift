//
//  LavenderLocaleInfo.swift
//  Lavender
//
//  Created by 范新 on 2018/6/5.
//

import Foundation

public struct LavenderLocaleInfo {

    var isni: String
    var chinaName: String
    var chinaNamePinyin: String
    var qtq: String
    var internaCode: String
    var regent: String

    init(isni: String, chinaName: String, qtq: String, internaCode: String, regent: String) {
        self.isni = isni
        self.chinaName = chinaName
        self.chinaNamePinyin = self.chinaName.lv.transformToPinyin().capitalized
        self.qtq = qtq
        self.internaCode = internaCode
        self.regent = regent
    }

}
