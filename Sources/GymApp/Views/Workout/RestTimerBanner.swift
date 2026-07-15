import SwiftUI

struct RestTimerBanner: View {
    var timer: RestTimerController

    var body: some View {
        if let endDate = timer.endDate, endDate > .now {
            HStack(spacing: Theme.Spacing.md) {
                Image(systemName: "timer")
                    .foregroundStyle(Color.accentColor)

                Text(timerInterval: Date()...endDate, countsDown: true)
                    .font(.title3.monospacedDigit().bold())

                Spacer()

                Button {
                    timer.addTime(15)
                } label: {
                    Text("+15s")
                        .font(.subheadline.weight(.semibold))
                }

                Button {
                    timer.cancel()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            .glassEffect(Glass.regular.tint(.accentColor.opacity(0.2)), in: .rect(cornerRadius: Theme.Radius.control))
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.top, Theme.Spacing.sm)
        }
    }
}
