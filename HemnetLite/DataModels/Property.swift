import Foundation

struct Property: Codable {
    let type: Kind
    let id: String
    let askingPrice: String?
    let averagePrice: String?
    let monthlyFee: String?
    let municipality: String?
    let area: String
    let rating: String?
    let daysOnHemnet: Int?
    let livingArea: Float?
    let numberOfRooms: Int?
    let streetAddress: String?
    let image: URL

    enum Kind: String, Codable {
        case highlighted = "HighlightedProperty"
        case property = "Property"
        case area = "Area"
    }
}
