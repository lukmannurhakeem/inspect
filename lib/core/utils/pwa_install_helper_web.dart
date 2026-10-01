// Web-only PWA install helpers
import 'dart:html' as html;

bool isPwaStandalone() =>
    html.window.matchMedia('(display-mode: standalone)').matches;

void listenInstallPrompt(VoidCallback onCanInstall) {
  html.window.addEventListener('beforeinstallprompt', (_) => onCanInstall());
}

void listenAppInstalled(VoidCallback onInstalled) {
  html.window.addEventListener('appinstalled', (_) => onInstalled());
}

void triggerInstall() {
  html.window.dispatchEvent(html.CustomEvent('flutter-install-click'));
}

typedef VoidCallback = void Function();
