import SwiftUI

struct MealCard: View {
    let meal: Meal
    let onDelete: () -> Void
    let onEdit: () -> Void
    @State private var showNotes = false
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(meal.title)
                        .font(.title2)
                        .bold()
                    Text(timeFormatter.string(from: meal.time))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Edit Button
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("\(meal.calories) kcal")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            
            // Macros
            HStack(spacing: 12) {
                MacroView(value: Int(meal.protein), unit: "P")
                MacroView(value: Int(meal.carbs), unit: "C")
                MacroView(value: Int(meal.fats), unit: "F")
            }
            
            if !meal.description.isEmpty {
                Button(action: { showNotes.toggle() }) {
                    HStack {
                        Text("Notes")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                        Image(systemName: showNotes ? "chevron.up" : "chevron.down")
                            .foregroundColor(.gray)
                    }
                }
                
                if showNotes {
                    Text(meal.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.1), radius: 10)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct MacroView: View {
    let value: Int
    let unit: String
    
    var body: some View {
        HStack(spacing: 2) {
            Text("\(value)")
                .fontWeight(.medium)
            Text(unit)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
