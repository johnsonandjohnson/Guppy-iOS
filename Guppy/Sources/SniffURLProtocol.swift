//
//  SniffURLProtocol.swift
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

import Foundation

public class SniffURLProtocol: URLProtocol, URLSessionDataDelegate, URLSessionTaskDelegate {
    
    private static let key = String(describing: SniffURLProtocol.self)
    private var dataTask: URLSessionDataTask!
    
    var session: NSURLConnection!
    var response: URLResponse?
    var responseData: Data?
    var requestData: Data?
    
    override public class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: SniffURLProtocol.key, in: request) != nil {
            return false
        }
        
        return true
    }
    
    override public init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)
        
        if let httpStream = request.httpBodyStream {
            
            // TODO: Is there a better way to handle bufferSize? Is 4096 enough?
            let bufferSize = 4096
            var buffer = Array<UInt8>(repeating: 0, count: bufferSize)
            
            httpStream.open()
            let bytesRead = httpStream.read(&buffer, maxLength: bufferSize)
            let data = NSData(bytes: &buffer, length: bytesRead)
            
            requestData = data as Data
        }
    }

    
    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override public func startLoading() {
        URLProtocol.setProperty("true", forKey: SniffURLProtocol.key, in: request as! NSMutableURLRequest)
        
        // TODO: Going to be creating a lot of URL Sessions abstract this out
        let urlSession: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        dataTask = urlSession.dataTask(with: request)
        dataTask.resume()
    }
    
    override public func stopLoading() {
        dataTask.cancel()

        guard let url = request.url else {
            assertionFailure("Invalid url")
            return
        }

        let networkData = NetworkData(domain: url.absoluteString, date: Date(), request: request, response: response, responseData: responseData, requestData: requestData)
        Guppy.shared.log(networkData)

        response = nil
        dataTask = nil
        responseData = nil
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                           didReceive response: URLResponse,
                           completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        self.response = response
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)

        // If the response data is large, it may come back in multiple chunks
        if responseData == nil {
            responseData = data
        } else {
            responseData?.append(data)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
}
