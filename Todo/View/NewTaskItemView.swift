//
//  NewTaskItemView.swift
//  Todo
//
//  Created by Dayal, Utkarsh on 26/05/21.
//

import SwiftUI

struct NewTaskItemView: View {
    //MARK: - Properties
    private var isButtonDisabled : Bool{
        task.isEmpty
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var task: String = ""
    
    @Binding var isShowing: Bool
    
    //MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            Spacer()
            //New Task + Save Button
            VStack(alignment: .center, spacing: 16, content: {
                TextField("New Task", text: $task)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                
                Button(action: {
                    addItem()
                }, label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                })
                .padding()
                .background(isButtonDisabled ? Color.gray : Color.pink)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(isButtonDisabled)
                
            })//VSTACK
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.7), radius: 24, x: 3, y: 3)
            .frame(maxWidth: 640)
        })//VSTACK
        .padding()
    }
    
    //MARK: - Functions
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.id = UUID()
            newItem.completion = false
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
            isShowing = false
        }
    }

}

//MARK: - Preview
struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
    }
}
