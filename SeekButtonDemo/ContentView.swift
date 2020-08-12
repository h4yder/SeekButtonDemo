//
//  ContentView.swift
//  SeekButtonDemo
//
//  Created by Hayder Al-Husseini on 11/08/2020.
//  Copyright © 2020 kodeba•se ltd.
//
//  See LICENSE.md for licensing information.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SeekButton { interval in
            print("Seek by \(interval)")
        }.frame(width: 64, height: 64)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
