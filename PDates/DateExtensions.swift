//
//  Date Extensions.swift
//  PDates
//
//  Created by Rui on 12/23/16.
//  Copyright © 2016 ivovl. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter.string(from: self)
    }
}
