# Creador de sólidos de revolución

Este proyecto tiene como objetivo desarrollar un programa para que un usuario pueda crear distintos sólidos de revolución

## Características de la aplicación

- Pantalla de inicio que introduce la aplicación al usuario. Contiene:
    - Controles:
        - Enter: Crear la figura
        - R/r: Resetear el juego
        - D/d: Borrar último punto añadido
    - Indicaciones para dibujar puntos
- Se dibuja una silueta pulsando con ratón por la parte derecha de la ventana
- Se crea un sólido de revolución a partir del perfil dibujado, esta figura seguirá el movimiento del ratón.

## Decisiones
###### Creación de la figura
- Se añaden dos vertices nuevos, uno a la misma altura del primer punto y otro en el último. La posición en el eje horizontal de estos puntos es justo la mitad, de esta forma la figura queda completamente cerrado.
- Para crear la figura se crean todos los triangulos. Esto se hace recorriendo capa a capa y creando los puntos que contecten esta capa con la superior e inferior.
- Se tiene en cuenta cual es su punto más alto y más bajo para que la figura creada este centrada con el ratón del usuario.

###### Detección de puntos
- Solo se detectan puntos a la derecha de la pantalla
- Si se mantiene pulsado el botón del ratón se detectan los puntos de forma consecutiva.
- Un punto no se detectará si no hay una distancia mayor de 15 entre el último punto y el nuevo.

## Resultado final
A continuación se ve un ejemplo de la aplicación:

![](resultado.gif)

## Herramientas utilizadas
- [Editar el readme.md](https://dillinger.io/)
- [Processing](https://processing.org/)

Realizado por [José Juan Reyes Cabrera](https://github.com/JoseJuanRC)
