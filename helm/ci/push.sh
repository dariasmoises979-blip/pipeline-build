#!/usr/bin/env bash
#Publica el chart en un repositorio (ej. GitHub Pages, ArtifactHub o Harbor)
#Publicar (push.sh): subir el chart a un repositorio OCI (ej. GitHub Packages, Harbor o Artifactory).
set -e

CHART_PACKAGE=$(ls dist/*.tgz | head -n 1)
REPO_URL=${REPO_URL:-"oci://ghcr.io/usuario/charts"}

echo "🚀 Subiendo $CHART_PACKAGE al repositorio $REPO_URL ..."
helm push "$CHART_PACKAGE" "$REPO_URL"

echo "✅ Chart publicado correctamente"
