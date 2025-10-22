# pipeline-build
graph TB
    Start([Push a rama específica]) --> Trigger{Workflow se activa}
    
    Trigger --> Test[Job 1: Run Tests]
    Test --> TestPass{¿Tests OK?}
    
    TestPass -->|❌ Fallan| End1([Workflow termina sin PR])
    TestPass -->|✅ Pasan| CallReusable[Job 2: Llamar workflow reusable]
    
    CallReusable --> ReusableStart[Workflow Reusable Inicia]
    ReusableStart --> CheckPR{¿Existe PR abierto?<br/>source → target}
    
    CheckPR -->|✅ SÍ existe| UpdatePR[Actualizar PR existente<br/>con comentario]
    CheckPR -->|❌ NO existe| CreatePR[Crear nuevo PR]
    
    UpdatePR --> AddComment[Añadir comentario con:<br/>- Link al workflow<br/>- Fecha y hora<br/>- Usuario que disparó<br/>- SHA del commit]
    AddComment --> End2([PR actualizado ✅])
    
    CreatePR --> SetDetails[Configurar PR:<br/>- Título personalizado<br/>- Descripción con checklist<br/>- Source y target branch<br/>- Links y metadata]
    SetDetails --> AddLabels[Añadir labels<br/>según configuración]
    AddLabels --> End3([PR creado ✅])
    
    style Start fill:#e1f5ff
    style End1 fill:#ffebee
    style End2 fill:#e8f5e9
    style End3 fill:#e8f5e9
    style TestPass fill:#fff9c4
    style CheckPR fill:#fff9c4
    style CallReusable fill:#f3e5f5
    style ReusableStart fill:#f3e5f5