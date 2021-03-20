//
//  ObentoBakoDesigneResultView.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/21.
//

import SwiftUI
import UIKit

struct ObentoBakoDesigneResultView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var designBentobakoImage: UIImage?
    
    var body: some View {
        ZStack {
            Color
                .blond
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    HStack(alignment: .top) {
                        CornerRadiusButton(text: "戻る",
                                           width: 100,
                                           height: 32,
                                           corrnerRadius: 24,
                                           backgroundColor: .red) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()

                    }
                    Spacer()
                    HStack(alignment: .bottom) {
                        CornerRadiusButton(text: "完了",
                                           width: 100,
                                           height: 32,
                                           corrnerRadius: 24,
                                           backgroundColor: .green) {}
                    }
                    Spacer()
                }
                Divider()
                if let designBentobakoImage = designBentobakoImage {
                    Image(uiImage: designBentobakoImage)
                        .resizable()
                }
            }

        }

    }
}

struct ObentoBakoDesigneResultView_Previews: PreviewProvider {
    static var previews: some View {
        ObentoBakoDesigneResultView()
    }
}
