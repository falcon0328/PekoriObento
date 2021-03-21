//
//  ModelData.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/20.
//

import Foundation
import SwiftUI

struct ObentoBako: Hashable, Codable, Identifiable {
    let id: String
    let name: String
    let category: String
    let colorName: String
    let dan: Int
    private let imageName: String
    
    var image: Image {
        Image(imageName)
    }
}

struct ObentoOkazu: Hashable, Codable, Identifiable {
    let id: String
    let name: String
    let category: String
    let imageName: String
    
    private let calorie: String
    var calorieValue: Int {
        guard let value = Int(calorie) else {
            return -1
        }
        return value
    }
    let calSource: String
    
    let recipe: String
    var recipeURL: URL? {
        guard !recipe.isEmpty, let url = URL(string: recipe) else {
            return nil
        }
        return url
    }
    
    let irodori: Int
    
    var image: Image {
        Image(imageName)
    }
}

enum IrodoriStatus: CaseIterable {
    case best // 10以上
    case good // 5以上
    case bad // それ以下
    
    init(irodori: Int) {
        if irodori >= 10 {
            self = .best
        } else if irodori >= 5 {
            self = .good
        } else {
            self = .bad
        }
    }
}


/// [参考文献](https://xn--mnq74t3x1andp4uh.biz/entry16.html)
enum CalorieStatus: CaseIterable {
    case OK // 700kcal 以下
    case NG // それ以上
    
    init(calorie: Int) {
        if calorie <= 700 {
            self = .OK
        } else {
            self = .NG
        }
    }
}

final class ModelData: ObservableObject {
    @Published var obentoBakoList: [ObentoBako] = load("obentoBakoData.json")
    @Published var okazuList: [ObentoOkazu] = load("obentoOkazuData.json")
    
    static func totalCalorie(from okazuList: [ObentoOkazu]) -> Int {
        var sum = 0
        for okazu in okazuList {
            if okazu.calorieValue == -1 {
                // カロリーが正式にデータとして登録されているもの
                // のみを対象として計算する
                continue
            }
            sum += okazu.calorieValue
        }
        return sum
    }
    
    static func irodoriJudge(from okazuList: [ObentoOkazu]) -> IrodoriStatus {
        var irodoriSum = 0
        for okazu in okazuList {
            irodoriSum += okazu.irodori
        }
        return IrodoriStatus(irodori: irodoriSum)
    }
    
    static func calorieJudge(from okazuList: [ObentoOkazu]) -> CalorieStatus {
        var calorieSum = 0
        for okazu in okazuList {
            if okazu.calorieValue == -1 {
                // カロリーが正式にデータとして登録されているもの
                // のみを対象として計算する
                continue
            }
            calorieSum += okazu.calorieValue
        }
        return CalorieStatus(calorie: calorieSum)
    }
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
