//
//  PhotoDetailView.swift
//  Rebound Journal
//
//  Created by hyunho lee on 2023/06/10.
//

import PDFKit
import SwiftUI

/// Show photo details flow
struct PhotoDetailView: UIViewRepresentable {
    let image: UIImage

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.backgroundColor = UIColor(Color("BackgroundColor"))
        view.document = PDFDocument()
        guard let page = PDFPage(image: image) else { return view }
        view.document?.insert(page, at: 0)
        view.autoScales = true
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) { }
}
