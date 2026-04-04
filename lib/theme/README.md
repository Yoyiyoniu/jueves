# Nothing Design System - Jueves App

Sistema de diseño inspirado en Nothing, aplicado a la aplicación Jueves.

## Fuentes

- **Space Grotesk**: Texto de cuerpo, UI, headings
- **Space Mono**: Labels, datos, displays técnicos (ALL CAPS)

## Paleta de Colores (Dark Mode)

### Superficies
- `black` (#000000) - Fondo OLED
- `surface` (#111111) - Tarjetas elevadas
- `surfaceRaised` (#1A1A1A) - Elevación secundaria

### Bordes
- `border` (#222222) - Divisores sutiles
- `borderVisible` (#333333) - Bordes intencionales

### Texto
- `textDisplay` (#FFFFFF) - Headlines, números hero
- `textPrimary` (#E8E8E8) - Texto principal
- `textSecondary` (#999999) - Labels, captions
- `textDisabled` (#666666) - Deshabilitado

### Acento y Estados
- `accent` (#D71921) - Rojo Nothing (estados activos/urgentes)
- `success` (#4A9E5C) - Confirmado/completado
- `warning` (#D4A843) - Precaución/pendiente
- `error` (#D71921) - Errores (comparte el rojo de acento)

## Espaciado (Base 8px)

- `space2xs`: 2px
- `spaceXs`: 4px
- `spaceSm`: 8px
- `spaceMd`: 16px
- `spaceLg`: 24px
- `spaceXl`: 32px
- `space2xl`: 48px
- `space3xl`: 64px
- `space4xl`: 96px

## Escala Tipográfica

- `displayXl`: 72px - Números hero
- `displayLg`: 48px - Displays grandes
- `displayMd`: 36px - Títulos de página
- `heading`: 24px - Encabezados de sección
- `subheading`: 18px - Subsecciones
- `body`: 16px - Texto principal
- `bodySm`: 14px - Texto secundario
- `caption`: 12px - Timestamps, notas
- `label`: 11px - Labels ALL CAPS

## Principios de Diseño

1. **Monocromático**: Grises + un acento rojo
2. **Sin sombras**: Separación por bordes
3. **Tipografía jerárquica**: Escala, peso y espaciado
4. **Botones pill**: border-radius 999px
5. **Labels en mayúsculas**: Space Mono, ALL CAPS
6. **Dot-grid background**: Motivo decorativo sutil
7. **Animaciones sutiles**: 300ms ease-out, sin bounce

## Uso

```dart
import 'package:jueves/theme/nothing_theme.dart';

// En MaterialApp
theme: NothingTheme.darkTheme()

// Helpers de fuentes
Text('LABEL', style: NothingTheme.spaceMonoLabel())
Text('Body text', style: NothingTheme.spaceGroteskBody())
Text('123', style: NothingTheme.spaceMonoDisplay())
```
