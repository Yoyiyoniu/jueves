 la versión anterior con TFLite nativo:

1. Instala las dependencias de Python:
   ```bash
   pip install -r requirements.txt
   ```

2. Actualiza las dependencias de Flutter:
   ```bash
   flutter pub get
   ```

3. Inicia el servidor Python:
   ```bash
   python server.py
   ```

4. Ejecuta la app:
   ```bash
   flutter run
   ```

### 🐛 Problemas Conocidos

- **Latencia ligeramente mayor**: ~100ms vs ~50ms con TFLite nativo
  - Aceptable para detección de aplausos en tiempo real
  - Puede optimizarse con gRPC en lugar de HTTP

- **Requiere servidor separado**: El servidor Python debe estar ejecutándose
  - Solución: Scripts de inicio automáticos (`start.sh`, `start.bat`)

- **Android requiere IP en lugar de localhost**
  - Ver TROUBLESHOOTING.md para configuración

### 🔮 Próximas Mejoras

- [ ] Soporte para múltiples clientes simultáneos
- [ ] WebSocket para menor latencia
- [ ] Modo offline con modelo ligero
- [ ] Configuración de sensibilidad desde la UI
- [ ] Historial de detecciones
- [ ] Exportar estadísticas

### 📚 Documentación

- [SETUP.md](SETUP.md) - Guía de instalación
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Solución de problemas
- [README.md](README.md) - Descripción general

---

## [1.0.0] - Versión Inicial (TFLite Nativo)

### Características
- Detección de aplausos con YAMNet
- TFLite integrado directamente en Flutter
- Contador de aplausos
- Animación visual

### Problemas
- Difícil de compilar en diferentes plataformas
- Errores de configuración nativa
- Difícil de depurar
