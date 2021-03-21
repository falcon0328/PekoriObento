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
                                           backgroundColor: .green) {
                            ModelData.save(obentoResult: ObentoResult(designBentobakoImage: designBentobakoImage,
                                                                      okazuList: okazuList))
                        }
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

                    Divider()
                    VStack(alignment: .center) {
                        VStack(alignment: .center) {
                            Text("カロリー：\(totalCalorie) kCal")
                                .font(.title)
                            switch ModelData.calorieJudge(from: okazuList) {
                            case .OK:
                                Text("適正カロリーです")
                                    .foregroundColor(Color.green)
                            case .NG:
                                Text("カロリーオーバーです")
                                    .foregroundColor(Color.blue)
                            }
                        }
                        
                        Divider()
                        VStack(alignment: .center) {
                            HStack(alignment: .bottom) {
                                switch ModelData.irodoriJudge(from: okazuList) {
                                case .best:
                                    VStack(alignment: .center) {
                                        Text("彩り：最高！！")
                                            .foregroundColor(Color.green)
                                        Text("超彩鮮やか！作るのも食べるのも楽しみですね！")
                                    }
                                case .good:
                                    VStack(alignment: .center) {
                                        Text("彩り：良し！")
                                            .font(.title)
                                            .foregroundColor(Color.gargoyleGas)
                                        Text("彩りに配慮されていますね。良き良きの良きです。")
                                    }
                                case .bad:
                                    VStack(alignment: .center) {
                                        Text("彩り：残念")
                                            .font(.title)
                                            .foregroundColor(Color.blue)
                                        Text("彩りに配慮しましょう。茶色い弁当が許されるのは中学生までです。")
                                    }

                                }
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
