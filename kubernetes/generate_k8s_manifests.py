#!/usr/bin/env python3
"""
Script interactivo para generar proyectos de Kubernetes
Soporta configuración manual o desde kustomization.yaml existente
"""
import os
import yaml
from pathlib import Path
from typing import Dict, Optional, Tuple

# ==========================================================
# Configuración por defecto
# ==========================================================
DEFAULT_BASE_DIR = "base"
DEFAULT_OVERLAYS_DIR = "overlays-kustom"

# ==========================================================
# Funciones auxiliares
# ==========================================================
def load_yaml_file(file_path: Path) -> Optional[Dict]:
    """Carga un archivo YAML"""
    try:
        with open(file_path, 'r') as f:
            content = yaml.safe_load(f)
            return content if content else {}
    except Exception as e:
        print(f"[⚠️] Error leyendo {file_path}: {e}")
        return None

def save_yaml_file(data: Dict, file_path: Path):
    """Guarda datos en un archivo YAML"""
    file_path.parent.mkdir(parents=True, exist_ok=True)
    with open(file_path, 'w') as f:
        yaml.dump(data, f, default_flow_style=False, sort_keys=False, indent=2)

def find_existing_kustomizations(overlays_dir: str) -> Dict[str, Dict[str, Path]]:
    """Busca kustomization.yaml existentes en overlays"""
    overlays_path = Path(overlays_dir)
    found = {}
    
    if not overlays_path.exists():
        return found
    
    for env_dir in overlays_path.iterdir():
        if not env_dir.is_dir():
            continue
        
        env_name = env_dir.name
        found[env_name] = {}
        
        for project_dir in env_dir.iterdir():
            if project_dir.is_dir():
                kustom_file = project_dir / "kustomization.yaml"
                if kustom_file.exists():
                    found[env_name][project_dir.name] = kustom_file
    
    return found

def show_existing_kustomizations(overlays_dir: str):
    """Muestra los kustomization.yaml existentes"""
    kustomizations = find_existing_kustomizations(overlays_dir)
    
    if kustomizations:
        print("\n📋 Kustomization.yaml existentes:")
        print("=" * 60)
        for env, projects in sorted(kustomizations.items()):
            print(f"\n🌐 {env}/")
            for project, path in sorted(projects.items()):
                print(f"   └── {project}/ → {path}")
        print("\n" + "=" * 60)
        return True
    else:
        print("\n⚠️  No se encontraron kustomization.yaml en overlays-kustom/")
        return False

def load_kustomization_config(kustom_path: Path) -> Optional[Dict]:
    """Carga y extrae la configuración de un kustomization.yaml"""
    data = load_yaml_file(kustom_path)
    if not data:
        return None
    
    config = {
        'namespace': data.get('namespace', ''),
        'namePrefix': data.get('namePrefix', ''),
        'nameSuffix': data.get('nameSuffix', ''),
        'commonLabels': data.get('commonLabels', {}),
        'commonAnnotations': data.get('commonAnnotations', {}),
        'replicas': None,
        'images': data.get('images', []),
        'configMapGenerator': data.get('configMapGenerator', []),
        'secretGenerator': data.get('secretGenerator', [])
    }
    
    # Buscar replicas en patches
    if 'patches' in data:
        for patch in data['patches']:
            if isinstance(patch, dict) and 'patch' in patch:
                patch_str = patch['patch']
                if 'replicas' in patch_str:
                    try:
                        # Intentar extraer el número de replicas
                        import re
                        match = re.search(r'replicas:\s*(\d+)', patch_str)
                        if match:
                            config['replicas'] = int(match.group(1))
                    except:
                        pass
    
    return config

def show_kustomization_config(config: Dict):
    """Muestra la configuración extraída de kustomization.yaml"""
    print("\n📋 Configuración detectada:")
    print("-" * 60)
    if config.get('namespace'):
        print(f"   Namespace:       {config['namespace']}")
    if config.get('namePrefix'):
        print(f"   Name Prefix:     {config['namePrefix']}")
    if config.get('nameSuffix'):
        print(f"   Name Suffix:     {config['nameSuffix']}")
    if config.get('replicas'):
        print(f"   Replicas:        {config['replicas']}")
    if config.get('commonLabels'):
        print(f"   Common Labels:   {config['commonLabels']}")
    if config.get('commonAnnotations'):
        print(f"   Annotations:     {config['commonAnnotations']}")
    if config.get('images'):
        print(f"   Images:          {len(config['images'])} configuradas")
    print("-" * 60)

