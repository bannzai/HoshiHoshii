import SwiftUI

public struct RepositoryCard: View {
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    Text("Gedatsu")
                        .font(.system(size: 17))
                        .foregroundColor(Color(red: 1, green: 1, blue: 1))
                    Image("gedatsu")
                        .resizable()
                        .frame(width: 44, height: 22)
                }
                Spacer()
                StarButton()
            }
            .frame(maxWidth: .infinity)
            Text("Gedatsu provide readable format about AutoLayout error console log")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 1, green: 1, blue: 1))
        }
        .padding(.all, 16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(red: 0.30980393290519714, green: 0.30980393290519714, blue: 0.30980393290519714))
    }
}
