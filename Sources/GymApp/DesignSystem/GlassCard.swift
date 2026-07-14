import SwiftUI

/// Applies the shared rounded Liquid Glass treatment to any view. Use inside a
/// `GlassEffectContainer` when several cards sit on screen together so their
/// highlights/refraction blend consistently.
extension View {
    func glassCardStyle(tint: Color? = nil, cornerRadius: CGFloat = Theme.Radius.card) -> some View {
        self
            .padding(Theme.Spacing.md)
            .glassEffect(
                tint.map { Glass.regular.tint($0) } ?? Glass.regular,
                in: .rect(cornerRadius: cornerRadius)
            )
    }
}
