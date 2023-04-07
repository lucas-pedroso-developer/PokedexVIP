import Foundation

public struct Pokemons : Model {
    var count : Int?
    var next : String?
    var previous : String?
    var results : [Results]?

    public init(count: Int?, next: String, previous: String, results: [Results]?) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}
