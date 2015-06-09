//
//  CVCalendarDayViewControlCoordinator.swift
//  CVCalendar
//
//  Created by E. Mozharovsky on 12/27/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

class CVCalendarDayViewControlCoordinator {
    // MARK: - Non public properties
    private var selectionManager = CVSelectionManager()
    private unowned let calendarView: CalendarView
    
    func getSelectionManager() -> CVSelectionManager {
        return selectionManager
    }
    
    // MARK: - Public properties
    weak var selectedDayView: CVCalendarDayView?
    var animator: CVCalendarViewAnimator! {
        get {
            return calendarView.animator
        }
    }

    // MARK: - initialization
    init(calendarView: CalendarView) {
        self.calendarView = calendarView
    }
}

// MARK: - Animator side callback

extension CVCalendarDayViewControlCoordinator {
    func selectionPerformedOnDayView(dayView: DayView) {
        // TODO:
    }
    
    func deselectionPerformedOnDayView(dayView: DayView) {
        if dayView != selectedDayView {
            selectionManager.removeSelectedDate(dayView.date)
            dayView.setDeselectedWithClearing(true)
        }
    }
    
    func dequeueDayView(dayView: DayView) {
        selectionManager.removeSelectedDate(dayView.date)
        dayView.setDeselectedWithClearing(true)
    }
    
    func flush() {
        selectedDayView = nil
        selectionManager.removeAll()
    }
}

// MARK: - Animator reference 

private extension CVCalendarDayViewControlCoordinator {
    func presentSelectionOnDayView(dayView: DayView) {
        animator.animateSelectionOnDayView(dayView)
        //animator?.animateSelection(dayView, withControlCoordinator: self)
    }
    
    func presentDeselectionOnDayView(dayView: DayView) {
        animator.animateDeselectionOnDayView(dayView)
        //animator?.animateDeselection(dayView, withControlCoordinator: self)
    }
}

// MARK: - Coordinator's control actions

extension CVCalendarDayViewControlCoordinator {
    func performDayViewSingleSelection(dayView: DayView) {
        selectionManager.addSelectedDate(dayView.date)
        
        if let selectedDayView = self.selectedDayView {
            if selectedDayView != dayView {
                self.presentDeselectionOnDayView(self.selectedDayView!)
                self.selectedDayView = dayView
                self.presentSelectionOnDayView(self.selectedDayView!)
            }
        } else {
            self.selectedDayView = dayView
            self.presentSelectionOnDayView(self.selectedDayView!)
        }
    }

    /**
        Allows for multiple selected dates
    */
    func performDayViewMultipleSelection(dayView: DayView) -> Bool {
        if selectionManager.isAlreadySelected(dayView.date) {
            selectionManager.removeSelectedDate(dayView.date)
            presentDeselectionOnDayView(dayView)
            selectedDayView = nil
            return false;
        } else {
            selectionManager.addSelectedDate(dayView.date)
            presentSelectionOnDayView(dayView)
            selectedDayView = dayView
            return true;
        }
        
    }
    
    func performDayViewRangeSelection(dayView: DayView) {
        println("Day view range selection found")
    }
}