def customize_manifest(manifest: Dict, env: str, project: str, config: Dict) -> Dict:
    """Personaliza un manifest según la configuración"""
    if not manifest:
        return manifest
    
    custom = manifest.copy()
    
    # Obtener configuración
    namespace = config.get('namespace', env)
    name_prefix = config.get('namePrefix', f'{project}-')
    name_suffix = config.get('nameSuffix', '')
    common_labels = config.get('commonLabels', {})
    common_annotations = config.get('commonAnnotations', {})
    replicas = config.get('replicas')
    
    # Personalizar metadata
    if 'metadata' in custom:
        # Aplicar prefijo y sufijo al nombre
        if 'name' in custom['metadata']:
            original_name = custom['metadata']['name']
            # Remover prefijo del proyecto si ya existe
            if original_name.startswith(project):
                original_name = original_name[len(project):].lstrip('-')
            new_name = f"{name_prefix.rstrip('-')}-{original_name}{name_suffix}"
            custom['metadata']['name'] = new_name
        
        # Labels
        if 'labels' not in custom['metadata']:
            custom['metadata']['labels'] = {}
        
        # Combinar labels comunes con los específicos
        default_labels = {
            'app': project,
            'environment': env
        }
        custom['metadata']['labels'].update(default_labels)
        custom['metadata']['labels'].update(common_labels)
        
        # Annotations
        if common_annotations:
            if 'annotations' not in custom['metadata']:
                custom['metadata']['annotations'] = {}
            custom['metadata']['annotations'].update(common_annotations)
        
        # Namespace
        custom['metadata']['namespace'] = namespace
    
    # Personalizar según el tipo de recurso
    if custom.get('kind') == 'Deployment':
        if 'spec' in custom:
            # Replicas
            if replicas is not None:
                custom['spec']['replicas'] = replicas
            
            # Template
            if 'template' in custom['spec']:
                if 'metadata' not in custom['spec']['template']:
                    custom['spec']['template']['metadata'] = {}
                if 'labels' not in custom['spec']['template']['metadata']:
                    custom['spec']['template']['metadata']['labels'] = {}
                
                template_labels = {
                    'app': project,
                    'environment': env
                }
                template_labels.update(common_labels)
                custom['spec']['template']['metadata']['labels'].update(template_labels)
                
                # Selector
                if 'selector' in custom['spec']:
                    custom['spec']['selector']['matchLabels'] = {
                        'app': project
                    }
                
                # Actualizar imagen si está configurada
                images_config = config.get('images', [])
                if images_config and 'containers' in custom['spec']['template'].get('spec', {}):
                    for container in custom['spec']['template']['spec']['containers']:
                        for img_conf in images_config:
                            if img_conf.get('name') == container.get('name'):
                                if 'newTag' in img_conf:
                                    # Separar imagen y tag
                                    image_parts = container['image'].split(':')
                                    container['image'] = f"{image_parts[0]}:{img_conf['newTag']}"
                                if 'newName' in img_conf:
                                    container['image'] = f"{img_conf['newName']}:{img_conf.get('newTag', 'latest')}"
    
    elif custom.get('kind') == 'Service':
        if 'spec' in custom and 'selector' in custom['spec']:
            custom['spec']['selector'] = {
                'app': project
            }
    
    elif custom.get('kind') == 'ConfigMap':
        # ConfigMaps pueden usar generators
        config_generators = config.get('configMapGenerator', [])
        if config_generators:
            for gen in config_generators:
                if gen.get('name') == custom['metadata'].get('name'):
                    if 'literals' in gen:
                        if 'data' not in custom:
                            custom['data'] = {}
                        for literal in gen['literals']:
                            key, value = literal.split('=', 1)
                            custom['data'][key] = value
    
    return custom

def get_user_input(prompt: str, default: str = "") -> str:
    """Solicita input del usuario con valor por defecto"""
    if default:
        user_input = input(f"{prompt} [{default}]: ").strip()
        return user_input if user_input else default
    else:
        while True:
            user_input = input(f"{prompt}: ").strip()
            if user_input:
                return user_input
            print("❌ Este campo es obligatorio")

