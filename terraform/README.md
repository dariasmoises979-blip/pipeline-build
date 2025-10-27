# Terraform Infrastructure

## Estructura
- modules/: módulos reutilizables
- qa/, pro/: entornos con main.tf
- backend.tf: backend remoto (GCS/S3/Terraform Cloud)
- Makefile: comandos simplificados
- .gitignore: evita versionar estados y dependencias

## Flujo de trabajo
 Targets disponibles:
   init      - Inicializa Terraform (incluye backend remoto)
   fmt       - Formatea el código Terraform
   validate  - Valida la configuración y revisa buenas prácticas
   plan      - Genera un plan de ejecución de Terraform
   apply     - Aplica el plan generado
   destroy   - Destruye toda la infraestructura
   clean     - Limpia archivos temporales de Terraform