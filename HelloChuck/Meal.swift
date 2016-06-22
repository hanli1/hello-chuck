//
//  Meal.swift
//  FoodTracker
//
//  Created by HAN LI on 6/14/16.
//  Copyright © 2016 HAN LI. All rights reserved.
//

import Foundation
import UIKit

class Meal: NSObject, NSCoding
{
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    struct PropertyKey{
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
    }
    init(name: String, photo: UIImage?, rating: Int)
    {
        self.name = name
        self.photo = photo
        self.rating = rating
        
        super.init()
        
    
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder)
    {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        self.init(name: name, photo: photo, rating: rating)
    }
}