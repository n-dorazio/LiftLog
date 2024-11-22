import SwiftUI

struct MealCard: View {
    let mealType: String
    let calories: String
    let time: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(mealType)
                    .font(.headline)
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(calories)
                .font(.subheadline)
                .foregroundColor(.orange)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
