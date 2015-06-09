//
//  CVSelectionManager.swift
//  Pods
//
//  Created by Marco Tresch on 07/06/15.
//
//

import Foundation

public class CVSelectionManager {
    private var selectionSet = Set<String>()
    
    func addSelectedDate(date: CVDate) {
        selectionSet.insert(date.identifier)
    }
    
    func removeSelectedDate(date: CVDate) {
        selectionSet.remove(date.identifier)
    }
    
    func isAlreadySelected(date:CVDate) -> Bool {
        return selectionSet.contains(date.identifier)
    }
    
    func removeAll() {
        selectionSet.removeAll(keepCapacity: true)
    }
    
    func numberOfSelections() -> Int {
        return selectionSet.count
    }
}