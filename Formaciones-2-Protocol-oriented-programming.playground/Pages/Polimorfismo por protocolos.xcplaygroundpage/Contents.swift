import UIKit
import Foundation

/*:
 
 # Polimorfismo por protocolos y value types
 
 El polimorfismo por protocolo puede ser aplicado tanto a value types como a reference types, sin embargo, en muchos casos preferiremos usar value types, simplemente por la seguridad y expresividad que aportan a nuestro código.
 
 En el siguiente ejemplo, hemos cambiado un poco el paradigma, y ahora ya no trabajamos directamente con UIViews, sino que creamos un value type intermedio que describirá las propiedades de nuestra UIView.
 
 En Swift podemos usar este patrón siempre que queramos aportar polimorfismo a las clases propias de Cocoa. Este tipo de solución además, nos permite una fácil testeabilidad, a parte de todas las ventajas que tiene trabajar con value types.
 */

protocol Viewable {
    var color: UIColor { get }
    var boundingBox: CGRect { get }
    func draw(context: CGContext)
}

struct Square: Viewable {
    var side: CGFloat
    var color: UIColor = .blue
    
    var boundingBox: CGRect {
        return CGRect(
            origin: .zero,
            size: .init(width: side, height: side)
        )
    }
    
    func draw(context: CGContext) {
        context.setFillColor(color.cgColor)
        context.fill(boundingBox)
    }
}

struct Circle: Viewable {
    var diameter: CGFloat
    var color: UIColor = .blue

    var boundingBox: CGRect {
        return CGRect(
            origin: .zero,
            size: .init(width: diameter, height: diameter)
        )
    }
    
    func draw(context: CGContext) {
        context.setFillColor(color.cgColor)
        context.fillEllipse(in: boundingBox)
    }
}

extension Viewable {
    var toUIView: UIView {
        // He usado esta solución por ser la más fácil, pero realmente podemos construir la view adecuada con BezierPaths u otros recursos similares.
        
        let view = UIImageView(frame: boundingBox)
        let renderer = UIGraphicsImageRenderer(bounds: boundingBox)
        
        view.image = renderer.image { draw(context: $0.cgContext) }
        
        return view
    }
}

let square = Square(side: 20, color: .blue)
let circle = Circle(diameter: 20, color: .blue)

let squareView = square.toUIView
let circleView = circle.toUIView

/*:
 
 Hay que remarcar varias de las ventajas que tiene esta implementación:
 
 * No estamos forzados a usar una superclase específica.
 * Podemos conformar tipos ya existentes a nuestro protocolo. Usando herencia no tenemos esta flexibilidad, no podemos cambair de forma retroactiva una superclase.
 * Como hemos dicho antes, el tipo que conforma puede ser tanto un value type, como un reference type.
 * No tenemos que preocuparnos de hacer override de n métodos o de si llamamos a super en el momento adecuado.
 
 */

// Implementar un transformador a viewable.

struct TransformedViewable: Viewable {
    let originalViawble: Viewable
    let transformation: CGAffineTransform
    
    var color: UIColor = .blue
    
    var boundingBox: CGRect {
        return originalViawble.boundingBox.applying(transformation)
    }
    
    func draw(context: CGContext) {
        context.saveGState()
        context.concatenate(transformation)
        originalViawble.draw(context: context)
        context.restoreGState()
    }
}

let square2 = Square(side: 20, color: .blue)
let transformedSquare = TransformedViewable(originalViawble: square2, transformation: .init(rotationAngle: .pi/3), color: .blue)
let transformedView = transformedSquare.toUIView

