//
//  CVCalendarViewDelegate.swift
//  CVCalendar
//
//  Created by E. Mozharovsky on 12/27/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

@objc
public protocol CVCalendarViewDelegate {
    func presentationMode() -> CalendarMode
    func firstWeekday() -> Weekday
    
    optional func shouldSelectDateOnViewChange() -> Bool
    optional func shouldAllowMultipleDateSelection() -> Bool
    optional func shouldShowWeekdaysOut() -> Bool
    optional func didTransitionToDate(date: CVDate)
    optional func didSelectDayView(dayView: DayView)
    optional func didDeSelectDayView(dayView: DayView)
    optional func presentedDateUpdated(date: Date)
    optional func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool
    optional func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool
    optional func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool
    optional func dotMarker(colorOnDayView dayView: DayView) -> UIColor
    optional func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat
    optional func supplementaryView(viewOnDayView dayView: DayView) -> UIView
    optional func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool
    optional func autoHighlightCurrentDay() -> Bool
}