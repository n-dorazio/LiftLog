 
import SwiftUI

struct GoalCard: View {
    let goal: Goal
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(goal.type)
                .font(.title2)
                .bold()
            
            Text("Reach \(String(format: "%.0f", goal.targetWeight)) lbs by \(dateFormatter.string(from: goal.deadline))")
                .font(.title3)
            
            if !goal.progress.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Progress")
                        .font(.headline)
                    ForEach(goal.progress) { progress in
                        Text("\(dateFormatter.string(from: progress.date)): \(String(format: "%.0f", progress.weight))lbs")
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
    }
}
