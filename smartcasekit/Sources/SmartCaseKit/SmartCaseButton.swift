//
//  SmartCaseButton.swift
//  SmartCaseKit
//
//  Copyright (c) Bragi GmbH. All rights reserved.
//

import Foundation
import Observation

/// A smart case button: an image index plus a background color
@Observable public class SmartCaseButton: Identifiable, Codable, CustomStringConvertible {
    /// The local model identifier, used for identity, equality, and hashing.
    ///
    /// This UUID is not transmitted over Bluetooth and is not the button's
    /// protocol index. Refreshing the device's buttons creates new models
    /// with new UUIDs.
    public var id: UUID
    
    /// An application-defined name for the button. Defaults to an empty string.
    ///
    /// This value is local metadata and is not read from or sent to the
    /// smart case over Bluetooth.
    public var name: String
    
    /// A textual representation of the button for logging and debugging.
    public var description: String { "SmartCaseButton(id: \(id), name: \"\(name)\", imageIndex: \(imageIndex), red: \(backgroundRed), green: \(backgroundGreen), blue: \(backgroundBlue))" }
    
    /// The zero-based index of an image available on the smart case.
    ///
    /// Valid indices depend on the device's image collection.
    /// The supplied sample apps use indices 0 through 15.
    /// Defaults to 0.
    public var imageIndex: UInt8
    
    /// The red background component, from 0 (none) to 255 (full intensity).
    ///
    /// Defaults to 32. Divide by 255.0 when using APIs that expect
    /// a normalized color component between 0.0 and 1.0.
    public var backgroundRed: UInt8
    
    /// The green background component, from 0 (none) to 255 (full intensity).
    ///
    /// Defaults to 32. Divide by 255.0 when using APIs that expect
    /// a normalized color component between 0.0 and 1.0.
    public var backgroundGreen: UInt8
    
    /// The blue background component, from 0 (none) to 255 (full intensity).
    ///
    /// Defaults to 32. Divide by 255.0 when using APIs that expect
    /// a normalized color component between 0.0 and 1.0.
    public var backgroundBlue: UInt8
    
    /// Creates a local button model without communicating with a smart case.
    ///
    /// - Parameters:
    ///   - id: The local model identifier. Defaults to a new UUID.
    ///   - name: An application-defined name. Defaults to an empty string.
    ///   - imageIndex: The device image index. Defaults to 0.
    ///   - backgroundRed: The red component, from 0 to 255. Defaults to 32.
    ///   - backgroundGreen: The green component, from 0 to 255. Defaults to 32.
    ///   - backgroundBlue: The blue component, from 0 to 255. Defaults to 32.
    public init(
        id: UUID = UUID(),
        name: String = "",
        imageIndex: UInt8 = 0,
        backgroundRed: UInt8 = 32,
        backgroundGreen: UInt8 = 32,
        backgroundBlue: UInt8 = 32
    ) {
        self.id = id
        self.name = name
        self.imageIndex = imageIndex
        self.backgroundRed = backgroundRed
        self.backgroundGreen = backgroundGreen
        self.backgroundBlue = backgroundBlue
    }

    enum CodingKeys: String, CodingKey {
        case id, name, imageIndex, backgroundRed, backgroundGreen, backgroundBlue
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageIndex = try container.decode(UInt8.self, forKey: .imageIndex)
        backgroundRed = try container.decode(UInt8.self, forKey: .backgroundRed)
        backgroundGreen = try container.decode(UInt8.self, forKey: .backgroundGreen)
        backgroundBlue = try container.decode(UInt8.self, forKey: .backgroundBlue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageIndex, forKey: .imageIndex)
        try container.encode(backgroundRed, forKey: .backgroundRed)
        try container.encode(backgroundGreen, forKey: .backgroundGreen)
        try container.encode(backgroundBlue, forKey: .backgroundBlue)
    }
}

extension SmartCaseButton: Equatable {
    public static func == (lhs: SmartCaseButton, rhs: SmartCaseButton) -> Bool {
        lhs.id == rhs.id
    }
}

extension SmartCaseButton: Hashable {
    public func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
    }
}
