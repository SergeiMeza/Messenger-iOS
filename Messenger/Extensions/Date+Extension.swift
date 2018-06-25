//
//  Date+Extension.swift
//  Messenger
//
//  Created by Sergei Meza on 2018/06/03.
//  Copyright © 2018 Sergei Meza. All rights reserved.
//

import Foundation

private extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

public extension Date {
    public var timestamp: Double {
        return timeIntervalSinceReferenceDate * 1000
    }
    
    static func dateWithTimestamp(timestamp: Double) -> Date {
        return Date.init(timeIntervalSinceReferenceDate: timestamp / 1000)
    }
    
    
    public var timestamp_iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    public var timeElapsed: String {
        var elapsed = ""
        let seconds = -self.timeIntervalSinceNow
        if seconds < 60 {
            elapsed = "Just now"
        } else if seconds < 60 * 60 {
            let minutes = Int(seconds / 60)
            elapsed = minutes > 1 ? "\(minutes) mins" : "\(minutes) min"
        } else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60 * 60))
            elapsed = hours > 1 ? "\(hours) hours" : "\(hours) hour"
        } else if seconds < 7 * 24 * 60 * 60 {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            elapsed = formatter.string(from: self)
        } else {
            elapsed = self.toShortString()
        }
        return elapsed
    }
    
    public func toShortString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .short, timeStyle: .none)
    }
    
    public func toMediumString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .none)
    }
    
    public func toMediumTimeString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .short)
    }
}

public extension TimeInterval {
    public func callDuration() -> String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        
        switch self {
        case 0 ..< 3600 :
            dateFormatter.allowedUnits = [.minute, .second]
        case 3600..<(3600*24) :
            dateFormatter.allowedUnits = [.hour, .minute, .second]
        default:
            dateFormatter.allowedUnits = [.minute, .second]
        }
        dateFormatter.zeroFormattingBehavior = .pad
        return dateFormatter.string(from: self) ?? "0:00"
    }
}

public extension String {
    public var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}
