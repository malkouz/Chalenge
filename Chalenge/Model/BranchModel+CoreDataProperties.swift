//
//  BranchModel+CoreDataProperties.swift
//  Chalenge
//
//  Created by Moayad Al kouz on 7/25/1438 AH.
//  Copyright © 1438 Moayad Al kouz. All rights reserved.
//

import Foundation
import CoreData


extension BranchModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BranchModel> {
        return NSFetchRequest<BranchModel>(entityName: "BranchModel");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var address: String?
    @NSManaged public var shopId: Int16

}
