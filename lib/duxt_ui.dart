/// DuxtUI - Component library for Jaspr
///
/// ```dart
/// import 'package:duxt_ui/duxt_ui.dart';
/// ```
library duxt_ui;

// Components
export 'src/components/button.dart';
export 'src/components/input.dart' hide DInputVariant; // Hide - defined in variants.dart
export 'src/components/card.dart' hide DCardVariant; // Hide - defined in variants.dart
export 'src/components/badge.dart' hide DBadgeVariant; // Hide - defined in variants.dart
export 'src/components/alert.dart' hide DAlertVariant; // Hide - defined in variants.dart
export 'src/components/modal.dart';
export 'src/components/dropdown.dart';
export 'src/components/tabs.dart';
export 'src/components/table.dart';
export 'src/components/avatar.dart';
export 'src/components/spinner.dart';

// Form Components
export 'src/components/form/checkbox.dart';
export 'src/components/form/checkbox_group.dart';
export 'src/components/form/radio_group.dart';
export 'src/components/form/switch.dart';
export 'src/components/form/select.dart';
export 'src/components/form/slider.dart';
export 'src/components/form/input_number.dart';
export 'src/components/form/pin_input.dart';
export 'src/components/form/file_upload.dart';
export 'src/components/form/form.dart';
export 'src/components/form/form_field.dart';

// Overlay Components
export 'src/components/overlay/overlay.dart';

// Layout Components
export 'src/components/layout/container.dart';
export 'src/components/layout/separator.dart';
export 'src/components/layout/main.dart';
export 'src/components/layout/header.dart' hide DPageHeader; // Hide - defined in page_header.dart
export 'src/components/layout/footer.dart';

// Navigation Components
export 'src/components/navigation/breadcrumb.dart';
export 'src/components/navigation/navigation_menu.dart';
export 'src/components/navigation/link.dart';
export 'src/components/navigation/kbd.dart';

// Chat Components
export 'src/components/chat/chat_message.dart';
export 'src/components/chat/chat_messages.dart';
export 'src/components/chat/chat_prompt.dart';
export 'src/components/chat/chat_prompt_submit.dart';
export 'src/components/chat/chat_palette.dart';

// Content Components
export 'src/components/content/accordion.dart';
export 'src/components/content/collapsible.dart';
export 'src/components/content/skeleton.dart';
export 'src/components/content/empty.dart';
export 'src/components/content/error.dart';

// Feedback Components
export 'src/components/feedback/toast.dart';
export 'src/components/feedback/toaster.dart';
export 'src/components/feedback/banner.dart';

// Blog Components
export 'src/components/blog/blog_post.dart';
export 'src/components/blog/blog_posts.dart';

// Pricing Components
export 'src/components/pricing/pricing_plan.dart';
export 'src/components/pricing/pricing_plans.dart';
export 'src/components/pricing/pricing_table.dart';

// Dashboard Components
export 'src/components/dashboard/dashboard_group.dart';
export 'src/components/dashboard/dashboard_panel.dart';
export 'src/components/dashboard/dashboard_navbar.dart';
export 'src/components/dashboard/dashboard_sidebar.dart';
export 'src/components/dashboard/dashboard_sidebar_toggle.dart';
export 'src/components/dashboard/dashboard_sidebar_collapse.dart';
export 'src/components/dashboard/dashboard_toolbar.dart';
export 'src/components/dashboard/dashboard_search.dart';

// Page Components
export 'src/components/page/page.dart';
export 'src/components/page/page_body.dart';
export 'src/components/page/page_header.dart';
export 'src/components/page/page_hero.dart' hide DPageHeaderAlign; // Hide - defined in page_header.dart
export 'src/components/page/page_section.dart';
export 'src/components/page/page_aside.dart';
export 'src/components/page/page_card.dart';
export 'src/components/page/page_grid.dart';
export 'src/components/page/page_columns.dart';
export 'src/components/page/page_cta.dart';

// Data Display Components
export 'src/components/data/chip.dart';
export 'src/components/data/avatar_group.dart';
export 'src/components/data/pagination.dart';
export 'src/components/data/progress.dart';
export 'src/components/data/timeline.dart';
export 'src/components/data/tree.dart';
export 'src/components/data/user.dart';

// Utility Components
export 'src/components/utility/icon.dart';
export 'src/components/utility/carousel.dart';
export 'src/components/utility/marquee.dart';
export 'src/components/utility/scroll_area.dart';
export 'src/components/utility/stepper.dart';
export 'src/components/utility/calendar.dart';

// Theme
export 'src/theme/theme.dart';
export 'src/theme/colors.dart';
export 'src/theme/variants.dart' hide DButtonVariant; // Hide - defined in button.dart
export 'src/theme/provider.dart';
export 'src/theme/tw_merge.dart';
