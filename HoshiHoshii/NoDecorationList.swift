import SwiftUI

struct NoDecorationList<Content: View>: View {
    @Environment(\.refresh) var refresh
    @ViewBuilder let content: () -> Content

    var body: some View {
        if let refresh = refresh {
            _body
                .refreshable {
                    await refresh()
                }
        } else {
            _body
        }
    }

    private var _body: some View {
        List {
            content()
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
    }
}
