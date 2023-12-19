//
//  PerfomanceView.swift
//  FirebaseSwiftUI
//
//  Created by Fedotov Aleksandr on 19.12.2023.
//

import SwiftUI
import FirebasePerformance
import FirebasePerformanceTarget

final class PerfomanceManager {
    static let shared = PerfomanceManager()
    private init() { }
 
    private var traces: [String: Trace] = [:]
    func startTrace(name: String) {
       let trace =  Performance.startTrace(name: name)
        traces[name] = trace
    }
    func setValue(name: String, value: String, forAttribute: String) {
        guard let trace = traces[name] else { return }
        trace.setValue(value, forAttribute: forAttribute)
    }
    func stopTrace(name: String) {
        guard let trace = traces[name] else { return }
        trace.stop()
        traces.removeValue(forKey: name)
    }
}


struct PerfomanceView: View {
    @State private var title: String = "Some title"
//    @State private var trace: Trace? = nil
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
                configure()
                downloadProductsAndUploadToFirebase()
                PerfomanceManager.shared.startTrace(name: "performance_screen_time")
//                self.trace = Performance.startTrace(name: "performance_screen_time")
            }
            .onDisappear {
                PerfomanceManager.shared.stopTrace(name: "performance_screen_time")
//                self.trace?.stop()
            }
    }
    private func configure() {
        PerfomanceManager.shared.startTrace(name: "performance_screen_time")
//        trace?.setValue(title, forAttribute: "title_text")
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerfomanceManager.shared.setValue(name: "performance_screen_time", value: "Started down", forAttribute: "func state")
//            trace?.setValue(title, forAttribute: "func state")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerfomanceManager.shared.setValue(name: "performance_screen_time", value: "Finished down", forAttribute: "func state")
//            trace?.setValue("continued downloding", forAttribute: "func state")
           
//            trace?.setValue("finished downloding", forAttribute: "func state")
            
        }
        
    }
    func downloadProductsAndUploadToFirebase() {
        // https://dummyjson.com/products
        let urlString = "https://dummyjson.com/products"
        guard let url = URL(string: urlString), let  metric = HTTPMetric(url: url, httpMethod: .get) else { return }
        metric.start()
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let response = response as? HTTPURLResponse {
                    metric.responseCode = response.statusCode
                }
                metric.stop()
                print("SUCCESS")
            } catch {
                print(error)
                metric.stop()
            }
        }
    }
}

#Preview {
    PerfomanceView()
}