def confirm_action(message: str) -> bool:
    """Pide confirmación al usuario"""
    response = input(f"{message} (s/n): ").strip().lower()
    return response in ['s', 'si', 'sí', 'y', 'yes']

def get_manual_config(env: str, project: str) -> Dict:
    """Solicita configuración manual del usuario"""
    print("\n⚙️  Configuración manual")
    print("-" * 60)
    
    config = {
        'namespace': get_user_input("Namespace", env),
        'namePrefix': get_user_input("Name Prefix (ej: redis-)", f"{project}-"),
        'nameSuffix': get_user_input("Name Suffix (opcional)", ""),
        'commonLabels': {},
        'commonAnnotations': {},
        'replicas': None,
        'images': []
    }
    
    # Labels personalizados
    if confirm_action("¿Agregar labels personalizados?"):
        print("Formato: key=value (escribe 'fin' para terminar)")
        while True:
            label = input("  Label: ").strip()
            if label.lower() in ['fin', 'exit', '']:
                break
            try:
                key, value = label.split('=', 1)
                config['commonLabels'][key.strip()] = value.strip()
            except:
                print("  ❌ Formato inválido")
    
    # Replicas
    if confirm_action("¿Especificar número de replicas?"):
        try:
            replicas = int(get_user_input("Número de replicas", "1"))
            config['replicas'] = replicas
        except:
            print("  ⚠️  Valor inválido, se omitirá")
    
    return config

def create_project(env: str, project: str, dest_dir: str, base_dir: str, 
                  overlays_dir: str, config: Dict):
    """Crea un proyecto completo con sus manifests"""
    print(f"\n🔨 Creando proyecto '{project}' en entorno '{env}'...")
    
    base_path = Path(base_dir)
    
    if not base_path.exists():
        print(f"❌ Error: No existe el directorio base: {base_path}")
        return False
    
    # Crear carpeta del proyecto
    project_dir = Path(dest_dir) / env / project
    
    if project_dir.exists():
        if not confirm_action(f"⚠️  La carpeta {project_dir} ya existe. ¿Sobrescribir?"):
            print("❌ Operación cancelada")
            return False
    
    project_dir.mkdir(parents=True, exist_ok=True)
    
    # Procesar archivos de base/
    base_files = list(base_path.glob("*.yaml"))
    
    if not base_files:
        print(f"⚠️  No se encontraron archivos YAML en {base_path}")
        return False
    
    print(f"\n📋 Procesando {len(base_files)} archivos base:")
    manifests_created = []
    
    for base_file in base_files:
        print(f"   • {base_file.name}...", end=" ")
        
        base_manifest = load_yaml_file(base_file)
        if not base_manifest:
            print("❌ Error al leer")
            continue
        
        custom_manifest = customize_manifest(base_manifest, env, project, config)
        
        output_file = project_dir / base_file.name
        save_yaml_file(custom_manifest, output_file)
        manifests_created.append(base_file.name)
        print("✅")
    
    # Crear kustomization.yaml en overlays-kustom
    overlay_dir = Path(overlays_dir) / env / project
    overlay_dir.mkdir(parents=True, exist_ok=True)
    
    kustomization = {
        'apiVersion': 'kustomize.config.k8s.io/v1beta1',
        'kind': 'Kustomization',
        'namespace': config.get('namespace', env),
        'resources': [f'../../../{base_dir}']
    }
    
    if config.get('namePrefix'):
        kustomization['namePrefix'] = config['namePrefix']
    if config.get('nameSuffix'):
        kustomization['nameSuffix'] = config['nameSuffix']
    if config.get('commonLabels'):
        kustomization['commonLabels'] = config['commonLabels']
    if config.get('commonAnnotations'):
        kustomization['commonAnnotations'] = config['commonAnnotations']
    
    kustomization_file = overlay_dir / "kustomization.yaml"
    save_yaml_file(kustomization, kustomization_file)
    
    print(f"\n✅ Proyecto creado exitosamente!")
    print(f"   📁 Manifests: {project_dir}")
    print(f"   📁 Kustomization: {kustomization_file}")
    print(f"   📝 Archivos generados: {len(manifests_created)}")
    
    return True

