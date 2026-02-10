import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show events;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/variants.dart';
import '../../theme/colors.dart';

/// Tree node data structure
class DTreeNode {
  /// Unique identifier for the node
  final String id;

  /// Display label
  final String label;

  /// Optional icon class
  final String? icon;

  /// Child nodes
  final List<DTreeNode> children;

  /// Whether this node is initially expanded
  final bool expanded;

  /// Whether this node is selected
  final bool selected;

  /// Whether this node is disabled
  final bool disabled;

  /// Custom data associated with this node
  final dynamic data;

  const DTreeNode({
    required this.id,
    required this.label,
    this.icon,
    this.children = const [],
    this.expanded = false,
    this.selected = false,
    this.disabled = false,
    this.data,
  });

  /// Check if node has children
  bool get hasChildren => children.isNotEmpty;

  /// Create a copy with modified properties
  DTreeNode copyWith({
    String? id,
    String? label,
    String? icon,
    List<DTreeNode>? children,
    bool? expanded,
    bool? selected,
    bool? disabled,
    dynamic data,
  }) {
    return DTreeNode(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      children: children ?? this.children,
      expanded: expanded ?? this.expanded,
      selected: selected ?? this.selected,
      disabled: disabled ?? this.disabled,
      data: data ?? this.data,
    );
  }
}

/// DuxtUI Tree component - Hierarchical list with expand/collapse
class DTree extends StatefulComponent {
  /// Root nodes of the tree
  final List<DTreeNode> nodes;

  /// Callback when a node is selected
  final void Function(DTreeNode node)? onSelect;

  /// Callback when a node is expanded/collapsed
  final void Function(DTreeNode node, bool expanded)? onToggle;

  /// Whether multiple nodes can be selected
  final bool multiSelect;

  /// Whether to show checkboxes
  final bool showCheckboxes;

  /// Whether to show connecting lines
  final bool showLines;

  /// Default icon for folder/parent nodes
  final String folderIcon;

  /// Default icon for collapsed folder
  final String folderCollapsedIcon;

  /// Default icon for leaf nodes
  final String leafIcon;

  /// Expand icon
  final String expandIcon;

  /// Collapse icon
  final String collapseIcon;

  /// Tree color
  final DColor color;

  /// Size
  final DSize size;

  const DTree({
    super.key,
    required this.nodes,
    this.onSelect,
    this.onToggle,
    this.multiSelect = false,
    this.showCheckboxes = false,
    this.showLines = false,
    this.folderIcon = 'i-lucide-folder-open',
    this.folderCollapsedIcon = 'i-lucide-folder',
    this.leafIcon = 'i-lucide-file',
    this.expandIcon = 'i-lucide-chevron-down',
    this.collapseIcon = 'i-lucide-chevron-right',
    this.color = DColor.primary,
    this.size = DSize.md,
  });

  @override
  State<DTree> createState() => _UTreeState();
}

