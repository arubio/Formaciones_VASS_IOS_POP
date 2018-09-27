/*:
 
 # Value-types vs Reference types
 
 ### Antes de hablar de programación orientada a protocolos es importante hablar de qué son los value-types, ya que brillan especialmente cuando los usamos junto a protocolos.
 
 ## ¿Qué es un reference type?

 Muchas veces nuestras estructuras de datos necesitan de un cicle de vida explícito, por ejemplo: un File Handler.

 Cuando escribimos a un archivo actuamos a través de un File Handler. En este contexto el ciclo de vida sería: abrimos el archivo, escribimos en el archivo y cerramos el archivo/destruimos nuestro objeto. Si en otra parte de la aplicación tuvieramos otro File Handler con exactamente las mismas propiedades que el anterior, seguiríamos teniendo la necesidad de diferenciar entre nuestras dos instancias de File Handler, por lo que las compararíamos por su dirección en memoria. Por esto, la implementación de este File Handler se beneficiaría de ser un reference type.
 
 Dentro de nuestro contexto como desarrolladores, hay muchos tipos de objetos que tienen y se benefician de un ciclo de vida, ej: interfaces de red, conexiones a base de datos, view controllers.

 
 ## ¿Qué es un value type?

 De la misma forma, también existen muchos tipos de objetos que solo están definidos por las propiedades que tienen, y por lo tanto no nos interesa su dirección en memoria ya que los compararíamos comparando sus propiedades.
 
 Los value-types son inmutables, no tienen este ciclo de vida interno que suelen tener los reference types. Además, los value-types solo tienen un propietario, siempre que se pasen de un contexto a otro serán copiados, y nunca se compartiran entre varios contextos (a diferencia de un reference type, que podrá tener multiples propietarios).
 
 ## En el contexto de Swift
 
 * Todos los datos definidos como ```class``` actuarán como reference types. Además, los closures también serán reference types.
 * Todos los datos definidos como ```struct```, ```enum``` serán value types.
 

 Más tarde hablaremos de las ventajas y desventajas de cada uno de estos tipos.
 
 */

// MARK: Reference

class DBConn {
    var type: String
    
    init(type: String) { self.type = type }
}

let postgresConn = DBConn(type: "postgres")
let postgresConn2 = postgresConn

postgresConn.type = "mysql"

dump(postgresConn)
dump(postgresConn2)

print(postgresConn === postgresConn2)

// MARK: Value

struct Address {
    var street: String
}

var address = Address(street: "C/ Europa Nº 1")
let address2 = address

// address2 === address no compila

address.street = "C/ Europa Nº 2"

print(address)
print(address2)


