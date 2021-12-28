//
//  HomeView.swift
//  Restart
//
//  Created by Morgan Bonhomme on 26/12/2021.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = false
    @State private var isAnimated: Bool = false

    var body: some View {
        VStack(
        ) {
            // HEADER
            Spacer()

            ZStack {
                CircleGroupView(shapeColor: .gray, shapeOpacity: 0.2)
                Image("character-2")
                    .resizable()
                    .scaledToFit()
                    .offset(y: isAnimated ? 35 : -35)
                    .animation(.easeOut(duration: 4).repeatForever(), value: isAnimated)
            }

            // BODY

            Text("The time that leads to mastery is dependent on the intensity of our focus.")
                .font(.title3)
                .fontWeight(.light)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            // footer

            Button(action: {
                withAnimation {
                    isOnboardingViewActive = true
                }

            }) {
                // HSTACK here by default
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill").imageScale(.large)

                Text("Restart")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.bold)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.large
            )
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { isAnimated = true }

        })
        .preferredColorScheme(.light)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
