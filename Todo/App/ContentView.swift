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
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                
                //MARK: - Main View
                
                VStack {
                    //MARK: - Header
                    HStack(alignment: .center, spacing: 10, content: {
                        //Title
                        Text("Todo")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .padding(.leading,4)
                        Spacer()
                        
                        //Edit Button
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal,15)
                            .padding(.vertical, 6)
                            .background(Capsule().stroke(lineWidth: 2.0))
                        
                        //Appearance Button
                        Button(action: {
                            isDarkMode.toggle()
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 32, height:32)
                                .font(.system(.title, design: .rounded))
                        })
                        
                    })//HSTACK
                    .padding()
                    .foregroundColor(.white)
                    
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
            .navigationBarHidden(true)
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
