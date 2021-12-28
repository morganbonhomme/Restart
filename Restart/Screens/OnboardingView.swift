//
//  OnboardingView.swift
//  Restart
//
//  Created by Morgan Bonhomme on 26/12/2021.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimated: Bool = false
    @State private var imageOffset: CGSize = .zero
    @State private var opacityModifier: Double = 1.0
    @State private var title: String = "Share"

    let hapticFeedback = UINotificationFeedbackGenerator()

    var body: some View {
        ZStack {
            Color("ColorBlue").ignoresSafeArea()

            VStack {
                // MARK: Header

                VStack {
                    Text(title)
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .transition(.opacity)
                        .id(title)

                    Text("""
                    It's not how much we give but
                    how much love we put into giving.
                    """)
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                }
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimated)

                Spacer()
                ZStack {
                    CircleGroupView(shapeColor: .white, shapeOpacity: 0.2)
                        .offset(x: imageOffset.width * -1)
                        .blur(radius: abs(imageOffset.width / 5))
                        .animation(.easeOut(duration: 1), value: imageOffset)

                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                        .opacity(isAnimated ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isAnimated)
                        .offset(x: imageOffset.width, y: 0)
                        .rotationEffect(.degrees(Double(imageOffset.width / 20)))
                        .gesture(
                            DragGesture()

                                .onChanged { gesture in

                                    if abs(imageOffset.width) <= 150 {
                                        imageOffset = gesture.translation
                                        withAnimation(.linear(duration: 0.25)) {
                                            opacityModifier = 0
                                            title = "Give"
                                        }
                                    }
                                }
                                .onEnded { _ in

                                    imageOffset = .zero
                                    withAnimation(.linear(duration: 0.25)) {
                                        opacityModifier = 1
                                        title = "Share"
                                    }
                                }
                        )
                        .animation(.easeOut(duration: 1), value: imageOffset)
                }

                Image(systemName: "arrow.left.arrow.right.circle")
                    .font(.system(size: 44, weight: .ultraLight))
                    .foregroundColor(.white)
                    .opacity(isAnimated ? 1 : 0)
                    .opacity(opacityModifier)
                    .animation(.easeOut(duration: 1).delay(2), value: isAnimated)

                Spacer()
                ZStack {
                    // 1. Background
                    Capsule()
                        .fill(.white.opacity(0.2))
                    Capsule()
                        .fill(.white.opacity(0.2))
                    // 2. CTA
                    Text("Get started")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)

                    // 3.  Capsule
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        Spacer()
                    }

                    // 4. Draggable circle
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .offset(x: buttonOffset)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        Spacer()
                    }
                }
                .frame(width: buttonWidth, height: 80, alignment: .center)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 40)
                .animation(.easeOut(duration: 1), value: isAnimated)
                .padding()
                .gesture(
                    DragGesture()
                        .onChanged { gesture in

                            if gesture.translation.width > 0, buttonOffset <= buttonWidth - 80 {
                                buttonOffset = gesture.translation.width
                            }
                        }
                        .onEnded { _ in
                            withAnimation(Animation.easeOut(duration: 0.4)) {
                                if buttonOffset > buttonWidth / 2 {
                                    hapticFeedback.notificationOccurred(.success)
                                    isOnboardingViewActive = false
                                } else {
                                    buttonOffset = 0
                                    hapticFeedback.notificationOccurred(.warning)
                                }
                            }
                        }
                )
            }
        }
        .onAppear(perform: {
            isAnimated = true
        })
        .preferredColorScheme(.light)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
