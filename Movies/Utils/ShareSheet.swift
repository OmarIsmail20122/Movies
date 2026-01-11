//
//  ShareSheet.swift
//  Movies
//
//  Created by MacBookPro on 06/08/2025.
//

import Foundation
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    let shareText: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

