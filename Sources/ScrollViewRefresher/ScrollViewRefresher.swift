//
//  SwiftUIView.swift
//
//
//  Created by Patryk Węgrzyński on 27/01/2023.
//

import SwiftUI

@available(iOS 14, *)
public struct ScrollViewRefresher: View {
    //MARK: State properties
    @State private var isRefreshing: Bool = false
    @State private var rectangleHeight: CGFloat = 0
    @State private var initialLocation: CGFloat = 0
    @State private var currentLocation: CGFloat = 0
    
    //MARK: Closures
    private let action: () async -> Void
    
    // MARK: Computed properties
    private var shouldShowRefreshIndicator: Bool {
        rectangleHeight > 50
    }
    
    //MARK: Initializers
    public init(action: @escaping () async -> Void) {
        self.action = action
    }
    
    //MARK: Body
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: rectangleHeight)
                    .onAppear {
                        initialLocation = proxy.frame(in: .global).origin.y
                        currentLocation = initialLocation
                    }
                    .onChange(of: proxy.frame(in: .global).origin.y) { value in
                        currentLocation = value
                        if !isRefreshing {
                            let newHeight = max(0, currentLocation - initialLocation)
                            if newHeight != rectangleHeight {
                                withAnimation {
                                    rectangleHeight = newHeight
                                }
                            }
                            
                            if shouldShowRefreshIndicator && !isRefreshing {
                                isRefreshing = true
                                Task { @MainActor in
                                    await self.action()
                                    withAnimation {
                                        self.isRefreshing = false
                                        self.rectangleHeight = 0
                                    }
                                }
                            }
                        }
                    }
                if shouldShowRefreshIndicator {
                    ProgressView()
                }
            }
            .frame(height: rectangleHeight)
            .opacity(isRefreshing ? 1 : 0)
            .animation(.easeInOut(duration: 1), value: shouldShowRefreshIndicator)
        }
        .frame(height: rectangleHeight)
    }
}
