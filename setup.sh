#!/bin/bash

echo "🚀 Configurando Firebase Authentication con Google Sign-In"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar si Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter no está instalado${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter encontrado${NC}"
echo ""

# Instalar dependencias
echo "📦 Instalando dependencias..."
flutter pub get

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencias instaladas${NC}"
else
    echo -e "${RED}❌ Error al instalar dependencias${NC}"
    exit 1
fi

echo ""
echo "🔥 Configurando Firebase..."
echo ""

# Verificar si FlutterFire CLI está instalado
if ! command -v flutterfire &> /dev/null; then
    echo -e "${YELLOW}⚠️  FlutterFire CLI no está instalado${NC}"
    echo "Instalando FlutterFire CLI..."
    dart pub global activate flutterfire_cli
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ FlutterFire CLI instalado${NC}"
    else
        echo -e "${RED}❌ Error al instalar FlutterFire CLI${NC}"
        exit 1
    fi
fi

echo ""
echo -e "${YELLOW}📋 Próximos pasos:${NC}"
echo ""
echo "1. Ejecuta: flutterfire configure"
echo "   (Esto configurará automáticamente Firebase)"
echo ""
echo "2. Ve a Firebase Console:"
echo "   https://console.firebase.google.com/"
echo ""
echo "3. Habilita Google Sign-In:"
echo "   Authentication → Sign-in method → Google"
echo ""
echo "4. Obtén SHA-1 y SHA-256 para Android:"
echo "   cd android && ./gradlew signingReport"
echo ""
echo "5. Agrega los fingerprints en Firebase Console:"
echo "   Project Settings → Your apps → Android app"
echo ""
echo "6. Ejecuta la app:"
echo "   flutter run"
echo ""
echo -e "${GREEN}✨ Configuración inicial completada${NC}"
echo ""
echo "📚 Lee CONFIGURACION_RAPIDA.md para más detalles"
