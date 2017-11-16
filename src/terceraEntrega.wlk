
class Musico {
	var habilidad
	var listaAlbumes = [ ]
	var esSolista

	constructor(cuantaHabilidad, solista, albumesPublicados) {
		habilidad = cuantaHabilidad 
		listaAlbumes = albumesPublicados 
		esSolista =	solista
	}
	method dejarGrupo() {
		esSolista = true
	}
	method enGrupo(){
		esSolista = false
	}
	method esMinimalista() {
		return listaAlbumes.all({ album => album.esDeDuracionCorta() })
	}

	method contieneLaPalabra(palabra) {
		return listaAlbumes.flatMap({ album => album.queCancionesContienen(palabra) })	
	}
	
	method obtenerListaDeCanciones(){
		return ( listaAlbumes.flatMap({ album => album.listarCanciones() }) )

	}
	method duracionObra() {
		return listaAlbumes.sum({ album => album.duracionTotal() })
	}
	method laPego() {
		return listaAlbumes.all({ album => album.buenasVentas() })
	}
	
	method agregarAlbum(listaDeAlbumesAAgregar) {
		listaAlbumes.add(listaDeAlbumesAAgregar)
	}
	method interpretaBien(cancion){
	return self.obtenerListaDeCanciones().contains(cancion) || self.habilidad() > 60
	}
	method habilidad(){
		return habilidad
	}
	method esCompositor(){
		return self.obtenerListaDeCanciones().isEmpty().negate()
	}
	method habilidadMayorA(num){
		return self.habilidad() >= num
	}
	method habilidadMenorA(num){
		return self.habilidad() <= num
	}
	
}

class MusicoDeGrupo inherits Musico {
	var cobra
	var aumentaEnGrupo

	constructor(cuantaHabilidad, solista, albumesPublicados, cantidadQueAumentaEnGrupo) =
	super ( cuantaHabilidad , solista , albumesPublicados ) {
		aumentaEnGrupo = cantidadQueAumentaEnGrupo
	}
	
	override method interpretaBien(cancion) {
		return (super(cancion) || cancion.duracion() > 300)
		 
		
	}
	override method habilidad() {
		if (esSolista) {
			return habilidad
		}
		else {
			return habilidad + aumentaEnGrupo
		}
	}
	method cobra(presentacion) {
		if (esSolista) {
			cobra = 100
		}
		else {
			cobra = 50
		} return cobra
	}
}

class VocalistaPopular inherits Musico {
	var cobraComoBase = 400
	var palabraClave

	constructor(cuantaHabilidad, solista, albumesPublicados, palabraConLaQueTocaBien) =
	super ( cuantaHabilidad , solista , albumesPublicados ) {
		palabraClave = palabraConLaQueTocaBien
	}
	override method habilidad() {
		if (esSolista) {
			return habilidad
		}
		else {
			return habilidad - 20
		}
		
	}
	override method interpretaBien(cancion) {
		return super (cancion) || cancion.contiene(palabraClave)
	}
	method cobra(presentacion) {
		if (presentacion.esEnLugarConcurrido()) {
			return 500
		}
		else {
			return cobraComoBase
		}
	}
	method modificarHabilidad(nuevaHabilidad){ //method para los ultimos 2 tests
		habilidad = nuevaHabilidad
	}
}

object luisAlberto inherits Musico ( 8 , true , [ ] ) {
	var guitarra = gibson
	
	override method habilidad() {
		return 100.min(guitarra.unidades() * 8)
	}
	override method interpretaBien(cancion) {
		return true
	}
	method cobra(presentacion) {
		if (self.esAntesDeFechaTope(presentacion)) {
			return 1200 }
		else { return 1000 }
	}

	method esAntesDeFechaTope(presentacion) {
		return presentacion.fecha().month() >= 9 && presentacion.fecha().year() >=
		2017
	}

	method guitarra(unaGuitarra) {
		guitarra = unaGuitarra
	}
}

