# Final Sistemas Distribuidos Lucas Bloise Frontend

## Integrantes del grupo

- Lucas Bloise - 113763

## Descripción del Proyecto

Este proyecto es una aplicación de Flutter que consume la API de Rick and Morty para mostrar personajes de la serie. Se integra con **Auth0** para gestionar la autenticación de usuarios y con un **backend propio** que actúa como intermediario para realizar operaciones con la API de Rick and Morty. Permite a los usuarios ver una lista de personajes, buscarlos por nombre y, para los usuarios autenticados, añadirlos a una lista de favoritos. La aplicación demuestra una arquitectura limpia y modular, haciendo uso de inyección de dependencias, un sistema de navegación robusto y una clara separación de responsabilidades.

## Arquitectura

La aplicación sigue una arquitectura limpia, separando las preocupaciones en diferentes capas y módulos. La estructura principal del proyecto se encuentra dentro del directorio `lib` y se organiza de la siguiente manera:

- **`features`**: Contiene los diferentes módulos o características de la aplicación. Cada *feature* (como `home` o `favorites`) está auto-contenida y sigue una estructura interna similar:
    - **`data`**: Define los modelos de datos (ej. `Character`).
    - **`presentation`**: Contiene la interfaz de usuario y la lógica de presentación.
        - **`views`**: Son los widgets que representan las pantallas (ej. `HomeView`). Utilizan un `StatefulWidget` para manejar su ciclo de vida y estado local de la UI.
        - **`view_models`**: (ej. `HomeViewModel`). Actúan como intermediarios entre las vistas y los servicios. Contienen la lógica de negocio, manejan el estado de la *feature* y notifican a las vistas sobre los cambios utilizando el patrón `ChangeNotifier`.
        - **`widgets`**: Widgets reutilizables dentro de la *feature* (ej. `CharacterCard`).
    - **`services`**: Contiene la lógica para interactuar con fuentes de datos externas, como APIs. Se definen a través de una abstracción (`i_character_service.dart`) y una implementación concreta (`character_service.dart`).

- **`infrastructure`**: Contiene la configuración y la lógica transversal a toda la aplicación.
    - **`ioc_manager.dart`**: Gestiona la Inyección de Dependencias (IoC) utilizando el paquete `get_it`. Centraliza el registro de todas las dependencias de la aplicación (servicios, view models, etc.), facilitando el desacoplamiento y la testeabilidad.
    - **`environments_config.dart`**: Maneja la configuración de diferentes entornos (ej. producción, desarrollo) cargando variables desde un archivo `.env`.

- **`integrations`**: Contiene la implementación de servicios externos o librerías.
    - **`http_helper`**: Abstracción sobre el cliente HTTP (`dio`) para realizar peticiones a las APIs.
    - **`injector`**: Abstracción sobre el inyector de dependencias.
    - **`navigation`**: Gestiona la navegación y el enrutamiento de la aplicación utilizando el paquete `auto_route`. Define todas las rutas en `app_router.dart`.

El flujo de la aplicación comienza en `main.dart`, que inicializa los bindings de Flutter, carga la configuración del entorno, registra las dependencias en el `IocManager` y finalmente ejecuta la aplicación, configurando el `MaterialApp.router` con las rutas definidas en `AppRouter`.

## Tecnologías Utilizadas

- **Lenguaje**: Dart
- **Framework**: Flutter
- **Gestión de Estado**: `ChangeNotifier` y `Provider` (implícitamente a través de `ChangeNotifier`).
- **Navegación**: `auto_route` para una navegación tipada y generación de código.
- **Inyección de Dependencias**: `get_it` para el registro y resolución de dependencias.
- **Cliente HTTP**: `dio` para realizar peticiones a la API.
- **Autenticación**: `auth0_flutter` para la integración con Auth0.
- **Fuentes**: `google_fonts` para utilizar fuentes de Google.
- **Variables de Entorno**: `flutter_dotenv` para gestionar la configuración.
- **Análisis de código**: `flutter_lints` para asegurar buenas prácticas de codificación.

## Requisitos para su ejecución

- Flutter SDK (versión 3.6.0 o superior)
- Un navegador web (para la ejecución en web).
- Un archivo `.env` en la raíz del proyecto con las siguientes variables (ejemplo):
  ```
  AUTH0_DOMAIN=your_auth0_domain
  AUTH0_CLIENT_ID=your_auth0_client_id
  ```

## Instrucciones de instalación y ejecución

1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/tu_usuario/tu_repositorio.git
    cd tu_repositorio
    ```

2.  **Crear el archivo de entorno:**
    Crea un archivo llamado `.env` en la raíz del proyecto y añade las credenciales de Auth0 como se muestra en la sección de requisitos.

3.  **Obtener dependencias:**
    Ejecuta el siguiente comando en la terminal para descargar todas las dependencias del proyecto:
    ```bash
    flutter pub get
    ```

4.  **Generar archivos de rutas:**
    La librería de navegación utiliza un generador de código. Ejecuta el siguiente comando para generar los archivos necesarios:
    ```bash
    flutter pub run build_runner build
    ```
    Si realizas cambios en las rutas (`app_router.dart`), deberás volver a ejecutar este comando.

5.  **Ejecutar la aplicación:**
    Asegúrate de tener un emulador en ejecución o un dispositivo conectado. Luego, ejecuta:
    ```bash
    flutter run
    ```
    También puedes seleccionar un dispositivo de destino (Chrome, iOS, Android) desde tu editor de código y ejecutar la aplicación.
