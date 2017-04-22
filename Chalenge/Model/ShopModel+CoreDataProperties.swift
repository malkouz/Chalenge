//
//  ShopModel+CoreDataProperties.swift
//  Chalenge
//
//  Created by Moayad Al kouz on 7/25/1438 AH.
//  Copyright © 1438 Moayad Al kouz. All rights reserved.
//

import Foundation
import CoreData


extension ShopModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShopModel> {
        return NSFetchRequest<ShopModel>(entityName: "ShopModel");
    }

    @NSManaged public var name: String?
    @NSManaged public var branchNumber: Int16
    @NSManaged public var image: NSData?
    @NSManaged public var desc: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var address: String?

}
