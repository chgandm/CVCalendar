//
//  CVCalendarView.swift
//  CVCalendar
//
//  Created by E. Mozharovsky on 12/26/14.
//  Copyright (c) 2014 GameApp. All rights reserved.
//

import UIKit

typealias WeekView = CVCalendarWeekView
typealias CalendarView = CVCalendarView
typealias MonthView = CVCalendarMonthView
typealias Manager = CVCalendarManager
public typealias DayView = CVCalendarDayView
typealias ContentController = CVCalendarContentViewController
typealias Appearance = CVCalendarViewAppearance
typealias Coordinator = CVCalendarDayViewControlCoordinator
public typealias Date = CVDate
public typealias CalendarMode = CVCalendarViewPresentationMode
public typealias Weekday = CVCalendarWeekday
typealias Animator = CVCalendarViewAnimator
typealias Delegate = CVCalendarViewDelegate
typealias AppearanceDelegate = CVCalendarViewAppearanceDelegate
typealias AnimatorDelegate = CVCalendarViewAnimatorDelegate
typealias ContentViewController = CVCalendarContentViewController
typealias MonthContentViewController = CVCalendarMonthContentViewController
typealias WeekContentViewController = CVCalendarWeekContentViewController
typealias MenuViewDelegate = CVCalendarMenuViewDelegate
typealias TouchController = CVCalendarTouchController
typealias SelectionType = CVSelectionType

public class CVCalendarView: UIView {
    // MARK: - Public properties
    var manager: Manager!
    var appearance: Appearance!
    var touchController: TouchController!
    var coordinator: Coordinator!
    var animator: Animator!
    var contentController: ContentViewController!
    var calendarMode: CalendarMode!
    
    var (weekViewSize: CGSize?, dayViewSize: CGSize?)
    
    private var validated = false
    
    public func setValidated(validated: Bool) {
        self.validated = validated
    }
    
    var firstWeekday: Weekday {
        get {
            if let delegate = delegate {
                return delegate.firstWeekday()
            } else {
                return .Sunday
            }
        }
    }
    
    var shouldShowWeekdaysOut: Bool! {
        if let delegate = delegate, let shouldShow = delegate.shouldShowWeekdaysOut?() {
            return shouldShow
        } else {
            return false
        }
    }
    
    var shouldAllowMultipleDateSelection: Bool! {
        if let delegate = delegate, let shouldAllowMultiple = delegate.shouldAllowMultipleDateSelection?() {
            return shouldAllowMultiple
        } else {
            return false
        }
    }
    
    var shouldSelectDateOnViewChange: Bool {
        if let delegate = delegate, let shouldSelect = delegate.shouldSelectDateOnViewChange?() {
            return shouldSelect
        } else {
            return false
        }
    }
    
    var autoHighlightCurrentDay: Bool! {
        if let delegate = delegate, let autoHighlightCurrentDay = delegate.autoHighlightCurrentDay?() {
            return autoHighlightCurrentDay
        } else {
            return false
        }
    }
    
    var presentedDate: Date! {
        didSet {
            if let oldValue = oldValue {
                delegate?.presentedDateUpdated?(presentedDate)
            }
        }
    }
    
    // MARK: - Calendar View Delegate
    
    @IBOutlet weak var calendarDelegate: AnyObject? {
        set {
            if let calendarDelegate = newValue as? Delegate {
                delegate = calendarDelegate
            }
        }
        
        get {
            return delegate
        }
    }
    
    var delegate: CVCalendarViewDelegate? {
        didSet {
            if manager == nil {
                manager = Manager(calendarView: self)
            }
            
            if appearance == nil {
                appearance = Appearance()
            }
            
            if touchController == nil {
                touchController = TouchController(calendarView: self)
            }
            
            if coordinator == nil {
                coordinator = Coordinator(calendarView: self)
            }
            
            if animator == nil {
                animator = Animator(calendarView: self)
            }
            
            if calendarMode == nil {
                loadCalendarMode()
            }
        }
    }
    
    // MARK: - Calendar Appearance Delegate
    
    @IBOutlet weak var calendarAppearanceDelegate: AnyObject? {
        set {
            if let calendarAppearanceDelegate = newValue as? AppearanceDelegate {
                if appearance == nil {
                    appearance = Appearance()
                }
                
                appearance.delegate = calendarAppearanceDelegate
            }
        }
        
        get {
            return appearance
        }
    }
    
