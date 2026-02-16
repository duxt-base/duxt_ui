import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';
import '../theme/tw_merge.dart';

/// Input sizes
enum DInputSize { xs, sm, md, lg, xl }

/// Input variants
enum DInputVariant { outline, soft, subtle, ghost, none }

/// Input colors
enum DInputColor { primary, secondary, success, info, warning, error, neutral }

/// DuxtUI Input component
class DInput extends StatelessComponent {
  final String? label;
  final String? placeholder;
  final String? name;
  final String? value;
  final String? hint;
  final String? error;
  final DInputSize size;
  final DInputVariant variant;
  final DInputColor? highlightColor;
  final bool disabled;
  final bool required;
  final bool readonly;
  final bool loading;
  final InputType type;
  final Component? leadingIcon;
  final Component? trailingIcon;
  final ValueChanged<String>? onInput;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DInput({
    super.key,
    this.label,
    this.placeholder,
    this.name,
    this.value,
    this.hint,
    this.error,
    this.size = DInputSize.md,
    this.variant = DInputVariant.outline,
    this.highlightColor,
    this.disabled = false,
    this.required = false,
    this.readonly = false,
    this.loading = false,
    this.type = InputType.text,
    this.leadingIcon,
    this.trailingIcon,
    this.onInput,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _baseClasses =>
      'w-full rounded-md border-0 appearance-none placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none disabled:cursor-not-allowed disabled:opacity-75 transition-colors';

  String get _sizeClasses {
    switch (size) {
      case DInputSize.xs:
        return 'px-2 py-1 text-xs';
      case DInputSize.sm:
        return 'px-2.5 py-1.5 text-xs';
      case DInputSize.md:
        return 'px-2.5 py-1.5 text-sm';
      case DInputSize.lg:
        return 'px-3 py-2 text-sm';
      case DInputSize.xl:
        return 'px-3 py-2 text-base';
    }
  }

  String get _iconSizeClasses {
    switch (size) {
      case DInputSize.xs:
      case DInputSize.sm:
        return 'size-4';
      case DInputSize.md:
      case DInputSize.lg:
        return 'size-5';
      case DInputSize.xl:
        return 'size-6';
    }
  }

  String get _leadingPadding {
    switch (size) {
      case DInputSize.xs:
        return 'ps-7';
      case DInputSize.sm:
        return 'ps-8';
      case DInputSize.md:
      case DInputSize.lg:
        return 'ps-9';
      case DInputSize.xl:
        return 'ps-10';
    }
  }

  String get _trailingPadding {
    switch (size) {
      case DInputSize.xs:
        return 'pe-7';
      case DInputSize.sm:
        return 'pe-8';
      case DInputSize.md:
      case DInputSize.lg:
        return 'pe-9';
      case DInputSize.xl:
        return 'pe-10';
    }
  }

  String get _variantClasses {
    final hasError = error != null && error!.isNotEmpty;
    if (hasError) {
      return 'text-gray-900 dark:text-white bg-white dark:bg-zinc-900 ring ring-inset ring-red-500';
    }

    switch (variant) {
      case DInputVariant.outline:
        return 'text-gray-900 dark:text-white bg-white dark:bg-zinc-900 ring ring-inset ring-gray-300 dark:ring-gray-700 focus:ring-2 focus:ring-cyan-500 dark:focus:ring-cyan-400';
      case DInputVariant.soft:
        return 'text-gray-900 dark:text-white bg-gray-50/50 dark:bg-zinc-800/50 hover:bg-gray-100 dark:hover:bg-gray-800 focus:bg-gray-100 dark:focus:bg-gray-800';
      case DInputVariant.subtle:
        return 'text-gray-900 dark:text-white bg-gray-50 dark:bg-zinc-800 ring ring-inset ring-gray-300 dark:ring-gray-700 focus:ring-2 focus:ring-cyan-500';
      case DInputVariant.ghost:
        return 'text-gray-900 dark:text-white bg-transparent hover:bg-gray-50 dark:hover:bg-gray-800 focus:bg-gray-50 dark:focus:bg-gray-800';
      case DInputVariant.none:
        return 'text-gray-900 dark:text-white bg-transparent';
    }
  }

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    final hasLeading = leadingIcon != null;
    final hasTrailing = trailingIcon != null || loading;

    return Div(className: 'space-y-1.5', children: [
      if (label != null)
        Span(
            className:
                'block text-sm font-medium text-gray-700 dark:text-gray-200',
            children: [
              Text(label!),
              if (required)
                Span(className: 'text-red-500 ml-0.5', children: [Text('*')]),
            ]),
      Div(className: 'relative', children: [
        if (hasLeading)
          Div(
            className:
                'absolute inset-y-0 start-0 flex items-center ps-2.5 pointer-events-none text-gray-400 dark:text-gray-500',
            children: [
              Span(className: '$_iconSizeClasses', children: [leadingIcon!])
            ],
          ),
        Input(
          type: type.name,
          name: name,
          value: value,
          disabled: disabled || loading,
          onInput: onInput,
          placeholder: placeholder,
          id: id,
          className: twMerge(
              '$_baseClasses $_sizeClasses $_variantClasses ${hasLeading ? _leadingPadding : ""} ${hasTrailing ? _trailingPadding : ""}'
                  .trim(),
              className),
          attributes: mergeAttributes({
            if (readonly) 'readonly': 'true',
          }, attributes),
          events: events,
        ),
        if (hasTrailing)
          Div(
            className:
                'absolute inset-y-0 end-0 flex items-center pe-2.5 pointer-events-none text-gray-400 dark:text-gray-500',
            children: [
              if (loading)
                Span(
                    className:
                        '$_iconSizeClasses animate-spin border-2 border-current border-t-transparent rounded-full',
                    children: [])
              else if (trailingIcon != null)
                Span(className: '$_iconSizeClasses', children: [trailingIcon!]),
            ],
          ),
      ]),
      if (hasError)
        P(className: 'text-sm text-red-500', children: [Text(error!)])
      else if (hint != null)
        P(
            className: 'text-sm text-gray-500 dark:text-gray-400',
            children: [Text(hint!)]),
    ]);
  }
}

/// DuxtUI Textarea component
class DTextarea extends StatelessComponent {
  final String? label;
  final String? placeholder;
  final String? name;
  final String? value;
  final String? hint;
  final String? error;
  final int rows;
  final DInputSize size;
  final DInputVariant variant;
  final bool disabled;
  final bool required;
  final bool autoresize;
  final ValueChanged<String>? onInput;
  final String? className;
  final String? id;
  final Map<String, String>? attributes;
  final Map<String, EventCallback>? events;

