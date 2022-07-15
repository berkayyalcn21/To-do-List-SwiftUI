//
//  NewTodosView.swift
//  To do List
//
//  Created by Berkay on 14.07.2022.
//

import SwiftUI

struct NewTodosView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var isPresented: Bool
    @Binding var content: String
    @State var isAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    Text("Create new to do")
                        .font(Font.system(size: 16, weight: .bold))
                    TextField("Content", text: $content)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(6)
                        .padding(.bottom)
                    
                    Spacer()
                }.padding()
                    .alert(isPresented: $isAlert) {
                        let title = Text("No data")
                        let message = Text("Please fill content")
                        return Alert(title: title, message: message)
                    }
            }
            .navigationBarTitle("New to do", displayMode: .inline)
            .navigationBarItems(leading: leading, trailing: trailing)
        }
    }
    
    var leading: some View {
        Button {
            isPresented.toggle()
        } label: {
            Text("Cancel")
        }

    }
    
    var trailing: some View {
        Button {
            if content != "" {
                let parameters: [String: Any] = ["content": content]
                viewModel.createPost(paramaters: parameters)
                viewModel.fetchPosts()
                isPresented.toggle()

            }else {
                isAlert.toggle()
            }
        } label: {
            Text("Add")
        }

    }
}

//struct NewTodosView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewTodosView()
//    }
//}
