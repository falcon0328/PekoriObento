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
    @State var pictureViewModel: PictureViewModel
    @State var designBentobakoImage: UIImage?
    
    @State private var okazuList: [ObentoOkazu] = []
    @State private var totalCalorie: Int = 0
    
    var body: some View {
        ZStack {
            Color
                .blond
                .edgesIgnoringSafeArea(.all)
            VStack {
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
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .center, spacing: 0) {
                        Text("作成したお弁当デザイン")
                            .font(.headline)
                        if let designBentobakoImage = designBentobakoImage {
                            Image(uiImage: designBentobakoImage)
                                .resizable()
                        }
                    }

                    VStack(alignment: .center) {
                        Divider()
                        VStack(alignment: .center) {
                            Text("カロリー：\(totalCalorie) kCal")
                                .font(.title)
                        }
                        
                        Divider()
                        VStack(alignment: .center) {
                            Text("彩り：良し！")
                                .font(.title)
                            HStack(alignment: .bottom) {
                                Text("残念！緑がたりません")
                            }
                        }
                        
                        Divider()
                        
                        VStack(alignment: .center) {
                            Text("お弁当に入れる料理")
                                .font(.headline)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(alignment: .top, spacing: 0) {
                                    ForEach(okazuList) { okazu in
                                        VStack(alignment: .center) {
                                            okazu.image
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                            Text(okazu.name)
                                                .foregroundColor(.primary)
                                                .font(.caption)
                                                .padding(.leading, 5)
                                                .padding(.bottom, 5)
                                        }
                                        .padding(.leading, 15)
                                        .onTapGesture {
                                            if let recipeURL = okazu.recipeURL {
                                                UIApplication.shared.open(recipeURL)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: 100)
                        }
                        
                        
                    }
                }

            }
        }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            let selectedOkazuList = pictureViewModel.pictures.map { $0.okazu }
            okazuList = selectedOkazuList
            totalCalorie = ModelData.totalCalorie(from: selectedOkazuList)
        }
    }
}

struct ObentoBakoDesigneResultView_Previews: PreviewProvider {
    static var previews: some View {
        ObentoBakoDesigneResultView(pictureViewModel: PictureViewModel())
    }
}
