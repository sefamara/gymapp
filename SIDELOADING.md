# Probar GymApp en tu iPhone sin Mac y sin cuenta paga

Esta guía cubre la ruta para instalar y mantener GymApp en tu iPhone usando solo:
- Un Apple ID gratis (sin Apple Developer Program de pago).
- GitHub Actions para compilar (no necesitas una Mac propia).
- [SideStore](https://sidestore.io) para firmar e instalar, con refresco automático **por internet**, sin depender de estar en la misma red wifi que ninguna computadora.

> Las herramientas de sideloading (SideStore/AltStore) son proyectos de comunidad, no oficiales de Apple. Los pasos exactos de instalación cambian con cierta frecuencia — si algo no coincide, revisa la documentación actual en sidestore.io antes de asumir que este documento está desactualizado.

## 1. Compilar el `.ipa` sin signar (GitHub Actions)

1. Sube esta carpeta (`GymApp/`) a un repositorio de GitHub (puede ser público, así los minutos de runner macOS son gratis/ilimitados).
2. El workflow ya está en `.github/workflows/build-unsigned-ipa.yml`. Ve a la pestaña **Actions** del repo → **Build unsigned IPA** → **Run workflow**.
3. Cuando termine, descarga el artifact `GymApp-unsigned` (contiene `GymApp.ipa`) desde esa misma corrida.

Este `.ipa` **no está firmado** a propósito — SideStore hace la firma con tu Apple ID al momento de instalar, que es como logra usar cuentas gratis sin pasar por Xcode.

### Si el build falla por el entitlement de iCloud

La firma gratuita de Apple no siempre permite el capability de iCloud/CloudKit. Si el paso de archive falla o SideStore rechaza la instalación por esto:
- En `project.yml`, borra el bloque `entitlements:` completo.
- En `Sources/GymApp/GymAppApp.swift`, cambia `cloudKitDatabase: .automatic` por `cloudKitDatabase: .none`.
- Vuelve a correr el workflow.

La app sigue funcionando igual de bien en modo solo-local; simplemente no sincroniza entre dispositivos.

## 2. Instalar SideStore en el iPhone

1. Instala SideStore siguiendo la guía oficial vigente en https://sidestore.io/#/getting-started (el método actual usa un helper de pairing que puede correr en Windows, Mac o Linux, o directamente en el iPhone según la versión).
2. Abre SideStore y agrega tu Apple ID gratis (Settings → Sign in). Esto reemplaza el paso que normalmente hace Xcode.
3. Importa el `GymApp.ipa` descargado: en el iPhone, comparte el archivo (AirDrop, iCloud Drive, Files, etc. — no necesita wifi compartida con nada) hacia **SideStore** usando el share sheet, o usa la opción "Import IPA" dentro de la app.
4. SideStore lo firma con tu Apple ID y lo instala. La primera vez, iOS puede pedirte confiar en el desarrollador: **Ajustes → General → VPN y gestión de dispositivos → confiar en tu Apple ID**.

## 3. Uso diario sin wifi

- Una vez instalada, GymApp corre completamente offline — SwiftData guarda todo en el propio iPhone.
- Los certificados de Apple ID gratis expiran cada **7 días**. SideStore refresca la firma automáticamente en segundo plano usando su túnel por internet (no requiere estar en ninguna red específica), siempre que SideStore tenga permiso de "Background App Refresh" y la app haya sido abierta al menos una vez recientemente.
- Límite de Apple: máximo **3 apps firmadas por Apple ID cada 7 días**. Si ya tienes otras apps sideloaded con el mismo Apple ID, puede que debas esperar o usar un Apple ID distinto para GymApp.

## Alternativa más simple (si esto se siente frágil)

Pedir prestada una Mac (o rentar una hora en un servicio como MacinCloud) una vez por semana para correr `xcodegen generate` → abrir en Xcode → `⌘R` con el iPhone por cable es más confiable, a costa de tener que repetir ese paso cada 7 días. Los pasos completos están en el `README.md` principal.
