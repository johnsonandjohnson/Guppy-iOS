//
//  GuppyURLProtocol.swift
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

public class GuppyURLProtocol: URLProtocol {
    
    private static let key = String(describing: GuppyURLProtocol.self)
    private var dataTask: URLSessionDataTask!
    
    var requestId: UUID?
    var response: URLResponse?
    var responseData: Data?
    var requestData: Data?

    override public class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: GuppyURLProtocol.key, in: request) != nil {
            return false
        }
        
        return true
    }
    
    override public init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
        super.init(request: request, cachedResponse: cachedResponse, client: client)

        requestData = request.httpBody ?? request.httpBodyStream.flatMap { stream in
            let data = NSMutableData()
            stream.open()
            while stream.hasBytesAvailable {
                var buffer = [UInt8](repeating: 0, count: 1024)
                let length = stream.read(&buffer, maxLength: buffer.count)
                data.append(buffer, length: length)
            }
            stream.close()
            return data as Data
        }
    }

    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override public func startLoading() {
        URLProtocol.setProperty(true, forKey: GuppyURLProtocol.key, in: request as! NSMutableURLRequest)

        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        dataTask = urlSession.dataTask(with: request)
        dataTask.resume()
        
        requestId = UUID()
        if let url = request.url, let requestId = requestId {
            let networkData = NetworkData(id: requestId,
                                          domain: url.absoluteString,
                                          date: Date(),
                                          request: request,
                                          response: response,
                                          responseData: responseData,
                                          requestData: requestData,
                                          isRequestComplete: false)
            Guppy.shared.log(networkData)
        }
        
        urlSession.finishTasksAndInvalidate()
    }
    
    override public func stopLoading() {
        dataTask.cancel()
        
        if let matchingIndex = Guppy.shared.logItems
            .firstIndex(where: { ($0 as? NetworkData)?.id == requestId }),
           var networkData = Guppy.shared.logItems[matchingIndex] as? NetworkData {
            networkData.response = response
            networkData.responseData = responseData
            networkData.isRequestComplete = true
            Guppy.shared.logItems[matchingIndex] = networkData
        }

        requestId = nil
        response = nil
        dataTask = nil
        responseData = nil
    }
}

extension GuppyURLProtocol: URLSessionTaskDelegate {
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
}

extension GuppyURLProtocol: URLSessionDataDelegate {
    
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
}
