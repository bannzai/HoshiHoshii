import SwiftUI

public struct RepositoryCard: View {
    let fragment: RepositoryCardFragment

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .center, spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    Text(fragment.name)
                        .font(.system(size: 17))
                        .foregroundColor(Color(red: 1, green: 1, blue: 1))

                    if fragment.usesCustomOpenGraphImage, let imageURL = fragment.openGraphImageUrl {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 44, height: 22)
                            case _:
                                ProgressView()
                            }
                        }
                    }
                }
                Spacer()
                StarButton(fragment: fragment.fragments.starButtonFragment)
            }
            .frame(maxWidth: .infinity)
            if let description = fragment.description {
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 1, green: 1, blue: 1))
            }
        }
        .padding(.all, 16)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(red: 0.30980393290519714, green: 0.30980393290519714, blue: 0.30980393290519714))
        .onTapGesture {
            UIApplication.shared.open(fragment.url)
        }
    }
}

extension RepositoryCardFragment: Identifiable {

}
