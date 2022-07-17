//
//  DetailView.swift
//  To do List
//
//  Created by Berkay on 14.07.2022.
//

import SwiftUI

// To do details page view
struct DetailView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode
    let item: PostModel
    @State var content = ""
    @State var isAlert = false
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Create new to do")
                    .font(Font.system(size: 16, weight: .bold))
                TextField("Content", text: $content)
                    .padding()
                    .background(Color.primary.colorInvert())
                    .cornerRadius(6)
                    .padding(.bottom)
                
                Spacer()
            }
                .padding()
                .onAppear {
                    self.content = item.content
                }
                .alert(isPresented: $isAlert) {
                    let title = Text("No data")
                    let message = Text("Please fill content and content must be greater than 3 ")
                    return Alert(title: title, message: message)
                }
        }
        .navigationBarTitle("Edit to do", displayMode: .inline)
        .navigationBarItems(trailing: trailing)
    }
    
    // Update to do button
    var trailing: some View {
        Button {
            // Update data
            if content.count >= 3 {
                let parameters: [String: Any] = ["content": content, "isCompleted": item.isCompleted]
                viewModel.updatePost(idUpdate: item.id, paramaters: parameters)
                presentationMode.wrappedValue.dismiss()
            }else {
                isAlert.toggle()
            }
        } label: {
            Text("Save")
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
