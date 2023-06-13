class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	
	method cargarCombustible(cuanto) {
		combustible += cuanto
	}
	method descargarCombustible(cuanto) {
		combustible = 0.max(combustible - cuanto)
	}
	method acelerar(cuanto) {
		velocidad = 0.max((velocidad + cuanto.abs()).min(100000))
	}
	method desacelerar(cuanto) { 
		velocidad = 0.max(velocidad - cuanto.abs())
	}
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	method acercarseUnPocoAlSol() {
		direccion = 10.min(direccion++)
	}
	method alejarseUnPocoDelSol(){
		direccion = -10.max(direccion--)
	}
	method prepararViaje() {
		self.prepararViajeCondicionComun()
		self.prepararViajeCondicionParticular()
	}
	method prepararViajeCondicionComun() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method prepararViajeCondicionParticular()
	method estaTranquila(){
		return self.estaTranquilaCondComun() &&
		self.estaTranquilaCondPart()
	}
	method estaTranquilaCondComun() {
		return combustible >= 4000 &&
		velocidad <= 12000
	}
	method estaTranquilaCondPart()
	method escapar()
	method avisar()
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	method estarDeRelajo(){
		return self.estaTranquila() && self.tienePocaActividad()
	}
	method tienePocaActividad()
}

class NaveBaliza inherits NaveEspacial {
	var colorBaliza = "rojo"
	var cambioDeColor = 0
	
	method colorBaliza() = colorBaliza
	method cambiarColorDeBaliza(colorNuevo) {
		colorBaliza = colorNuevo
		cambioDeColor++
	}
	override method prepararViajeCondicionParticular() {
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	override method estaTranquilaCondPart() {
		return colorBaliza != "rojo"
	}
	override method escapar(){
		self.irHaciaElSol()
	}
	override method avisar() {
		self.cambiarColorDeBaliza("rojo")
	}
	override method tienePocaActividad(){
		return cambioDeColor == 0
	}
}

class NaveDePasajeros inherits NaveEspacial {
	const property cantidadDePasajeros
	var racionesDeComida = 0
	var racionesDeBebida = 0
	var totalDeRacionesServidas = 0
	
	method racionesDeComida() = racionesDeComida
	method cargarComida(cuanto) {racionesDeComida += cuanto}
	method descargarComida(cuanto) {
		racionesDeComida = 0.max(racionesDeComida - cuanto)
		totalDeRacionesServidas *= cuanto
	}
	method racionesDeBebida() = racionesDeBebida
	method cargarBebida(cuanto) {racionesDeBebida += cuanto}
	method descargarBebida(cuanto) {
		racionesDeComida = 0.max(racionesDeBebida - cuanto)
	}
	override method prepararViajeCondicionParticular() {
		self.cargarComida(4*cantidadDePasajeros)
		self.cargarBebida(6*cantidadDePasajeros)
		self.acercarseUnPocoAlSol()
	}
	override method estaTranquilaCondPart() {
		return true
	}
	override method escapar(){
		self.acelerar(velocidad*2)
	}
	override method avisar() {
		self.descargarComida(cantidadDePasajeros)
		self.descargarBebida(cantidadDePasajeros*2)
	}
	override method tienePocaActividad(){
		return totalDeRacionesServidas < 50
	}
}

class NaveDeCombate inherits NaveEspacial {
	var estaInvisible = false
	var misilesDesplegados = false
	const property mensajesEmitidos = []
	
	method estaInvisible() = estaInvisible
	method misilesDesplegados() = misilesDesplegados
	method ponerseVisible() {
		estaInvisible = false
	}
	method ponerseInvisible() {
		estaInvisible = true
	}
	method desplegarMisiles() {
		misilesDesplegados = true
	}
	method replegarMisiles() {
		misilesDesplegados = false
	}
	method emitirMensaje(unMensaje) {
		mensajesEmitidos.add(unMensaje)
	}
	method primerMensajeEmitido() {
		if(mensajesEmitidos.isEmpty()) self.error("no hay mensajes")
		return mensajesEmitidos.first()
	}
	method ultimoMensajeEmitido() {
		if(mensajesEmitidos.isEmpty()) self.error("no hay mensajes")
		return mensajesEmitidos.last()
	}
	method esEscueta() {
		return mensajesEmitidos.all({m=>m.size() <= 30})
	}
	method esEscuetaConAny() {
		return !mensajesEmitidos.any({m=>m.size() > 30})
	}
	method emitioMensaje(mensaje) {
		return mensajesEmitidos.contains(mensaje)
	}
	override method prepararViajeCondicionParticular() {
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en mision")
	}
	override method estaTranquilaCondPart() {
		return !self.misilesDesplegados()
	}
	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar() {
		self.emitirMensaje("Amenaza recibida")
	}
	override method tienePocaActividad(){
		return self.esEscueta()
	}
}

class NaveHospital inherits NaveDePasajeros{
	var property quirofanosPreparados = false
	override method estaTranquilaCondPart() {
		return !self.quirofanosPreparados()
	}
	override method recibirAmenaza() {
		super()
		self.quirofanosPreparados(true)
	}
}

class NaveSigilosa inherits NaveDeCombate {
	override method estaTranquilaCondPart() {
		return !self.estaInvisible()
	}
	override method escapar() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
		
	}
	
}