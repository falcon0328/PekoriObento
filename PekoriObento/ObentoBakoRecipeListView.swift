//
//  ObentoBakoRecipeListView.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/21.
//

import SwiftUI

struct ObentoBakoRecipeListView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ZStack {
            Color
                .blond
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    Spacer()
                    HStack(alignment: .top) {
                        CornerRadiusButton(text: "◀︎ 戻る",
                                           width: 100,
                                           height: 32,
                                           corrnerRadius: 24,
                                           backgroundColor: .red) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ObentoBakoRecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        ObentoBakoRecipeListView()
    }
}
