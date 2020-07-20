//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by Benjamin Stone on 7/20/20.
//  Copyright © 2020 Benjamin Stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    class EpisodeTableViewDiffableDataSource: UITableViewDiffableDataSource<Season, Episode> {
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Season \(section + 1)"
        }
    }
    
    @IBOutlet var episodesTableView: UITableView!
        
    var seasons = [Season]() {
        didSet {
            updateTableView()
        }
    }
    
    var dataSource: EpisodeTableViewDiffableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadData()
    }
    
    func loadData() {
        let fetchingService = BundleFetchingService<Episode>()
        let episodes = fetchingService.getArray(from: "officeEpisodes", ofType: "json")
        let seasons = Season.getSeasons(fromEpisodes: episodes)
        self.seasons = seasons
    }
    
    func configureTableView() {
        episodesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "episodeCell")
        configureDataSource()
    }
    
    func configureDataSource() {
        dataSource = EpisodeTableViewDiffableDataSource(tableView: episodesTableView, cellProvider: { (tableView, indexPath, episode) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath)
            cell.textLabel?.text = episode.name
            return cell
        })
        episodesTableView.dataSource = dataSource
    }
    
    func updateTableView() {
        var snapshot = NSDiffableDataSourceSnapshot<Season, Episode>()
        snapshot.appendSections(seasons)
        for season in seasons {
            snapshot.appendItems(season.episodes, toSection: season)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

