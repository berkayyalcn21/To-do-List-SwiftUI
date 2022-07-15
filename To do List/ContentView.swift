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

                }
            }
            .listStyle(InsetListStyle())
            .navigationBarTitle("Todos")
            .navigationBarItems(trailing: plusButton)
        }
        .sheet(isPresented: $isPresentedNewTodo) {
            NewTodosView(isPresented: $isPresentedNewTodo, content: $content)
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
