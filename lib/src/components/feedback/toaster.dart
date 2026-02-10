import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

import '../../theme/variants.dart';
import 'toast.dart';

/// Toast position on screen
enum DToasterPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// DuxtUI Toaster component - Toast container/manager
class DToaster extends StatefulComponent {
  final DToasterPosition position;
  final List<ToastData> toasts;
  final ValueChanged<String>? onToastClose;

  const DToaster({
    super.key,
    this.position = DToasterPosition.topRight,
    this.toasts = const [],
    this.onToastClose,
  });

  @override
  State<DToaster> createState() => _UToasterState();
}

class _UToasterState extends State<DToaster> {
  String get _positionClasses {
    switch (component.position) {
      case DToasterPosition.topLeft:
        return 'top-4 left-4';
      case DToasterPosition.topCenter:
        return 'top-4 left-1/2 -translate-x-1/2';
      case DToasterPosition.topRight:
        return 'top-4 right-4';
      case DToasterPosition.bottomLeft:
        return 'bottom-4 left-4';
      case DToasterPosition.bottomCenter:
        return 'bottom-4 left-1/2 -translate-x-1/2';
      case DToasterPosition.bottomRight:
        return 'bottom-4 right-4';
    }
  }

  String get _stackDirection {
    switch (component.position) {
      case DToasterPosition.topLeft:
      case DToasterPosition.topCenter:
      case DToasterPosition.topRight:
        return 'flex-col';
      case DToasterPosition.bottomLeft:
      case DToasterPosition.bottomCenter:
      case DToasterPosition.bottomRight:
        return 'flex-col-reverse';
    }
  }

  @override
  Component build(BuildContext context) {
    if (component.toasts.isEmpty) return Div(children: []);

    return Div(
      className: cx([
        'fixed z-50',
        _positionClasses,
        'flex',
        _stackDirection,
        'gap-3',
        'pointer-events-none',
      ]),
      children: [
        for (final toast in component.toasts)
          Div(
            className: 'pointer-events-auto',
            children: [
              DToast(
                id: toast.id,
                title: toast.title,
                description: toast.description,
                color: toast.color,
                variant: toast.variant,
                closable: toast.closable,
                onClose: component.onToastClose != null
                    ? () => component.onToastClose!(toast.id)
                    : null,
              ),
            ],
          ),
      ],
    );
  }
}

/// Static toast manager for imperative toast creation
/// Usage: ToastManager.show(context, ToastData.success(...))
class ToastManager {
  static final List<ToastData> _toasts = [];
  static void Function()? _notifyListeners;

  /// Register a listener for toast changes
  static void addListener(void Function() listener) {
    _notifyListeners = listener;
  }

  /// Remove the listener
  static void removeListener() {
    _notifyListeners = null;
  }

  /// Get current toasts
  static List<ToastData> get toasts => List.unmodifiable(_toasts);

  /// Show a toast
  static void show(ToastData toast) {
    _toasts.add(toast);
    _notifyListeners?.call();

    // Auto-dismiss after duration
    if (toast.duration > 0) {
      Future.delayed(Duration(milliseconds: toast.duration), () {
        dismiss(toast.id);
      });
    }
  }

  /// Show a success toast
  static void success({
    required String message,
    String? title,
    int duration = 5000,
  }) {
    show(ToastData.success(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: message,
      duration: duration,
    ));
  }

  /// Show an error toast
  static void error({
    required String message,
    String? title,
    int duration = 5000,
  }) {
    show(ToastData.error(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: message,
      duration: duration,
    ));
  }

  /// Show a warning toast
  static void warning({
    required String message,
    String? title,
    int duration = 5000,
  }) {
    show(ToastData.warning(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: message,
      duration: duration,
    ));
  }

  /// Show an info toast
  static void info({
    required String message,
    String? title,
    int duration = 5000,
  }) {
    show(ToastData.info(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: message,
      duration: duration,
    ));
  }

  /// Dismiss a specific toast
  static void dismiss(String id) {
    _toasts.removeWhere((t) => t.id == id);
    _notifyListeners?.call();
  }

  /// Dismiss all toasts
  static void dismissAll() {
    _toasts.clear();
    _notifyListeners?.call();
  }
}

/// Provider component that manages toast state
class DToasterProvider extends StatefulComponent {
  final Component child;
  final DToasterPosition position;

  const DToasterProvider({
    super.key,
    required this.child,
    this.position = DToasterPosition.topRight,
  });

  @override
  State<DToasterProvider> createState() => _UToasterProviderState();
}

class _UToasterProviderState extends State<DToasterProvider> {
  @override
  void initState() {
    super.initState();
    ToastManager.addListener(_onToastsChanged);
  }

  @override
  void dispose() {
    ToastManager.removeListener();
    super.dispose();
  }

  void _onToastsChanged() {
    setState(() {});
  }

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      component.child,
      DToaster(
        position: component.position,
        toasts: ToastManager.toasts,
        onToastClose: (id) => ToastManager.dismiss(id),
      ),
    ]);
  }
}
