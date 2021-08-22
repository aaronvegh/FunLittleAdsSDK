//
//  AsyncImage.swift
//  AsyncImage
//
//  Created by Vadym Bulavin on 2/13/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import SwiftUI

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let image: (XImage) -> Image
    
    init(
        url: URL,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder image: @escaping (XImage) -> Image = { img in
            #if os(macOS)
            Image.init(nsImage: img)
                .resizable()
            #elseif os(iOS)
            Image.init(uiImage: img)
                .resizable()
            #endif
        }
    ) {
        self.placeholder = placeholder()
        self.image = image
        self.loader = ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue)
    }
    
    var body: some View {
        content
            .onAppear(perform: loader.load)
    }
    
    private var content: some View {
        Group {
            if loader.image != nil {
                image(loader.image!)
            } else {
                placeholder
            }
        }
    }
}