def select_kustomization(kustomizations: Dict[str, Dict[str, Path]]) -> Optional[Tuple[str, str, Path]]:
    """Permite al usuario seleccionar un kustomization existente"""
    # Crear lista de opciones
    options = []
    for env, projects in sorted(kustomizations.items()):
        for project, path in sorted(projects.items()):
            options.append((env, project, path))
    
    if not options:
        return None
    
    print("\n📋 Selecciona un kustomization.yaml existente:")
    print("=" * 60)
    for idx, (env, project, path) in enumerate(options, 1):
        print(f"{idx}. {env}/{project} → {path}")
    print(f"{len(options) + 1}. Ninguno (configuración manual)")
    print("=" * 60)
    
    while True:
        try:
            choice = input(f"\nSelecciona una opción [1-{len(options) + 1}]: ").strip()
            choice_num = int(choice)
            
            if choice_num == len(options) + 1:
                return None
            
            if 1 <= choice_num <= len(options):
                env, project, path = options[choice_num - 1]
                print(f"\n✅ Seleccionado: {env}/{project}")
                return (env, project, path)
            else:
                print(f"❌ Opción inválida. Debe ser entre 1 y {len(options) + 1}")
        except ValueError:
            print("❌ Por favor ingresa un número válido")
        except KeyboardInterrupt:
            print("\n❌ Operación cancelada")
            return None

def interactive_mode():
    """Modo interactivo principal"""
    print("=" * 60)
    print("🚀 GENERADOR DE PROYECTOS KUBERNETES")
    print("=" * 60)
    
    overlays_dir = DEFAULT_OVERLAYS_DIR
    
    # Buscar kustomizations existentes
    kustomizations = find_existing_kustomizations(overlays_dir)
    
    # Mostrar si existen
    if kustomizations:
        print("\n✨ Se encontraron kustomization.yaml existentes")
        total_kustom = sum(len(projects) for projects in kustomizations.values())
        print(f"   Total: {total_kustom} configuraciones disponibles")
    else:
        print("\n⚠️  No se encontraron kustomization.yaml existentes")
        print("   Se usará configuración manual")
    
    while True:
        print("\n" + "=" * 60)
        print("📝 CREAR NUEVO PROYECTO")
        print("=" * 60)
        
        # Datos básicos
        env = get_user_input("🌐 Nombre del entorno (qa, pro, staging, etc.)")
        project = get_user_input("📦 Nombre del proyecto (app, redis, etc.)")
        dest_dir = get_user_input("📂 Directorio de destino", ".")
        
        # Decidir origen de configuración
        config = None
        config_source = "manual"
        
        if kustomizations:
            print("\n⚙️  Configuración del proyecto:")
            print("   1. Usar kustomization.yaml existente")
            print("   2. Configuración manual")
            
            choice = get_user_input("Selecciona [1/2]", "1")
            
            if choice == "1":
                selected = select_kustomization(kustomizations)
                
                if selected:
                    selected_env, selected_project, kustom_path = selected
                    config = load_kustomization_config(kustom_path)
                    
                    if config:
                        config_source = f"{selected_env}/{selected_project}"
                        show_kustomization_config(config)
                        
                        # Opción de modificar namespace y prefijos
                        if confirm_action("\n¿Ajustar namespace/prefix para el nuevo proyecto?"):
                            config['namespace'] = get_user_input("Namespace", env)
                            config['namePrefix'] = get_user_input("Name Prefix", f"{project}-")
                    else:
                        print("⚠️  Error al cargar configuración, usando manual")
                        config = get_manual_config(env, project)
                else:
                    config = get_manual_config(env, project)
            else:
                config = get_manual_config(env, project)
        else:
            config = get_manual_config(env, project)
        
        # Resumen
        print(f"\n📋 Resumen:")
        print(f"   Entorno:    {env}")
        print(f"   Proyecto:   {project}")
        print(f"   Destino:    {dest_dir}/{env}/{project}")
        print(f"   Config:     {config_source}")
        
        if confirm_action("\n¿Crear este proyecto?"):
            create_project(env, project, dest_dir, DEFAULT_BASE_DIR, overlays_dir, config)
        
        if not confirm_action("\n¿Crear otro proyecto?"):
            break
    
    print("\n✨ ¡Proceso completado!")
    print("=" * 60)

# ==========================================================
# Main
# ==========================================================
if __name__ == "__main__":
    try:
        interactive_mode()
    except KeyboardInterrupt:
        print("\n\n⚠️  Operación cancelada por el usuario")
    except Exception as e:
        print(f"\n❌ Error inesperado: {e}")
        import traceback
        traceback.print_exc()