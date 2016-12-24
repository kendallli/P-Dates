//
//  PDateViewModel.swift
//  PDates
//
//  Created by Rui on 12/23/16.
//  Copyright © 2016 ivovl. All rights reserved.
//

import UIKit

class PDateViewModel: NSObject {
    var startDate: Date
    var endDate: Date?
    var nextStartDate: Date?
    
    override init() {
        self.startDate = Date();
    }
}
