import Foundation

struct BundleFetchingService<T: Codable> {
    func getArray(from resource: String, ofType type: String) -> [T] {
        guard let pathToData = Bundle.main.path(forResource: resource, ofType: type) else {
            fatalError("Couldn't find file")
        }
        let internalURL = URL(fileURLWithPath: pathToData)
        do {
            let data = try Data(contentsOf: internalURL)
            return try JSONDecoder().decode([T].self, from: data)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    func getSingleElement(from resource: String, ofType type: String) -> T {
        fatalError("To Do")
    }
}
