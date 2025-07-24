//
//  BreifingViewModel.swift
//  john-task-mobile
//
//  Created by Milo Woodman on 7/23/25.

import Foundation
import UIKit

class BriefingViewModel: ObservableObject {
    private static let ENDPOINT: URL = URL(string: "http://localhost:3000/daily-brief")!;
    
    @Published var briefs: [DailyBrief] = [];
    @Published var images: [UIImage?] = [];
    @Published var requestError: (any Error)?;
    @Published var loaded: Bool = false;
    @Published var storyIndex: Int = 0;
    
    func retrieveBriefs() {
        guard !loaded || requestError != nil else {
            return;
        }
        
        self.requestError = nil;
        
        let req = URLRequest(url: BriefingViewModel.ENDPOINT);
        
        let dataTask = URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
                self.requestError = error;
                
                print("[⚠️ BriefingViewModel::retrieveBriefs] request error: ", error);
                
                self.loaded = true;
                
                return;
            }
            
            guard let response = response as? HTTPURLResponse else {
                self.loaded = true;
                
                return;
            }
            
            if response.statusCode == 200 {
                guard let data = data else {
                    self.loaded = true;
                    
                    return;
                }
                
                DispatchQueue.main.async {
                    do {
                        let decodedBriefs = try JSONDecoder().decode(Array<DailyBrief>.self, from: data);
                        self.briefs = decodedBriefs;
                    } catch let decodeError {
                        self.requestError = decodeError;
                        
                        print("[⚠️ BriefingViewModel::retrieveBriefs] decode error: ", decodeError);
                    }
                    
                    for brief in self.briefs {
                        if let base64 = brief.inlineImage {
                            guard let bytes = Data(base64Encoded: base64),
                                  let image = UIImage(data: bytes) else {
                                self.images.append(nil);
                                
                                continue;
                            };
                            
                            self.images.append(image);
                        }
                    }
                    
                    self.loaded = true;
                }
            }
        }
        
        dataTask.resume();
    }
}
