//
//  CVSelectionManager.swift
//  Pods
//
//  Created by Marco Tresch on 07/06/15.
//
//

import Foundation

public class CVSelectionManager {
    private var selectionSet = Set<CVDate>()
    
    public var selectedDates: Set<CVDate> {
        return selectionSet
    }
    
    func addSelectedDate(date: CVDate) {
        selectionSet.insert(date)
    }
    
    func removeSelectedDate(date: CVDate) {
        selectionSet.remove(date)
    }
    
    func isAlreadySelected(date:CVDate) -> Bool {
        return selectionSet.contains(date)
    }
    
    func removeAll() {
        selectionSet.removeAll(keepCapacity: true)
    }
    
    func numberOfSelections() -> Int {
        return selectionSet.count
    }
}