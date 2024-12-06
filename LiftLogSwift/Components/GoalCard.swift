import SwiftUI

struct GoalCard: View {
    let goal: Goal
    @Binding var goals: [Goal]
    @State private var showEditSheet = false
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with goal type, name and deadline
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.type)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(goal.name)
                        .font(.title2)
                        .bold()
                    Text(dateFormatter.string(from: goal.deadline))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    showEditSheet = true
                }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
            }
            
            // Target with units
            HStack(spacing: 4) {
                Image(systemName: "target")
                    .foregroundColor(.orange)
                Text("Target: \(String(format: "%.1f", goal.targetWeight)) \(goal.unit)")
                    .font(.headline)
            }
            
            // Notes if they exist
            if !goal.notes.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)
                        .foregroundColor(.orange)
                    Text(goal.notes)
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            
            // Progress section with units
            if !goal.progress.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Progress")
                        .font(.headline)
                        .foregroundColor(.orange)
                    ForEach(goal.progress) { progress in
                        HStack {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                                .foregroundColor(.orange)
                            Text("\(dateFormatter.string(from: progress.date))")
                            Text("\(String(format: "%.1f", progress.weight)) \(goal.unit)")
                                .bold()
                        }
                        .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.1), radius: 10)
        )
        .padding(.horizontal)
        .sheet(isPresented: $showEditSheet) {
            EditGoalView(goal: goal, goals: $goals)
        }
    }
}
