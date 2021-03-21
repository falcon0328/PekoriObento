//
//  DraggableContentView.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/19.
//

import SwiftUI

struct ObentoBakoDesignerContentView: View {
    @EnvironmentObject var modelData: ModelData
    var obentoBako: ObentoBako
    
    @State private var selectedDan: Int = 0
    @State private var selectedOkazu: ObentoOkazu? = nil
    @State private var designBentobakoRect: CGRect = .zero
    @State var designBentobakoImage: UIImage? = nil
    @ObservedObject private var pictureViewModel: PictureViewModel = PictureViewModel()
    
    @State var isEditStart = false

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
                        CornerRadiusButton(text: "キャンセル",
                                           width: 100,
                                           height: 32,
                                           corrnerRadius: 24,
                                           backgroundColor: .red) {}
                        Spacer()

                    }
                    Spacer()
                    HStack(alignment: .bottom) {
                        VStack {
                            if isEditStart {
                                NavigationLink(destination: ObentoBakoDesigneResultView(pictureViewModel: pictureViewModel, designBentobakoImage: designBentobakoImage)) {
                                    // ここで直接をTextを定義した場合のみ想定どおりの挙動を行う
                                    Text("次へ ▶︎ ")
                                        .fontWeight(.semibold)
                                        .frame(width: 80, height: 32)
                                        .foregroundColor(Color(.white))
                                        .background(Color.green)
                                        .cornerRadius(24)
                                }.simultaneousGesture(TapGesture().onEnded {
                                    // 弁当箱のデザイン結果を画像として保存
                                    // その後別画面に遷移する
                                    designBentobakoImage = UIApplication.shared.windows[0].rootViewController?.view!.getImage(rect: self.designBentobakoRect)
                                })
                            }

                        }

                    }
                    Spacer()
                }
                Divider()
                ObentobakoImageView(obentoBako: obentoBako,
                                    pictureViewModel: pictureViewModel,
                                    selectedDan: $selectedDan,
                                    selectedOkazu: $selectedOkazu,
                                    bentobakoRect: $designBentobakoRect, isEditStart: $isEditStart)
                ObentoOkazuList(selectedOkazu: $selectedOkazu)
                Spacer()
            }
         }
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct DraggableContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        Group {
            ObentoBakoDesignerContentView(obentoBako: modelData.obentoBakoList[0])
                .previewDevice("iPhone SE (2nd generation)")
                .environmentObject(modelData)
            ObentoBakoDesignerContentView(obentoBako: modelData.obentoBakoList[0])
                .environmentObject(modelData)
        }
    }
}

struct ObentobakoImageView: View {
    let widthAspectRatio: CGFloat = 16.0
    let heightAspectRatio: CGFloat = 9.0
    
    let expectedImageRatioWhenHeight: CGFloat = 0.65
    
    let obentoBako: ObentoBako
    
    @ObservedObject var pictureViewModel: PictureViewModel
    @Binding var selectedDan: Int
    @Binding var selectedOkazu: ObentoOkazu?
    @Binding var bentobakoRect: CGRect
    
    @Binding var isEditStart: Bool
    
    var body: some View {
        GeometryReader { device in
            VStack {
                Spacer()
                Text("\(obentoBako.name)（\(isEditStart ? "編集中" : "未編集")）")
                    .font(.headline)
                    .padding(.bottom, 8)
//                Menu {
//                    ForEach(0..<obentoBako.dan) { index in
//                        Button("▼ \(selectedDan + 1) 段目", action: {})
//                    }
//                } label: {
//                    CornerRadiusButton(text: "▼ \(selectedDan + 1) 段目",
//                                       width: 160,
//                                       height: 32,
//                                       corrnerRadius: 24,
//                                       backgroundColor: .blue)
//                }
                CornerRadiusButton(text: "入力を全て消す",
                                   width: 160,
                                   height: 32,
                                   corrnerRadius: 24,
                                   backgroundColor: Color.yellow) {
                    isEditStart = false
                    selectedOkazu = nil
                    pictureViewModel.removeAllPictures()
                }
                ZStack {
                    // 2021年3月現在
                    // 1:1 サイズの液晶を持つiPhoneが存在しない
                    if device.size.width < device.size.height {
                        // そのため
                        // 既存のiPhone端末の縦表示はこちらが該当する
                        portraitBody(device)
                            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded { dragGesture in
                                guard let selectedOkazu = selectedOkazu else {
                                    return
                                }
                                isEditStart = true
                                self.pictureViewModel
                                    .addPicture(from: selectedOkazu,
                                                at: CGSize(width: 50, height: 50),
                                                size: CGSize(width: 100, height: 100))
                            })
                    } else {
                        // 逆に横表示はこちらが該当する
                        landScapeBody(device)
                    }
                    ForEach(self.pictureViewModel.pictures) { picture in
                        Image(uiImage: picture.picture)
                            .resizable()
                            .scaledToFit()
                            .frame(width: picture.width, height: picture.height)
                            .gesture(dragPicture(picture: picture))
                            .position(x: picture.x, y: picture.y)
                            .onTapGesture(count: 2) {
                                pictureViewModel.removePicture(picture)
                                if pictureViewModel.pictures.isEmpty {
                                    isEditStart = false
                                }
                            }
                    }
                }.background(RectangleGetter(rect: $bentobakoRect))
            }
        }

    }
    
    func portraitBody(_ device: GeometryProxy) -> some View {
        let size = device.size.width
        return obentoBako.image
            .resizable()
            .scaledToFit()
            .frame(width: size,
                   height: size)
    }
    
    func landScapeBody(_ device: GeometryProxy) -> some View {
        let expectedSize = device.size.height
        
        if expectedSize > device.size.height {
            // 想定しているお弁当箱画像の高さより、画面の高さが短い場合
            let newSize = device.size.height * expectedImageRatioWhenHeight
            return obentoBako.image
                .resizable()
                .scaledToFit()
                .frame(width: newSize,
                       height: newSize)
        } else {
            // 想定している高さ
            
            return obentoBako.image
                .resizable()
                .scaledToFit()
                .frame(width: expectedSize,
                       height: expectedSize)
        }
    }
    
    func dragPicture(picture: Pictures.Picture) -> some Gesture {
        DragGesture()
            .onChanged{ value in
                self.pictureViewModel.movePicture(picture, by: CGSize(
                    width: value.translation.width,
                    height: value.translation.height
                ))
            }
            .onEnded{ value in
                self.pictureViewModel.movePicture(picture, by: CGSize(
                    width: value.translation.width,
                    height: value.translation.height
                ))
            }
    }
}

struct ObentoOkazuList: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var selectedOkazu: ObentoOkazu?
    
    var body: some View {
        VStack(alignment: .center) {
            Text("お弁当：料理")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(modelData.okazuList) { okazu in
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
                        .border(Color.moonstone, width: selectedOkazu == okazu ? 2 : 0)
                        .padding(.leading, 15)
                        .onTapGesture {
                            selectedOkazu = okazu
                        }
                    }
                }
            }
            .frame(height: 100)
        }
    }
}
