//
//  PekoriObentoApp.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/19.
//

import SwiftUI

@main
struct PekoriObentoApp: App {
    var body: some Scene {
        WindowGroup {
            let modelData = ModelData()
            DraggableContentView(obentoBako: modelData.obentoBakoList[0])
                .environmentObject(ModelData())
        }
    }
}
