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
    
    var body: some View {
        NavigationView {
            ZStack {
                Color
                    .blond
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    Divider()
                    HStack {
                        Spacer()
                        HStack(alignment: .top) {
                            CornerRadiusButton(text: "キャンセル",
                                               width: 100,
                                               height: 32,
                                               corrnerRadius: 24,
                                               backgroundColor: .red)
                            Spacer()

                        }
                        Spacer()
                        HStack(alignment: .bottom) {
                            CornerRadiusButton(text: "終了",
                                               width: 80,
                                               height: 32,
                                               corrnerRadius: 24,
                                               backgroundColor: .green)
                        }
                        Spacer()
                    }
                    Divider()
                    Menu {
                        ForEach(0..<obentoBako.dan) { index in
                            Button("▼ \(selectedDan + 1) 段目", action: {})
                        }
                    } label: {
                        CornerRadiusButton(text: "▼ \(selectedDan + 1) 段目",
                                           width: 160,
                                           height: 32,
                                           corrnerRadius: 24,
                                           backgroundColor: .blue)
                    }
                    ObentobakoImageView(obentoBako: obentoBako)
                    ObentoOkazuList()
                }
             }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct DraggableContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        ObentoBakoDesignerContentView(obentoBako: modelData.obentoBakoList[0])
            .environmentObject(modelData)
    }
}

struct ObentobakoImageView: View {
    let widthAspectRatio: CGFloat = 16.0
    let heightAspectRatio: CGFloat = 9.0
    
    let expectedImageRatioWhenHeight: CGFloat = 0.65
    
    let obentoBako: ObentoBako
    
    var body: some View {
        GeometryReader { device in
            VStack(alignment: .leading) {
                Spacer()
                Text("お弁当：料理")
                    .font(.headline)
                    .padding(.leading, 15)
                    .padding(.top, 5)
                // 2021年3月現在
                // 1:1 サイズの液晶を持つiPhoneが存在しない
                if device.size.width < device.size.height {
                    // そのため
                    // 既存のiPhone端末の縦表示はこちらが該当する
                    portraitBody(device)
                } else {
                    // 逆に横表示はこちらが該当する
                    landScapeBody(device)
                }
            }
        }

    }
    
    func portraitBody(_ device: GeometryProxy) -> some View {
        let size = device.size.width
        return obentoBako.image
            .resizable()
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
                .frame(width: newSize,
                       height: newSize)
        } else {
            // 想定している高さ
            
            return obentoBako.image
                .resizable()
                .frame(width: expectedSize,
                       height: expectedSize)
        }
    }
}

struct ObentoOkazuImage: View {
    @State var location: CGPoint = CGPoint(x: 0, y: 0)
    @GestureState var startLocation: CGPoint? = nil
    
    let imageName: String
    
    var body: some View {
        
        // Here is create DragGesture and handel jump when you again start the dragging/
        let dragGesture = DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.x += value.translation.width
                newLocation.y += value.translation.height
                self.location = newLocation
            }.updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
        
        return Image(imageName)
            .resizable()
            .frame(width: 100, height: 100)
            .position(location)
            .gesture(dragGesture)
    }
}

struct ObentoOkazuList: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack(alignment: .leading) {
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
                                .frame(width: 100, height: 100)
                            Text(okazu.name)
                                .foregroundColor(.primary)
                                .font(.caption)
                        }
                        .padding(.leading, 15)
                    }
                }
            }
            .frame(height: 120)
        }
    }
}
