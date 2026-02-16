import 'package:jaspr/jaspr.dart' hide Text;
import 'package:jaspr/dom.dart' show RawText;
import 'package:duxt_html/duxt_html.dart';
import '../../theme/tw_merge.dart';
import 'icon.dart';

/// DuxtUI Calendar component - Date picker grid
///
/// A calendar component for date selection with month/year navigation.
/// Uses inline JavaScript for interactivity.
class DCalendar extends StatelessComponent {
  /// Currently selected date (format: YYYY-MM-DD)
  final String? selectedDate;

  /// Initial display month (1-12)
  final int? initialMonth;

  /// Initial display year
  final int? initialYear;

  /// Minimum selectable date (format: YYYY-MM-DD)
  final String? minDate;

  /// Maximum selectable date (format: YYYY-MM-DD)
  final String? maxDate;

  /// First day of week (0 = Sunday, 1 = Monday)
  final int firstDayOfWeek;

  /// Name attribute for form submission
  final String? name;

  /// Custom CSS classes
  final String? className;

  /// HTML id attribute
  final String? id;

  /// Additional HTML attributes
  final Map<String, String>? attributes;

  /// Event handlers
  final Map<String, EventCallback>? events;

  const DCalendar({
    super.key,
    this.selectedDate,
    this.initialMonth,
    this.initialYear,
    this.minDate,
    this.maxDate,
    this.firstDayOfWeek = 1, // Monday default
    this.name,
    this.className,
    this.id,
    this.attributes,
    this.events,
  });

  String get _calendarId => 'calendar_$hashCode';

