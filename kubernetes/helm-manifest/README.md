# HelloWorld Helm Chart

Este chart despliega una aplicación de ejemplo **HelloWorld** con Kubernetes, usando buenas prácticas de Helm:

- Deployment con replicas
- Service
- ConfigMap y Secret
- Ingress
- HorizontalPodAutoscaler (HPA)
- Valores configurables por entorno (`values.yaml`)

## Uso

```bash
helm install my-helloworld ./helloworld-helm-chart


Desinstalar
helm uninstall my-helloworld


Comando helm template para generar YAML físicos separados

Podemos usar Helm >= 3.8 con la opción --output-dir para generar automáticamente la estructura:

helm template my-helloworld ./helloworld-helm-chart --output-dir ./manifiestos


Esto hará:

manifiestos/
└── my-helloworld/
    └── helloworld-helm-chart/
        └── templates/
            deployment.yaml
            service.yaml
            configmap.yaml
            secret.yaml
            ingress.yaml
            hpa.yaml


✅ Todos los YAMLs estarán físicamente separados, listos para kubectl apply -f.