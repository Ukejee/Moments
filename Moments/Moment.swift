//
//  Moment.swift
//  Moments
//
//  Created by Ukejee on 1/3/22.
//

import UIKit

class Moment: NSObject, Codable {

    var caption: String
    var image: String

    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
    
}
