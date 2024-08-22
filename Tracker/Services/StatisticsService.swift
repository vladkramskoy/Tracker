//
//  StatisticsService.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 21.08.2024.
//

import UIKit

final class StatisticsService {
    private let userDefaults = UserDefaults.standard
    private let trackerRecordsKey = "trackerRecords"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func updateStatistics(with newRecord: TrackerRecord) {
        var trackerRecords = fetchTrackerRecords()
        trackerRecords.append(newRecord)
        saveTrackerRecords(trackerRecords)
    }
    
    func removeRecord(_ recordToRemove: TrackerRecord) {
        var trackerRecords = fetchTrackerRecords()
        if let index = trackerRecords.firstIndex(of: recordToRemove) {
            trackerRecords.remove(at: index)
            saveTrackerRecords(trackerRecords)
        }
    }
    
    private func fetchTrackerRecords() -> [TrackerRecord] {
        guard let data = userDefaults.data(forKey: trackerRecordsKey),
              let records = try? decoder.decode([TrackerRecord].self, from: data) else {
            return []
        }
        return records
    }
    
    private func saveTrackerRecords(_ records: [TrackerRecord]) {
        if let data = try? encoder.encode(records) {
            userDefaults.set(data, forKey: trackerRecordsKey)
        }
    }
    
    private func calculateBestStreak(from records: [TrackerRecord]) -> Int {
        guard !records.isEmpty else { return 0 }
        
        let sortedRecords = records.sorted { $0.date < $1.date }
        var bestStreak = 0
        var currentStreak = 1
        
        for i in 1..<sortedRecords.count {
            let previousDate = Calendar.current.startOfDay(for: sortedRecords[i - 1].date)
            let currentDate = Calendar.current.startOfDay(for: sortedRecords[i].date)
            
            if Calendar.current.isDate(currentDate, inSameDayAs: previousDate.addingTimeInterval(86400)) {
                currentStreak += 1
            } else {
                bestStreak = max(bestStreak, currentStreak)
                currentStreak = 1
            }
        }
        
        return max(bestStreak, currentStreak)
    }
    
    private func calculatePerfectDays(from records: [TrackerRecord]) -> Int {
        guard !records.isEmpty else { return 0 }
        
        let sortedRecords = records.sorted { $0.date < $1.date }
        var perfectDaysCount = 0
        
        for i in 1..<sortedRecords.count {
            let previousDate = Calendar.current.startOfDay(for: sortedRecords[i - 1].date)
            let currentDate = Calendar.current.startOfDay(for: sortedRecords[i].date)
            
            if Calendar.current.isDate(currentDate, inSameDayAs: previousDate.addingTimeInterval(86400)) {
                perfectDaysCount += 1
            }
        }
        
        return perfectDaysCount
    }
    
    private func calculateAverage(totalMarks: Int, perfectDays: Int) -> Int {
        totalMarks > 0 ? (perfectDays * 100) / totalMarks : 0
    }
    
    func getStatisticsData() -> [TrackerData] {
        let trackerRecords = fetchTrackerRecords()
        let bestStreak = calculateBestStreak(from: trackerRecords)
        let perfectDays = calculatePerfectDays(from: trackerRecords)
        let totalMarks = trackerRecords.count
        let average = calculateAverage(totalMarks: totalMarks, perfectDays: perfectDays)
        
        return [
            TrackerData(title: Localizable.statisticsBestPeriod, value: bestStreak),
            TrackerData(title: Localizable.statisticsPerfectDays, value: perfectDays),
            TrackerData(title: Localizable.statisticsTrackersСompleted, value: totalMarks),
            TrackerData(title: Localizable.statisticsAverageValue, value: average)
        ]
    }
}

