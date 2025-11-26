# Repositorio Kubernetes - GitOps con ArgoCD

## Estructura

- base/: manifiestos reutilizables
- overlays/: configuraciones específicas por entorno (dev, qa, pro)
- argocd/apps/: ArgoCD Applications apuntando a overlays
- test/: manifiestos de prueba y ejemplos

## Flujo de despliegue

1. Cambios en base/ o overlays/
2. Pull request con pipeline de validación (YAML lint + kubectl dry-run)
3. Merge a main
4. ArgoCD sincroniza el entorno correspondiente:
   - dev: sincronización automática
   - qa: revisión manual
   - pro: aprobación manual o política GitOps
