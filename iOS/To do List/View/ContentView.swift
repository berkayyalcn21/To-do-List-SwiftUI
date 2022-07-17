//
//  ContentView.swift
//  To do List
//
//  Created by Berkay on 14.07.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
    }
}

// To do list home page view
struct HomeView: View {
    @StateObject var viewModel = ViewModel()
    @State var isPresentedNewTodo = false
    @State var content = ""
    
    var body: some View {
        NavigationView {
            if viewModel.items.isEmpty && viewModel.isLoding {
                ProgressView()
            }else {
                List {
                    ForEach(viewModel.items, id: \.id) { item in
                        ListRow(item: item)
                        // scroll and delete
                    }.onDelete(perform: deletePost)
                }
                .listStyle(InsetListStyle())
                .navigationBarTitle("Todos")
                .navigationBarItems(trailing: plusButton)
                .sheet(isPresented: $isPresentedNewTodo) {
                    NewTodosView(isPresented: $isPresentedNewTodo, content: $content)
                        .environmentObject(viewModel)
                }
            }   
        }
    }

    // Delete post func
    private func deletePost(indexSet: IndexSet) {
        let id = indexSet.map { viewModel.items[$0].id }
        DispatchQueue.main.async {
            self.viewModel.items.remove(atOffsets: indexSet)
            let parameters: [String: Any] = ["id": id[0]]
            self.viewModel.deletePost(idDelete: id[0], paramaters: parameters)
        }
    }
    
    // Create To do button
    var plusButton : some View {
        Button {
            isPresentedNewTodo.toggle()
        } label: {
            Image(systemName: "plus")
        }
        
    }
    
    @ViewBuilder
    func ListRow(item: PostModel) -> some View {
        HStack {
            // Check completed or not completed button
            Button {
                let parameters: [String: Any] = ["content": item.content, "isCompleted": !item.isCompleted]
                viewModel.updatePost(idUpdate: item.id, paramaters: parameters)
                
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.square.fill" : "checkmark.square")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 40)
            .contentShape(Rectangle())
            
            // Todos rows
            NavigationLink {
                DetailView(item: item)
                    .environmentObject(viewModel)
            } label: {
                
                Group {
                    if item.isCompleted {
                        Text(item.content).strikethrough().opacity(0.4)
                    }
                    else { Text(item.content) }
                }.font(.title2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
