
class Musico {
	var habilidad
	var listaAlbumes
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
	method duracionObra() {
		return listaAlbumes.sum({ album => album.duracionTotal() })
	}
	method laPego() {
		return listaAlbumes.all({ album => album.buenasVentas() })
	}
	
	method agregarAlbum(listaDeAlbumesAAgregar) {
		listaAlbumes.add(listaDeAlbumesAAgregar)
	}
}

class MusicoDeGrupo inherits Musico {
	var cobra
	var aumentaEnGrupo

	constructor(cuantaHabilidad, solista, albumesPublicados, cantidadQueAumentaEnGrupo) =
	super ( cuantaHabilidad , solista , albumesPublicados ) {
		aumentaEnGrupo = cantidadQueAumentaEnGrupo
	}
	
	method interpretaBien(cancion) {
		return cancion.duracion() > 300
	}
	method habilidad() {
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
	method habilidad() {
		if (esSolista) {
			return habilidad
		}
		else {
			return habilidad - 20
		}
		
	}
	method interpretaBien(cancion) {
		return cancion.contiene(palabraClave)
	}
	method cobra(presentacion) {
		if (presentacion.esEnLugarConcurrido()) {
			return 500
		}
		else {
			return cobraComoBase
		}
	}
}

object luisAlberto inherits Musico ( 8 , true , [ ] ) {
	var guitarra = gibson
	
	method habilidad() {
		return 100.min(guitarra.unidades() * 8)
	}
	method interpretaBien(cancion) {
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
	var listaDeCanciones
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
	method duracionMasLarga() {
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
}

class Cancion {
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
	method esCorta() {
		return duracion < 180
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
	