//
//  ViewController.swift
//
//  Copyright © 2019 Johnson & Johnson
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import Guppy

class ViewController: UIViewController {

    @IBAction private func getRequestPressed() {
        let url = URL(string: "http://api.github.com/users")!

        URLSession.shared.dataTask(with: url) { _, response, error in
            if let error = error {
                print(error)
            } else {
                print(response!)
            }
        }.resume()
    }

    @IBAction private func postRequestPressed() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try! JSONSerialization.data(withJSONObject: ["key": "value"])

        urlRequest.httpBody = jsonData

        URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            if let error = error {
                print(error)
            } else {
                print(response!)
            }
        }.resume()
    }

    @IBAction private func putRequestPressed() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try! JSONSerialization.data(withJSONObject: ["key": "value"])

        urlRequest.httpBody = jsonData

        URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            if let error = error {
                print(error)
            } else {
                print(response!)
            }
        }.resume()
    }

    @IBAction private func deleteRequestPressed() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try! JSONSerialization.data(withJSONObject: ["key": "value"])

        urlRequest.httpBody = jsonData

        URLSession.shared.dataTask(with: urlRequest) { _, response, error in
            if let error = error {
                print(error)
            } else {
                print(response!)
            }
        }.resume()
    }

    @IBAction private func showOnShakeToggled(_ sender: UISwitch) {
        Guppy.shared.showOnShake = sender.isOn
    }

    @IBAction private func openGuppy() {
        Guppy.shared.presentLogViewController()
    }
}
