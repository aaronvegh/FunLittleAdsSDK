//
//  Tester.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-06-02.
//

import SwiftUI

class ViewController: ObservableObject {
    var timer: Timer?
    var containerView = ContainerView()
    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in
            self.updateViews()
        })
    }
    func updateViews() {
        objectWillChange.send()
    }
}

struct ContainerView: View {
    @EnvironmentObject var viewController: ViewController
    var body: some View {
        Text("\(Date().timeIntervalSince1970)")
    }
}

struct ContentView: View {
    @StateObject var viewController = ViewController()
    var body: some View {
        viewController.containerView
            .environmentObject(viewController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
