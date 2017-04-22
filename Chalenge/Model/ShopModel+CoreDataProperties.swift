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

    @NSManaged public var id: Int16
    @NSManaged public var desc: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?

}