object gibson {
	var estaRota = false
	method unidades() {
		return if (estaRota) return 5 else 15
	}
	method cambiarARota() {
		estaRota = true
	}

	method cambiarASana() {
		estaRota = false
	}
}

object fender {

	method unidades() {
		return 10
	}
}

class Album {
	var listaDeCanciones = [ ]
	var titulo
	var fechaLanzamiento
	var unidades
	var unidadesVendidas

	constructor(canciones, tituloDisco,dia,mes,anio, unidadesQueSalieron, unidadesQueSeVendieron) {
		listaDeCanciones = canciones 
		fechaLanzamiento = new Date(dia,mes,anio)
		 titulo = tituloDisco
		unidades = unidadesQueSalieron
		unidadesVendidas = unidadesQueSeVendieron
	}
	method listarCanciones() {
		return listaDeCanciones
	}

	method esDeDuracionCorta() {
		return listaDeCanciones.all({ cancion => cancion.esCorta() })
	}
	method cancionConLaDuracionMasLarga() { //sirve para el punto1 del tp3
		return listaDeCanciones.max({ cancion => cancion.longitud() })
	}
	method buenasVentas() {
		return unidadesVendidas >= 0.75 * unidades
	}
	method queCancionesContienen(palabra) {
		return listaDeCanciones.filter({ cancion => cancion.contiene(palabra) })
	}
	method duracionTotal() {
		return listaDeCanciones.sum({ cancion => cancion.duracion() })
	}
	method cancionConTamanioDeLetraMasLargo(){
		return self.mayorSegun({cancion => cancion.longitud()})
	}
	method tituloMasLargo(){
		return listaDeCanciones.max({cancion => cancion.longitudTitulo()})
	}
	method mayorSegun(criterioBloque){
		return listaDeCanciones.max(criterioBloque)		
	}
}


class Cancion {
	var nombre
	var duracion
	var letra

	constructor(nombreCancion, duracionCancion, letraCancion) {
		nombre = nombreCancion duracion = duracionCancion letra = letraCancion
	}
	method duracion() {
		return duracion
	}
	method letra() {
		return letra
	}
	method contiene(palabra) {
		return letra.contains(palabra)
	}
	method longitud() {
		return letra.size()
	}
	method longitudTitulo() {
		return nombre.size()
		}
	method esCorta() {
		return duracion < 180
	}
}


	
class Remix inherits Cancion{
	constructor(nombreCancion, duracionCancion, letraCancion) = super (nombreCancion, duracionCancion, letraCancion){
		duracion = duracionCancion*3
		letra = "mueve tu cuelpo baby "+letraCancion+" yeah oh yeah"
	}
}

class Mashup inherits Cancion{
	
	
	
	constructor(nombreCancion, duracionCancion, letraCancion, nombreCancion2, duracionCancion2, letraCancion2) = super (nombreCancion, duracionCancion, letraCancion){
		nombre = nombreCancion + " " + nombreCancion2
		duracion = duracionCancion.max(duracionCancion2)
		letra = letraCancion + " " + letraCancion2
	}
}	

object lunaPark {
	var capacidad = 9290
	method capacidad(dia, mes, anio) {
		return capacidad
	}
	method concurrido() {
		return capacidad > 5000
	}
}

object laTrastienda {
	var capacidad = 400
	
	method esSabado(dia, mes, anio) {
		var unDia
		unDia = new Date(dia, mes, anio) return unDia.dayOfWeek() == 6
	}
	method capacidad(dia, mes, anio) {
		if (self.esSabado(dia, mes, anio)) return capacidad + 300 return capacidad
	}
	method concurrido() {
		return capacidad > 5000
	}
}

class Presentacion {
	var lugar
	var cantantes = []
	var fechaDePresentacion
	method modificarFecha(dia, mes, anio) {
		fechaDePresentacion = new Date(dia, mes, anio)
	}
	method modificarLugar(nuevoLugar) {
		lugar = nuevoLugar
	}
	method modificarCantantes(listaCantantes) {
		cantantes = listaCantantes
	}
	method esEnLugarConcurrido() {
		return lugar.concurrido()
	}
	method costo() {
		return cantantes.sum({ cantante => cantante.cobra(self) })
	}
	method fecha() {
		return fechaDePresentacion
	}
}
	
