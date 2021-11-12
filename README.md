# Hunahpu

Hunahpu nace de la idea de una aplicación de comparador y verificador de precios de productos para las 3 mas grandes cadenas de supermercados en el norte de México (Waltmart, HEB y Soriana).
La aplicacion hace uso de framework flutter para el Frontend y como Backend se utiliza Firebase Firestore.
Algunas de las funciones clave de la apicación:
- Login mediante Facebook y Gmail.
- Lectura de codigo de barras de productos.
- Busqueda manual (por teclado) de productos haciendo uso de funciones de Google cloud y Elastic search.
- Navegación por distintos departamentos de productos.
- Lectura y manejo de JSON (Pagina de Sub-departamentos y categorias).
- Creacion de lista de productos favoritos (Escritura y eliminación de elementos JSON en un archivo que se crea en el almacenamiento del dispostivo móvil).

Para la creacion de productos en la base de datos firestore se utilizo un codigo a parte de python que hace uso de la libreria BeautifulSoup para recopilar la información de los productos y evitar meter la información a mano.

NOTA: Por cuestiones de costos y tiempos la apliación no pudo llegar a su fin, como funciones extra se tenia considerado:
- Mostrar los precios de las tiendas según el estado de México donde se haga uso.
- Completar los departamentos con todos los productos usuales.
- Agregar un modulo si al escanear un codigo de barras no se encuentra el producto y que usuario pueda solicitarlo.
- Una cuarta pantalla de productos mas buscados o en rebajas.

Ejemplo en acción: 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
