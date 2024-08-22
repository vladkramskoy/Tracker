//
//  Localizable.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 07.08.2024.
//

import Foundation

struct Localizable {
    private static func localizedString(from value: String) -> String {
        NSLocalizedString(value, comment: "")
    }
    
    static let onboardingMessageScreenOne = localizedString(from: "onboarding.messageScreenOne")
    static let onboardingMessageScreenTwo = localizedString(from: "onboarding.messageScreenTwo")
    static let onboardingButton = localizedString(from: "onboarding.button")
    
    static let trackersTitle = localizedString(from: "trackers.title")
    static let trackersSearch = localizedString(from: "trackers.search")
    static let trackersStub = localizedString(from: "trackers.stub")
    static let trackersStubSearch = localizedString(from: "trackers.stubSearch")
    static let trackerNotMarked = localizedString(from: "tracker.notMarked")
    static let trackerMarked = localizedString(from: "tracker.marked")
    static let trackerFiltersButton = localizedString(from: "tracker.filtersButton")
    
    static let сontextMenuPin = localizedString(from: "сontextMenu.pin")
    static let сontextMenuUnpin = localizedString(from: "сontextMenu.unpin")
    static let сontextMenuEdit = localizedString(from: "сontextMenu.edit")
    static let сontextMenuDelete = localizedString(from: "сontextMenu.delete")
    
    static let actionSheetTitle = localizedString(from: "actionSheet.title")
    static let actionSheetDelete = localizedString(from: "actionSheet.delete")
    static let actionSheetCancel = localizedString(from: "actionSheet.cancel")
    
    static let filtersTitle = localizedString(from: "filters.title")
    static let filtersAllTrackers = localizedString(from: "filters.allTrackers")
    static let filtersTrackersForToday = localizedString(from: "filters.trackersForToday")
    static let filtersCompleted = localizedString(from: "filters.completed")
    static let filtersNotCompleted = localizedString(from: "filters.notCompleted")
    
    static let tabBarTrackers = localizedString(from: "tabBar.trackers")
    static let tabBarStatistics = localizedString(from: "tabBar.statistics")
    
    static let createTrackerTitle = localizedString(from: "createTracker.title")
    static let createTrackerHabit = localizedString(from: "createTracker.habit")
    static let createTrackerIrregularEvent = localizedString(from: "createTracker.irregularEvent")
    
    static let newHabitTitle = localizedString(from: "newHabit.title")
    static let newHabitName = localizedString(from: "newHabit.name")
    static let newHabitCategory = localizedString(from: "newHabit.category")
    static let newHabitSchedule = localizedString(from: "newHabit.schedule")
    static let newHabitColor = localizedString(from: "newHabit.color")
    static let newHabitCancelButton = localizedString(from: "newHabit.cancelButton")
    static let newHabitCreateButton = localizedString(from: "newHabit.createButton")
    
    static let editHabitTitle = localizedString(from: "editHabit.title")
    static let editHabitSaveButton = localizedString(from: "editHabit.saveButton")
    
    static let newIrregularEventTitle = localizedString(from: "newIrregularEvent.title")
    
    static let categoriesTitle = localizedString(from: "categories.title")
    static let categoriesStub = localizedString(from: "categories.stub")
    static let categoriesAddButton = localizedString(from: "categories.addButton")
    
    static let newCategoryTitle = localizedString(from: "newCategory.title")
    static let newCategoryNameField = localizedString(from: "newCategory.nameField")
    static let newCategoryDoneButton = localizedString(from: "newCategory.doneButton")
    
    static let scheduleTitle = localizedString(from: "schedule.title")
    static let scheduleDayOne = localizedString(from: "schedule.dayOne")
    static let scheduleDayTwo = localizedString(from: "schedule.dayTwo")
    static let scheduleDayThree = localizedString(from: "schedule.dayThree")
    static let scheduleDayFour = localizedString(from: "schedule.dayFour")
    static let scheduleDayFive = localizedString(from: "schedule.dayFive")
    static let scheduleDaySix = localizedString(from: "schedule.daySix")
    static let scheduleDaySeven = localizedString(from: "schedule.daySeven")
    static let scheduleDoneButton = localizedString(from: "schedule.doneButton")
    static let shortWeekDayMonday = localizedString(from: "shortWeekDay.monday")
    static let shortWeekDayTuesday = localizedString(from: "shortWeekDay.tuesday")
    static let shortWeekDayWednesday = localizedString(from: "shortWeekDay.wednesday")
    static let shortWeekDayThursday = localizedString(from: "shortWeekDay.thursday")
    static let shortWeekDayFriday = localizedString(from: "shortWeekDay.friday")
    static let shortWeekDaySaturday = localizedString(from: "shortWeekDay.saturday")
    static let shortWeekDaySunday = localizedString(from: "shortWeekDay.sunday")
    
    static let statisticsTitle = localizedString(from: "statistics.title")
    static let statisticsBestPeriod = localizedString(from: "statistics.bestPeriod")
    static let statisticsPerfectDays = localizedString(from: "statistics.perfectDays")
    static let statisticsTrackersСompleted = localizedString(from: "statistics.trackersСompleted")
    static let statisticsAverageValue = localizedString(from: "statistics.averageValue")
    static let statisticsPlaceholderLabel = localizedString(from: "statistics.placeholderLabel")
}
