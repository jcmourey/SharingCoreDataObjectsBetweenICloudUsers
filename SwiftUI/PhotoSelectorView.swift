/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A SwiftUI view that picks a photo.
*/

import SwiftUI
import PhotosUI

struct PhotoSelectorView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Label("Add", systemImage: "plus")
                .font(.system(size: 18))
                .labelStyle(.iconOnly)
        }
        #if os(watchOS)
        .buttonStyle(.plain)
        #else
        .buttonStyle(.borderless)
        #endif
        .onChange(of: selectedItem) { value in
            if let value = value {
                loadTransferable(from: value)
            }
        }
    }
}

extension PhotoSelectorView {
    @discardableResult
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: UIImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.selectedItem else {
                    print("Failed to get the picked photo.")
                    return
                }
                switch result {
                case .success(let image?):
                    PersistenceController.shared.addPhoto(image: image)
                case .success(nil):
                    print("No photo is picked.")
                case .failure(let error):
                    print("Failed to load the picked photo: \(error)")
                }
            }
        }
    }
}

extension UIImage: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let image = UIImage(data: data) else {
                throw PhotoSelectorError.importFailed
            }
            return image
        }
    }
}

private enum PhotoSelectorError: Error, LocalizedError {
    case importFailed
    
    var errorDescription: String? {
        switch self {
        case .importFailed:
            return NSLocalizedString("Failed to import the picked photo.", comment: "")
        }
    }
}
