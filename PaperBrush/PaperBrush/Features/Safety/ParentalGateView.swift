import SwiftUI

// SAFETY-002: Parental gate — math challenge modal (Screen 09 per design spec §2.8.1)
// Prevents children from triggering purchases, shares, and other gated actions.
struct ParentalGateView: View {
    let onSuccess: () -> Void
    let onCancel: () -> Void

    @State private var answer = ""
    @State private var problem = MathProblem.generate()
    @State private var isShaking = false
    @State private var wrongAttempts = 0
    @State private var isLocked = false
    @State private var lockoutSecondsRemaining = 0
    @State private var blinkOn = true

    var body: some View {
        ZStack {
            // Scrim — deep navy 50%
            Color(red: 0.106, green: 0.165, blue: 0.290)
                .opacity(0.50)
                .ignoresSafeArea()

            VStack(spacing: PBTokens.Spacing.md) {
                modal
                    .shake(isShaking)

                // Context note below modal
                Text("This keeps purchases safe")
                    .font(PBTokens.Typography.nunitoSans(.regular, size: 12))
                    .foregroundColor(.white.opacity(0.60))
            }
            .padding(.bottom, PBTokens.Spacing.xl)
        }
        .background(Color.clear)
        .presentationBackground(.clear)
        .onAppear { startBlink() }
    }

    // MARK: - Modal Card

    private var modal: some View {
        VStack(spacing: 0) {
            // Lock icon in gold circle (52pt per mockup)
            ZStack {
                Circle()
                    .fill(PBTokens.Colors.honeyGold.opacity(0.12))
                    .frame(width: 52, height: 52)
                Image(systemName: "lock.fill")
                    .font(.system(size: 24))
                    .foregroundColor(PBTokens.Colors.honeyGold)
            }
            .padding(.top, PBTokens.Spacing.lg)

            // Title — "Grown-ups only!" (Nunito Bold 22pt, Deep Navy per mockup)
            Text("Grown-ups only!")
                .font(PBTokens.Typography.nunito(.bold, size: 22))
                .foregroundColor(PBTokens.Colors.deepNavy)
                .padding(.top, PBTokens.Spacing.sm)

            if isLocked {
                lockoutMessage
            } else {
                mathChallenge
            }

            // Continue button (teal, 48pt height)
            Button {
                guard !isLocked else { return }
                submitAnswer()
            } label: {
                Text("Continue")
                    .font(PBTokens.Typography.nunito(.bold, size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        canSubmit
                            ? PBTokens.Colors.richTeal
                            : PBTokens.Colors.richTeal.opacity(0.38)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.sm))
                    .shadow(color: PBTokens.Colors.richTeal.opacity(0.22), radius: 8, x: 0, y: 4)
            }
            .disabled(!canSubmit || isLocked)
            .padding(.top, PBTokens.Spacing.md)

            // Cancel link
            Button("Cancel") {
                onCancel()
            }
            .font(PBTokens.Typography.nunitoSans(.semibold, size: 15))
            .foregroundColor(PBTokens.Colors.softGraphite)
            .padding(.top, PBTokens.Spacing.md)
            .padding(.bottom, PBTokens.Spacing.lg)
        }
        .padding(.horizontal, PBTokens.Spacing.lg)
        .frame(width: 300)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: PBTokens.CornerRadius.lg))
        .shadow(
            color: Color(red: 0.106, green: 0.165, blue: 0.290).opacity(0.18),
            radius: 24, x: 0, y: 8
        )
    }

    // MARK: - Math Challenge

    private var mathChallenge: some View {
        VStack(spacing: PBTokens.Spacing.md) {
            // Question (Nunito Sans SemiBold 18pt, Soft Graphite per mockup)
            Text("What is \(problem.questionString)?")
                .font(PBTokens.Typography.nunitoSans(.semibold, size: 18))
                .foregroundColor(PBTokens.Colors.softGraphite)
                .padding(.top, PBTokens.Spacing.sm)

            // Answer field — 120pt wide, 48pt height, teal border
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(PBTokens.Colors.richTeal, lineWidth: 1.5)
                    .shadow(color: PBTokens.Colors.richTeal.opacity(0.12), radius: 6, x: 0, y: 0)

                if answer.isEmpty {
                    Text("|")
                        .font(PBTokens.Typography.nunito(.bold, size: 24))
                        .foregroundColor(PBTokens.Colors.richTeal)
                        .opacity(blinkOn ? 1 : 0)
                } else {
                    Text(answer)
                        .font(PBTokens.Typography.nunito(.bold, size: 24))
                        .foregroundColor(PBTokens.Colors.deepNavy)
                }
            }
            .frame(width: 120, height: 48)
            .overlay(
                TextField("", text: $answer)
                    .keyboardType(.numberPad)
                    .opacity(0.011)
                    .frame(width: 120, height: 48)
                    .onChange(of: answer) { newValue in
                        answer = String(newValue.filter { $0.isNumber }.prefix(4))
                    }
            )
        }
    }

    // MARK: - Lockout Message

    private var lockoutMessage: some View {
        VStack(spacing: PBTokens.Spacing.sm) {
            Text("Too many wrong answers")
                .font(PBTokens.Typography.nunitoSans(.semibold, size: 15))
                .foregroundColor(PBTokens.Colors.sunsetCoral)
                .padding(.top, PBTokens.Spacing.sm)

            Text("Try again in \(lockoutSecondsRemaining)s")
                .font(PBTokens.Typography.nunitoSans(.regular, size: 13))
                .foregroundColor(PBTokens.Colors.softGraphite)
                .monospacedDigit()
        }
        .padding(.top, PBTokens.Spacing.sm)
        .frame(height: 100)
    }

    // MARK: - Logic

    private var canSubmit: Bool { !answer.isEmpty && !isLocked }

    private func submitAnswer() {
        guard let userAnswer = Int(answer) else { return }

        if userAnswer == problem.answer {
            onSuccess()
        } else {
            wrongAttempts += 1
            answer = ""
            isShaking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isShaking = false
            }
            problem = MathProblem.generate()

            if wrongAttempts >= 6 {
                startLockout(seconds: 300)
            } else if wrongAttempts >= 3 {
                startLockout(seconds: 30)
            }
        }
    }

    private func startLockout(seconds: Int) {
        isLocked = true
        lockoutSecondsRemaining = seconds
        Task {
            while lockoutSecondsRemaining > 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                await MainActor.run { lockoutSecondsRemaining -= 1 }
            }
            await MainActor.run {
                isLocked = false
                wrongAttempts = 0
                problem = MathProblem.generate()
            }
        }
    }

    private func startBlink() {
        Task {
            while true {
                try? await Task.sleep(nanoseconds: 500_000_000)
                await MainActor.run { blinkOn.toggle() }
            }
        }
    }
}

// MARK: - Shake Modifier

extension View {
    func shake(_ active: Bool) -> some View {
        modifier(ShakeModifier(isShaking: active))
    }
}

private struct ShakeModifier: ViewModifier {
    var isShaking: Bool

    func body(content: Content) -> some View {
        content
            .offset(x: isShaking ? 8 : 0)
            .animation(
                isShaking
                    ? .easeInOut(duration: 0.07).repeatCount(5, autoreverses: true)
                    : .default,
                value: isShaking
            )
    }
}

// MARK: - Math Problem Generator

private struct MathProblem {
    let a: Int
    let b: Int
    let answer: Int
    var questionString: String { "\(a) × \(b)" }

    static func generate() -> MathProblem {
        let a = Int.random(in: 12...29)
        let b = Int.random(in: 3...9)
        return MathProblem(a: a, b: b, answer: a * b)
    }
}
