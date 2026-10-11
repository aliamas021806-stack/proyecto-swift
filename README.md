# GestorCitas — Conversión de Stitch a SwiftUI

Proyecto **SwiftUI** (iOS 17+) que reproduce fielmente el diseño "Gestor de Citas
Médicas" exportado desde **Stitch**, aplicando el sistema de diseño
**"Clinical Soft Light"** (`clinical_soft_light/DESIGN.md`).

> ⚠️ **Nota importante sobre el entorno de generación**
> Este código se generó en un sandbox **Linux sin toolchain de Swift/Xcode**.
> Por eso **no** se ha podido compilar ni previsualizar aquí. Es código fuente
> SwiftUI listo para abrir en **Xcode en un Mac**. Sigue las instrucciones de
> "Cómo abrir" para generar el proyecto `.xcodeproj`.

---

## Estructura del proyecto

```
GestorCitas/
├── project.yml                     # Definición XcodeGen (genera el .xcodeproj)
├── README.md
└── GestorCitas/
    ├── App/
    │   ├── GestorCitasApp.swift     # @main — punto de entrada
    │   └── RootTabView.swift        # Barra inferior flotante + secciones
    ├── DesignSystem/
    │   └── Theme.swift              # Colores, tipografía, espaciado, sombras
    ├── Models/
    │   └── Models.swift             # Modelos de dominio + datos de ejemplo
    ├── Components/
    │   ├── Components.swift         # Avatar, badges, botones, chips, cards…
    │   └── AppHeader.swift          # Cabecera glassmorphic + logo MediCare
    ├── Screens/
    │   ├── DashboardView.swift      # Pantalla 1 · Citas
    │   ├── CalendarView.swift       # Pantalla 2 · Calendario y agenda
    │   ├── NewAppointmentView.swift # Pantalla 3 · Nueva cita (stepper)
    │   └── AppointmentDetailView.swift # Pantalla 4 · Detalle de cita
    └── Resources/
        └── Assets.xcassets          # AppIcon + AccentColor
```

---

## Pantallas convertidas

| # | Pantalla Stitch            | Archivo SwiftUI                        | Estado |
|---|----------------------------|----------------------------------------|--------|
| 1 | `gestor_de_citas_dashboard`| `Screens/DashboardView.swift`          | ✅ |
| 2 | `calendario_y_agenda_de_citas` | `Screens/CalendarView.swift`       | ✅ |
| 3 | `nueva_cita_m_dica`        | `Screens/NewAppointmentView.swift`     | ✅ |
| 4 | `detalle_de_cita_m_dica`   | `Screens/AppointmentDetailView.swift`  | ✅ |
| — | `medicare_logo`            | `Components/AppHeader.swift` → `MediCareLogo` | ✅ |

---

## Sistema de diseño (`Theme.swift`)

Traducción directa de `clinical_soft_light/DESIGN.md`:

- **Colores** — `AppColor`: superficies, primario (azul `#004AC6`/`#2563EB`),
  secundario (menta `#006C49`), terciario, error, ámbar, azul "en consulta".
- **Tipografía** — `AppFont`: *Plus Jakarta Sans* (títulos) + *Inter* (cuerpo).
  Incluye helper `tabularNumbers` para alinear horas/fechas.
- **Espaciado** — `AppSpacing`: grid base de 8 pt (`xs…xl`, márgenes, gutters).
- **Radios** — `AppRadius`: 16 pt tarjetas, 12 pt campos, pill para badges.
- **Sombras** — `AppShadow` + modificador `.cardStyle()` (borde hairline +
  sombra tintada azul suave, tal como define el DESIGN.md).

### Fuentes (opcional)

Para fidelidad tipográfica total, añade al target en Xcode:
`PlusJakartaSans-*.ttf` e `Inter-*.ttf`, e inclúyelas en `Info.plist` bajo
`UIAppFonts`. Si no se añaden, `Font.custom` cae al sistema con el peso correcto
y el layout se mantiene intacto.

---

## Componentes reutilizables (`Components.swift`)

- `AvatarView` — avatar por iniciales con color determinista por semilla.
- `StatusBadge` — píldora de estado con punto indicador y color semántico
  (Confirmada / Pendiente / En Consulta / Cancelada / En Espera).
- `PrimaryButton`, `SoftButton`, `IconButton` — jerarquía de botones.
- `SelectableChip`, `PeriodPill` — filtros y píldoras de fecha.
- `MetricCard` — tarjetas de métricas del carrusel pastel.
- `ClinicalToggle` — interruptor de estilo clínico (recordatorio, ayunas).
- `DocumentRow` — fila de expediente/recetas con previsualizar y descargar.
- `SectionHeader`, `Hairline`, `AnyShape` — utilidades.

---

## Interacciones implementadas

- **Dashboard**: selector de período (Hoy/Mañana/Esta semana), filtros por
  especialidad, conmutador Lista/Agenda, buscador.
- **Calendario**: toggle Vista Día/Semana, selector de especialistas, timeline
  con huecos libres, pausa clínica y drawer de ocupación expandible.
- **Nueva Cita**: stepper de 4 pasos, selector de día y franjas horarias
  (con slots ocupados deshabilitados), modalidad presencial/telemedicina,
  motivo, switches y estado de guardado con feedback.
- **Detalle**: snapshot del paciente, sala virtual, expediente, y notas
  médicas con modo edición (editar/guardar/cancelar).

---

## Cómo abrir el proyecto

### Opción A — XcodeGen (recomendada)

```bash
# En un Mac, dentro de la carpeta GestorCitas/
brew install xcodegen     # si no lo tienes
xcodegen generate         # crea GestorCitas.xcodeproj
open GestorCitas.xcodeproj
```

### Opción B — Manual

1. Xcode → **File ▸ New ▸ Project ▸ App** (SwiftUI, nombre `GestorCitas`).
2. Borra los archivos generados y arrastra la carpeta `GestorCitas/` al proyecto.
3. Establece el *deployment target* en **iOS 17.0**.
4. Compila y ejecuta (⌘R) en un simulador de iPhone.

---

## Requisitos

- macOS con **Xcode 15+**
- **iOS 17.0+** (usa `.scrollContentBackground`, `NavigationStack`, `FlowTags`, etc.)
- Swift 5.9

---

## Estructura de datos (modelos)

`Patient`, `Doctor`, `Appointment`, `AgendaItem` (unión de cita / hueco libre /
pausa), `SlotOption`, `DayChip`, y enums `AppointmentStatus`,
`AppointmentModality`, `QuickFilter`, `PeriodFilter`. Los datos de ejemplo
replican exactamente los del export de Stitch (`SampleData`).

---

## Pendiente / próximos pasos

- [ ] Sustituir `SampleData` por una capa de datos real (SwiftData / API).
- [ ] Añadir las pantallas **Pacientes**, **Médicos** y **Ajustes**
      (hoy son placeholders; no venían en el export de Stitch).
- [ ] Integrar iconos Material Symbols → SF Symbols definitivos si se desea
      paridad total (actualmente mapeados a SF Symbols equivalentes).
- [ ] Añadir los archivos de fuentes `.ttf` para paridad tipográfica.
- [ ] Tests de UI/preview para cada pantalla.

---

## Origen

Conversión realizada a partir del archivo
`stitch_gestor_de_citas_m_dicas.zip` (export de Stitch con HTML + capturas +
`DESIGN.md`). El HTML original se conserva en `stitch_source/` como referencia.
