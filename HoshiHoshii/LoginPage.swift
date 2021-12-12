import SwiftUI

public struct LoginPage: View {
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
                .frame(height: 10)
            HStack(alignment: .center, spacing: 10) {
                Text("GitHub でログイン")
                    .font(.system(size: 17))
                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 1, green: 1, blue: 1), lineWidth: 1))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
