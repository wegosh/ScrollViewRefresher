//
//  SwiftUIView.swift
//
//
//  Created by Patryk Węgrzyński on 27/01/2023.
//

import SwiftUI

@available(iOS 14, *)
struct ScrollViewRefresher: View {
    @Binding var refreshing: Bool
    let action: () async -> Void
    @State private var rectangleHeight: CGFloat = 0
    @State private var initialLocation: CGFloat = 0
    @State private var currentLocation: CGFloat = 0
    
    var body: some View {
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
    
    func action() async{
        //TODO: Implement async action that will refresh the view, update refreshing once finished
        do{
            // Delay the task to simulate API call or some other action
            try await Task.sleep(nanoseconds: 5_000_000_000)
            await MainActor.run{
                // Once task is finished update the refreshing state
                self.refreshing = false
            }
        } catch {
            // TODO: Handle error
            print(error.localizedDescription)
        }
    }
}