    // MARK: - Calendar Animator Delegate
    
    @IBOutlet weak var animatorDelegate: AnyObject? {
        set {
            if let animatorDelegate = newValue as? AnimatorDelegate {
                animator.delegate = animatorDelegate
            }
        }
        
        get {
            return animator
        }
    }
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: CGRectZero)
        hidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hidden = true
    }

    /// IB Initialization
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        hidden = true
    }
}

// MARK: - Frames update

extension CVCalendarView {
    public func commitCalendarViewUpdate() {
        if let delegate = delegate, let contentController = contentController {
            let contentViewSize = contentController.bounds.size
            let selfSize = bounds.size
            
            if selfSize != contentViewSize {
                if !validated {
                    let width = selfSize.width
                    let height: CGFloat
                    let countOfWeeks = CGFloat(5)
                    
                    let vSpace = appearance.spaceBetweenWeekViews!
                    let hSpace = appearance.spaceBetweenDayViews!
                    
                    if let mode = calendarMode {
                        switch mode {
                        case .WeekView:
                            height = selfSize.height
                        case .MonthView :
                            height = (selfSize.height / countOfWeeks) - (vSpace * countOfWeeks)
                        }
                        
                        weekViewSize = CGSizeMake(width, height)
                        dayViewSize = CGSizeMake((width / 7.0) - hSpace, height)
                        validated = true
                        
                        contentController.updateFrames(bounds)
                    }
                }
            } else {
                contentController.updateFrames(CGRectZero)
            }
        }
    }
}

// MARK: - Coordinator callback

extension CVCalendarView {
    func didTransitionToDate(date: CVDate) {
        delegate?.didTransitionToDate?(date)
    }
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        presentedDate = dayView.date
        delegate?.didSelectDayView?(dayView)
        if let controller = contentController {
            controller.performedDayViewSelection(dayView) // TODO: Update to range selection
        }
    }
    
    func didDeSelectDayView(dayView: CVCalendarDayView) {
        delegate?.didDeSelectDayView?(dayView)
        if let controller = contentController {
            controller.performedDayViewSelection(dayView)
        }
    }
}

// MARK: - Convenience API

extension CVCalendarView {
    func changeDaysOutShowingState(shouldShow: Bool) {
        contentController.updateDayViews(shouldShow)
    }
    
    func toggleViewWithDate(date: NSDate) {
        contentController.togglePresentedDate(date)
    }
    
    func toggleCurrentDayView() {
        contentController.togglePresentedDate(NSDate())
    }
    
    public func loadNextView() {
        contentController.presentNextView(nil)
    }
    
    public func loadPreviousView() {
        contentController.presentPreviousView(nil)
    }
    
    func changeMode(mode: CalendarMode) {
        if let selectedDate = coordinator.selectedDayView?.date.convertedDate() where calendarMode != mode {
            calendarMode = mode
            
            let newController: ContentController
            switch mode {
            case .WeekView:
                contentController.updateHeight(dayViewSize!.height, animated: true)
                newController = WeekContentViewController(calendarView: self, frame: bounds, presentedDate: selectedDate)
            case .MonthView:
                contentController.updateHeight(contentController.presentedMonthView.potentialSize.height, animated: true)
                newController = MonthContentViewController(calendarView: self, frame: bounds, presentedDate: selectedDate)
            }
            
            
            newController.updateFrames(bounds)
            newController.scrollView.alpha = 0
            addSubview(newController.scrollView)
            
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.contentController.scrollView.alpha = 0
                newController.scrollView.alpha = 1
            }) { _ in
                self.contentController.scrollView.removeAllSubviews()
                self.contentController.scrollView.removeFromSuperview()
                self.contentController = newController
            }
        }
    }
}

// MARK: - Mode load 

private extension CVCalendarView {
    func loadCalendarMode() {
        if let delegate = delegate {
            calendarMode = delegate.presentationMode()
            switch delegate.presentationMode() {
                case .MonthView: contentController = MonthContentViewController(calendarView: self, frame: bounds)
                case .WeekView: contentController = WeekContentViewController(calendarView: self, frame: bounds)
                default: break
            }
            
            addSubview(contentController.scrollView)
        }
    }
}
