# ScrollViewRefresher

## Lightweight and easy SwiftUI 2.0 Scroll View Refresher

### Usage

``````swift
struct Content: View{
    var body: some View{
        ScrollView{
            VStack{
                ScrollViewRefresher(action: action)
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
            try? await Task.sleep(for: .seconds(2))      
        } catch {             
            // TODO: Handle error   
            print(error.localizedDescription)         
        }
    }
}

``````

