import SwiftUI

public struct StarButton: View {
    let fragment: StarButtonFragment
    @Environment(\.apollo) var apollo

    @State var error: Error?

    public var body: some View {
        Button(action: {
            Task {
                do {
                    _ = try await apollo.perform(mutation: StarMutation(repositoryID: fragment.repositoryId))
                } catch {
                    self.error = error
                }
            }
        }, label: {
            HStack(alignment: .center, spacing: 4) {
                if fragment.viewerIsGod {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(red: 0.9490196108818054, green: 0.7882353067398071, blue: 0.2980392277240753))
                } else {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(red: 0.7686274647712708, green: 0.7686274647712708, blue: 0.7686274647712708))
                }
            }
            .padding(.all, 8)
            .background(Color(red: 0.30980393290519714, green: 0.30980393290519714, blue: 0.30980393290519714))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(red: 1, green: 1, blue: 1), lineWidth: 1))
        }).handle(error: $error)
    }
}


