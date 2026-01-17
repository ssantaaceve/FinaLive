//
//  README.md
//  FinaLive
//
//  Created by Sergio Andres  Santa Acevedo on 13/1/2026.
//
# FinaLive — MVP iOS App

Aplicación iOS enfocada en el control financiero personal, ahorro y beneficios alineados a objetivos del usuario.

---

## 🧠 Stack Tecnológico

- Plataforma: iOS
- UI: SwiftUI
- IDE: Xcode
- Editor asistido: Cursor
- Arquitectura: MVVM (ligera)
- Backend: Supabase
- Base de datos: PostgreSQL (Supabase)
- Analytics: App Store Connect / Firebase
- Versionado: Git + GitHub

---

## 📐 Arquitectura del Proyecto

Estructura base del proyecto:
FinaLive
├── App
├── Core
│ ├── Models
│ ├── Services
│ └── Extensions
├── Features
│ ├── Onboarding
│ ├── Home
│ └── AddTransaction
├── Components
└── Resources


---

## 🌿 Flujo de Trabajo con Git (OBLIGATORIO)

### Regla principal
**Nunca se trabaja directamente en `main`.**

Todo el desarrollo se hace en ramas de tipo `feature`.

---

### Crear un nuevo feature

1. Asegurarse de estar en la rama `main`
2. Crear una nueva rama con el formato: feature/nombre-del-feature


Ejemplos:
- feature/onboarding
- feature/home
- feature/add-transaction

---

### Desarrollo dentro del feature

- Un feature tiene un objetivo claro
- Los cambios deben ser pequeños y coherentes
- Un feature puede tener varios commits

Ejemplos de commits correctos:
Create onboarding view layout
Add continue button to onboarding
Add navigation between onboarding steps


Evitar commits genéricos como:
- update
- fix
- changes

---

### Commits

- Hacer commits frecuentemente
- Cada commit debe representar un avance entendible
- Si un cambio puede romper algo, debe tener su propio commit

---

### Push

Hacer push cuando:
- El código compila
- El flujo se puede probar
- El feature no está a medio camino

---

### Merge a main

Un feature se mergea a `main` cuando:
- Cumple su objetivo funcional
- No rompe el flujo principal
- La app sigue siendo estable

Después del merge, la rama puede eliminarse.

---

## 🤖 Uso de Cursor

Cursor se utiliza como asistente de desarrollo, no como reemplazo de criterio técnico.

### Reglas de uso:
- Dar contexto claro antes de pedir código
- Pedir cambios específicos, no genéricos
- Evitar generar grandes bloques de código sin entenderlos
- Hacer commits intermedios cuando Cursor genere cambios importantes

Prompt base recomendado para Cursor:
Eres un senior iOS developer.
Estoy construyendo un MVP en SwiftUI usando MVVM.
Quiero código simple, escalable y bien organizado.
No agregues lógica innecesaria.


Eres un senior iOS developer especializado en SwiftUI.

Estoy desarrollando un MVP iOS con SwiftUI y arquitectura MVVM ligera.
El proyecto sigue un Design System definido.

Reglas obligatorias:
- Usar colores y tipografías desde DesignSystem.swift
- No hardcodear colores ni fuentes
- Seguir lineamientos visuales modernos de Apple (Liquid Glass)
- UI limpia, clara y con buen espaciado
- Componentes reutilizables cuando tenga sentido
- Evitar sobrecargar la interfaz

Prioriza código limpio, escalable y mantenible.
Evita overengineering y código repetitivo.
Explica brevemente antes de mostrar código.


Estoy trabajando en el feature Onboarding.
Quiero crear la segunda pantalla con un input de ingresos mensuales.
Debe ser simple, accesible y fácil de entender.
No incluyas lógica de backend.


--------------------------------------
Errores
Eres un senior iOS developer experto en SwiftUI y MVVM.

Tengo un error de compilación en Xcode.

Contexto del proyecto:
- MVP iOS en SwiftUI
- Arquitectura MVVM ligera
- Código limpio y escalable
- Design System definido (no hardcodear colores ni fuentes)

Error exacto de Xcode:
Cannot find 'AuthView' in scope


Archivo:
FinaLiveApp.swift

Línea aproximada:
    @ViewBuilder
    private var rootView: some View {
        switch router.currentView {
        case .onboarding:
            OnboardingView(router: router)
        case .auth:
            AuthView(router: router)
        case .home:
            HomeView(router: router)
        }
    }


Código relevante:
[pega solo el bloque relacionado]

Qué intento hacer:
[describe brevemente el objetivo]

Necesito:
- Identificar la causa real del error
- Proponer una solución alineada con MVVM
- Mantener la arquitectura y reglas del proyecto
- Evitar soluciones temporales o hacks

Explica brevemente el problema antes de mostrar el código corregido.


---

## 🧭 Metodología de Desarrollo

El desarrollo sigue este ciclo:
Definir objetivo → Crear rama → Desarrollar → Commit → Push → Merge



Siempre se trabaja en un solo feature a la vez.

---

## 🚀 Estado del Proyecto (MVP)

- [x] Setup del proyecto
- [x] Git y GitHub configurados
- [ ] Onboarding
- [ ] Home
- [ ] Registro de ingresos y gastos
- [ ] Persistencia con Supabase
- [ ] IA ligera (insights)
- [ ] Monetización




