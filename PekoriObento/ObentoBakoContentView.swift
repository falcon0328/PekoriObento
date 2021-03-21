//
//  ObentoBakoContentView.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/21.
//

import SwiftUI

struct ObentoBakoContentView: View {
    @EnvironmentObject var modelData: ModelData

    var body: some View {
        NavigationView {
            ZStack {
                Color
                    .blond
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    Text("ペコリのお弁当")
                        .font(.largeTitle)
                    Text("HackID: 68 ポテトサラダ")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Image("playstore")
                        .resizable()
                        .frame(width: 256, height: 256)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        let destination = ObentoBakoDesignerContentView(obentoBako: modelData.obentoBakoList[0])
                        NavigationLink(destination: destination) {
                            Text("作る")
                                .fontWeight(.semibold)
                                .frame(width: 120, height: 60)
                                .foregroundColor(Color(.white))
                                .background(Color.crayolasBrightYellow)
                                .cornerRadius(24)
                        }

                        let recipeDestination = ObentoBakoRecipeListView()
                        NavigationLink(destination: recipeDestination) {
                            Text("レシピ")
                                .fontWeight(.semibold)
                                .frame(width: 120, height: 60)
                                .foregroundColor(Color(.white))
                                .background(Color.green)
                                .cornerRadius(24)
                        }
                        Spacer()

                    }
                }
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct ObentoBakoContentView_Previews: PreviewProvider {
    static var previews: some View {
        ObentoBakoContentView()
    }
}
