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
    private let imageName: String
    
    var image: Image {
        Image(imageName)
    }
}

final class ModelData: ObservableObject {
    @Published var obentoBakoList: [ObentoBako] = load("obentoBakoData.json")
    @Published var okazuList: [ObentoOkazu] = load("obentoOkazuData.json")
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
