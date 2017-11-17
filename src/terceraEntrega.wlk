
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
	method modificarHabilidad(nuevaHabilidad){
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

	constructor(canciones,dia,mes,anio, unidadesQueSalieron, unidadesQueSeVendieron) {
		listaDeCanciones = canciones 
		fechaLanzamiento = new Date(dia,mes,anio)
		unidades = unidadesQueSalieron
		unidadesVendidas = unidadesQueSeVendieron
	}
	method listarCanciones() {
		return listaDeCanciones
	}

	method esDeDuracionCorta() {
		return listaDeCanciones.all({ cancion => cancion.esCorta() })
	}
	method cancionConLaDuracionMasLarga() {
		return listaDeCanciones.max({ cancion => cancion.duracion() })
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
	method cancionConLaLetraMasLarga(){
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

	constructor(duracionCancion, letraCancion) {
		duracion = duracionCancion 
		letra = letraCancion
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
	constructor(duracionCancion, letraCancion) = super (duracionCancion, letraCancion){
		duracion = duracionCancion*3
		letra = "mueve tu cuelpo baby "+letraCancion+" yeah oh yeah"
	}
}

class Mashup inherits Cancion{
	constructor(duracionCancion, letraCancion, duracionCancion2, letraCancion2) = super (duracionCancion, letraCancion){
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
	constructor(_lugar,dia,mes,anio){
		lugar = _lugar
		fechaDePresentacion = new Date(dia, mes, anio)
	}
	method agregarCantantes(cantante) {
		cantantes.add(cantante)
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

	var cancionAlicia = new Cancion(510,"Qui�n sabe Alicia, este pa�s no estuvo hecho porque s�. Te vas a ir, vas a salir pero te quedas, �d�nde m�s vas a ir? Y es que aqu�, sabes el trabalenguas, trabalenguas, el asesino te asesina, y es mucho para ti. Se acab� ese juego que te hac�a feliz.")
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
		else
		{
			error.throwWithMessage("Error")
		}	
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
object soledad inherits VocalistaPopular(55,true,[laSole],"amor"){}
object laSole inherits Album([eres,corazonAmericano],04,02,2005,200000,130000){}
object eres inherits Cancion(145,"Eres lo mejor que me pas� en la vida, no tengo duda, no habr� m�s nada despu�s de ti. Eres lo que le dio brillo al d�a a d�a, y as� ser� por siempre, no cambiar�, hasta el final de mis d�as"){}
object corazonAmericano inherits Cancion (154,"Canta coraz�n, canta m�s alto, que tu pena al fin se va marchando, el nuevo milenio ha de encontrarnos, junto coraz�n, como so�amos."){}
	
object luisAlberto1 inherits Musico(8,true,[paraLosArboles,justCrisantemo]){}
object paraLosArboles inherits Album([cisne,almaDeDiamante],05,12,2007,28000,27500){}
object justCrisantemo inherits Album([crisantemo],05,12,2007,28000,27500){}
object cisne inherits Cancion(312,"Hoy el viento se abri� qued� vac�o el aire una vez m�s y el manantial brot� y nadie est� aqu� y puedo ver que solo estallan las hojas al brillar"){}
object almaDeDiamante inherits Cancion(216,"Ven a mi con tu dulce luz alma de diamante. Y aunque el sol se nuble despues sos alma de diamante. Cielo o piel silencio o verdad sos alma de diamante. Por eso ven así con la humanidad alma de diamante"){}
object crisantemo inherits Cancion(175,"Tocame junto a esta pared, yo quede por aqui... cuando no hubo mas luz... quiero mirar a traves de mi piel... Crisantemo, que se abrio... encuentra el camino hacia el cielo"){}
	
object joaquin inherits Musico(20,false,[especialLaFamilia]){
	override method interpretaBien(cancion){
	return self.obtenerListaDeCanciones().contains(cancion) || self.habilidad() > 60 || cancion.duracion()> 300
	}
}
object especialLaFamilia inherits Album([laFamilia],17,06,1992,100000,89000){}
object laFamilia inherits Cancion(264,"Quiero brindar por mi gente sencilla, por el amor brindo por la familia"){}
	
object kike inherits MusicoDeGrupo(60,false,[],20){}
object lucia inherits VocalistaPopular(70,true,[],"familia"){}
	
object remixLaFamilia inherits Remix(264,"Quiero brindar por mi gente sencilla, por el amor brindo por la familia"){}
object mashupDiamanteyCrisantemo inherits Mashup(216,"Ven a mi con tu dulce luz alma de diamante. Y aunque el sol se nuble despues sos alma de diamante. Cielo o piel silencio o verdad sos alma de diamante. Por eso ven así con la humanidad alma de diamante",175,"Tocame junto a esta pared, yo quede por aqui... cuando no hubo mas luz... quiero mirar a traves de mi piel... Crisantemo, que se abrio... encuentra el camino hacia el cielo"){}
object pdpalooza inherits PresentacionConRestricciones(lunaPark,15,12,2017){}
	
	
