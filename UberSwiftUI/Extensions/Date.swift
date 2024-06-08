//
//  Date.swift
//  UberSwiftUI
//
//  Created by HardiB.Salih on 6/8/24.
//

import Foundation

/**
 * Defines various date format options.
 *
 * This enum provides pre-defined string representations for commonly used date formats.
 * You can use these formats to consistently format dates throughout your code.
 */
enum DateFormat: String {
  case yyyyMMdd = "yyyy-MM-dd" // Year-Month-Day (e.g., 2024-06-07)
  case ddMMyyyy = "dd/MM/yyyy" // Day-Month-Year (e.g., 07/06/2024)
  case MMddyyyy = "MM-dd-yyyy" // Month-Day-Year (e.g., 06-07-2024)
  case MMMMddyyyy = "MMMM dd, yyyy" // Full month name-Day-Year (e.g., June 7, 2024)
  case MMMddyyyy = "MMM dd, yyyy" // Abbreviated month name-Day-Year (e.g., Jun 7, 2024)
  case HHmmss = "HH:mm:ss" // 24-hour hour-minute-second (e.g., 16:04:23)
  case hhmmA = "hh:mm a" // 12-hour hour-minute with AM/PM (e.g., 04:04 PM)
  case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss" // Year-Month-Day with time (e.g., 2024-06-07 16:04:23)
  case iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ" // ISO 8601 standard format (e.g., 2024-06-07T16:04:23Z)
}

/**
 * Extension for Date that provides formatting functionality.
 *
 * This extension allows you to easily format a Date object using a predefined format from the DateFormat enum.
 * It simplifies date formatting and ensures consistency throughout your codebase.
 */
extension Date {
  /**
   * Formats the date using the specified DateFormat.
   *
   * - Parameter format: The DateFormat enum value representing the desired format.
   * - Returns: A String representing the formatted date.
   */
  func formatted(_ format: DateFormat) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    return dateFormatter.string(from: self)
  }
}
