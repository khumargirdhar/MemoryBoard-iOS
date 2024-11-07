import SwiftUI

struct ReflectionCardView: View {
    @State private var reflections = [
        "What are you grateful for today?",
            "Describe a moment that made you smile.",
            "What was a challenge you faced recently?",
            "What are your goals for the upcoming week?",
            "Reflect on a recent success you've had.",
            "What inspired you today?",
            "Who made a positive impact on your life recently?",
            "What’s something new you learned this week?",
            "Describe a recent act of kindness you witnessed or performed.",
            "What’s a goal you’d like to set for yourself?",
            "How have you grown over the past month?",
            "What is something you’re looking forward to?",
            "What’s a memory that brings you joy?",
            "What are three things you’re proud of?",
            "How can you take better care of yourself?",
            "What are some of your biggest strengths?",
            "What challenges have you overcome recently?",
            "Who is someone you’re grateful to have in your life?",
            "What is something you’ve accomplished that you’re proud of?",
            "How can you show gratitude to someone in your life?"
    ]
    @State private var currentReflection: String = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: shuffleReflection) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 18))
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .foregroundColor(.black)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding(.top, 10)
                .padding(.trailing, 10)
            }

            Spacer()

            ZStack {
                frostedGlassBackground()
                    .cornerRadius(10)
                
                Text(currentReflection)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .frame(width: 400, height: 200)
        .background(appleCardGradient())
        .cornerRadius(15)
        .shadow(radius: 10)
        .onAppear {
            shuffleReflection()
        }
    }
    
    private func shuffleReflection() {
        currentReflection = reflections.randomElement() ?? "What are you thinking today?"
    }

    private func appleCardGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.95, green: 0.75, blue: 0.73),
                Color(red: 0.74, green: 0.80, blue: 0.92),
                Color(red: 0.80, green: 0.94, blue: 0.82),
                Color(red: 1.0, green: 0.88, blue: 0.65)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private func frostedGlassBackground() -> some View {
        Color.white.opacity(0.2)
            .background(BlurEffect(style: .systemUltraThinMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct BlurEffect: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct ReflectionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ReflectionCardView()
    }
}
