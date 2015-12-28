//
//  Colors.swift
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

public struct Colors {

    static let Brightness: CGFloat = 1.0
    static let Saturation: CGFloat = 0.4
    static let Alpha: CGFloat = 1.0

    struct Fg {
        static let Black = ASKColor.blackColor()
        static let Red = ASKColor.redColor()
        static let Green = ASKColor.greenColor()
        static let Yellow = ASKColor.yellowColor()
        static let Blue = ASKColor.blueColor()
        static let Magenta = ASKColor.magentaColor()
        static let Cyan = ASKColor.cyanColor()
        static let White = ASKColor.whiteColor()

        static let BrightBlack = ASKColor(white: 0.337, alpha: 1.0)
        static let BrightRed = ASKColor(hue: 1.0, saturation: Colors.Saturation, brightness: Colors.Brightness, alpha: Colors.Alpha)
        static let BrightGreen = ASKColor(hue: 1.0 / 3.0, saturation: Colors.Saturation, brightness: Colors.Brightness, alpha: Colors.Alpha)
        static let BrightYellow = ASKColor(hue: 1.0 / 6.0, saturation: Colors.Saturation, brightness: Colors.Brightness, alpha: Colors.Alpha)
        static let BrightBlue = ASKColor(hue: 2.0 / 3.0, saturation: Colors.Saturation, brightness: Colors.Brightness, alpha: Colors.Alpha)
        static let BrightMagenta = ASKColor(hue: 5.0 / 6.0, saturation: Colors.Saturation, brightness: Colors.Brightness, alpha: Colors.Alpha)
        static let BrightCyan = ASKColor(hue: 0.5, saturation: Colors.Saturation, brightness: Colors.Brightness, alpha: Colors.Alpha)
        static let BrightWhite = ASKColor.whiteColor()
    }
    struct Bg {
        static let Black = ASKColor.blackColor()
        static let Red = ASKColor.redColor()
        static let Green = ASKColor.greenColor()
        static let Yellow = ASKColor.yellowColor()
        static let Blue = ASKColor.blueColor()
        static let Magenta = ASKColor.magentaColor()
        static let Cyan = ASKColor.cyanColor()
        static let White = ASKColor.whiteColor()

        static let BrightBlack = Colors.Fg.BrightBlack
        static let BrightRed = Colors.Fg.BrightRed
        static let BrightGreen = Colors.Fg.BrightGreen
        static let BrightYellow = Colors.Fg.BrightYellow
        static let BrightBlue = Colors.Fg.BrightBlue
        static let BrightMagenta = Colors.Fg.BrightMagenta
        static let BrightCyan = Colors.Fg.BrightCyan
        static let BrightWhite = ASKColor.whiteColor()
    }

}

func SGRCodeForColor(aColor: ASKColor?, isForegroundColor: Bool) -> SGRCode
{
    if (isForegroundColor) {
        if (aColor == Colors.Fg.Black) {
            return SGRCode.FgBlack
        } else if (aColor == Colors.Fg.Red) {
            return SGRCode.FgRed
        } else if (aColor == Colors.Fg.Green) {
            return SGRCode.FgGreen
        } else if (aColor == Colors.Fg.Yellow) {
            return SGRCode.FgYellow
        } else if (aColor == Colors.Fg.Blue) {
            return SGRCode.FgBlue
        } else if (aColor == Colors.Fg.Magenta) {
            return SGRCode.FgMagenta
        } else if (aColor == Colors.Fg.Cyan) {
            return SGRCode.FgCyan
        } else if (aColor == Colors.Fg.White) {
            return SGRCode.FgWhite
        } else if (aColor == Colors.Fg.BrightBlack) {
            return SGRCode.FgBrightBlack
        } else if (aColor == Colors.Fg.BrightRed) {
            return SGRCode.FgBrightRed
        } else if (aColor == Colors.Fg.BrightGreen) {
            return SGRCode.FgBrightGreen
        } else if (aColor == Colors.Fg.BrightYellow) {
            return SGRCode.FgBrightYellow
        } else if (aColor == Colors.Fg.BrightBlue) {
            return SGRCode.FgBrightBlue
        } else if (aColor == Colors.Fg.BrightMagenta) {
            return SGRCode.FgBrightMagenta
        } else if (aColor == Colors.Fg.BrightCyan) {
            return SGRCode.FgBrightCyan
        } else if (aColor == Colors.Fg.BrightWhite) {
            return SGRCode.FgBrightWhite
        }
    } else {
        if (aColor == Colors.Bg.Black) {
            return SGRCode.BgBlack
        } else if (aColor == Colors.Bg.Red) {
            return SGRCode.BgRed
        } else if (aColor == Colors.Bg.Green) {
            return SGRCode.BgGreen
        } else if (aColor == Colors.Bg.Yellow) {
            return SGRCode.BgYellow
        } else if (aColor == Colors.Bg.Blue) {
            return SGRCode.BgBlue
        } else if (aColor == Colors.Bg.Magenta) {
            return SGRCode.BgMagenta
        } else if (aColor == Colors.Bg.Cyan) {
            return SGRCode.BgCyan
        } else if (aColor == Colors.Bg.White) {
            return SGRCode.BgWhite
        } else if (aColor == Colors.Bg.BrightBlack) {
            return SGRCode.BgBrightBlack
        } else if (aColor == Colors.Bg.BrightRed) {
            return SGRCode.BgBrightRed
        } else if (aColor == Colors.Bg.BrightGreen) {
            return SGRCode.BgBrightGreen
        } else if (aColor == Colors.Bg.BrightYellow) {
            return SGRCode.BgBrightYellow
        } else if (aColor == Colors.Bg.BrightBlue) {
            return SGRCode.BgBrightBlue
        } else if (aColor == Colors.Bg.BrightMagenta) {
            return SGRCode.BgBrightMagenta
        } else if (aColor == Colors.Bg.BrightCyan) {
            return SGRCode.BgBrightCyan
        } else if (aColor == Colors.Bg.BrightWhite) {
            return SGRCode.BgBrightWhite
        }
    }

    return SGRCode.NoneOrInvalid
}
