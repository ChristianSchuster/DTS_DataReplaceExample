import SwiftUI

@Observable
final class MyObservableItem: Codable, Identifiable, Hashable, Equatable  {
    var id: UUID
    var order: Int
    var persistentIDString: String
    var name: String
    var colorString: String
    var currentValue: Int
    var targetValue: Int
    var lastSubmittedValue: Int
    var progress: Double
    
    enum CodingKeys: CodingKey {
        case id
        case order
        case persistentIDString
        case name
        case colorString
        case currentValue
        case targetValue
        case lastSubmittedValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MyObservableItem, rhs: MyObservableItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(id: UUID, order: Int = 0, persistentIDString: String = "", name: String, colorString: String, currentValue: Int, targetValue: Int, lastSubmittedValue: Int = 0) {
        self.id = id
        self.order = order
        self.persistentIDString = persistentIDString
        self.name = name
        self.colorString = colorString
        self.currentValue = currentValue
        self.targetValue = targetValue
        self.lastSubmittedValue = lastSubmittedValue
        self.progress = Double(currentValue) / Double(targetValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        order = try container.decode(Int.self, forKey: .order)
        persistentIDString = try container.decode(String.self, forKey: .persistentIDString)
        name = try container.decode(String.self, forKey: .name)
        colorString = try container.decode(String.self, forKey: .colorString)
        currentValue = try container.decode(Int.self, forKey: .currentValue)
        targetValue = try container.decode(Int.self, forKey: .targetValue)
        lastSubmittedValue = try container.decode(Int.self, forKey: .lastSubmittedValue)
        progress = Double(try container.decode(Int.self, forKey: .currentValue)) / Double(try container.decode(Int.self, forKey: .targetValue))
    }
    
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(order, forKey: .order)
        try container.encode(persistentIDString, forKey: .persistentIDString)
        try container.encode(name, forKey: .name)
        try container.encode(colorString, forKey: .colorString)
        try container.encode(currentValue, forKey: .currentValue)
        try container.encode(targetValue, forKey: .targetValue)
        try container.encode(lastSubmittedValue, forKey: .lastSubmittedValue)
    }
    
    func updateProgress() {
        progress = Double(self.currentValue) / Double(self.targetValue)
    }
    
    
    
}

extension MyObservableItem {
    enum sampleSize {
        case small
        case large
        case moreNumbers
    }
    static func exampleItems(_ sampleSize: MyObservableItem.sampleSize) -> [MyObservableItem] {
        switch sampleSize {
        case .small:
            return [MyObservableItem(id: UUID(), name: "Mario", colorString: Color.red.rgbaString(), currentValue: 12, targetValue: 40),
                    MyObservableItem(id: UUID(), name: "Luigi", colorString: Color.pink.rgbaString(), currentValue: 122, targetValue: 326),
                    MyObservableItem(id: UUID(), name: "Peach", colorString: Color.blue.rgbaString(), currentValue: 15, targetValue: 60)]
        case .large:
            return [MyObservableItem(id: UUID(), name: "Toad", colorString: Color.red.rgbaString(), currentValue: 4, targetValue: 58),
                    MyObservableItem(id: UUID(), name: "Mario", colorString: Color.pink.rgbaString(), currentValue: 100, targetValue: 326),
                    MyObservableItem(id: UUID(), name: "Luigi", colorString: Color.blue.rgbaString(), currentValue: 5, targetValue: 60),
                    MyObservableItem(id: UUID(), name: "Peach", colorString: Color.yellow.rgbaString(), currentValue: 56, targetValue: 160)]
        
    case .moreNumbers:
            return [MyObservableItem(id: UUID(), name: "Mario", colorString: Color.red.rgbaString(), currentValue: 14, targetValue: 64),
                    MyObservableItem(id: UUID(), name: "Luigi", colorString: Color.pink.rgbaString(), currentValue: 165, targetValue: 426),
                    MyObservableItem(id: UUID(), name: "Peach", colorString: Color.blue.rgbaString(), currentValue: 16, targetValue: 63),
                    MyObservableItem(id: UUID(), name: "Bowser", colorString: Color.yellow.rgbaString(), currentValue: 42, targetValue: 160)]
    }
        
    }
}




struct TransportMessage: Codable {
    let type: String
    let payload: [MyObservableItem]
}
