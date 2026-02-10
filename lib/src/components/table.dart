import 'package:jaspr/jaspr.dart' hide Text;
import 'package:duxt_html/duxt_html.dart';

/// Table column definition
class DTableColumn<T> {
  final String key;
  final String label;
  final Component Function(T item)? render;
  final String? classes;

  const DTableColumn({
    required this.key,
    required this.label,
    this.render,
    this.classes,
  });
}

/// DuxtUI Table component
class DTable<T> extends StatelessComponent {
  final List<DTableColumn<T>> columns;
  final List<T> data;
  final String Function(T item)? rowKey;
  final bool striped;
  final bool hoverable;
  final bool bordered;
  final Component? emptyState;

  const DTable({
    super.key,
    required this.columns,
    required this.data,
    this.rowKey,
    this.striped = false,
    this.hoverable = true,
    this.bordered = false,
    this.emptyState,
  });

  @override
  Component build(BuildContext context) {
    return Div(className: 'overflow-x-auto', children: [
      Table(
        className:
            'min-w-full divide-y divide-gray-200 ${bordered ? "border border-gray-200" : ""}',
        children: [
          // Header
          Thead(className: 'bg-gray-50', children: [
            Tr(children: [
              for (final col in columns)
                Th(
                  className:
                      'px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider ${col.classes ?? ""}',
                  children: [Text(col.label)],
                ),
            ]),
          ]),
          // Body
          Tbody(
            className: 'bg-white divide-y divide-gray-200',
            children: data.isEmpty && emptyState != null
                ? [
                    Tr(children: [
                      Td(
                        attributes: {'colspan': columns.length.toString()},
                        className: 'px-4 py-8 text-center',
                        children: [emptyState!],
                      ),
                    ]),
                  ]
                : [
                    for (var i = 0; i < data.length; i++)
                      Tr(
                        className:
                            '${striped && i.isOdd ? "bg-gray-50" : ""} ${hoverable ? "hover:bg-gray-50" : ""}',
                        children: [
                          for (final col in columns)
                            Td(
                              className:
                                  'px-4 py-3 text-sm text-gray-900 ${col.classes ?? ""}',
                              children: [
                                if (col.render != null)
                                  col.render!(data[i])
                                else
                                  Text(_getValue(data[i], col.key)),
                              ],
                            ),
                        ],
                      ),
                  ],
          ),
        ],
      ),
    ]);
  }

  String _getValue(T item, String key) {
    if (item is Map) {
      return item[key]?.toString() ?? '';
    }
    return '';
  }
}
