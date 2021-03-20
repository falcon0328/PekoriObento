//
//  Pictures.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/20.
//

// [参考文献](https://byceclorets.com/swift/mvvn-gesture/)

import Foundation
import UIKit

struct Pictures {
    
    var pictures = [Picture]()
    
    struct Picture: Identifiable, Hashable {
        let id: Int
        var x: CGFloat
        var y: CGFloat
        var picture: UIImage
        var width: CGFloat
        var height: CGFloat
        
        fileprivate init(picture: UIImage, x: CGFloat, y: CGFloat, id: Int, size: CGSize) {
            self.picture = picture
            self.x = x
            self.y = y
            self.id = id
            self.width = size.width
            self.height = size.height
        }
    }
    
    private var uniquePictureId = 0
    
    mutating func addPicture(_ picture: UIImage, x: CGFloat, y: CGFloat, size: CGSize) {
        uniquePictureId += 1
        pictures.append(Picture(picture: picture, x: x, y: y, id: uniquePictureId, size: size))
    }
    
}

class PictureViewModel: ObservableObject {
    @Published private var model: Pictures = Pictures()
    
    var pictures: [Pictures.Picture] { model.pictures }
    
    func addPicture(_ picture: UIImage, at location: CGSize, size: CGSize) {
        model.addPicture(picture, x: location.width, y: location.height, size: size)
    }
    
    func movePicture(_ picture: Pictures.Picture, by offset: CGSize) {
        if let index = model.pictures.firstIndex(of: picture) {
            model.pictures[index].x += offset.width
            model.pictures[index].y += offset.height
        }
    }
}
