//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 03. 03..
//

import Fuzi
import Foundation

extension String {
    
    var dashToCamel: String {
        split(separator: "-").reduce("", { $0 + $1.capitalized }).capitalizingFirstLetter()
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).lowercased()
        let other = String(dropFirst())
        return first + other
    }
}

let workUrl = URL(fileURLWithPath: #file)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    
let inputUrl = workUrl.appendingPathComponent("svg")
let outputUrl = workUrl.appendingPathComponent("out")


let files = try FileManager.default.contentsOfDirectory(atPath: inputUrl.path)
for file in files {
    let fileUrl = inputUrl.appendingPathComponent(file)
    
//    let fileName = fileUrl.deletingPathExtension().lastPathComponent
    
//    if fileName.dashToCamel == fileName {
//        print("case \(fileName.dashToCamel)")
//    }
//    else {
//        print("case \(fileName.dashToCamel) = \"\(fileName)\"")
//    }

    try generateDSL(fileUrl)
}


func generateDSL(_ fileUrl: URL) throws {
    let fileName = fileUrl.deletingPathExtension().lastPathComponent.dashToCamel
    var out = """
        public extension Svg {
            static var \(fileName): Svg {
        
        """
    
    let xml = try String(contentsOf: fileUrl)
    
    let document = try XMLDocument(string: xml)
    if let root = document.root {
        out += "\t\t.icon([\n"
        for element in root.children {
            guard let tag = element.tag else {
                continue;
            }
            out += "\t\t\t"
            switch tag {
            case "polygon":
                let points = element.attributes["points"]!.components(separatedBy: " ").joined(separator: ", ")
                out += "Polygon([\(points)])"
            case "polyline":
                let points = element.attributes["points"]!.components(separatedBy: " ").joined(separator: ", ")
                out += "Polyline([\(points)])"
            case "path":
                let d = element.attributes["d"]!
                out += "Path(\"\(d)\")"
            case "line":
                let x1 = element.attributes["x1"]!
                let y1 = element.attributes["y1"]!
                let x2 = element.attributes["x2"]!
                let y2 = element.attributes["y2"]!
                out += "Line(x1: \(x1), y1: \(y1), x2: \(x2), y2: \(y2))"
            case "rect":
                let x = element.attributes["x"]!
                let y = element.attributes["y"]!
                let w = element.attributes["width"]!
                let h = element.attributes["height"]!

                out += "Rect(x: \(x), y: \(y), width: \(w), height: \(h)"
                if let rx = element.attributes["rx"] {
                    out += ", rx: \(rx)"
                }
                if let ry = element.attributes["ry"] {
                    out += ", ry: \(ry)"
                }
                out += ")"
            case "circle":
                let cx = element.attributes["cx"]!
                let cy = element.attributes["cy"]!
                let r = element.attributes["r"]!
                out += "Circle(cx: \(cx), cy: \(cy), r: \(r))"
            case "ellipse":
                let cx = element.attributes["cx"]!
                let cy = element.attributes["cy"]!
                let rx = element.attributes["rx"]!
                let ry = element.attributes["ry"]!
                out += "Ellipse(cx: \(cx), cy: \(cy), rx: \(rx), ry: \(ry))"
            default:
                fatalError("Unhandled tag: \(tag)")
            }
            out += ",\n"
        }
        out += "\t\t])"
    }
    
    out += "\n\t}\n}\n"
    
    let file = "Svg+" + fileName + ".swift"
    let outUrl = outputUrl.appendingPathComponent(file)
    try out.write(to: outUrl, atomically: true, encoding: .utf8)
//    print(out)
}
