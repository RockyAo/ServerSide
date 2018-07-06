import Vapor
import SwiftGD

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let rootDirectory = DirectoryConfig.detect().workDir
    let uploadDirectory = URL(fileURLWithPath: "\(rootDirectory)Public/uploads")
    let originalsDirectory = uploadDirectory.appendingPathComponent("originals")
    let thumbsDirectory = uploadDirectory.appendingPathComponent("thumbs")
    
    router.get { (req) -> Future<View> in
        let fm = FileManager()
        
        guard let files = try? fm.contentsOfDirectory(at: originalsDirectory, includingPropertiesForKeys: nil) else {
            throw Abort(.internalServerError)
        }
        let allFilenames = files.map { $0.lastPathComponent }
        let visibleFilenames = allFilenames.filter { !$0.hasPrefix(".") }
        
        let context = ["files": visibleFilenames]
        return try req.view().render("home", context)
    }
    
    router.post("upload") { (req) -> Future<Response> in
        struct UserFile: Content {
            var upload: [File]
        }
        
        return try req.content.decode(UserFile.self).map(to: Response.self, { (data)  in
            let acceptabletypes = [MediaType.png, MediaType.jpeg]
            
            for file in data.upload {
                guard let mimeType = file.contentType else { continue }
                guard acceptabletypes.contains(mimeType) else { continue }
                
                let cleanedFilename = file.filename.replacingOccurrences(of: " ", with: "-")
                let newURL = originalsDirectory.appendingPathComponent(cleanedFilename)
                
                _ = try? file.data.write(to: newURL)
                
                let thumbURL = thumbsDirectory.appendingPathComponent(cleanedFilename)
                
                if let image = Image(url: newURL) {
                    if let resized = image.resizedTo(width: 300) {
                        resized.write(to: thumbURL)
                    }
                }
            }
            
            return req.redirect(to: "/")
        })
    }
}
