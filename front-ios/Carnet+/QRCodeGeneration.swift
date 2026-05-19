//
//  QRCodeGeneration.swift
//  Carnet+
//
//  Created by Jorge Beltrán on 08/03/26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

/// Utilidad para la generación de códigos QR dinámicos.
/// HCI: Garantiza la 'Visibilidad del estado del sistema' al generar un token único de asistencia.
struct QRCodeGenerator {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()

    /// Transforma un String (ID del evento) en un UIImage de alta definición.
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            // Transformamos la imagen CIImage a CGImage para tener control sobre la nitidez
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        // Imagen de respaldo en caso de fallo en el procesamiento
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
