//
//  ReflectionCard.swift
//  MemoryBoard
//
//  Created by Khumar Girdhar on 02/11/24.
//

import SwiftUI

struct ReflectionCardView: View {
    @State private var reflections = [
        "What are you grateful for today?",
        "Describe a moment that made you smile.",
        "What was a challenge you faced recently?",
        "What are your goals for the upcoming week?",
        "Reflect on a recent success you've had."
    ]
    @State private var currentReflection: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Today's Reflection")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            Text(currentReflection)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: shuffleReflection) {
                Label("Shuffle Reflection", systemImage: "shuffle")
                    .font(.body)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.bottom)
        }
        .frame(width: 300, height: 200)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .onAppear {
            shuffleReflection()
        }
    }
    
    private func shuffleReflection() {
        currentReflection = reflections.randomElement() ?? "What are you thinking today?"
    }
}

struct ReflectionCardView_Previews: PreviewProvider {
    static var previews: some View {
        ReflectionCardView()
    }
}

