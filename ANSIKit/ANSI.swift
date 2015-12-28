//
//  ANSI.swift
//  ANSIKit
//
//  Created by Matthew Delves on 18/02/2015.
//  Copyright (c) 2015 Matthew Delves. All rights reserved.
//

#if os(OSX)
    import Cocoa
#else
    import UIKit
#endif

public struct AnsiHelper {
    #if os(OSX)
    public var defaultStringColor: NSColor
    public var font: NSFont
    public init(color: NSColor, font: NSFont) {
        self.defaultStringColor = color
        self.font = font
    }
    #else
    public var defaultStringColor: UIColor
    public var font: UIFont
    public init(color: UIColor, font: UIFont) {
    self.defaultStringColor = color
    self.font = font
    }
    #endif
}

struct HSB {
    var hue: CGFloat
    var saturation: CGFloat
    var brightness: CGFloat

    init (hue: CGFloat, saturation: CGFloat, brightness: CGFloat)
    {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
    }
}

struct AttributeKeys {
    static let name = "attributeName"
    static let value = "attributeValue"
    static let range = "range"
    static let code = "code"
    static let location = "location"
}

func getHSBFromColor(color: ASKColor) -> HSB {
    var hue: CGFloat = 0.0
    var saturation: CGFloat = 0.0
    var brightness: CGFloat = 0.0

    color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)

    return HSB(hue: hue, saturation: saturation, brightness: brightness)
}


public func ansiEscapedAttributedString(helper: AnsiHelper, _ ansi: String) -> NSAttributedString? {
    let string: NSAttributedString? = attributedStringWithANSIEscapedString(helper, aString: ansi)

    return string
}

func attributedStringWithANSIEscapedString(helper: AnsiHelper, aString: String) -> NSAttributedString? {
    if (aString == "") {
        return nil
    }


    var cleanString: String?
    let attributesAndRanges = attributesForString(helper, aString, &cleanString)
    let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: cleanString!, attributes: [NSFontAttributeName: helper.font, NSForegroundColorAttributeName: helper.defaultStringColor])

    for thisAttributeDict: [String: AnyObject] in attributesAndRanges {
        if let attributeValue: AnyObject = thisAttributeDict[AttributeKeys.value], let attributeName: String = thisAttributeDict[AttributeKeys.name] as? String, let range = thisAttributeDict[AttributeKeys.range] as? NSRange {
            attributedString.addAttribute(attributeName, value: attributeValue, range: range)
        }
    }

    return attributedString;
}

func attributesForString(helper: AnsiHelper, _ aString: String, inout _ aCleanString: String?) -> [[String: AnyObject]] {
    if (aString == "") {
        return []
    }

    if (aString.utf8.count <= EscapeCharacters.CSI.utf8.count) {
        if (aCleanString != nil) {
            aCleanString = aString
        }
        return []
    }

    var attrsAndRanges = [[String: AnyObject]]()

    var cleanString: String? = ""
    let formatCodes: [[String: AnyObject]] = escapeCodesForString(aString, &cleanString)
    let foundCodes = formatCodes.count
    var startIndex = 0
    var range: NSRange

    for (index, thisCodeDict) in formatCodes.enumerate() {
        let thisCode = thisCodeDict[AttributeKeys.code] as! Int
        let code = SGRCode(rawValue: thisCode)

        if let attributeName = attributeNameForCode(code!) {
            if let attributeValue: AnyObject = attributeValueForCode(code!, helper) {
                startIndex = index + 1
                range = rangeOfString(cleanString!, thisCodeDict, Array(formatCodes[startIndex..<foundCodes]))
                attrsAndRanges.append([
                    AttributeKeys.range: range,
                    AttributeKeys.name: attributeName,
                    AttributeKeys.value: attributeValue
                    ])
            }
        }
    }

    if (cleanString != nil) {
        aCleanString = cleanString
    }

    return attrsAndRanges
}

