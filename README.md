# semantic_profiling

# Debtor Archetypes Semantic Profiler

Este repositorio implementa un prototipo técnico que usa *embeddings* y similitud semántica para perfilar referencias de deudores en arquetipos de riesgo, pensado para scoring avanzado, originación responsable y cobranzas inteligentes.

---

## ¿Qué hace este código?

A partir de un texto libre de referencia (comentarios de terceros, referencias personales, notas de campo, etc.), el script:

1. Genera el embedding del texto de referencia usando `text-embedding-3-small` de OpenAI.
2. Genera embeddings de una serie de arquetipos de deudor definidos manualmente.
3. Calcula la similitud coseno entre la referencia y cada arquetipo.
4. Escala las similitudes y las proyecta en un **radar chart** para visualizar el patrón de afinidad semántica del deudor frente a los arquetipos.

En términos simples: convierte lenguaje natural desordenado en una señal cuantitativa interpretable para riesgo de crédito y estrategias de cobranza.

---

## Arquetipos incluidos

Actualmente se modelan siete arquetipos operativos típicos en originación y cobranza:

- **El cumplido** – Historial impecable, baja probabilidad de deterioro.
- **El prevenido** – Gestiona riesgos antes de caer en mora.
- **El atrasado crónico** – Usa el atraso como mecanismo de financiamiento.
- **El sobreendeudado** – Alta carga financiera, estrés de liquidez.
- **El invisible** – Difícil de contactar, baja trazabilidad.
- **El oportunista** – Paga solo ante incentivos o presión efectiva.
- **El conflictivo** – Niega, pelea, amenaza; alto costo operativo.

Cada arquetipo se define con una descripción operativa y se vectoriza para comparar cualquier referencia textual contra ese espacio semántico.

---

## Aplicaciones prácticas

Este código no es un juguete académico; es el bloque base de varios productos monetizables en fintech y collections:

1. **Enriquecimiento de scoring de originación**  
   - Integrar referencias cualitativas (proveedores, empleadores, redes) como señales vectoriales.
   - Detectar patrones de riesgo que no aparecen en bureaus tradicionales.

2. **Segmentación avanzada en cobranza**  
   - Asignar estrategias distintas según el arquetipo predominante (tono, canal, timing, oferta).
   - Reducir tiempo muerto y desgaste operacional en casos “conflictivos” o “invisibles”.

3. **Priorización de portafolio**  
   - Ordenar casos por “combinación de arquetipos” + métricas financieras.
   - Foco en cuentas con mejor relación recuperación esperada / costo de gestión.

4. **Monitoreo de calidad de cartera tercerizada**  
   - Analizar comentarios de aliados, gestores, corresponsales.
   - Detectar zonas o canales con sesgos sistemáticos (“están metiendo pura basura”).

5. **Normalización de lenguaje humano**  
   - Convertir juicios subjetivos (“ese man es problemático”) en features cuantitativos.
   - Integrable con modelos de ML clásicos, sistemas de recomendación de estrategias, y agentes de IA conversacionales.

---

## Stack técnico

- **Lenguaje:** R
- **Librerías clave:**
  - `openai` – generación de embeddings.
  - `dplyr`, `tidyr` – manejo de datos.
  - `fmsb` – construcción del radar chart.
  - `ggplot2` – visualización (extensible).
- **Métrica principal:** similitud coseno entre el embedding de la referencia y cada arquetipo.

Este enfoque es directamente portable a arquitecturas de microservicios, pipelines en producción y orquestadores (Cloud Run, Lambdas, etc.).

---

## Requisitos

1. R instalado.
2. Variables de entorno configuradas en `.Renviron`:
   ```bash
   OPENAI=tu_api_key
