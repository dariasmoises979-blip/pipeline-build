#!/usr/bin/env bash
#Empaqueta y firma el chart
#Empaquetar (package.sh): generar el .tgz del chart que será publicado.
set -e

CHART_PATH=${1:-"./chart/n8n-helm-chart/charts/n8n"}
OUTPUT_DIR=${2:-"./dist"}

mkdir -p "$OUTPUT_DIR"

echo "📦 Empaquetando Helm Chart..."
helm package "$CHART_PATH" -d "$OUTPUT_DIR"

echo "✅ Chart empaquetado en $OUTPUT_DIR"
