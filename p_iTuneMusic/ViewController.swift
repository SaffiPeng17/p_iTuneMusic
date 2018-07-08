//
//  ViewController.swift
//  p_iTuneMusic
//
//  Created by Saffi on 2018/7/8.
//  Copyright © 2018 Saffi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Button events
    @IBAction func buttonTouched(_ sender: Any) {
        fetchAPI(searchStr: "蕭敬騰") { tracks in
            for track in tracks {
                print(track)
            }
        }
    }

    //MARK: functions
    /**
     post API

     - Parameters:
        - searchStr: request parameters
        - result: API response result
     */
    func fetchAPI(searchStr: String, result: @escaping ([Track]) -> Void) {
        let urlstr = "https://itunes.apple.com/search?term=\(searchStr)&media=music"
        let url = URL(string: urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let data = data, let tracks = try? decoder.decode(TrackData.self, from: data) {
                result(tracks.results)
                print(tracks.resultCount)
            } else {
                result([])
            }
        }
        task.resume()
    }
}

