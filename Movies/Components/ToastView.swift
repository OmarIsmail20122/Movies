//
//  ToastView.swift
//  Movies
//
//  Created by MacBookPro on 11/01/2026.
//

import Foundation
import SwiftUI

struct ToastView: View {
    let message: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
            
            Text(message)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.85))
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// Toast modifier for MovieDetailsView
struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let icon: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            VStack {
                Spacer()
                
                if isShowing {
                    ToastView(message: message, icon: icon)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    isShowing = false
                                }
                            }
                        }
                        .padding(.bottom, 30)
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isShowing)
        }
    }
}

extension View {
    func toast(isShowing: Binding<Bool>, message: String, icon: String = "checkmark.circle.fill") -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message, icon: icon))
    }
}