func rangeOfString(string: String, _ startCode: [String: AnyObject], _ codes: [[String: AnyObject]]) -> NSRange {
    var formattingRunEndLocation = -1
    let formattingRunStartLocation = startCode[AttributeKeys.location] as! Int
    let formattingRunStartCode = SGRCode(rawValue: startCode[AttributeKeys.code] as! Int)

    for endCode: [String: AnyObject] in codes {
        let theEndCode = endCode[AttributeKeys.code] as! Int
        if (shouldEndFormattingIntroduced(SGRCode(rawValue: theEndCode)!, formattingRunStartCode!)) {
            formattingRunEndLocation = endCode[AttributeKeys.location] as! Int
            break
        }
    }
    if (formattingRunEndLocation == -1) {
        formattingRunEndLocation = string.utf8.count
    }

    let range = NSMakeRange(formattingRunStartLocation, (formattingRunEndLocation-formattingRunStartLocation))

    return range
}

func attributeNameForCode(code: SGRCode) -> String? {
    if codeIsFgColor(code) {
        return NSForegroundColorAttributeName
    } else if codeIsBgColor(code) {
        return NSBackgroundColorAttributeName
    } else if codeIsIntensity(code) {
        return NSFontAttributeName
    } else if codeIsUnderline(code) {
        return NSUnderlineStyleAttributeName
    }
    return nil
}

func attributeValueForCode(code: SGRCode, _ helper: AnsiHelper) -> AnyObject? {
    #if os(OSX)
        let descriptor = helper.font.fontDescriptor
    #else
        let descriptor = helper.font.fontDescriptor()
    #endif
    var traits = descriptor.symbolicTraits
    if codeIsColor(code) {
        return code.color
    } else if code == SGRCode.IntensityBold {
        #if os(OSX)
            traits = traits | UInt32(NSFontBoldTrait)
        #else
            traits = traits.union(.TraitBold)
        #endif
        if let boldDescriptor: ASKFontDescriptor = descriptor.fontDescriptorWithSymbolicTraits(traits) {
            let boldFont = ASKFont(descriptor: boldDescriptor, size: helper.font.pointSize)
            return boldFont
        }
    } else if codeIsIntensity(code) {
        #if os(OSX)
            traits = traits | UInt32(NSFontMonoSpaceTrait)
        #else
            traits = traits.union(.TraitMonoSpace)
        #endif
        if let newDescriptor: ASKFontDescriptor = descriptor.fontDescriptorWithSymbolicTraits(traits) {
            let unboldFont = ASKFont(descriptor: newDescriptor, size: helper.font.pointSize)
            return unboldFont
        }
    } else if code == SGRCode.UnderlineSingle {
        return NSUnderlineStyle.StyleSingle.rawValue
    } else if code == SGRCode.UnderlineDouble {
        return NSUnderlineStyle.StyleDouble.rawValue
    } else if code == SGRCode.UnderlineNone {
        return NSUnderlineStyle.StyleNone.rawValue
    }

    return nil
}

func codeIsFgColor(code: SGRCode) -> Bool {
    return (code.rawValue >= SGRCode.FgBlack.rawValue && code.rawValue <= SGRCode.FgWhite.rawValue) ||
        (code.rawValue >= SGRCode.FgBrightBlack.rawValue && code.rawValue <= SGRCode.FgBrightWhite.rawValue)
}

func codeIsBgColor(code: SGRCode) -> Bool {
    return (code.rawValue >= SGRCode.BgBlack.rawValue && code.rawValue <= SGRCode.BgWhite.rawValue) ||
        (code.rawValue >= SGRCode.BgBrightBlack.rawValue && code.rawValue <= SGRCode.BgBrightWhite.rawValue)
}

func codeIsIntensity(code: SGRCode) -> Bool {
    return code.rawValue == SGRCode.IntensityNormal.rawValue || code.rawValue == SGRCode.IntensityBold.rawValue || code.rawValue == SGRCode.IntensityFaint.rawValue
}

func codeIsUnderline(code: SGRCode) -> Bool {
    return code.rawValue == SGRCode.UnderlineNone.rawValue || code.rawValue == SGRCode.UnderlineSingle.rawValue || code.rawValue == SGRCode.UnderlineDouble.rawValue
}

func codeIsColor(code: SGRCode) -> Bool {
    return codeIsFgColor(code) || codeIsBgColor(code)
}

