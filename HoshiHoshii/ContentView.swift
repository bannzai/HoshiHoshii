import SwiftUI

public struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    public var body: some View {
        if let me = appViewModel.me {
            KojikiPage()
                .environment(\.me, .init(me: me))
        } else {
            LoginPage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
