Helm Charts Repository
📌 Propósito del repositorio

Este repositorio centraliza charts de Helm para múltiples servicios y entornos.
Su objetivo es proporcionar:

Charts listos para desplegar aplicaciones en Kubernetes.

Ejemplos de configuración y despliegue.

Integración con CI/CD para validación, empaquetado y publicación.

Soporte para overrides por entorno (dev, qa, staging, pre, pro).

Nota: El chart n8n se incluye como ejemplo de demostración; la estructura y prácticas se aplican a cualquier otro chart.

🗂 Estructura general
helm/
├── chart/                 # Contiene todos los charts
│   ├── n8n-helm-chart     # Ejemplo de chart (n8n)
│   │   ├── charts/        # Subcharts (dependencias)
│   │   ├── templates/     # Manifiestos de Kubernetes
│   │   ├── values.yaml    # Valores por defecto
│   │   ├── examples/      # Ejemplos de configuración
│   │   ├── Makefile       # Tareas automáticas
│   │   ├── CHANGELOG.md   # Historial de versiones
│   │   └── LICENSE
│   └── prometheus         # Otro chart de ejemplo
├── ci/                    # Scripts de integración continua
│   ├── lint.sh            # Validar charts
│   ├── package.sh         # Empaquetar charts
│   └── push.sh            # Publicar charts
├── override/              # Valores específicos por entorno
│   ├── dev/
│   ├── qa/
│   ├── staging/
│   ├── pre/
│   └── pro/
└── helmfile.yaml          # Configuración global de Helmfile

⚡ Cómo usar los charts
1. Instalar un chart localmente
# Instala n8n usando los valores por defecto
helm install n8n ./chart/n8n-helm-chart/charts/n8n

2. Aplicar valores por defecto o overrides
# Con valores por defecto
helm install n8n ./chart/n8n-helm-chart/charts/n8n -f ./chart/n8n-helm-chart/charts/n8n/values.yaml

# Con valores personalizados para QA
helm install n8n ./chart/n8n-helm-chart/charts/n8n -f ./override/qa/n8n-values.yaml

3. Ejemplos de despliegue
# Ejemplo "full" del chart n8n
helm install n8n ./chart/n8n-helm-chart/charts/n8n -f ./chart/n8n-helm-chart/examples/values_full.yaml

# Ejemplo "small" para producción
helm install n8n ./chart/n8n-helm-chart/charts/n8n -f ./chart/n8n-helm-chart/examples/values_small_prod.yaml

🛠 CI/CD
Scripts disponibles

Lint: ci/lint.sh — valida sintaxis y coherencia del chart.

Package: ci/package.sh — empaqueta el chart para distribución.

Push: ci/push.sh — publica el chart en repositorios (Artifact Hub, repos privados).

Uso de Makefile

El Makefile de cada chart facilita tareas comunes:

# Validar el chart
make lint

# Empaquetar
make package

# Instalar en cluster local
make install

🤝 Contribuciones
Agregar un nuevo chart

Crear carpeta bajo chart/ con el nombre del chart.

Incluir:

Chart.yaml

values.yaml

templates/

Opcional: examples/, Makefile, tests/

Añadir documentación en README.md del chart.

Agregar ejemplos o tests

Los valores de ejemplo deben ir en examples/.

Tests de conexión o sanity checks deben ir en templates/tests/.

🌐 Publicación

Charts listos pueden publicarse en Artifact Hub usando artifacthub-repo.yml.

También se pueden publicar en repositorios privados mediante scripts de CI/CD.