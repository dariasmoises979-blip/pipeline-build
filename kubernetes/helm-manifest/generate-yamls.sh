#!/bin/bash
set -e

CHART_PATH="./helloworld-helm-chart"
RELEASE_NAME="my-helloworld"
OUTPUT_DIR="./manifiestos"

# Limpiar salida anterior
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

# Generar los YAMLs
echo "Generando manifiestos de Helm..."
helm template $RELEASE_NAME $CHART_PATH --output-dir $OUTPUT_DIR

echo "¡Listo! Los archivos YAML se encuentran en: $OUTPUT_DIR"
