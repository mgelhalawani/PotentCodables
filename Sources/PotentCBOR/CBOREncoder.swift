//
//  CBOREncoder.swift
//  PotentCodables
//
//  Copyright © 2021 Outfox, inc.
//
//
//  Distributed under the MIT License, See LICENSE for details.
//

import Foundation
import PotentCodables


/// `CBOREncoder` facilitates the encoding of `Encodable` values into CBOR values.
///
public class CBOREncoder: ValueEncoder<CBOR, CBOREncoderTransform>, EncodesToData {
  // MARK: Options

    /// The strategy to use for encoding `Date` values.
    public enum DateEncodingStrategy {
        /// Encode the `Date` as a UNIX timestamp (floating point seconds since epoch).
        case secondsSince1970
        
        /// Encode the `Date` as UNIX millisecond timestamp (integer milliseconds since epoch).
        case millisecondsSince1970
        
        /// Encode the `Date` as an ISO-8601-formatted string (in RFC 3339 format).
        case iso8601
        
        case tdate
    }

  /// The strategy to use in encoding dates. Defaults to `.iso8601`.
  open var dateEncodingStrategy: DateEncodingStrategy = .iso8601

  /// The options set on the top-level encoder.
  override public var options: CBOREncoderTransform.Options {
    return CBOREncoderTransform.Options(
      dateEncodingStrategy: dateEncodingStrategy,
      keyEncodingStrategy: keyEncodingStrategy,
      userInfo: userInfo
    )
  }

  override public init() {
    super.init()
  }

}

public struct CBOREncoderTransform: InternalEncoderTransform, InternalValueSerializer {
    
    public typealias Value = CBOR
    public typealias Encoder = InternalValueEncoder<CBOR, Self>
    public typealias State = Void
    
    public static var emptyKeyedContainer = CBOR.map([:])
    public static var emptyUnkeyedContainer = CBOR.array([])
    
    public struct Options: InternalEncoderOptions {
        public let dateEncodingStrategy: CBOREncoder.DateEncodingStrategy
        public let keyEncodingStrategy: KeyEncodingStrategy
        public let userInfo: [CodingUserInfoKey: Any]
    }
    
    public static func boxNil(encoder: Encoder) throws -> CBOR { return nil }
    public static func box(_ value: Bool, encoder: Encoder) throws -> CBOR { return CBOR(value) }
    public static func box(_ value: Int, encoder: Encoder) throws -> CBOR { return CBOR(Int64(value)) }
    public static func box(_ value: Int8, encoder: Encoder) throws -> CBOR { return CBOR(Int64(value)) }
    public static func box(_ value: Int16, encoder: Encoder) throws -> CBOR { return CBOR(Int64(value)) }
    public static func box(_ value: Int32, encoder: Encoder) throws -> CBOR { return CBOR(Int64(value)) }
    public static func box(_ value: Int64, encoder: Encoder) throws -> CBOR { return CBOR(Int64(value)) }
    public static func box(_ value: UInt, encoder: Encoder) throws -> CBOR { return CBOR(UInt64(value)) }
    public static func box(_ value: UInt8, encoder: Encoder) throws -> CBOR { return CBOR(UInt64(value)) }
    public static func box(_ value: UInt16, encoder: Encoder) throws -> CBOR { return CBOR(UInt64(value)) }
    public static func box(_ value: UInt32, encoder: Encoder) throws -> CBOR { return CBOR(UInt64(value)) }
    public static func box(_ value: UInt64, encoder: Encoder) throws -> CBOR { return CBOR(UInt64(value)) }
    public static func box(_ value: String, encoder: Encoder) throws -> CBOR { return CBOR(value) }
    public static func box(_ value: Float, encoder: Encoder) throws -> CBOR { return CBOR(value) }
    public static func box(_ value: Double, encoder: Encoder) throws -> CBOR { return CBOR(value) }
    public static func box(_ value: Decimal, encoder: Encoder) throws -> CBOR { return CBOR((value as NSDecimalNumber).doubleValue) }
    public static func box(_ value: Data, encoder: Encoder) throws -> CBOR { return CBOR(value) }
    public static func box(_ value: URL, encoder: Encoder) throws -> CBOR { return .tagged(.uri, .utf8String(value.absoluteString)) }
    
