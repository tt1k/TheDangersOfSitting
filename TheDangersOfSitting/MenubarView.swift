//
//  MenubarView.swift
//  TheDangersOfSitting
//
//  Created by IcedOtaku on 2022/3/18.
//

import SwiftUI

struct MenubarView: View {
    @StateObject var menubar = Menubar.shared

    private let scale: CGFloat = 0.4
    private let width: CGFloat = 1000
    private let height: CGFloat = 400
    
    // from https://www.azquotes.com/quotes/topics/computer-science.html
    private let mottos: Array = [
        "All problems in computer science can be solved by another level of indirection.",
        "The best way to predict the future is to create it.",
        "Code never lies, comments sometimes do.",
        "Computer science is the operating system for all innovation.",
        "Imagination is more important than knowledge.",
        "Good code is its own best documentation.",
        "Controlling complexity is the essence of computer programming.",
        "Make everything as simple as possible, but not simpler."
    ]
    
    var body: some View {
        VStack {
            Image("avatar")
                .resizable()
                .frame(width: 60, height: 60)
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            HStack {
                if 1 == menubar.percentage {
                    Text("Great job today!")
                } else {
                    Text("Already worked \(menubar.hours)h \(menubar.minutes)m \(menubar.seconds)s")
                }
                Spacer()
                Text("\(String(format: "%.2f", menubar.percentage * 100))%")
            }
            
            GeometryReader { r in
                Rectangle()
                    .foregroundColor(.white)
                    .overlay(
                        HStack(spacing: 0) {
                            Rectangle()
                                .foregroundColor(.blue)
                                .frame(width: r.size.width * menubar.percentage)
                            if menubar.percentage < 1 {
                                Spacer()
                            }
                        }
                    )
                    .cornerRadius(4)
            }
            .frame(height: 15)

            Spacer()
            
            HStack {
                if menubar.shouldActivePopover {
                    HStack {
                        Text("Important notice: It's time to go for a walk!")
                            .font(.system(.body).weight(.bold))
                        Button {
                            menubar.shouldActivePopover = false
                            menubar.hidePopover()
                        } label: {
                            Text("Got it!")
                        }
                    }
                } else {
                    let motto: String = mottos[menubar.minutes % mottos.count]
                    Text(motto)
                }
                Spacer()
            }
        }
        .frame(width: self.width * self.scale, height: self.height * self.scale)
        .padding()
    }
}

struct MenubarPreview: PreviewProvider {
    static var previews: some View {
        MenubarView()
    }
}
