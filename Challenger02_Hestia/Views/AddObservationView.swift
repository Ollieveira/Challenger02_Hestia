import SwiftUI
import TelemetryClient

struct AddObservationView: View {
    @FocusState private var isTextEditorFocused: Bool
    
    @Binding var isPresented: Bool
    @State var isSheet: Bool
    @State var note: String = ""
    var meal: Meal
    var viewModel: MealViewModel
    
    
    var body: some View {
        VStack {
            VStack {
                Text("Your notes!")
                    .font(.title)
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $note)
                        .focused($isTextEditorFocused)
                        .frame(width: 320, height: 192)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(5)
                    if note.isEmpty {
                        Text("Write your notes here...")
                            .foregroundColor(.gray)
                            .padding(.top, 14)
                            .padding(.leading, 12)
                    }
                    
                }
                .font(.system(.body, design: .rounded))
                
                Button(action: {
                    TelemetryManager.send("buttonPress", with: ["button": "Adicionou uma nota"])

                    viewModel.saveMealNotes(meal, notes: note)
                    isPresented = false
                    
                }, label: {
                    Text("Done")
                        .font(.title3)
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.white)
                        .frame(width: 100, height: 50)
                })
                .background(Color.tabViewCor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxWidth: .infinity, alignment: .trailing)
                
            }
            .padding(.horizontal, 36).padding(.top, isSheet ? 48 : 120)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isTextEditorFocused = false
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 44)
            .fill(Color.bgFavCardCor)
        )
        .edgesIgnoringSafeArea(.all)
    }
}

//#Preview {
//    AddObservationView(isPresented: .constant(true))
//}
