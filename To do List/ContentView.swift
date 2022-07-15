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

struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var isPresentedNewTodo = false
    @State var content = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items, id: \.id) { item in
                    NavigationLink(
                    destination: DetailView(item: item),
                    label: {
                        Text(item.content).font(.title2)
                    })

                }.onDelete(perform: deletePost)
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle("Todos")
            .navigationBarItems(trailing: plusButton)
        }
        .sheet(isPresented: $isPresentedNewTodo) {
            NewTodosView(isPresented: $isPresentedNewTodo, content: $content)
        }
    }
    
    private func deletePost(indexSet: IndexSet) {
        let id = indexSet.map { viewModel.items[$0].id }
        DispatchQueue.main.async {
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
