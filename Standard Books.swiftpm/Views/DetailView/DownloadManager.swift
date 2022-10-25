import UIKit
import SwiftUI

// 1. Activity View
struct ActivityView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {}
}


final class DownloadManager: ObservableObject {
    enum NetworkingError: Error {
        case invalidServerResponse
        case badJSON
    }
    enum FileError: Error {
        case moveError
        case removeError
    }
    @Published var isDownloading: Bool = false
    func download(file fileName: String, from url: URL) async throws {
        isDownloading = true
        print(isDownloading)
        
        if let destinationUrl = fileURL(for: fileName) {
            print(destinationUrl)
            if FileManager().fileExists(atPath: destinationUrl.path) {
                print("File already exists")
                isDownloading = false
            } else {
                let (location, response) = try await URLSession.shared.download(from: url)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 /* OK */ else {
                    print(response)
                    print("error")
                    throw NetworkingError.invalidServerResponse
                }
                print("move item")
                print(location)
                do {
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                } catch {
                    throw FileError.moveError
                }   
//                print("remove item")
//                do {
//                    try FileManager.default.removeItem(at: loc)
//                } catch {
//                    throw FileError.removeError
//                }             
                print("Finished")
                isDownloading = false
            }
        }
        isDownloading = false
        print(isDownloading)
    }
//    func share(file url: URL) async {
//        print("activity???")
//        let vc = await UIActivityViewController(activityItems: [url], applicationActivities: [])
//        present(vc, animated: true)
////        let activityController = await UIActivityViewController(activityItems: [url], applicationActivities: nil)
////        await UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
//        print("activity!")
//    }
    func checkFileExists(file fileName: String) -> Bool {
        if let destinationUrl = fileURL(for: fileName) {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                return true
            }
        }
        return false
    }
    func removeFile(file fileName: String) throws {
        if let destinationUrl = fileURL(for: fileName) {
            do {
                try FileManager().removeItem(atPath: destinationUrl.path)
            } catch {
                throw FileError.removeError
            }
        }
    }
    func fileURL(for fileName: String) -> URL? {
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let destinationUrl = docsUrl?.appendingPathComponent(fileName) {
            return destinationUrl
        }
        return nil
    }
}
