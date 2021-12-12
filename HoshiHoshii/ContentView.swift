import SwiftUI

public struct ContentView: View {
    public var body: some View {
        KojikiPage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