class PresentacionConRestricciones inherits Presentacion{
	var cancionAlicia = new Cancion("Canci?n de Alicia en el pa?s",510,"Qui?n sabe Alicia, este pa?s no estuvo hecho porque s?. Te vas a ir, vas a salir pero te quedas, ?d?nde m?s vas a ir? Y es que aqu?, sabes el trabalenguas, trabalenguas, el asesino te asesina, y es mucho para ti. Se acab? ese juego que te hac?a feliz.")
	method cantanteConHabilidadMayorAlMinimo(cantante){
		return cantante.habilidadMayorA(70)
	}
	method cantanteDebeSerCompositor(cantante){
		return cantante.esCompositor() 
	}
	method cantanteDebeInterpretarBienLaCancion(cantante,cancion){
		return cantante.interpretaBien(cancion)
	}
	method agregarUnCantante(cantante){
		if (self.cantanteConHabilidadMayorAlMinimo(cantante) && self.cantanteDebeSerCompositor(cantante) && self.cantanteDebeInterpretarBienLaCancion(cantante,cancionAlicia)){
			cantantes.add(cantante)	
		}
		else{
			if (not (self.cantanteConHabilidadMayorAlMinimo(cantante))) {error.throwWithMessage("El cantante no cumple con la habilidad minima de 70!!")}
			if (not (self.cantanteDebeSerCompositor(cantante))) {error.throwWithMessage("El cantante no es compositor!!")}
			else {error.throwWithMessage ("El cantante no interpreta la cancion Alicia!!")}
		}	
	}
	method cantantesAceptados(){
		return cantantes
	}
	
}

//Punto Bonus
class PresentacionRestringida inherits Presentacion{
	var listaDeCondiciones = []
	method agregarCondiciones(condicion){
		listaDeCondiciones.add(condicion)
	}
	method eleminarCondiciones(condicion){
		listaDeCondiciones.remove(condicion)
	}
	method agregarUnCantante(cantante){
		if (listaDeCondiciones.all({condicion => condicion.seCumple(cantante)})){
			cantantes.add(cantante)
		}
	}
	method condicionesVigentes(){
		return listaDeCondiciones
	}
	method cantantesAceptados(){
		return cantantes
	}
}

class CondicionHabilidadMayorA{
	var habilidad
	constructor(habilidadAEvaluar) {
		habilidad = habilidadAEvaluar
	}
	method seCumple(cantante){
		if(cantante.habilidadMayorA(habilidad))
		{return true}
		else
		{error.throwWithMessage("La habilidad debe ser mayor a " + habilidad)
			return false
		}
	}
}

class CondicionHabilidadMenorA{
	var habilidad
	constructor(habilidadAEvaluar) {
		habilidad = habilidadAEvaluar
	}
	method seCumple(cantante){
		return cantante.habilidadMenorA(habilidad)	
	}
}

class CondicionDebeSerCompositor{
	var esONoCompositor
	constructor(booleanoElegido) {
		esONoCompositor = booleanoElegido
	}
	method seCumple(cantante){
		if ((esONoCompositor and cantante.esCompositor())
			or
			(esONoCompositor.negate() and cantante.esCompositor().negate())
		)
		{
			return true
		}
		else {
			error.throwWithMessage("El cantante no cumple con el requisito de ser o no compositor")
			return false
		}	
	}
}

class CondicionSabeInterpretar{
	var cancion
	constructor(cancionADefinir) {
		cancion = cancionADefinir
	}
	method seCumple(cantante){
		if(cantante.interpretaBien(cancion)){
		return true
		}
		else{
		error.throwWithMessage("El cantante no interpreta " + cancion.nombre() + "!!")
		return false
		}
	}
}

//
	
	
