# Módulo GKE

Crea un cluster GKE con Node Pools configurables.

## Variables principales
- cluster_name: nombre del cluster
- region: región
- node_count: cantidad de nodos
- node_machine_type: tipo de máquina
- node_disk_size: tamaño del disco
- network: VPC
- subnetwork: subred

## Outputs
- cluster_name: nombre del cluster
- cluster_endpoint: endpoint de API
- node_pool_names: nombres de los node pools
