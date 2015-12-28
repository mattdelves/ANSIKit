//
//  Characters.swift
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

public enum SGRCode: Int {
  case NoneOrInvalid = -1
  case AllReset = 0

  case IntensityBold = 1
  case IntensityFaint = 2
  case IntensityNormal = 22

  case ItalicOn = 3

  case UnderlineSingle = 4
  case UnderlineDouble = 21
  case UnderlineNone  = 24

  case FgBlack = 30
  case FgRed = 31
  case FgGreen = 32
  case FgYellow = 33
  case FgBlue = 34
  case FgMagenta = 35
  case FgCyan = 36
  case FgWhite = 37
  case FgReset = 39

  case BgBlack = 40
  case BgRed = 41
  case BgGreen = 42
  case BgYellow = 43
  case BgBlue = 44
  case BgMagenta = 45
  case BgCyan = 46
  case BgWhite = 47
  case BgReset = 49

  case FgBrightBlack = 90
  case FgBrightRed = 91
  case FgBrightGreen = 92
  case FgBrightYellow = 93
  case FgBrightBlue = 94
  case FgBrightMagenta = 95
  case FgBrightCyan = 96
  case FgBrightWhite = 97

  case BgBrightBlack = 100
  case BgBrightRed = 101
  case BgBrightGreen = 102
  case BgBrightYellow = 103
  case BgBrightBlue = 104
  case BgBrightMagenta = 105
  case BgBrightCyan = 106
  case BgBrightWhite = 107
}

public struct EscapeCharacters {
  static let CSI: String = "["
  static let SGREnd = "m"
}

protocol Color {
  var color: ASKColor { get }
}

extension SGRCode: Color {
  var color: ASKColor {
    switch self {
    case SGRCode.FgBlack:
      return Colors.Fg.Black
    case SGRCode.FgRed:
      return Colors.Fg.Red
    case SGRCode.FgGreen:
      return Colors.Fg.Green
    case SGRCode.FgYellow:
      return Colors.Fg.Yellow
    case SGRCode.FgBlue:
      return Colors.Fg.Blue
    case SGRCode.FgMagenta:
      return Colors.Fg.Magenta
    case SGRCode.FgCyan:
      return Colors.Fg.Cyan
    case SGRCode.FgWhite:
      return Colors.Fg.White
    case SGRCode.FgBrightBlack:
      return Colors.Fg.BrightBlack
    case SGRCode.FgBrightRed:
      return Colors.Fg.BrightRed
    case SGRCode.FgBrightGreen:
      return Colors.Fg.BrightGreen
    case SGRCode.FgBrightYellow:
      return Colors.Fg.BrightYellow
    case SGRCode.FgBrightBlue:
      return Colors.Fg.BrightBlue
    case SGRCode.FgBrightMagenta:
      return Colors.Fg.BrightMagenta
    case SGRCode.FgBrightCyan:
      return Colors.Fg.BrightCyan
    case SGRCode.FgBrightWhite:
      return Colors.Fg.BrightWhite
    case SGRCode.BgBlack:
      return Colors.Bg.Black
    case SGRCode.BgRed:
      return Colors.Bg.Red
    case SGRCode.BgGreen:
      return Colors.Bg.Green
    case SGRCode.BgYellow:
      return Colors.Bg.Yellow
    case SGRCode.BgBlue:
      return Colors.Bg.Blue
    case SGRCode.BgMagenta:
      return Colors.Bg.Magenta
    case SGRCode.BgCyan:
      return Colors.Bg.Cyan
    case SGRCode.BgWhite:
      return Colors.Bg.White
    case SGRCode.BgBrightBlack:
      return Colors.Bg.BrightBlack
    case SGRCode.BgBrightRed:
      return Colors.Bg.BrightRed
    case SGRCode.BgBrightGreen:
      return Colors.Bg.BrightGreen
    case SGRCode.BgBrightYellow:
      return Colors.Bg.BrightYellow
    case SGRCode.BgBrightBlue:
      return Colors.Bg.BrightBlue
    case SGRCode.BgBrightMagenta:
      return Colors.Bg.BrightMagenta
    case SGRCode.BgBrightCyan:
      return Colors.Bg.BrightCyan
    case SGRCode.BgBrightWhite:
      return Colors.Bg.BrightWhite
    default:
      break
    }
    
    return Colors.Fg.Black
  }
}
