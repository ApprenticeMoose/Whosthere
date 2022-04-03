//
//  BindingWhereValue.swift
//  Whosthere
//
//  Created by Moose on 03.04.22.
//

import Foundation
import SwiftUI

public extension Binding where Value: Equatable {
    init(_ source: Binding<Value>, deselectTo value: Value) {
        self.init(get: { source.wrappedValue },
                  set: { source.wrappedValue = $0 == source.wrappedValue ? value : $0 }
        )
    }
}

extension Optional where Wrapped == Date {
    var _bound: Date? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: Date {
        get {
            return _bound ?? Date()
        }
        set {
            _bound = Calendar.current.isDateInToday(newValue) ? nil : newValue
        }
    }
}
