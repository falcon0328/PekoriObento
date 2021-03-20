//
//  CornerRadiusButton.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/20.
//

import SwiftUI

struct CornerRadiusButton: View {
    let text: String
    let width: CGFloat
    let height: CGFloat
    let corrnerRadius: CGFloat
    let backgroundColor: Color
    var action: ()->Void = {}
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .fontWeight(.semibold)
                .frame(width: width, height: height)
                .foregroundColor(Color(.white))
                .background(backgroundColor)
                .cornerRadius(corrnerRadius)
        }

    }
}

struct CornerRadius_Previews: PreviewProvider {
    static var previews: some View {
        CornerRadiusButton(text: "Hello, Falcon",
                           width: 160,
                           height: 48,
                           corrnerRadius: 24,
                           backgroundColor: .blue) {}
    }
}
