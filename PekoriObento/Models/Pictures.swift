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
        let okazu: ObentoOkazu
        
        let id: Int
        var x: CGFloat
        var y: CGFloat
        var picture: UIImage
        var width: CGFloat
        var height: CGFloat
        
        fileprivate init(from okazu: ObentoOkazu, x: CGFloat, y: CGFloat, id: Int, size: CGSize) {
            self.okazu = okazu
            self.picture = UIImage(imageLiteralResourceName: okazu.imageName)
            self.x = x
            self.y = y
            self.id = id
            self.width = size.width
            self.height = size.height
        }
    }
    
    private var uniquePictureId = 0
    
    mutating func addPicture(from okazu: ObentoOkazu, x: CGFloat, y: CGFloat, size: CGSize) {
        uniquePictureId += 1
        pictures.append(Picture(from: okazu, x: x, y: y, id: uniquePictureId, size: size))
    }
    
    mutating func removePicture(_ target: Picture) {
        for (index, picture) in pictures.enumerated() {
            if picture == target {
                pictures.remove(at: index)
                return
            }
        }
    }
    
    mutating func removeAllPictures() {
        pictures.removeAll()
    }
}

class PictureViewModel: ObservableObject {
    @Published private var model: Pictures = Pictures()
    
    var pictures: [Pictures.Picture] { model.pictures }
    
    func addPicture(from okazu: ObentoOkazu, at location: CGSize, size: CGSize) {
        model.addPicture(from: okazu, x: location.width, y: location.height, size: size)
    }
    
    func removePicture(_ target: Pictures.Picture) {
        model.removePicture(target)
    }
    
    func removeAllPictures() {
        model.removeAllPictures()
    }
    
    func movePicture(_ picture: Pictures.Picture, by offset: CGSize) {
        if let index = model.pictures.firstIndex(of: picture) {
            model.pictures[index].x += offset.width
            model.pictures[index].y += offset.height
        }
    }
}
