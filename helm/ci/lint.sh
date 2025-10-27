#!/usr/bin/env bash
#Script para validar charts con estándares de Helm y YAML
#Validar (lint.sh): revisar sintaxis, templates, y convenciones del chart antes del despliegue.
set -e

CHART_PATH=${1:-"./chart/n8n-helm-chart/charts/n8n"}

echo "🔍 Ejecutando helm lint en $CHART_PATH ..."
helm lint "$CHART_PATH" || {
  echo "❌ Error: Helm lint falló"
  exit 1
}

echo "✅ Helm lint completado correctamente"
