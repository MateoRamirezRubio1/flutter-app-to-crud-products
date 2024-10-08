# 🛠️ Aplicación Flutter para la API de Productos 📦

![image](https://github.com/user-attachments/assets/af6ab023-a072-47fa-8e20-5c5bf3c9c5ee)

Esta aplicación está diseñada para interactuar con una API RESTful de backend y está destinada a fines de práctica y demostración. Para obtener detalles sobre la API y cómo funciona el backend, por favor consulta el [repositorio del backend](https://github.com/MateoRamirezRubio1/back_crud_products) y sigue los pasos propuestos ahí para poder disfrutar de la app completa.

## Demostración app funcional conectada con el Backend nodejs
https://github.com/user-attachments/assets/8e6ec2e0-b3b3-4771-baf1-c0f8242a9a1b

## 📝 Contenido

- [Descripción](#descripción)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Ejecutar la Aplicación](#ejecutar-la-aplicación)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Enlaces Útiles](#enlaces-útiles)

## 🎯Descripción

Esta aplicación Flutter se conecta a una API RESTful para realizar operaciones CRUD en productos. Los usuarios pueden listar, crear, editar y eliminar productos, así como ver imágenes asociadas a cada producto.

## ⚙Requisitos

Para ejecutar esta aplicación, necesitarás instalar las siguientes herramientas:

1. **[Flutter SDK](https://flutter.dev/docs/get-started/install):** El kit de desarrollo para construir y ejecutar aplicaciones Flutter.
2. **[Android Studio](https://developer.android.com/studio):** IDE recomendado para desarrollar aplicaciones Flutter, que incluye un emulador de Android.
3. **[Emulador de Android](https://developer.android.com/studio/run/emulator):** Necesario para probar la aplicación en un entorno simulado o un dispositivo físico.

## 🚀Instalación

1. **Clonar el Repositorio**

   Clona este repositorio en tu máquina local:

   ```bash
   git clone https://github.com/MateoRamirezRubio1/flutter-app-to-crud-products.git
   ```

2. **Navega al directorio del proyecto:**

   ```bash
   cd flutter-app-to-crud-products
   ```

3. **Instala las dependencias de Flutter:**

   Asegúrate de que todas las dependencias estén instaladas ejecutando:

    ```bash
   flutter pub get
    ```

## 🔧Configuración

1. **Crea un Archivo `.env`:**

   En el directorio raíz del proyecto, crea un archivo `.env` con el siguiente contenido:

    ```plaintext
    API_URL=http://127.000.0.1:3000
    ```

   Reemplaza `127.000.0.1` con la IP donde se está ejecutando tu servidor API que en este caso sería la IP de tu computadora (Si ya seguiste todos los pasos de la condiguración de la [API RESTful](https://github.com/MateoRamirezRubio1/back_crud_products)).

## 🏃‍♂Ejecutar la Aplicación

Para ejecutar la aplicación en un emulador de Android o en un dispositivo físico:

1. **Abre Android Studio y asegúrate de tener un emulador configurado o un dispositivo conectado y ejecutandose.**

2. **Lista los dispositivos disponibles:**

    ```bash
   flutter devices
    ```

3. **Ejecuta la aplicación en el dispositivo o emulador deseado**

    ```bash
   flutter run --release -d <device_id>
    ```

   Reemplaza <device_id> con el ID del dispositivo o emulador que aparece en la lista de dispositivos disponibles.
   Esto compilará la aplicación para producción, optimizando el rendimiento.

## 📂Estructura del Proyecto

- `android/`: Archivos específicos para la plataforma Android.
- `ios/`: Archivos específicos para la plataforma iOS.
- `lib/`: Contiene el código fuente de la aplicación Flutter.
  - `feature_1/`: Módulo para la primera característica de la aplicación.
  - `models/`: Definiciones de modelos de datos.
    - `product.dart`: Modelo de datos para productos.
  - `screens/`: Pantallas de la aplicación.
    - `product_create_screen.dart`: Pantalla para crear un nuevo producto.
    - `product_detail_screen.dart`: Pantalla para ver los detalles de un producto.
    - `product_edit_screen.dart`: Pantalla para editar un producto existente.
    - `product_list_screen.dart`: Pantalla para listar todos los productos.
  - `services/`: Servicios para interactuar con la API.
    - `api_service.dart`: Servicio para manejar la comunicación con la API RESTful.
  - `main.dart`: Archivo principal para iniciar la aplicación.
- `web/`: Archivos específicos para la plataforma web.
- `linux/`: Archivos específicos para la plataforma Linux.
- `macos/`: Archivos específicos para la plataforma macOS.
- `windows/`: Archivos específicos para la plataforma Windows.
- `.flutter-plugins-dependencies`: Información sobre las dependencias de plugins de Flutter.
- `.gitignore`: Archivos y directorios que deben ser ignorados por Git.
- `.metadata`: Metadatos del proyecto de Flutter.
- `README.md`: Este archivo.
- `analysis_options.yaml`: Configuración para análisis estático de código.
- `pubspec.yaml`: Archivo de configuración para las dependencias de la aplicación.

## 🌐Enlaces Útiles

- [Documentación de Flutter](https://flutter.dev/docs)
- [Guía de Instalación de Flutter](https://flutter.dev/docs/get-started/install)
- [Documentación de Android Studio](https://developer.android.com/studio/intro)

