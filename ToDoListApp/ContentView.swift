import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItem.name, ascending: true)], animation: .default) private var items: FetchedResults<ToDoItem>
    
    @State private var newItemName = ""
    @State private var selectedItem: ToDoItem? // Store the item being edited
    @FocusState private var isInputActive: Bool // Track focus on the TextField

    var body: some View {
        NavigationView {
            VStack {
                TextField("Add new item", text: $newItemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .focused($isInputActive) // Bind focus state
                    .onSubmit {
                        saveItem() // Save the item when pressing return
                    }

                Button(action: saveItem) {
                    Text(selectedItem == nil ? "Add Item" : "Update Item")
                        .padding()
                        .frame(maxWidth: .infinity) // Make button full width
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal) // Add padding to the button
                
                List {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Text(item.name ?? "Unnamed")
                                .onTapGesture {
                                    // Set the selected item for editing
                                    selectedItem = item
                                    newItemName = item.name ?? ""
                                    isInputActive = true // Focus on the TextField
                                }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .onTapGesture {
                    isInputActive = false // Dismiss the keyboard when tapping the list
                }
            }
            .navigationTitle("To-Do List")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                newItemName = "" // Clear the input field on appear
                selectedItem = nil // Clear selection
            }
        }
    }

    private func saveItem() {
        // If no item is selected, create a new one; otherwise, update the existing one
        if let item = selectedItem {
            item.name = newItemName
        } else {
            let newItem = ToDoItem(context: viewContext)
            newItem.name = newItemName
        }
        
        do {
            try viewContext.save()
            newItemName = ""
            selectedItem = nil // Reset selection after saving
            isInputActive = false // Dismiss the keyboard
        } catch {
            // Handle the error appropriately in a production app
            print("Error saving item: \(error)")
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(items[index])
        }
        
        do {
            try viewContext.save()
        } catch {
            // Handle the error appropriately in a production app
            print("Error deleting item: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

