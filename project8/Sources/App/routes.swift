import Vapor
import SwiftGD


/// Register your application's routes here.
public func routes(_ router: Router) throws {
   
    router.get{ (req) -> Future<View> in
        let context = [String: String]()
        return try req.view().render("home", context)
    }
    
    router.get("fetch") { (req) -> Future<String> in
        let imageString = try image(from: req).map(to: String.self, { (image)  in
            guard let img = image else { return "" }
            let asciiBlocks = ["@", "#", "*", "+", ";", ":", ",", ".", "`", " "]
            let imageSize = img.size
            let blockSize = 2
            var rows = [[String]]()
            rows.reserveCapacity(imageSize.height)
            
            for y in stride(from: 0, to: imageSize.height, by: blockSize) {
                
                var row = [String]()
                
                for x in stride(from: 0, to: imageSize.width, by: blockSize) {
                    let color = img.get(pixel: Point(x: x, y: y))
                    let brightness = color.redComponent + color.greenComponent + color.blueComponent
                    let sum = Int(round(brightness*3))
                    row.append(asciiBlocks[sum])
                }
                
                rows.append(row)
            }
            
            let output = rows.reduce("", {
                $0 + $1.joined(separator: " ") + "\n"
            })
            
            return output
        })
        return imageString
    }
}

func image(from request: Request) throws -> Future<Image?> {
    guard let uri: String = request.query["url"] else {
        return Future.map(on: request, { () in
            return nil
        })
    }
    
    return try request.client().get(uri)
        .flatMap(to: Image?.self, { (imageResponse) in
            let temporaryName = NSTemporaryDirectory().appending("input.png")
            let temporaryURL = URL(fileURLWithPath: temporaryName)
            
            return imageResponse.http.body.consumeData(max: 16_000_000, on: request)
                .map(to: Image?.self, { (data)  in
                    try data.write(to: temporaryURL)
                    
                    if let image = Image(url: temporaryURL) {
                        return image
                    } else {
                        return nil
                    }
                })
        })
}
