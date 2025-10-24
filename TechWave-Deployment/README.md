👋 BIENVENIDO/A - ¡NO SE PREOCUPE!
¿No es técnico? ¿Le da miedo la terminal? ¡Tranquilo/a! Este manual le guiará paso a paso como si fuera una receta de cocina. No necesita saber programación.

📦 ¿QUÉ VIENE EN ESTE PAQUETE?
Archivos que ha recibido:
text
📁 TechWave-Deployment-Package/
├── 🧩 deploy-production.sh     (EL ARCHIVO MÁGICO)
├── 📝 config-cliente.yaml      (PLANTILLA para rellenar)
├── 🧙 setup-wizard.sh          (ASISTENTE que le hace preguntas)
├── 📖 README-detallado.md      (Este manual)
├── 📂 examples/                (Ejemplos para copiar)
└── 🔧 scripts/                 (Para expertos, ignore)
En español: Tiene un "programa mágico" que hará todo el trabajo técnico por usted.

🎯 PASO A PASO - ELIGA SU RUTA
🏃‍♂️ RUTA RÁPIDA (10 minutos - Recomendada)
Para los que quieren resultados sin complicaciones

🐢 RUTA DETALLADA (20 minutos)
Para los que prefieren entender cada paso

🏃‍♂️ RUTA RÁPIDA - 4 PASOS SENCILLOS
PASO 1️⃣: ABRIR LA TERMINAL (No se asuste)
Windows:

Presione Tecla Windows + R

Escriba cmd

Presione Enter

Mac:

Presione Cmd + Espacio

Escriba terminal

Presione Enter

Linux:

Presione Ctrl + Alt + T

👉 Verá una ventana negra con texto. ¡Perfecto! Así debe ser.

PASO 2️⃣: IR A LA CARPETA CORRECTA
En la ventana negra, escriba EXACTAMENTE esto:

bash
cd Escritorio/TechWave-Deployment-Package
💡 Si guardó la carpeta en otro sitio, escriba:

bash
cd Descargas/TechWave-Deployment-Package
(Cambie "Descargas" por donde guardó la carpeta)

PASO 3️⃣: EJECUTAR EL ASISTENTE MÁGICO
Escriba EXACTAMENTE esto y presione Enter:

bash
./deploy-production.sh --setup
🎪 El programa le hará preguntas como:

text
¿Nombre de su empresa? [Escriba su respuesta]
¿Email de contacto? [Escriba su email]
¿Dominio deseado? [ej: app.suempresa.com]
¿ID de suscripción Azure? [ver siguiente sección]
PASO 4️⃣: CONFIGURAR CREDENCIALES AZURE
📋 Cómo obtener las credenciales (15 minutos):

Vaya a portal.azure.com

Inicie sesión con su cuenta de empresa

Siga este camino exacto:

Haga clic en Azure Active Directory (en el menú izquierdo)

Haga clic en App registrations

Haga clic en + New registration

Nombre: TechWave-Deployment

Haga clic en Register

Anote el "Application (client) ID" ← Este es su AZURE_CLIENT_ID

Generar contraseña:

En la misma página, haga clic en Certificates & secrets

Haga clic en + New client secret

Description: TechWave Secret

Haga clic en Add

⚠️ COPIE EL VALOR AHORA (solo lo verá una vez) ← Este es su AZURE_CLIENT_SECRET

Anotar Tenant ID:

Volver a Azure Active Directory

Haga clic en Overview

Anote el "Tenant ID" ← Este es su AZURE_TENANT_ID

Obtener Subscription ID:

Busque Subscriptions en la barra de búsqueda superior

Haga clic en su suscripción

Anote el "Subscription ID"

PASO 5️⃣: PONER LAS CREDENCIALES EN LA TERMINAL
En la misma ventana negra, escriba EXACTAMENTE (reemplazando con SUS datos):

bash
export AZURE_CLIENT_ID="00000000-0000-0000-0000-000000000000"
export AZURE_CLIENT_SECRET="su-contraseña-super-secreta"
export AZURE_TENANT_ID="00000000-0000-0000-0000-000000000000"
👉 Presione Enter después de CADA línea

PASO 6️⃣: EJECUTAR EL DESPLIEGUE
Escriba:

bash
./deploy-production.sh
🎉 ¡Y LISTO! El sistema hará el trabajo durante 30-45 minutos.
