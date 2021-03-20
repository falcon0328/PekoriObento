//
//  DropdownList.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/20.
//

import SwiftUI

struct DropdownList<Content: CustomStringConvertible & Hashable>: View {
    let list: [Content]
    @Binding var selected: Content
    
    var body: some View {
        Menu {
            ForEach(list, id: \.self) { content in
                Button {
                    selected = content
                } label: {
                    Text(content.description)
                }
            }
        }
        label: {
            HStack {
                Text("▼")
                Text(selected.description).lineLimit(1)
            }
        }
    }
}
