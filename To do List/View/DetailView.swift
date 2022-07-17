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
    
    var body: some View {
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
                .onAppear {
                    self.content = item.content
                }
        }
        .navigationBarTitle("Edit to do", displayMode: .inline)
        .navigationBarItems(trailing: trailing)
    }
    
    // Update to do button
    var trailing: some View {
        Button {
            // Update data
            let parameters: [String: Any] = ["content": content, "isCompleted": item.isCompleted]
            viewModel.updatePost(idUpdate: item.id, paramaters: parameters)
            presentationMode.wrappedValue.dismiss()
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
