//
//  DetailView.swift
//  To do List
//
//  Created by Berkay on 14.07.2022.
//

import SwiftUI

struct DetailView: View {
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
                    self.content = item.content ?? ""
                }
        }
        .navigationBarTitle("Edit to do", displayMode: .inline)
        .navigationBarItems(trailing: trailing)
    }
    
    var trailing: some View {
        Button {
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
