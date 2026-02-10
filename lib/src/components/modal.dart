import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';

/// Modal sizes
enum DModalSize { xs, sm, md, lg, xl, xxl, xxxl, xxxxl, xxxxxl, full }

/// DuxtUI Modal component - uses native HTML dialog element
///
/// Uses inline JavaScript for interactivity.
class DModal extends StatelessComponent {
  final Component trigger;
  final String? title;
  final String? description;
  final Component? header;
  final Component? footer;
  final DModalSize size;
  final bool closeOnOverlay;
  final bool fullscreen;
  final List<Component> children;

  const DModal({
    super.key,
    required this.trigger,
    this.title,
    this.description,
    this.header,
    this.footer,
    this.size = DModalSize.md,
    this.closeOnOverlay = true,
    this.fullscreen = false,
    this.children = const [],
  });

  String get _sizeClasses {
    if (fullscreen)
      return 'w-screen h-screen max-w-none max-h-none m-0 rounded-none';

    switch (size) {
      case DModalSize.xs:
        return 'max-w-xs';
      case DModalSize.sm:
        return 'max-w-sm';
      case DModalSize.md:
        return 'max-w-md';
      case DModalSize.lg:
        return 'max-w-lg';
      case DModalSize.xl:
        return 'max-w-xl';
      case DModalSize.xxl:
        return 'max-w-2xl';
      case DModalSize.xxxl:
        return 'max-w-3xl';
      case DModalSize.xxxxl:
        return 'max-w-4xl';
      case DModalSize.xxxxxl:
        return 'max-w-5xl';
      case DModalSize.full:
        return 'max-w-full';
    }
  }

  @override
  Component build(BuildContext context) {
    return Div(
      className: 'inline-block',
      attributes: {'data-modal': 'true'},
      children: [
        // Trigger
        Div(
          attributes: {'data-modal-trigger': 'true'},
          className: 'cursor-pointer inline-block',
          children: [trigger],
        ),
        // Dialog element
        Dialog(
          className:
              'm-auto w-full $_sizeClasses bg-white dark:bg-zinc-900 rounded-lg shadow-xl ring-1 ring-gray-200 dark:ring-gray-800 p-0 backdrop:bg-gray-900/50 dark:backdrop:bg-zinc-950/75',
          attributes: {
            'data-modal-dialog': 'true',
            if (closeOnOverlay) 'data-close-on-backdrop': 'true',
          },
          children: [
            Div(
              className: 'flex flex-col',
              children: [
                // Header
                if (title != null ||
                    description != null ||
                    header != null)
                  Div(
                    className: 'flex items-start justify-between p-4 sm:p-6',
                    children: [
                      if (header != null)
                        header!
                      else
                        Div(className: 'flex-1 min-w-0', children: [
                          if (title != null)
                            H3(
                                className:
                                    'text-base font-semibold text-gray-900 dark:text-white',
                                children: [Text(title!)]),
                          if (description != null)
                            P(
                                className:
                                    'mt-1 text-sm text-gray-500 dark:text-gray-400',
                                children: [Text(description!)]),
                        ]),
                      // Close button
                      Button(
                        type: 'button',
                        className:
                            'shrink-0 -my-1 -mx-1 p-2 text-gray-400 hover:text-gray-500 dark:text-gray-500 dark:hover:text-gray-400 rounded-md hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors',
                        attributes: {'data-modal-close': 'true'},
                        children: [
                          Span(
                              className:
                                  'size-5 flex items-center justify-center text-xl',
                              children: [Text('×')]),
                        ],
                      ),
                    ],
                  ),
                // Body
                Div(
                    className:
                        'flex-1 p-4 sm:p-6 text-gray-700 dark:text-gray-300 ${title != null || description != null || header != null ? "pt-0 sm:pt-0" : ""}',
                    children: children),
                // Footer
                if (footer != null)
                  Div(
                      className:
                          'flex items-center justify-end gap-3 p-4 sm:px-6 border-t border-gray-200 dark:border-gray-800',
                      children: [footer!]),
              ],
            ),
          ],
        ),
        // Modal CSS and JavaScript
        RawText('''<style>
dialog[data-modal-dialog] {
  position: fixed;
  inset: 0;
  margin: auto;
}
</style>
<script>
if (!window._modalInit) {
  window._modalInit = true;

  document.addEventListener('click', function(e) {
    // Open trigger
    var trigger = e.target.closest('[data-modal-trigger]');
    if (trigger) {
      var modal = trigger.closest('[data-modal]');
      var dialog = modal.querySelector('[data-modal-dialog]');
      if (dialog) dialog.showModal();
      return;
    }

    // Close button
    var closeBtn = e.target.closest('[data-modal-close]');
    if (closeBtn) {
      var dialog = closeBtn.closest('dialog');
      if (dialog) dialog.close();
      return;
    }

    // Backdrop click (clicking on dialog element itself, not content)
    var dialog = e.target;
    if (dialog.tagName === 'DIALOG' && dialog.hasAttribute('data-close-on-backdrop')) {
      var rect = dialog.getBoundingClientRect();
      var isInDialog = (e.clientX >= rect.left && e.clientX <= rect.right &&
                        e.clientY >= rect.top && e.clientY <= rect.bottom);
      if (!isInDialog) {
        dialog.close();
      }
    }
  });
}
</script>'''),
      ],
    );
  }
}

