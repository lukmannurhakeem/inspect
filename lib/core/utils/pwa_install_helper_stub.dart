// Stub for non-web platforms

bool isPwaStandalone() => false;

void listenInstallPrompt(VoidCallback onCanInstall) {}

void listenAppInstalled(VoidCallback onInstalled) {}

void triggerInstall() {}

typedef VoidCallback = void Function();
