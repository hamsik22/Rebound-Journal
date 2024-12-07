//
//  ReboundJournalApp.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import SwiftUI

@main
struct ReboundJournalApp: App {
    // 데이터를 전체에서 쓸 방법
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var manager: DataManager = DataManager(preview: false)
    
    var body: some Scene {
        WindowGroup {
            DashboardContentView()
                .environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}


/// Create a shape with specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

/// Present an alert from anywhere in the app
func presentAlert(title: String, message: String, primaryAction: UIAlertAction = .OK, secondaryAction: UIAlertAction? = nil, tertiaryAction: UIAlertAction? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(primaryAction)
        if let secondary = secondaryAction { alert.addAction(secondary) }
        if let tertiary = tertiaryAction { alert.addAction(tertiary) }
        rootController?.present(alert, animated: true, completion: nil)
    }
}

var rootController: UIViewController? {
    var root = UIApplication.shared.windows.first?.rootViewController
    if let presenter = root?.presentedViewController { root = presenter }
    return root
}

/// Blur background view
struct BackgroundBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
