//
//  SeekButton.swift
//  SeekButtonDemo
//
//  Created by Hayder Al-Husseini on 11/08/2020.
//  Copyright © 2020 kodeba•se ltd.
//
//  See LICENSE.md for licensing information.
//

import SwiftUI

struct SeekButton: View {
    var interval: Int = 10
    var action: (Int) -> Void
    
    @State private var rotation: Angle = .zero
    @State private var backgroundOpacity: Double = 0.0
    @State private var durationLabelOpacity: Double = 1.0
    @State private var xOffset: CGFloat = 0.0
    @State private var accumulationLabelOpacity: Double = 0.0
    @State private var numberOfAnimations: Int = 0
    @State private var accumulationString: String = ""
    
    var body: some View {
        ZStack {
            Group {
                RoundArrowBackground()
                    .fill()
                    .opacity(backgroundOpacity)
                RoundArrow()
                    .stroke(lineWidth: 3)
                RoundArrowHead()
                    .fill()
            }
            .rotationEffect(rotation)
            
            // Duration label
            ScalableText(string: "\(interval)")
                .opacity(durationLabelOpacity)
            
            ScalableText(string: accumulationString, fontWeight: .bold, xOffset: xOffset)
                .opacity(accumulationLabelOpacity)
        }
        .accessibility(label: Text("Forward \(interval) seconds"))
        .accessibility(addTraits: .isButton)
        .accessibilityAction { self.performTap() }
        .contentShape(Rectangle())
        .onTapGesture { self.performTap() }
    }
    
    private func performTap() {
        if numberOfAnimations == 0 {
            accumulationString = "+\(self.interval)"
        } else {
            accumulationString = incrementSeekValue()
        }
        
        numberOfAnimations += 1
        
        animateArrowAndBackground()
        animateDurationLabel()
        animateAccumulationLabel()
        popAnimation()
        action(interval)
    }
    
    private func popAnimation() {
        let delay = DispatchTime.now() + 0.8
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.numberOfAnimations -= 1
            
            if self.numberOfAnimations == 0 {
                withAnimation(Animation.easeInOut(duration: 0.15)) {
                    self.durationLabelOpacity = 1.0
                }
            }
        }
    }
    
    private func incrementSeekValue() -> String {
        var valueString = accumulationString
        valueString.removeFirst()
        
        if var value = Int(valueString) {
            value += interval
            return "+" + String(value)
        }
        
        return accumulationString
    }
    
    private func animateArrowAndBackground() {
        // Arrow and background animate out
        withAnimation(.easeInOut(duration: 0.1)) {
            rotation = .degrees(20)
            backgroundOpacity = 0.3
        }
        
        // Arrow and background animate in
        withAnimation(Animation.easeInOut(duration: 0.1).delay(0.1)) {
            rotation = .zero
            backgroundOpacity = 0.0
        }
    }
    
    private func animateDurationLabel() {
        durationLabelOpacity = 1.0
        // Duration label animation
        withAnimation(.easeInOut(duration: 0.1)) {
            durationLabelOpacity = 0.0
        }
    }
    
    private func animateAccumulationLabel() {
        // Reset the labels animation values
        accumulationLabelOpacity = 0
        xOffset = 0.0
        
        // Fade in
        withAnimation(.easeInOut(duration: 0.1)) {
            accumulationLabelOpacity = 1.0
        }
        
        // Animate out offset
        withAnimation(Animation.timingCurve(0.0, 0.0, 0.2, 1.0, duration: 0.35)) {
            xOffset = 80
        }
        
        // Fade out
        withAnimation(Animation.timingCurve(0.0, 0.0, 0.2, 1.0, duration: 0.45).delay(0.5)) {
            accumulationLabelOpacity = 0.0
        }
    }
}

// MARK: - Arrow code

extension SeekButton {
    fileprivate struct RoundArrowHead: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let w = rect.size.width
            let arrowHead = w * 0.3
            let x = w * 0.6

            for i in 0..<2 {
                path.move(to: CGPoint(x: x + CGFloat(i) * arrowHead, y: 0.0))
                path.addLines([
                    CGPoint(x: x - arrowHead + CGFloat(i) * arrowHead, y: -arrowHead * 0.75),
                    CGPoint(x: x - arrowHead + CGFloat(i) * arrowHead, y: arrowHead * 0.75),
                    CGPoint(x: x + CGFloat(i) * arrowHead, y: 0.0)
                ])
                path.closeSubpath()
                
            }
            return path
        }
    }
    
    fileprivate struct RoundArrow: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let w = rect.size.width
            let h = rect.size.height
            
            path.addArc(center: CGPoint(x: w * 0.5,
                                        y: h * 0.5),
                        radius: h * 0.5,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 270),
                        clockwise: false)

            return path
        }
    }
    
    fileprivate struct RoundArrowBackground: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let w = rect.size.width
            let h = rect.size.height
            
            path.addArc(center: CGPoint(x: w * 0.5,
                                        y: h * 0.5),
                        radius: h * 0.5,
                        startAngle: Angle(degrees: 0),
                        endAngle: Angle(degrees: 360),
                        clockwise: true)

            return path
        }
    }
}

// MARK: - Text code
extension SeekButton {
    private struct ScalableText: View {
        var string: String
        var fontWeight: Font.Weight = .regular
        var xOffset: CGFloat = 0
        
        
        var animatableData: CGFloat {
            get { return xOffset }
            set { xOffset = newValue }
        }
        var body: some View {
            GeometryReader { geometry in
                Text(self.string)
                    .font(
                        .system(size: geometry.size.width * 0.4)
                    )
                    .fontWeight(self.fontWeight)
                    .offset(x: self.xOffset * geometry.size.width/44.0, y: 0.0)
            }
            
        }
    }
}

struct SeekButton_Previews: PreviewProvider {
    static var previews: some View {
        SeekButton { _ in
            print("Hello Button")
        }.frame(width: 64, height: 64)
    }
}
