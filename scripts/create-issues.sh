#!/usr/bin/env bash
# Run this script to create all roadmap issues in GitHub.
# Requires: gh cli authenticated with repo scope
# Usage: ./scripts/create-issues.sh

set -e
REPO="bvis/homeassistant-pycupra"

echo "Creating issues in $REPO..."

# Phase 1: Bugfixes
gh issue create --repo "$REPO" \
  --title "fix: Known bugs in existing code" \
  --body "## Phase 1 — Bugfixes

- [ ] **button.py**: \`async_show_pycupra_notification\` usado sin importar
- [ ] **climate.py:73-78**: Código muerto — mapping de hvac_modes inalcanzable
- [ ] **lock.py**: \`async_lock\`/\`async_unlock\` sin error handling (try-except)
- [ ] **\__init__.py:88**: Typo \`28,5\` debería ser \`28.5\` en validación de temperatura
- [ ] **Throttling inconsistente**: \`statusreport\` tiene mínimo 30s, pero \`position\` y \`basiccardata\` no
- [ ] **Código comentado**: Limpiar legacy token file, battery power params

Candidato a PR upstream."

# Phase 1: Diagnostics
gh issue create --repo "$REPO" \
  --title "feat: Add diagnostics platform" \
  --body "## Phase 1 — Diagnostics

Añadir \`diagnostics.py\` para descargar JSON de debug del vehículo.
- Redactar datos sensibles: VIN, GPS, credenciales, tokens, email
- Requisito para integraciones de calidad HA
- Facilita soporte y debugging

Candidato a PR upstream."

# Phase 2: Image entity
gh issue create --repo "$REPO" \
  --title "feat: Add image entity (vehicle photo)" \
  --body "## Phase 2 — Image Entity

Crear entidad \`image\` con la foto del vehículo.
- \`model_image_large\` ya se descarga pero no se expone como entidad
- Opcionalmente: mapa estático de la posición de parking
- Platform: \`image\`"

# Phase 2: Cover entities
gh issue create --repo "$REPO" \
  --title "feat: Add cover entities (trunk, sunroof)" \
  --body "## Phase 2 — Cover Entities

Maletero y techo solar tienen estado binario + la API soporta control.
- Exponerlos como \`cover\` (open/close) en vez de solo binary_sensor
- Platform: \`cover\`"

# Phase 2: Select entities
gh issue create --repo "$REPO" \
  --title "feat: Add select entities (climatisation mode, seat heaters)" \
  --body "## Phase 2 — Select Entities

Algunas features encajan mejor como \`select\` que como switches on/off:
- Modo de climatización (electric, auxiliary, ventilation)
- Nivel de calefacción de asientos (off/low/medium/high)
- Modo de carga
- Platform: \`select\`"

# Phase 2: Warning lights individual
gh issue create --repo "$REPO" \
  --title "feat: Individual warning light binary sensors" \
  --body "## Phase 2 — Warning Lights

\`API_WARNINGLIGHTS\` ya se llama pero todo se agrupa en un sensor \`warnings\`.
- Desglosar en binary_sensors individuales (aceite, frenos, batería 12V, etc.)
- Migrar a endpoint v3: \`/v3/vehicles/{vin}/warninglights\` "

# Phase 2: Energy Dashboard
gh issue create --repo "$REPO" \
  --title "feat: Energy Dashboard integration (kWh sensor)" \
  --body "## Phase 2 — Energy Dashboard

Añadir sensor con \`device_class: energy\`, \`state_class: total_increasing\` para kWh cargados.
- Permite que el vehículo aparezca en el Energy Dashboard de HA
- Fuente: datos de sesión de carga o contador acumulativo de la API
- **Alto impacto** para usuarios con paneles solares/gestión energética"

# Phase 2: Repair/Issue registry
gh issue create --repo "$REPO" \
  --title "feat: Use HA Repair/Issue registry instead of persistent notifications" \
  --body "## Phase 2 — Repair Registry

Reemplazar persistent_notifications para problemas de la integración:
- Credenciales expiradas
- Vehículo offline
- Cuenta bloqueada
- Rate limit alcanzado

Usar \`homeassistant.helpers.issue_registry\` para surfacear en el panel Repairs de HA."

# Phase 3: Battery Care
gh issue create --repo "$REPO" \
  --title "feat: Battery Care control" \
  --body "## Phase 3 — Battery Care
Endpoints confirmados:
- GET \`/v1/vehicles/{vin}/charging/battery-care\`
- GET \`/v1/vehicles/{vin}/charging/battery-care/target\`
- POST \`/v1/vehicles/{vin}/charging/actions/update-battery-care\`

Entidades: sensor (estado, target), switch (enable/disable)
Servicio: \`set_battery_care_target\`"

# Phase 3: Vehicle Wakeup
gh issue create --repo "$REPO" \
  --title "feat: Explicit vehicle wakeup button" \
  --body "## Phase 3 — Vehicle Wakeup
Endpoint: POST \`/v1/vehicles/{vin}/vehicle-wakeup/request\`
- Botón dedicado en vez del refresh actual
- Más limpio y explícito"

# Phase 3: Independent Ventilation
gh issue create --repo "$REPO" \
  --title "feat: Independent ventilation control" \
  --body "## Phase 3 — Ventilación Independiente
Endpoints:
- POST \`v1/vehicles/{vin}/ventilation/start\`
- POST \`v1/vehicles/{vin}/ventilation/stop\`
- POST \`v1/vehicles/{vin}/ventilation/timers\`

Separar ventilación de climatización. Climate entity o switch dedicado."

# Phase 3: Driving Data Reports
gh issue create --repo "$REPO" \
  --title "feat: Driving data reports (short/long/cyclic)" \
  --body "## Phase 3 — Driving Data Reports
Endpoint: GET \`/v2/vehicles/{vin}/driving-data/{intervalType}\`
- intervalType: short, long, cyclic
- Sensores: avg speed, avg consumption, distance, duration por intervalo
- Más rico que el actual last trip / last cycle"

# Phase 3: Charging History
gh issue create --repo "$REPO" \
  --title "feat: Charging history (home and public)" \
  --body "## Phase 3 — Charging History
Endpoints:
- GET \`charging_history/home\`
- GET \`charging_history/public\`

Sensor con última sesión + atributos (kWh, duración, ubicación) o event entity."

# Phase 3: Speed Alert CRUD
gh issue create --repo "$REPO" \
  --title "feat: Speed alert management (CRUD)" \
  --body "## Phase 3 — Speed Alert CRUD
Endpoints: GET/POST/PUT/DELETE \`v1/vehicles/{vin}/alerts/configuration/speed[/{id}]\`

Servicios HA: \`create_speed_alert\`, \`update_speed_alert\`, \`delete_speed_alert\`
Sensor: alertas de velocidad activas + atributos"

# Phase 3: Geofence CRUD
gh issue create --repo "$REPO" \
  --title "feat: Geofence management (CRUD)" \
  --body "## Phase 3 — Geofence CRUD
Endpoints: GET/POST/PUT/DELETE \`v1/vehicles/{vin}/alerts/configuration/area[/{id}]\`

Servicios HA: \`create_geofence\`, \`update_geofence\`, \`delete_geofence\`
Sensor: geofences activos + atributos"

# Phase 3: Vehicle Specifications
gh issue create --repo "$REPO" \
  --title "feat: Vehicle specifications as device attributes" \
  --body "## Phase 3 — Vehicle Specifications
Endpoint: GET \`/v2/vehicles/{vin}/specifications\`
Poblar device_info con: model, year, engine type, color, equipment"

# Phase 3: Transaction History
gh issue create --repo "$REPO" \
  --title "feat: Transaction history (event entities)" \
  --body "## Phase 3 — Transaction History
Historial de eventos: lock/unlock, honk, geofence triggers, speed alerts, valet.
Event entities o sensores con últimos eventos.
10 capabilities de historial identificadas en la app."

# Phase 4: Calendar entity
gh issue create --repo "$REPO" \
  --title "feat: Calendar entity for departure/charging/climate timers" \
  --body "## Phase 4 — Calendar Entity

Mostrar departure timers, climatisation timers y charging schedules como eventos en el calendario de HA.
Platform: \`calendar\`"

# Phase 4: EUDA complete
gh issue create --repo "$REPO" \
  --title "feat: Complete EUDA data integration (tire pressure, fault codes)" \
  --body "## Phase 4 — EUDA Completo

- Activar EUDA en el config flow UI (actualmente escondido)
- Explotar todos los data clusters: presión de neumáticos (TPMS por rueda), fault codes, datos de frenada/estabilidad
- Ya hay código parcial — extender y exponer como entidades"

# Phase 4: Translations
gh issue create --repo "$REPO" \
  --title "feat: Complete translations (es, it, fr, pt)" \
  --body "## Phase 4 — Traducciones

- Completar es.json, it.json (actualmente parciales)
- Añadir fr.json, pt.json para mercados europeos de Cupra
- Cubrir todas las entidades y servicios nuevos"

echo ""
echo "All issues created successfully!"
