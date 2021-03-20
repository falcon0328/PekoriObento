//
//  DraggableContentView.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/19.
//

import SwiftUI

struct DraggableContentView: View {
    @EnvironmentObject var modelData: ModelData
    var obentoBako: ObentoBako
    
    @State private var selectedDan: Int = 0
    
    var body: some View {
        VStack {
            Menu {
                ForEach(0..<obentoBako.dan) { index in
                    Button("▼ \(selectedDan + 1) 段目", action: {})
                }
            } label: {
                CornerRadiusButton(text: "▼ \(selectedDan + 1) 段目",
                                   width: 160,
                                   height: 48,
                                   corrnerRadius: 24,
                                   backgroundColor: .blue)
            }
            ObentobakoImageView()
            ObentoOkazuList()
        }
    }
}

struct DraggableContentView_Previews: PreviewProvider {
    static var previews: some View {
        let modelData = ModelData()
        DraggableContentView(obentoBako: modelData.obentoBakoList[0])
            .environmentObject(modelData)
    }
}

struct ObentobakoImageView: View {
    let widthAspectRatio: CGFloat = 16.0
    let heightAspectRatio: CGFloat = 9.0
    
    let expectedImageRatioWhenHeight: CGFloat = 0.65
    
    let imageName: String
    
    init(imageName: String = "obentou_kara") {
        self.imageName = imageName
    }
    
    var body: some View {
        GeometryReader { device in
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
    
    func portraitBody(_ device: GeometryProxy) -> some View {
        let width = device.size.width
        let height = device.size.width * heightAspectRatio / widthAspectRatio
        return Image(imageName)
            .resizable()
            .offset(x: 0.0,
                    y: (device.size.height / 2.0) - height / 2.0)
            .frame(width: width,
                   height: width)
    }
    
    func landScapeBody(_ device: GeometryProxy) -> some View {
        let expectedWidth = device.size.width * expectedImageRatioWhenHeight
        let expectedHeight = expectedWidth * heightAspectRatio / widthAspectRatio
        
        if expectedHeight > device.size.height {
            // 想定しているお弁当箱画像の高さより、画面の高さが短い場合
            // 高さを基準にお弁当箱のサイズを決める
            
            let height = device.size.height * expectedImageRatioWhenHeight
            let width = height * heightAspectRatio / widthAspectRatio
            
            return Image(imageName)
                .resizable()
                .offset(x: device.size.width / 2.0 - width / 2.0,
                        y: (device.size.height / 2.0) - height / 2.0)
                .frame(width: width,
                       height: height)
        } else {
            // 想定している高さ
            
            return Image(imageName)
                .resizable()
                .offset(x: device.size.width / 2.0 - expectedWidth / 2.0,
                        y: (device.size.height / 2.0) - expectedHeight / 2.0)
                .frame(width: expectedWidth,
                       height: expectedHeight)
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
