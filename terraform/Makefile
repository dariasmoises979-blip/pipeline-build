# ==========================================================
# Makefile para Terraform
# ==========================================================
# Este Makefile proporciona comandos para gestionar la 
# infraestructura de Terraform de manera más rápida y 
# documentada.
#
# Targets disponibles:
#   init      - Inicializa Terraform (incluye backend remoto)
#   fmt       - Formatea el código Terraform
#   validate  - Valida la configuración y revisa buenas prácticas
#   plan      - Genera un plan de ejecución de Terraform
#   apply     - Aplica el plan generado
#   destroy   - Destruye toda la infraestructura
#   clean     - Limpia archivos temporales de Terraform
# ==========================================================

# Variables
PLAN_FILE=tfplan

# ----------------------------------------------------------
# Inicializar Terraform (incluye backend remoto)
# ----------------------------------------------------------
.PHONY: init
init:
	@echo "==> Inicializando Terraform..."
	terraform init

# ----------------------------------------------------------
# Formatear código Terraform
# ----------------------------------------------------------
.PHONY: fmt
fmt:
	@echo "==> Formateando código Terraform..."
	terraform fmt -recursive

# ----------------------------------------------------------
# Validar configuración y buenas prácticas
# ----------------------------------------------------------
.PHONY: validate
validate:
	@echo "==> Validando configuración Terraform..."
	terraform validate
	@echo "==> Ejecutando TFLint para revisión de buenas prácticas..."
	tflint

# ----------------------------------------------------------
# Generar plan de ejecución
# ----------------------------------------------------------
.PHONY: plan
plan:
	@echo "==> Generando plan de ejecución..."
	terraform plan -out=$(PLAN_FILE)

# ----------------------------------------------------------
# Aplicar cambios según el plan
# ----------------------------------------------------------
.PHONY: apply
apply:
	@echo "==> Aplicando plan de Terraform..."
	terraform apply "$(PLAN_FILE)"

# ----------------------------------------------------------
# Destruir infraestructura
# ----------------------------------------------------------
.PHONY: destroy
destroy:
	@echo "==> Destruyendo infraestructura..."
	terraform destroy -auto-approve

# ----------------------------------------------------------
# Limpiar archivos temporales de Terraform
# ----------------------------------------------------------
.PHONY: clean
clean:
	@echo "==> Limpiando archivos temporales..."
	rm -f $(PLAN_FILE)
	rm -rf .terraform
