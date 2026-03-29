import AppKit
import Foundation

let outputPath = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : "assets/images/app_logo_ios_1024.png"

let size = CGSize(width: 1024, height: 1024)
let image = NSImage(size: size)

image.lockFocus()

let context = NSGraphicsContext.current!.cgContext
context.setAllowsAntialiasing(true)
context.setShouldAntialias(true)

let rect = CGRect(origin: .zero, size: size)
let backgroundPath = NSBezierPath(
    roundedRect: rect.insetBy(dx: 96, dy: 96),
    xRadius: 140,
    yRadius: 140
)

NSColor.white.setFill()
backgroundPath.fill()

context.setShadow(
    offset: CGSize(width: 0, height: -18),
    blur: 56,
    color: NSColor(
      calibratedRed: 50 / 255,
      green: 58 / 255,
      blue: 145 / 255,
      alpha: 0.16
    ).cgColor
)
NSColor.white.setFill()
backgroundPath.fill()
context.setShadow(offset: .zero, blur: 0, color: nil)

let strokeColor = NSColor(
    calibratedRed: 50 / 255,
    green: 58 / 255,
    blue: 145 / 255,
    alpha: 1
)

let outlinedCircle = NSBezierPath(ovalIn: CGRect(x: 430, y: 390, width: 310, height: 310))
outlinedCircle.lineWidth = 14
strokeColor.setStroke()
outlinedCircle.stroke()

let filledCircle = NSBezierPath(ovalIn: CGRect(x: 285, y: 305, width: 310, height: 310))
strokeColor.setFill()
filledCircle.fill()

image.unlockFocus()

guard
    let tiffData = image.tiffRepresentation,
    let bitmap = NSBitmapImageRep(data: tiffData),
    let pngData = bitmap.representation(using: .png, properties: [:])
else {
    fputs("Failed to render app icon.\n", stderr)
    exit(1)
}

let outputURL = URL(fileURLWithPath: outputPath)
try FileManager.default.createDirectory(
    at: outputURL.deletingLastPathComponent(),
    withIntermediateDirectories: true
)
try pngData.write(to: outputURL)
