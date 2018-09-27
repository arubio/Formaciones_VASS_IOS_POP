import UIKit

/*:
 
 # Polimorfismo por herencia
 
 ## ¿Qué es?
 
 Muchas veces, para compartir código entre entidades creamos jerarquias complejas basadas en herencia. Este patrón es totalmente correcto, pero no está exento de problemas.
 
 ### Ejemplo:
 */

class SquaredView: UIView {
    init(side: CGFloat) {
        let squaredFrame = CGRect(
            origin: .zero,
            size: .init(width: side, height: side)
        )
        
        super.init(frame: squaredFrame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CircledView: SquaredView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        layer.cornerRadius = bounds.width/2
    }
}


let square = SquaredView(side: 20)
square.backgroundColor = .blue

let circle = CircledView(side: 20)
circle.backgroundColor = .blue


/*:

 El código anterior es totalmente correcto, y de hecho, durante muchos años ha sido (y sigue siendo) el patrón recomendado por Apple. Pero desde la llegada de Swift y su implementación de protocolos notamos mucho más las desventajas de esta aproximación:
 
 * Las clases son reference types. Esto en sí mismo no es una desventaja, pero muy facilmente se convierte en una. El hecho de que una entidad pueda ser apropiada por n entidades diferentes termina por sembrar mucha incertidumbre en nuestro código, sobretodo cuando no tenemos en cuenta que esto puede pasar.
 * Y de aquí pasamos al concepto de **local reasoning**: local reasoning nos habla de la importancia que tiene el que, cuando tenemos en frente un trozo de código, no tengamos que pensar en como interactuará el resto de nuestra aplicación con ese trozo de código en concreto. El poder centrarnos únicamente en lo que esta pasando en el contexto actual nos permite entender el código más rápido, mantenerlo mejor y testearlo fácilmente.
 * Los reference types pueden vulnerar muy rápidamente el razonamiento local del contexto al que te enfrentes. Como ejemplo tenemos la clase UIButton. Esta clase hereda de UIControl, que hereda de UIView, que hereda de UIResponder que hereda de NSObject. Para conocer correctamente el funcionamiento de un UIButton deberíamos también prestar atención a sus clases padres, pero esto no suele ser el caso.
 
 ## Otra aproximación al problema
 
 Los value types y el polimorfismo mediante protocolos nos fuerzan en parte a evitar estos problemas, ya que un struct o enum no puede heredar de otro. Además, como ya hemos hablado un value type solo vive dentro de un único contexto, y por lo tanto no puede ser modificado desde otro contexto diferente.
 
 */

// Aquí dejo un experimento de como haríamos esto con protocolos, y en este caso en concreto vemos que los beneficios son muy sutiles, y casi inexistentes a efectos prácticos (no usamos una extension en UIView, esa es la ventaja...). Quizá se podría plantear de alguna otra forma, pero no caigo a la hora de escribir esto. 

protocol SquareView { }
protocol CircleView: SquareView { }

extension SquareView where Self: UIView {
    init(side: CGFloat) {
        let squaredFrame = CGRect(
            origin: .zero,
            size: .init(width: side, height: side)
        )
        
        self.init(frame: squaredFrame)
    }
}

extension CircleView where Self: UIView {
    init(diameter: CGFloat) {
        self.init(side: diameter)
        
        layer.cornerRadius = diameter
    }
}

class Square: UIView, SquareView { }
class Circle: UIView, CircleView { }

let squared = Square(side: 20)
square.backgroundColor = .blue

let circled = Circle(diameter: 20)
circle.backgroundColor = .blue
