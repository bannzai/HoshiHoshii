import SwiftUI

public struct UserProfile: View {
    let fragment: UserProfileFragment
    
    public var body: some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(url: fragment.avatarUrl) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 66, height: 66)
                        .foregroundColor(Color(red: 1, green: 1, blue: 1, opacity: 0.20000000298023224))
                        .background(Color(red: 1, green: 1, blue: 1, opacity: 0.20000000298023224))
                        .cornerRadius(33)
                        .overlay(RoundedRectangle(cornerRadius: 33).stroke(Color(red: 0, green: 0, blue: 0), lineWidth: 3))
                case _:
                    ProgressView()
                }
            }
            VStack(alignment: .leading, spacing: 7) {
                Text(fragment.login)
                    .font(.system(size: 24))
                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
                if let name = fragment.name {
                    Text(name)
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.7411764860153198, green: 0.7411764860153198, blue: 0.7411764860153198))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            UIApplication.shared.open(fragment.url)
        }
    }
}

