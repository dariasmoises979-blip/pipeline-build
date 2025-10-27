# Módulo docker-instance

Crea instancias GCE configurables para ejecutar contenedores Docker.

## Variables principales
- name: nombre base de la instancia
- instance_count: número de instancias
- machine_type: tipo de máquina
- zone: zona de despliegue
- image: imagen del disco
- network: red VPC

## Outputs
- instance_names: lista de nombres
- instance_ips: lista de IPs públicas
