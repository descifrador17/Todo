//
//  ContentView.swift
//  Todo
//
//  Created by Dayal, Utkarsh on 26/05/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - Properties
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false

    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                
                //MARK: - Main View
                
                VStack {
                    //MARK: - Header
                    Spacer(minLength: 80)
                    
                    //MARK: - New Task Button
                    Button(action: {
                        showNewTaskItem = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(backgroundGradient.clipShape(Capsule()))
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12, x: 3, y: 3)
                    
                    //MARK: - Todo List
                    List {
                        ForEach(items) { item in
                            
                            //Item
                            VStack(alignment: .leading, spacing: 3, content: {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            })//VSTACK
                        }
                        .onDelete(perform: deleteItems)
                    }//LIST
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12, x: 3, y: 3)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                }//VSTACK
                
                //MARK: - New Task Item View
                if showNewTaskItem{
                    BlankView()
                        .onTapGesture {
                            withAnimation(){
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
            }//ZSTACK
            .onAppear(){
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Text("ToDo")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .scaleEffect(1.2, anchor: .leading)
                }
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing){
                    EditButton()
                }
                #endif
            }//TOOLBAR
            .background(BackgroundImageView())
            .background(backgroundGradient.ignoresSafeArea(.all))
        }//NAVIGATION
        .navigationViewStyle(StackNavigationViewStyle())
    }

    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
