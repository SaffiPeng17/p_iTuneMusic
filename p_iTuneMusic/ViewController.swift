//
//  ViewController.swift
//  p_iTuneMusic
//
//  Created by Saffi on 2018/7/8.
//  Copyright © 2018 Saffi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tracksTableView: UITableView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var trackArray = [Track]()
    var images = [UIImage?]() {
        didSet {
            if trackArray.count > 0, images.count == trackArray.count {
                loadingView.isHidden = true
                activityIndicator.stopAnimating()

                DispatchQueue.main.async {
                    self.tracksTableView.reloadData()
                }
            }
        }
    }
    var player: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //點一下Keyboard以外的地方，會收起鍵盤
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    //MARK: functions
    func fetchAPI(searchStr: String, result: @escaping ([Track]) -> Void) {
        let urlstr = "https://itunes.apple.com/search?term=\(searchStr)&media=music"
        let url = URL(string: urlstr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        let task = URLSession.shared.dataTask(with: url!) { (data, response , error) in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let data = data, let tracks = try? decoder.decode(TrackData.self, from: data) {
                result(tracks.results)
            } else {
                result([])
            }
        }
        task.resume()
    }

    func getImage(url: URL, result: @escaping (Bool) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { location, response, error in
            guard location != nil else {
                print("download error:", error ?? "")
                return
            }
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.images.append(UIImage(data: data))
                }
                result(true)
            } catch {
                result(false)
                print(error)
            }
        }
        task.resume()
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    //When click the "Search" button on keyboard,
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        activityIndicator.startAnimating()
        loadingView.isHidden = false
        
        trackArray = []
        images = []
        fetchAPI(searchStr: searchBar.text!) { tracks in
            self.trackArray = tracks
            for track in tracks {
                self.getImage(url: track.artworkUrl100) { isSuccess in
//                    print(isSuccess)
                }
            }
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    //SETUP: How many rows in every section?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackArray.count
    }
    //SETUP: The view of every cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackcell", for: indexPath) as! TrackCell
        cell.albumCover.image = images[indexPath.row]
        cell.trackName.text = trackArray[indexPath.row].trackName
        cell.collectionName.text = trackArray[indexPath.row].collectionName

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        player?.pause()

        let url = trackArray[indexPath.row].previewUrl
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
    }
}


