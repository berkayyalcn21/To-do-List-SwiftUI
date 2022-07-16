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

struct ListView: View {
    
    let item: PostModel
    
    var body: some View {
        NavigationLink(destination: DetailView(item: item)) {
            Title
        }
    }
    
    var Title: some View {
        Text(item.content).font(.title2)
    }
}

struct HomeView: View {
    @StateObject var viewModel = ViewModel()
    @State var isPresentedNewTodo = false
    @State var content = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.id) { item in
                    HStack {
                        Button {
                            if item.isCompleted {
                                let paramaters: [String: Any] = ["content": item.content, "isCompleted": false]
                                viewModel.updatePost(idUpdate: item.id, paramaters: paramaters)
                            }else {
                                let paramaters: [String: Any] = ["content": item.content, "isCompleted": true]
                                viewModel.updatePost(idUpdate: item.id, paramaters: paramaters)
                            }
                            
                        } label: {
                            if item.isCompleted{
                                Image(systemName: "checkmark.square.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)
                            }else {
                                Image(systemName: "checkmark.square")
                                    .imageScale(.large)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 40)
                        .contentShape(Rectangle())

                        
                        NavigationLink {
                            DetailView(item: item)
                                .environmentObject(viewModel)
                        } label: {
                            Text(item.content).font(.title2)
                        }
                    }
                    
                }.onDelete(perform: deletePost)
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle("Todos")
            .navigationBarItems(trailing: plusButton)
        }
        .sheet(isPresented: $isPresentedNewTodo) {
            NewTodosView(isPresented: $isPresentedNewTodo, content: $content)
                .environmentObject(viewModel)
        }
    }
    
    private func deletePost(indexSet: IndexSet) {
        let id = indexSet.map { viewModel.items[$0].id }
        DispatchQueue.main.async {
            self.viewModel.items.remove(atOffsets: indexSet)
            let parameters: [String: Any] = ["id": id[0]]
            self.viewModel.deletePost(idDelete: id[0], paramaters: parameters)
            self.viewModel.fetchPosts()
        }
    }
    
    var plusButton : some View {
        Button {
            isPresentedNewTodo.toggle()
        } label: {
            Image(systemName: "plus")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
