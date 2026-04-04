import 'package:flutter/material.dart';
import 'package:jueves/home/widget/background_widget.dart';
import 'package:jueves/home/widget/error_widget.dart';
import 'package:jueves/home/widget/welcome_modal.dart';
import 'package:jueves/settings/settings_page.dart';
import 'package:jueves/theme/nothing_theme.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final HomeController _controller;
  late AnimationController _welcomeAnimCtrl;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _welcomeAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
        if (_controller.showWelcome) {
          _welcomeAnimCtrl.forward(from: 0);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _welcomeAnimCtrl.dispose();
    super.dispose();
  }

  /// Maneja el cierre de sesión
  Future<void> _handleSignOut() async {
    try {
      // El AuthWrapper en main.dart detectará el cambio y navegará al login
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: ${e.toString()}'),
            backgroundColor: NothingTheme.interactive,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Muestra un diálogo de confirmación antes de cerrar sesión
  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NothingTheme.black,
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: NothingTheme.borderVisible, width: 1),
        ),
        title: Text(
          '¿Cerrar sesión?',
          style: NothingTheme.spaceMonoLabel(
            fontSize: NothingTheme.body,
            color: NothingTheme.textDisplay,
          ),
        ),
        content: Text(
          'Tendrás que volver a iniciar sesión con Google',
          style: NothingTheme.spaceMonoLabel(
            fontSize: NothingTheme.caption,
            color: NothingTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'CANCELAR',
              style: NothingTheme.spaceMonoLabel(
                fontSize: NothingTheme.caption,
                color: NothingTheme.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'CERRAR SESIÓN',
              style: NothingTheme.spaceMonoLabel(
                fontSize: NothingTheme.caption,
                color: NothingTheme.interactive,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      await _handleSignOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NothingTheme.black,
      appBar: AppBar(
        title: Text(
          '[ Asistente JUEVES ]',
          style: NothingTheme.spaceMonoLabel(
            fontSize: NothingTheme.label,
            color: NothingTheme.textSecondary,
          ),
        ),
        actions: [],
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(NothingTheme.spaceMd),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildControlButton(),
                        if (_controller.errorMessage != null) ...[
                          const SizedBox(height: NothingTheme.spaceSm),
                          ErrorCard(controller: _controller),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_controller.showWelcome)
            WelcomeModal(welcomeAnimCtrl: _welcomeAnimCtrl),
        ],
      ),
    );
  }

  Widget _buildControlButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
          icon: const Icon(Icons.settings_outlined),
          color: NothingTheme.textSecondary,
          iconSize: 18,
          padding: const EdgeInsets.only(right: NothingTheme.spaceSm),
          constraints: const BoxConstraints(),
          tooltip: 'Configuración',
        ),
        const SizedBox(width: NothingTheme.spaceSm),
        OutlinedButton(
          onPressed: _controller.loading ? null : _controller.toggle,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: _controller.listening
                  ? NothingTheme.interactive
                  : NothingTheme.borderVisible,
              width: 1,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: NothingTheme.spaceMd,
              vertical: NothingTheme.spaceSm,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller.loading)
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: NothingTheme.textDisplay,
                  ),
                )
              else
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _controller.listening
                        ? NothingTheme.interactive
                        : NothingTheme.textDisabled,
                    shape: BoxShape.circle,
                  ),
                ),
              const SizedBox(width: NothingTheme.spaceSm),
              Text(
                'MODO LIBRE',
                style: NothingTheme.spaceMonoLabel(
                  fontSize: NothingTheme.label,
                  color: _controller.listening
                      ? NothingTheme.textDisplay
                      : NothingTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