/// Controlled modal for use with @client components
class DModalControlled extends StatelessComponent {
  final bool open;
  final String? title;
  final String? description;
  final Component? header;
  final Component? footer;
  final DModalSize size;
  final bool closeOnOverlay;
  final bool closeOnEscape;
  final bool preventClose;
  final bool fullscreen;
  final VoidCallback? onClose;
  final List<Component> children;

  const DModalControlled({
    super.key,
    required this.open,
    this.title,
    this.description,
    this.header,
    this.footer,
    this.size = DModalSize.md,
    this.closeOnOverlay = true,
    this.closeOnEscape = true,
    this.preventClose = false,
    this.fullscreen = false,
    this.onClose,
    this.children = const [],
  });

  String get _sizeClasses {
    if (fullscreen)
      return 'w-screen h-screen max-w-none max-h-none m-0 rounded-none';

    switch (size) {
      case DModalSize.xs:
        return 'max-w-xs';
      case DModalSize.sm:
        return 'max-w-sm';
      case DModalSize.md:
        return 'max-w-md';
      case DModalSize.lg:
        return 'max-w-lg';
      case DModalSize.xl:
        return 'max-w-xl';
      case DModalSize.xxl:
        return 'max-w-2xl';
      case DModalSize.xxxl:
        return 'max-w-3xl';
      case DModalSize.xxxxl:
        return 'max-w-4xl';
      case DModalSize.xxxxxl:
        return 'max-w-5xl';
      case DModalSize.full:
        return 'max-w-full';
    }
  }

  void _handleOverlayClick() {
    if (!preventClose && closeOnOverlay && onClose != null) {
      onClose!();
    }
  }

  @override
  Component build(BuildContext context) {
    if (!open) return Div(children: []);

    return Div(
      className: 'fixed inset-0 z-50 overflow-y-auto',
      children: [
        // Backdrop
        Div(
          className:
              'fixed inset-0 bg-gray-900/50 dark:bg-zinc-950/75 transition-opacity',
          events: {'click': (_) => _handleOverlayClick()},
          children: [],
        ),
        // Modal container
        Div(
          className: 'flex min-h-full items-center justify-center p-4',
          children: [
            Div(
              className:
                  'relative w-full $_sizeClasses bg-white dark:bg-zinc-900 rounded-lg shadow-xl ring-1 ring-gray-200 dark:ring-gray-800 flex flex-col',
              events: {'click': (e) => e.stopPropagation()},
              children: [
                // Header
                if (title != null ||
                    description != null ||
                    header != null ||
                    onClose != null)
                  Div(
                    className: 'flex items-start justify-between p-4 sm:p-6',
                    children: [
                      if (header != null)
                        header!
                      else
                        Div(className: 'flex-1 min-w-0', children: [
                          if (title != null)
                            H3(
                                className:
                                    'text-base font-semibold text-gray-900 dark:text-white',
                                children: [Text(title!)]),
                          if (description != null)
                            P(
                                className:
                                    'mt-1 text-sm text-gray-500 dark:text-gray-400',
                                children: [Text(description!)]),
                        ]),
                      if (onClose != null && !preventClose)
                        Button(
                          type: 'button',
                          onClick: onClose,
                          className:
                              'shrink-0 -my-1 -mx-1 p-2 text-gray-400 hover:text-gray-500 dark:text-gray-500 dark:hover:text-gray-400 rounded-md hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors',
                          children: [
                            Span(
                                className:
                                    'size-5 flex items-center justify-center text-xl',
                                children: [Text('×')]),
                          ],
                        ),
                    ],
                  ),
                // Body
                Div(
                    className:
                        'flex-1 p-4 sm:p-6 text-gray-700 dark:text-gray-300 ${title != null || description != null || header != null ? "pt-0 sm:pt-0" : ""}',
                    children: children),
                // Footer
                if (footer != null)
                  Div(
                      className:
                          'flex items-center justify-end gap-3 p-4 sm:px-6 border-t border-gray-200 dark:border-gray-800',
                      children: [footer!]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