    public static func box(_ value: UUID, encoder: Encoder) throws -> CBOR {
        return withUnsafeBytes(of: value) { ptr in
            let bytes = Data(ptr.bindMemory(to: UInt8.self))
            return .tagged(.uuid, .byteString(bytes))
        }
    }
    
    public static func box(_ value: Date, encoder: Encoder) throws -> CBOR {
        switch encoder.options.dateEncodingStrategy {
        case .iso8601: return .tagged(.iso8601DateTime, .utf8String(_iso8601Formatter.string(from: value)))
        case .secondsSince1970: return .tagged(.epochDateTime, CBOR(value.timeIntervalSince1970))
        case .millisecondsSince1970: return .tagged(.epochDateTime, CBOR(Int64(value.timeIntervalSince1970 * 1000.0)))
        case .tdate: return .tagged(.tdate, .utf8String(tdateFormatter.string(from: value)))
        }
    }
    
    public static func box(_ value: Any, withTag tagValue: UInt64, encoder: Encoder) throws -> CBOR {

        let cbor: CBOR

        switch value {
        case is Bool:
            guard
                let value = value as? Bool
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Bool")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Int:
            guard
                let value = value as? Int
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Int")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Int8:
            guard
                let value = value as? Int8
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Int8")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Int16:
            guard
                let value = value as? Int16
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Int16")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Int32:
            guard
                let value = value as? Int32
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Int32")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Int64:
            guard
                let value = value as? Int64
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Int64")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is UInt:
            guard
                let value = value as? UInt
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to UInt")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is UInt8:
            guard
                let value = value as? UInt8
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value nit castable to UInt8")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is UInt16:
            guard
                let value = value as? UInt16
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to UInt16")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is UInt32:
            guard
                let value = value as? UInt32
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to UInt32")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is UInt64:
            guard
                let value = value as? UInt64
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to UInt64")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Float:
            guard let value = value as? Float else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Float")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Double:
            guard let value = value as? Double else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Double")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Decimal:
            guard let value = value as? Decimal else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Decimal")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is String:
            guard let value = value as? String else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to String")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Data:
            guard let value = value as? Data else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Data")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is URL:
            guard let value = value as? URL else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to URL")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is UUID:
            guard let value = value as? UUID else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to UUID")
                throw EncodingError.invalidValue(value, context)
            }
            cbor = try box(value, encoder: encoder)
        case is Encodable:
            guard let value = value as? Encodable else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "value not castable to Encodable")
                throw EncodingError.invalidValue(value, context)
            }

            guard
                let otherTypeCbor = try box(value, otherType: Swift.type(of: value), encoder: encoder)
            else {
                let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "non-encodable type")
                throw EncodingError.invalidValue(value, context)
            }
            
            cbor = otherTypeCbor
        default:
            let context = EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Worng value data type")
            throw EncodingError.invalidValue(value, context)
        }

        let tag = CBOR.Tag(rawValue: tagValue)
        return .tagged(tag, cbor)
    }
    
    public static func unkeyedValuesToValue(_ values: [CBOR], encoder: Encoder) -> CBOR {
        return .array(values)
    }
    
    public static func keyedValuesToValue(_ values: [AnyHashable: CBOR], encoder: Encoder) -> CBOR {
        return .map(Dictionary(uniqueKeysWithValues: values.map { key, value in
            if let key = key as? Int {
                return (CBOR(UInt64(key)), value)
            } else {
                return (CBOR(String(describing: key)), value)
            }
        }))
    }
    
    public static func data(from value: CBOR, options: Options) throws -> Data {
        return try CBORSerialization.data(with: value)
    }
}

private let _iso8601Formatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.calendar = Calendar(identifier: .iso8601)
  formatter.locale = Locale(identifier: "en_US_POSIX")
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
  return formatter
}()

private let tdateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()


#if canImport(Combine)

  import Combine

  extension CBOREncoder: TopLevelEncoder {
    public typealias Output = Data
  }

#endif
