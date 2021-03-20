//
//  UIView+UIGraphicsImageRenderer.swift
//  PekoriObento
//
//  Created by aseo on 2021/03/21.
//

import Foundation
import UIKit

extension UIView {
    func getImage(rect: CGRect) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: rect)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
