//
//  Float.swift
//  Whosthere
//
//  Created by Moose on 06.11.22.
//

import Foundation

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}
