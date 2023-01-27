//
//  SwiftUIView.swift
//
//
//  Created by Patryk Węgrzyński on 27/01/2023.
//

import SwiftUI

@available(iOS 14, *)
public struct ScrollViewRefresher: View {
    @Binding public var refreshing: Bool
    public let action: () async -> Void
    @State private var rectangleHeight: CGFloat = 0
    @State private var initialLocation: CGFloat = 0
    @State private var currentLocation: CGFloat = 0
    
    public var body: some View {
        GeometryReader{ proxy in
            ZStack{
                Rectangle()
                    .fill(.clear)
                    .frame(height: rectangleHeight, alignment: .center)
                    .onAppear{
                        initialLocation = proxy.frame(in: .global).origin.y
                        currentLocation = initialLocation
                    }
                    .onChange(of: refreshing, perform: { value in
                        if value == false {
                            withAnimation{
                                currentLocation = initialLocation
                                rectangleHeight = 0
                            }
                        }
                    })
                    .onChange(of: proxy.frame(in: .global).origin.y, perform: { value in
                        currentLocation = value
                        withAnimation{
                            if !refreshing{
                                rectangleHeight = currentLocation > initialLocation ? -(initialLocation - currentLocation) : 0
                            }
                            
                            if rectangleHeight > 50{
                                Task{
                                    await self.action()
                                }
                            }
                        }
                    })
                if rectangleHeight > 50{
                    ProgressView()
                }
            }
            .frame(height: rectangleHeight, alignment: .center)
            
        }
        .frame(height: rectangleHeight, alignment: .center)
    }
}

