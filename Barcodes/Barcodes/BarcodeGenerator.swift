import UIKit

enum Descriptor: String, CaseIterable {
    case qr = "CIQRCodeGenerator"
    case aztec = "CIAztecCodeGenerator"
    case pdf417 = "CIPDF417BarcodeGenerator"
    case code128 = "CICode128BarcodeGenerator"

    func displayName() -> String {
        switch self {

        case .qr: return "QR"
        case .aztec: return "Aztec"
        case .pdf417: return "PDF-417"
        case .code128: return "Code-128"
        }
    }
}

class BarcodeGenerator {

    private static var key: String = "inputMessage"

    class func generate(from string: String,
                        descriptor: Descriptor,
                        size: CGSize) -> CIImage? {
        let filterName = descriptor.rawValue

        guard let data = string.data(using: .ascii),
              let filter = CIFilter(name: filterName) else {
            return nil
        }

        filter.setValue(data, forKey: BarcodeGenerator.key)

        guard let image = filter.outputImage else {
            return nil
        }

        let imageSize = image.extent.size

        let transform = CGAffineTransform(scaleX: size.width / imageSize.width,
                                          y: size.height / imageSize.height)
        let scaledImage = image.transformed(by: transform)

        return scaledImage
    }
}
