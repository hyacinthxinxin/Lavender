//
//  LavenderLocaleStore.swift
//  Lavender
//
//  Created by 范新 on 2018/6/5.
//

import Foundation

public struct LavenderLocaleStore {

    public enum GroupedByAlphabetsFetchResults {
        case success(infos: [LavenderLocaleInfo], groupedInfos: [String: [LavenderLocaleInfo]])
        case error(error: (title: String?, message: String?))
    }

    public enum FetchResults {
        case success(response: [LavenderLocaleInfo])
        case error(error: (title: String?, message: String?))
    }

    public static func getInfo(completion: @escaping (FetchResults) -> ()) {
        let bundle = Bundle(for: LavenderLocalePickerViewController.self)
        let path = "Countries.bundle/Data/CountryCodes"
        guard let jsonPath = bundle.path(forResource: path, ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return completion(FetchResults.error(error: (title: "ContryCodes Error", message: "No ContryCodes Bundle Access")))
        }
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments)) as? Array<Any> {
            var result: [LavenderLocaleInfo] = []
            for jsonObject in jsonObjects {
                guard let countryObj = jsonObject as? Dictionary<String, Any> else { continue }
                guard let isni = countryObj["ISNI"] as? String,
                    let chinaName = countryObj["ChinaName"] as? String,
                    let qtq = countryObj["QTQ"] as? String,
                    let internaCode = countryObj["InternaCode"] as? String,
                    let regent = countryObj["REGENT"] as? String else {
                        continue
                }
                result.append(LavenderLocaleInfo(isni: isni, chinaName: chinaName, qtq: qtq, internaCode: internaCode, regent: regent))
            }
            return completion(FetchResults.success(response: result))
        }
        return completion(FetchResults.error(error: (title: "JSON Error", message: "Couldn't parse json to Info")))
    }

    public static func fetch(completion: @escaping (GroupedByAlphabetsFetchResults) -> ()) {
        getInfo { (result) in
            switch result {
            case let .success(infos):
                var groupedInfos = [String: [LavenderLocaleInfo]]()
                infos.forEach {
                    if LVU.isSystemChineseHans() {
                        let chinaNameToPinyin = $0.chinaNamePinyin
                        let index = String(chinaNameToPinyin[chinaNameToPinyin.startIndex])
                        var value = groupedInfos[index] ?? [LavenderLocaleInfo]()
                        value.append($0)
                        groupedInfos[index] = value
                    } else {
                        let isni = $0.isni
                        let index = String(isni[isni.startIndex])
                        var value = groupedInfos[index] ?? [LavenderLocaleInfo]()
                        value.append($0)
                        groupedInfos[index] = value
                    }
                }
                groupedInfos.forEach { (arg) in
                    let (key, value) = arg
                    if LVU.isSystemChineseHans() {
                        groupedInfos[key] = value.sorted(by: { (lhs, rhs) -> Bool in
                            return lhs.chinaNamePinyin < rhs.chinaNamePinyin
                        })
                    } else {
                        groupedInfos[key] = value.sorted(by: { (lhs, rhs) -> Bool in
                            return lhs.isni < rhs.isni
                        })
                    }
                }
                completion(GroupedByAlphabetsFetchResults.success(infos: infos, groupedInfos: groupedInfos))
            case let .error(error):
                completion(GroupedByAlphabetsFetchResults.error(error: error))
            }
        }
    }

}