class _UTreeState extends State<DTree> {
  late Map<String, bool> _expandedState;
  late Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _expandedState = {};
    _selectedIds = {};
    _initializeState(component.nodes);
  }

  void _initializeState(List<DTreeNode> nodes) {
    for (final node in nodes) {
      _expandedState[node.id] = node.expanded;
      if (node.selected) {
        _selectedIds.add(node.id);
      }
      if (node.hasChildren) {
        _initializeState(node.children);
      }
    }
  }

  bool _isExpanded(String id) => _expandedState[id] ?? false;

  bool _isSelected(String id) => _selectedIds.contains(id);

  void _toggleExpand(DTreeNode node) {
    setState(() {
      _expandedState[node.id] = !_isExpanded(node.id);
    });
    component.onToggle?.call(node, _isExpanded(node.id));
  }

  void _selectNode(DTreeNode node) {
    if (node.disabled) return;

    setState(() {
      if (component.multiSelect) {
        if (_selectedIds.contains(node.id)) {
          _selectedIds.remove(node.id);
        } else {
          _selectedIds.add(node.id);
        }
      } else {
        _selectedIds.clear();
        _selectedIds.add(node.id);
      }
    });
    component.onSelect?.call(node);
  }

  String get _iconSize {
    switch (component.size) {
      case DSize.xs:
        return 'size-3';
      case DSize.sm:
        return 'size-3.5';
      case DSize.md:
        return 'size-4';
      case DSize.lg:
        return 'size-5';
      case DSize.xl:
        return 'size-6';
    }
  }

  String get _textSize {
    switch (component.size) {
      case DSize.xs:
        return 'text-xs';
      case DSize.sm:
        return 'text-sm';
      case DSize.md:
        return 'text-sm';
      case DSize.lg:
        return 'text-base';
      case DSize.xl:
        return 'text-lg';
    }
  }

  String get _itemPadding {
    switch (component.size) {
      case DSize.xs:
        return 'py-0.5 px-1';
      case DSize.sm:
        return 'py-1 px-1.5';
      case DSize.md:
        return 'py-1.5 px-2';
      case DSize.lg:
        return 'py-2 px-2.5';
      case DSize.xl:
        return 'py-2.5 px-3';
    }
  }

  String get _selectedColor {
    final baseColor = defaultColorMapping[component.color] ?? 'green';
    return 'bg-$baseColor-50 dark:bg-$baseColor-950 text-$baseColor-700 dark:text-$baseColor-300';
  }

  @override
  Component build(BuildContext context) {
    return Ul(
      className: 'tree-root',
      attributes: {'role': 'tree'},
      children: [
        for (final node in component.nodes) _buildNode(node, 0),
      ],
    );
  }

  Component _buildNode(DTreeNode node, int depth) {
    final isExpanded = _isExpanded(node.id);
    final isSelected = _isSelected(node.id);
    final hasChildren = node.hasChildren;

    return Li(
      className: 'tree-item',
      attributes: {
        'role': 'treeitem',
        if (hasChildren) 'aria-expanded': '$isExpanded',
        'aria-selected': '$isSelected',
      },
      children: [
        // Node row
        Div(
          className: cx([
            'flex items-center gap-1 rounded-md cursor-pointer transition-colors',
            _itemPadding,
            if (isSelected) _selectedColor,
            if (!isSelected && !node.disabled)
              'hover:bg-gray-100 dark:hover:bg-gray-800',
            if (node.disabled) 'opacity-50 cursor-not-allowed',
          ]),
          style: 'padding-left: ${depth * 20 + 4}px',
          events: events(onClick: () {
            if (!node.disabled) {
              _selectNode(node);
            }
          }),
          children: [
            // Expand/collapse button
            if (hasChildren)
              Button(
                type: 'button',
                className:
                    'shrink-0 p-0.5 rounded hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors',
                events: {'click': (event) {
                  event.stopPropagation();
                  _toggleExpand(node);
                }},
                children: [
                  I(
                    className: cx([
                      isExpanded
                          ? component.expandIcon
                          : component.collapseIcon,
                      _iconSize,
                      'text-gray-500 dark:text-gray-400',
                    ]),
                    children: [],
                  ),
                ],
              )
            else
              // Spacer for alignment
              Span(className: '${_iconSize} shrink-0', children: []),

            // Checkbox (if enabled)
            if (component.showCheckboxes)
              Input(
                type: 'checkbox',
                className: cx([
                  'rounded border-gray-300 dark:border-gray-600 shrink-0',
                  'text-${defaultColorMapping[component.color]}-500',
                  'focus:ring-${defaultColorMapping[component.color]}-500',
                ]),
                attributes: {
                  if (isSelected) 'checked': 'true',
                  if (node.disabled) 'disabled': 'true',
                },
                events: {'click': (event) {
                  event.stopPropagation();
                  _selectNode(node);
                }},
              ),

            // Icon
            I(
              className: cx([
                node.icon ??
                    (hasChildren
                        ? (isExpanded
                            ? component.folderIcon
                            : component.folderCollapsedIcon)
                        : component.leafIcon),
                _iconSize,
                'shrink-0',
                if (isSelected)
                  'text-${defaultColorMapping[component.color]}-600 dark:text-${defaultColorMapping[component.color]}-400'
                else
                  'text-gray-500 dark:text-gray-400',
              ]),
              children: [],
            ),

            // Label
            Span(
              className: cx([
                _textSize,
                'truncate',
                if (isSelected) 'font-medium',
              ]),
              children: [Text(node.label)],
            ),
          ],
        ),

        // Children (if expanded)
        if (hasChildren && isExpanded)
          Ul(
            className: cx([
              'tree-children',
              if (component.showLines)
                'ml-3 border-l border-gray-200 dark:border-gray-700',
            ]),
            attributes: {'role': 'group'},
            children: [
              for (final child in node.children) _buildNode(child, depth + 1),
            ],
          ),
      ],
    );
  }
}

/// Simple tree for file browser use case
class DFileTree extends StatelessComponent {
  /// Root nodes
  final List<DTreeNode> nodes;

  /// Callback when a file is selected
  final void Function(DTreeNode node)? onSelect;

  /// Currently selected file ID
  final String? selectedId;

  const DFileTree({
    super.key,
    required this.nodes,
    this.onSelect,
    this.selectedId,
  });

  @override
  Component build(BuildContext context) {
    return DTree(
      nodes: nodes,
      onSelect: onSelect,
      folderIcon: 'i-lucide-folder-open',
      folderCollapsedIcon: 'i-lucide-folder',
      leafIcon: 'i-lucide-file-text',
      showLines: true,
      color: DColor.primary,
    );
  }
}
