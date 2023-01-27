# ScrollViewRefresher

## Easy SwiftUI 2.0 Scroll View Refresher

### Usage

``````swift
struct Content: View{
    @State private var refreshing: Bool = false
    var body: some View{
        ScrollView{
            VStack{
                ScrollViewRefresher(refreshing: $refreshing, action: action)
                ForEach(0..<10, id: \.self){item in
                    Text("Item: \(item)")
                }
            }
        }
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

``````