  @override
  Component build(BuildContext context) {
    final now = DateTime.now();
    final displayMonth = initialMonth ?? now.month;
    final displayYear = initialYear ?? now.year;

    return Div(
      id: id ?? _calendarId,
      className: twMerge(
          'p-4 bg-white dark:bg-zinc-900 rounded-lg border border-gray-200 dark:border-gray-700',
          className),
      attributes: mergeAttributes({
        'data-calendar': 'true',
        'data-month': '$displayMonth',
        'data-year': '$displayYear',
        'data-first-day': '$firstDayOfWeek',
        if (minDate != null) 'data-min': minDate!,
        if (maxDate != null) 'data-max': maxDate!,
        if (selectedDate != null) 'data-selected': selectedDate!,
      }, attributes),
      events: events,
      children: [
        // Header with month/year navigation
        Div(
          className: 'flex items-center justify-between mb-4',
          attributes: {'data-header': 'true'},
          children: [
            Button(
              type: 'button',
              className:
                  'p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors',
              attributes: {'data-action': 'prev', 'aria-label': 'Previous month'},
              children: [
                DIcon(name: DIconNames.chevronLeft, size: DIconSize.sm),
              ],
            ),
            Span(
              className: 'font-semibold text-gray-900 dark:text-white',
              attributes: {'data-month-label': 'true'},
              children: [Text(_getMonthName(displayMonth) + ' $displayYear')],
            ),
            Button(
              type: 'button',
              className:
                  'p-2 hover:bg-gray-100 dark:hover:bg-gray-800 rounded-lg transition-colors',
              attributes: {'data-action': 'next', 'aria-label': 'Next month'},
              children: [
                DIcon(name: DIconNames.chevronRight, size: DIconSize.sm),
              ],
            ),
          ],
        ),

        // Weekday headers
        Div(
          className: 'grid grid-cols-7 gap-1 mb-2',
          children: [
            for (final label in _getWeekdayLabels())
              Div(
                className:
                    'text-center text-xs font-medium text-gray-500 dark:text-gray-400 py-2',
                children: [Text(label)],
              ),
          ],
        ),

        // Days grid (will be populated by JS)
        Div(
          className: 'grid grid-cols-7 gap-1',
          attributes: {'data-days': 'true'},
          children: _buildInitialDays(displayMonth, displayYear),
        ),

        // Hidden input for form submission
        if (name != null)
          Input(
            type: 'hidden',
            name: name,
            value: selectedDate ?? '',
            attributes: {'data-date-input': 'true'},
          ),

        // Calendar JavaScript
        RawText('''<script>
if (!window._calendarInit) {
  window._calendarInit = true;
  var months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  var days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

  function renderCalendar(cal) {
    var m = parseInt(cal.dataset.month);
    var y = parseInt(cal.dataset.year);
    var firstDay = parseInt(cal.dataset.firstDay) || 1;
    var selected = cal.dataset.selected || '';
    var minD = cal.dataset.min || '';
    var maxD = cal.dataset.max || '';

    var label = cal.querySelector('[data-month-label]');
    if (label) label.textContent = months[m-1] + ' ' + y;

    var daysGrid = cal.querySelector('[data-days]');
    if (!daysGrid) return;
    daysGrid.innerHTML = '';

    var firstOfMonth = new Date(y, m-1, 1);
    var daysInMonth = new Date(y, m, 0).getDate();
    var startDay = (firstOfMonth.getDay() - firstDay + 7) % 7;

    for (var i = 0; i < startDay; i++) {
      var empty = document.createElement('div');
      empty.className = 'p-2';
      daysGrid.appendChild(empty);
    }

    for (var d = 1; d <= daysInMonth; d++) {
      var dateStr = y + '-' + String(m).padStart(2,'0') + '-' + String(d).padStart(2,'0');
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.textContent = d;
      btn.dataset.date = dateStr;

      var isSelected = dateStr === selected;
      var isToday = dateStr === new Date().toISOString().split('T')[0];
      var isDisabled = (minD && dateStr < minD) || (maxD && dateStr > maxD);

      var cls = 'w-10 h-10 flex items-center justify-center text-sm rounded-lg transition-colors ';
      if (isDisabled) {
        cls += 'text-gray-300 dark:text-gray-600 cursor-not-allowed';
        btn.disabled = true;
      } else if (isSelected) {
        cls += 'bg-cyan-600 text-white font-semibold';
      } else if (isToday) {
        cls += 'bg-cyan-50 dark:bg-cyan-900/20 text-cyan-600 dark:text-cyan-400 font-semibold hover:bg-cyan-100 dark:hover:bg-cyan-900/30 cursor-pointer';
      } else {
        cls += 'text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-800 cursor-pointer';
      }
      btn.className = cls;
      daysGrid.appendChild(btn);
    }
  }

  document.addEventListener('click', function(e) {
    var btn = e.target.closest('[data-action], [data-date]');
    if (!btn) return;
    var cal = btn.closest('[data-calendar]');
    if (!cal) return;

    if (btn.dataset.action === 'prev') {
      var m = parseInt(cal.dataset.month);
      var y = parseInt(cal.dataset.year);
      if (m === 1) { m = 12; y--; } else { m--; }
      cal.dataset.month = m;
      cal.dataset.year = y;
      renderCalendar(cal);
    } else if (btn.dataset.action === 'next') {
      var m = parseInt(cal.dataset.month);
      var y = parseInt(cal.dataset.year);
      if (m === 12) { m = 1; y++; } else { m++; }
      cal.dataset.month = m;
      cal.dataset.year = y;
      renderCalendar(cal);
    } else if (btn.dataset.date && !btn.disabled) {
      cal.dataset.selected = btn.dataset.date;
      var input = cal.querySelector('[data-date-input]');
      if (input) input.value = btn.dataset.date;
      renderCalendar(cal);
      cal.dispatchEvent(new CustomEvent('dateselect', { detail: { date: btn.dataset.date } }));
    }
  });
}
</script>'''),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  List<String> _getWeekdayLabels() {
    const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final result = <String>[];
    for (var i = 0; i < 7; i++) {
      result.add(labels[(i + firstDayOfWeek) % 7]);
    }
    return result;
  }

  List<Component> _buildInitialDays(int month, int year) {
    final firstOfMonth = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startDay = (firstOfMonth.weekday - firstDayOfWeek + 7) % 7;
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final cells = <Component>[];

    // Empty cells for offset
    for (var i = 0; i < startDay; i++) {
      cells.add(Div(className: 'p-2', children: []));
    }

    // Day cells
    for (var day = 1; day <= daysInMonth; day++) {
      final dateStr = '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
      final isSelected = dateStr == selectedDate;
      final isToday = dateStr == todayStr;
      final isDisabled = (minDate != null && dateStr.compareTo(minDate!) < 0) ||
          (maxDate != null && dateStr.compareTo(maxDate!) > 0);

      String cellClasses = 'w-10 h-10 flex items-center justify-center text-sm rounded-lg transition-colors ';

      if (isDisabled) {
        cellClasses += 'text-gray-300 dark:text-gray-600 cursor-not-allowed';
      } else if (isSelected) {
        cellClasses += 'bg-cyan-600 text-white font-semibold';
      } else if (isToday) {
        cellClasses += 'bg-cyan-50 dark:bg-cyan-900/20 text-cyan-600 dark:text-cyan-400 font-semibold hover:bg-cyan-100 dark:hover:bg-cyan-900/30 cursor-pointer';
      } else {
        cellClasses += 'text-gray-900 dark:text-white hover:bg-gray-100 dark:hover:bg-gray-800 cursor-pointer';
      }

      cells.add(Button(
        type: 'button',
        disabled: isDisabled,
        className: cellClasses,
        attributes: {'data-date': dateStr},
        children: [Text('$day')],
      ));
    }

    return cells;
  }
}