func shouldEndFormattingIntroduced(endCode: SGRCode, _ startCode: SGRCode) -> Bool {
    if codeIsFgColor(startCode) {
        return endCode.rawValue == SGRCode.AllReset.rawValue ||
            (endCode.rawValue >= SGRCode.FgBlack.rawValue && endCode.rawValue <= SGRCode.FgReset.rawValue) ||
            (endCode.rawValue >= SGRCode.FgBrightBlack.rawValue && endCode.rawValue <= SGRCode.FgBrightWhite.rawValue)
    } else if codeIsBgColor(startCode) {
        return endCode.rawValue == SGRCode.AllReset.rawValue ||
            (endCode.rawValue >= SGRCode.BgBlack.rawValue && endCode.rawValue <= SGRCode.BgReset.rawValue) ||
            (endCode.rawValue >= SGRCode.BgBrightBlack.rawValue && endCode.rawValue <= SGRCode.BgBrightWhite.rawValue)
    } else if codeIsIntensity(startCode) {
        return (endCode.rawValue == SGRCode.AllReset.rawValue || endCode.rawValue == SGRCode.IntensityNormal.rawValue ||
            endCode.rawValue == SGRCode.IntensityBold.rawValue || endCode.rawValue == SGRCode.IntensityFaint.rawValue);
    } else if codeIsUnderline(startCode) {
        return (endCode.rawValue == SGRCode.AllReset.rawValue || endCode.rawValue == SGRCode.UnderlineNone.rawValue ||
            endCode.rawValue == SGRCode.UnderlineSingle.rawValue || endCode.rawValue == SGRCode.UnderlineDouble.rawValue);
    }

    return false
}

func escapeCodesForString(escapedString: String, inout _ cleanString: String?) -> [[String: AnyObject]] {
    let aString = escapedString as NSString
    if (aString == "") {
        return []
    }

    if (aString.length <= EscapeCharacters.CSI.utf8.count) {
        return []
    }

    var formatCodes = [[String: AnyObject]]()

    let aStringLength = aString.length
    var coveredLength = 0

    var searchRange = NSMakeRange(0, aStringLength)
    var sequenceRange: NSRange
    var thisCoveredLength: Int = 0
    var searchStart: Int = 0

    repeat
    {
        sequenceRange = aString.rangeOfString(EscapeCharacters.CSI, options: NSStringCompareOptions.LiteralSearch, range: searchRange)

        if (sequenceRange.location != NSNotFound) {

            thisCoveredLength = sequenceRange.location - searchRange.location
            coveredLength += thisCoveredLength

            formatCodes += codesForSequence(&sequenceRange, string: aString).map { code in
                [AttributeKeys.code: code, AttributeKeys.location: coveredLength]
            }

            if (thisCoveredLength > 0) {
                cleanString = cleanString?.stringByAppendingString(aString.substringWithRange(NSMakeRange(searchRange.location, thisCoveredLength)))
            }

            searchStart = NSMaxRange(sequenceRange)
            searchRange = NSMakeRange(searchStart, aStringLength - searchStart)
        }
    } while(sequenceRange.location != NSNotFound)

    if (searchRange.length > 0) {
        cleanString = cleanString?.stringByAppendingString(aString.substringWithRange(searchRange))
    }

    return formatCodes
}

func codesForSequence(inout sequenceRange: NSRange, string: NSString) -> [Int] {
    var codes = [Int]()
    var code = 0
    var lengthAddition = 1
    var thisIndex: Int

    while(true)
    {
        thisIndex = (NSMaxRange(sequenceRange) + lengthAddition - 1)

        if (thisIndex >= string.length) {
            break
        }

        let c: Int = Int(string.characterAtIndex(thisIndex))

        if ((48 <= c) && (c <= 57))
        {
            let digit: Int = c - 48
            code = (code == 48) ? digit : code * 10 + digit
        }

        if (c == 109)
        {
            codes.append(code)
            break
        } else if ((64 <= c) && (c <= 126)) {
            codes.removeAll(keepCapacity: false)
            break
        } else if (c == 59) {
            codes.append(code)
            code = 0
        }
        
        lengthAddition++
    }
    
    sequenceRange.length += lengthAddition
    
    return codes
}