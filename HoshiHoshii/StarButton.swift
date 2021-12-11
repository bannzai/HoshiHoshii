import SwiftUI

public struct StarButton: View {
    public var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundColor(Color(red: 0.7686274647712708, green: 0.7686274647712708, blue: 0.7686274647712708))
        }
        .padding(.all, 8)
        .background(Color(red: 0.30980393290519714, green: 0.30980393290519714, blue: 0.30980393290519714))
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 1, green: 1, blue: 1), lineWidth: 1))
    }
}


