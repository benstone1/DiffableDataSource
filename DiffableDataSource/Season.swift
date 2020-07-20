import Foundation

struct Season: Hashable {
    var episodes: [Episode]
    let number: Int
    static func getSeasons(fromEpisodes episodes: [Episode]) -> [Season] {
        var fetchedSeasons = seasonNumbers(from: episodes)
            .map { Season(episodes: [], number: $0) }
            .sorted(by: { $0.number < $1.number })

        for episode in episodes {
            guard let matchingSeason = fetchedSeasons.first(where: { $0.number == episode.season } ),
                  let seasonIndex = fetchedSeasons.firstIndex(of: matchingSeason) else {
                continue
            }
            fetchedSeasons[seasonIndex].episodes.append(episode)
        }

        return fetchedSeasons.map { season in
            Season(episodes: season.episodes.sorted { $0.number < $1.number }, number: season.number)
        }
    }
    static private func seasonNumbers(from episodes: [Episode]) -> [Int] {
        var seasonNumbers = Set<Int>()
        for episode in episodes {
            seasonNumbers.insert(episode.season)
        }
        return seasonNumbers.map { $0 }
    }
}
