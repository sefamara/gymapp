import Foundation
import UserNotifications
#if canImport(UIKit)
import UIKit
#endif

/// Drives the rest-between-sets countdown. Schedules a local notification so
/// the rest period still alerts the lifter after the phone locks or the app
/// backgrounds — a plain in-process `Timer` would not fire reliably then.
@MainActor
@Observable
final class RestTimerController {
    private(set) var endDate: Date?
    private(set) var duration: TimeInterval = 180

    private var notificationID: String?
    private var autoExpireTask: Task<Void, Never>?

    var isActive: Bool { endDate != nil }

    func start(duration: TimeInterval) {
        cancel()
        self.duration = duration
        let end = Date().addingTimeInterval(duration)
        endDate = end
        scheduleNotification(at: end)
        scheduleAutoExpire()
        requestNotificationPermissionIfNeeded()
    }

    func addTime(_ seconds: TimeInterval) {
        guard let currentEnd = endDate else { return }
        let newEnd = max(currentEnd.addingTimeInterval(seconds), Date())
        endDate = newEnd
        scheduleNotification(at: newEnd)
        scheduleAutoExpire()
    }

    func cancel() {
        endDate = nil
        autoExpireTask?.cancel()
        autoExpireTask = nil
        if let notificationID {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
        }
        notificationID = nil
    }

    private func scheduleAutoExpire() {
        autoExpireTask?.cancel()
        autoExpireTask = Task { @MainActor [weak self] in
            while let self, let end = self.endDate, !Task.isCancelled {
                let remaining = end.timeIntervalSinceNow
                if remaining <= 0 {
                    self.endDate = nil
                    #if canImport(UIKit)
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    #endif
                    break
                }
                try? await Task.sleep(for: .seconds(min(remaining, 1)))
            }
        }
    }

    private func scheduleNotification(at date: Date) {
        if let notificationID {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
        }
        let id = UUID().uuidString
        notificationID = id

        let content = UNMutableNotificationContent()
        content.title = "Descanso terminado"
        content.body = "Hora de tu siguiente serie 💪"
        content.sound = .default

        let interval = max(date.timeIntervalSinceNow, 1)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    private func requestNotificationPermissionIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else { return }
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }
}