  const DTextarea({
    super.key,
    this.label,
    this.placeholder,
    this.name,
    this.value,
    this.hint,
    this.error,
    this.rows = 3,
    this.size = DInputSize.md,
    this.variant = DInputVariant.outline,
    this.disabled = false,
    this.required = false,
    this.autoresize = false,
    this.onInput,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _baseClasses =>
      'w-full rounded-md border-0 appearance-none placeholder:text-gray-400 dark:placeholder:text-gray-500 focus:outline-none disabled:cursor-not-allowed disabled:opacity-75 transition-colors resize-none';

  String get _sizeClasses {
    switch (size) {
      case DInputSize.xs:
        return 'px-2 py-1 text-xs';
      case DInputSize.sm:
        return 'px-2.5 py-1.5 text-xs';
      case DInputSize.md:
        return 'px-2.5 py-1.5 text-sm';
      case DInputSize.lg:
        return 'px-3 py-2 text-sm';
      case DInputSize.xl:
        return 'px-3 py-2 text-base';
    }
  }

  String get _variantClasses {
    final hasError = error != null && error!.isNotEmpty;
    if (hasError) {
      return 'text-gray-900 dark:text-white bg-white dark:bg-zinc-900 ring ring-inset ring-red-500';
    }

    switch (variant) {
      case DInputVariant.outline:
        return 'text-gray-900 dark:text-white bg-white dark:bg-zinc-900 ring ring-inset ring-gray-300 dark:ring-gray-700 focus:ring-2 focus:ring-cyan-500 dark:focus:ring-cyan-400';
      case DInputVariant.soft:
        return 'text-gray-900 dark:text-white bg-gray-50/50 dark:bg-zinc-800/50 hover:bg-gray-100 dark:hover:bg-gray-800 focus:bg-gray-100 dark:focus:bg-gray-800';
      case DInputVariant.subtle:
        return 'text-gray-900 dark:text-white bg-gray-50 dark:bg-zinc-800 ring ring-inset ring-gray-300 dark:ring-gray-700 focus:ring-2 focus:ring-cyan-500';
      case DInputVariant.ghost:
        return 'text-gray-900 dark:text-white bg-transparent hover:bg-gray-50 dark:hover:bg-gray-800 focus:bg-gray-50 dark:focus:bg-gray-800';
      case DInputVariant.none:
        return 'text-gray-900 dark:text-white bg-transparent';
    }
  }

  @override
  Component build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;

    return Div(className: 'space-y-1.5', children: [
      if (label != null)
        Span(
            className:
                'block text-sm font-medium text-gray-700 dark:text-gray-200',
            children: [
              Text(label!),
              if (required)
                Span(className: 'text-red-500 ml-0.5', children: [Text('*')]),
            ]),
      Textarea(
        name: name,
        onInput: onInput,
        id: id,
        className: twMerge('$_baseClasses $_sizeClasses $_variantClasses', className),
        placeholder: placeholder,
        rows: rows,
        disabled: disabled,
        attributes: attributes,
        events: events,
        children: [if (value != null) Text(value!)],
      ),
      if (hasError)
        P(className: 'text-sm text-red-500', children: [Text(error!)])
      else if (hint != null)
        P(
            className: 'text-sm text-gray-500 dark:text-gray-400',
            children: [Text(hint!)]),
    ]);
  }
}
