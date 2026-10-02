
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/menu_item.dart';
import 'package:inspect/provider/auth_provider.dart';
import 'package:inspect/screen/categories/categories_screen.dart';
import 'package:inspect/screen/customer/customer_screen.dart';
import 'package:inspect/screen/cycle/cycle_screen.dart';
import 'package:inspect/screen/dashboard/dashboard_screen.dart';
import 'package:inspect/screen/job/job_add_new_screen.dart';
import 'package:inspect/screen/job/job_screen.dart';
import 'package:inspect/screen/personnel/personnel_screen.dart';
import 'package:inspect/screen/personnel/personnel_team_screen.dart';
import 'package:inspect/screen/planner/planner_screen.dart';
import 'package:inspect/screen/planner/team_planner_screen.dart';
import 'package:inspect/screen/settings/access/acccess_view_screen.dart';
import 'package:inspect/screen/settings/company/agent_screen.dart';
import 'package:inspect/screen/settings/company/division_screen.dart';
import 'package:inspect/screen/settings/report_setup/report_types_screen.dart';
import 'package:inspect/screen/site/site_screen.dart';
import 'package:inspect/widget/welcome_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final bool showWelcomeDialog;
  final String? userName;

  const HomeScreen({super.key, this.showWelcomeDialog = false, this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final Set<int> _expandedMenus = {};
  bool _isSidebarExpanded = true;

  late AnimationController _animationController;

  List<MenuItem> get _allMenuItems => [
    MenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard_rounded, // overview/dashboard grid
      index: 0,
      screen: DashboardScreen(),
    ),
    MenuItem(
      title: 'Planner',
      icon: Icons.calendar_month_rounded, // calendar-based planning
      index: 1,
      children: [
        MenuItem(
          title: 'View Planner',
          icon: Icons.event_note_rounded, // scheduled notes on calendar
          index: 30,
          screen: PlannerScreen(),
        ),
        MenuItem(
          title: 'Add Planner',
          icon: Icons.event_available_rounded, // adding a new planned event
          index: 31,
          screen: TeamPlannerScreen(),
        ),
      ],
    ),
    MenuItem(
      title: 'Jobs',
      icon: Icons.work_rounded, // briefcase = jobs
      index: 2,
      children: [
        MenuItem(
          title: 'View All',
          icon: Icons.fact_check_rounded, // job list with status tracking
          index: 12,
          screen: JobScreen(),
        ),
        MenuItem(
          title: 'Add New',
          icon: Icons.post_add_rounded, // adding a new job entry/document
          index: 13,
          screen: JobAddNewScreen(),
        ),
      ],
    ),
    MenuItem(
      title: 'Personnel',
      icon: Icons.manage_accounts_rounded, // managing people/accounts
      index: 3,
      children: [
        MenuItem(
          title: 'Personnel Records',
          icon: Icons.assignment_ind_rounded,
          // individual personnel assignment
          index: 14,
          screen: PersonnelScreen(),
        ),
        MenuItem(
          title: 'Teams',
          icon: Icons.groups_2_rounded, // team grouping
          index: 15,
          screen: PersonnelTeamScreen(),
        ),
      ],
    ),
    MenuItem(
      title: 'Customer',
      icon: Icons.handshake_rounded, // customer relationship
      index: 4,
      screen: Center(child: CustomerScreen()),
    ),
    MenuItem(
      title: 'Sites',
      icon: Icons.map_rounded, // physical site/location
      index: 5,
      screen: Center(child: SiteScreen()),
    ),
    MenuItem(
      title: 'Categories',
      icon: Icons.category_rounded, // explicit category icon
      index: 6,
      screen: Center(child: CategoriesScreen()),
    ),
    MenuItem(
      title: 'Settings',
      icon: Icons.settings_rounded, // settings gear
      index: 8,
      children: [
        MenuItem(
          title: 'Report Setup',
          icon: Icons.summarize_rounded, // report summary/setup
          index: 17,
          children: [
            MenuItem(
              title: 'Cycle',
              icon: Icons.autorenew_rounded, // recurring cycle concept
              index: 25,
              screen: CycleScreen(),
            ),
            MenuItem(
              title: 'Report Type',
              icon: Icons.article_rounded, // document/report type
              index: 24,
              screen: ReportTypeScreen(),
            ),
            MenuItem(
              title: 'Agent',
              icon: Icons.record_voice_over_rounded,
              index: 26,
              screen: AgentScreen(),
            ),
          ],
        ),
        MenuItem(
          title: 'Company',
          icon: Icons.business_rounded, // company/business
          index: 18,
          children: [
            MenuItem(
              title: 'Divisions',
              icon: Icons.corporate_fare_rounded, // org structure/floors
              index: 22,
              screen: CompanyDivisionScreen(),
            ),
          ],
        ),
        MenuItem(
          title: 'Access',
          icon: Icons.admin_panel_settings_rounded, // access control panel
          index: 19,
          children: [
            MenuItem(
              title: 'Logins',
              icon: Icons.key_rounded, // login key/credentials
              index: 20,
              screen: AccessViewScreen(),
            ),
          ],
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showWelcomeDialog) {
        WelcomeDialog.show(context, userName: widget.userName);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<MenuItem> _getFilteredMenuItems(String userGroup) {
    final isAdmin = userGroup.toLowerCase() == 'admin';

    if (!isAdmin) {
      return [
        MenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard_rounded,
          index: 0,
          screen: DashboardScreen(),
        ),
        MenuItem(
          title: 'Planner',
          icon: Icons.calendar_month_rounded,
          index: 1,
          children: [
            MenuItem(
              title: 'View Planner',
              icon: Icons.event_note_rounded,
              index: 30,
              screen: PlannerScreen(),
            ),
            MenuItem(
              title: 'Add Planner',
              icon: Icons.event_available_rounded,
              index: 31,
              screen: TeamPlannerScreen(),
            ),
          ],
        ),
        MenuItem(
          title: 'Jobs',
          icon: Icons.work_rounded,
          index: 2,
          children: [
            MenuItem(
              title: 'View All',
              icon: Icons.fact_check_rounded,
              index: 12,
              screen: JobScreen(),
            ),
          ],
        ),
      ];
    }

    return _allMenuItems;
  }

  MenuItem? _getCurrentMenuItem(List<MenuItem> menuItems) {
    MenuItem? findItem(List<MenuItem> items, int index) {
      for (final item in items) {
        if (item.index == index) return item;
        if (item.children != null) {
          final found = findItem(item.children!, index);
          if (found != null) return found;
        }
      }
      return null;
    }

    return findItem(menuItems, _selectedIndex) ?? menuItems.first;
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
      if (_isSidebarExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  /// Builds a beautiful icon container with gradient background + subtle shadow.
  /// [isSelected] shows an active filled look; [isChild] uses a smaller, softer style.
  /// Parent icon: solid rounded square with gradient + glow when selected.
  /// Child icon: circle badge style — softer, smaller, clearly subordinate.
  Widget _buildBeautifulIcon({
    required IconData icon,
    required bool isSelected,
    bool isChild = false,
    double size = 20,
  }) {
    final primary = context.colors.primary;

    if (isChild) {
      // Child items: small circle with subtle tinted background + border ring.
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isSelected
                  ? primary.withOpacity(0.15)
                  : primary.withOpacity(0.06),
          border: Border.all(
            color:
                isSelected
                    ? primary.withOpacity(0.5)
                    : primary.withOpacity(0.15),
            width: 1.2,
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: isSelected ? primary : primary.withOpacity(0.55),
        ),
      );
    }

    // Parent items: rounded square with gradient + glow on selection.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient:
            isSelected
                ? LinearGradient(
                  colors: [primary, primary.withOpacity(0.75)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : LinearGradient(
                  colors: [
                    primary.withOpacity(0.12),
                    primary.withOpacity(0.06),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: primary.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
                : [],
      ),
      child: Icon(
        icon,
        size: size,
        color: isSelected ? Colors.white : primary.withOpacity(0.85),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticateProvider>(
      builder: (context, authProvider, child) {
        final userGroup = authProvider.userGroup;
        final menuItems = _getFilteredMenuItems(userGroup);
        final currentMenuItem = _getCurrentMenuItem(menuItems);

        return Scaffold(
          appBar:
              (currentMenuItem?.title == 'Dashboard' ||
                      currentMenuItem?.title == 'Add Planner')
                  ? null
                  : AppBar(
                    automaticallyImplyLeading: false,
                    title: Text(
                      currentMenuItem?.title ?? '',
                      style: context.topology.textTheme.titleMedium?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                    centerTitle: true,
                    iconTheme: IconThemeData(color: context.colors.primary),
                    backgroundColor: context.colors.onPrimary,
                  ),
          body: Row(
            children: [
              // Animated Sidebar
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isSidebarExpanded ? 260 : 72,
                decoration: BoxDecoration(
                  color: context.colors.onPrimary,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.primary.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(4, 0),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Logo Section
                      Container(
                        height: 80,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child:
                            _isSidebarExpanded
                                ? Image.asset(
                                  'assets/images/logo.jpg',
                                  height: 50,
                                  fit: BoxFit.contain,
                                )
                                : Image.asset(
                                  'assets/images/logo_small.jpg',
                                  height: 36,
                                  fit: BoxFit.contain,
                                ),
                      ),

                      Divider(
                        height: 1,
                        color: context.colors.primary.withOpacity(0.1),
                      ),

                      // Toggle Button
                      SizedBox(
                        height: 52,
                        child: Center(
                          child: _buildIconButton(
                            icon:
                                _isSidebarExpanded
                                    ? Icons.menu_open_rounded
                                    : Icons.menu_rounded,
                            tooltip: _isSidebarExpanded ? 'Collapse' : 'Expand',
                            onTap: _toggleSidebar,
                          ),
                        ),
                      ),

                      Divider(
                        height: 1,
                        color: context.colors.primary.withOpacity(0.1),
                      ),

                      // Menu Items
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          children: _buildMenuList(menuItems),
                        ),
                      ),

                      Divider(
                        height: 1,
                        color: context.colors.primary.withOpacity(0.1),
                      ),

                      // Logout
                      _buildLogoutTile(authProvider),
                    ],
                  ),
                ),
              ),

              // Main Content
              Expanded(
                child: SafeArea(
                  top: true,
                  child: _getBodyContent(currentMenuItem),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: context.colors.primary.withOpacity(0.08),
          ),
          child: Icon(
            icon,
            size: 20,
            color: context.colors.primary.withOpacity(0.85),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutTile(AuthenticateProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tooltip(
        message: 'Logout',
        child: InkWell(
          onTap: () => authProvider.logout(context),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red.withOpacity(0.07),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(0.18),
                        Colors.red.withOpacity(0.08),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
                if (_isSidebarExpanded) ...[
                  const SizedBox(width: 12),
                  Text(
                    'Logout',
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMenuList(List<MenuItem> items, {int indent = 0}) {
    return items.expand((item) {
      final bool isSelected = _selectedIndex == item.index;
      final bool isExpanded = _expandedMenus.contains(item.index);
      final bool hasChildren = item.children != null;
      final bool isChild = indent > 0;

      List<Widget> tiles = [
        Padding(
          padding: EdgeInsets.only(
            left: _isSidebarExpanded ? (indent * 12).toDouble() : 0,
            bottom: 2,
          ),
          child:
              hasChildren && !_isSidebarExpanded
                  ? _buildCollapsedMenuWithPopup(item, isExpanded)
                  : _buildMenuTile(
                    item: item,
                    isSelected: isSelected,
                    isExpanded: isExpanded,
                    hasChildren: hasChildren,
                    isChild: isChild,
                  ),
        ),
      ];

      if (hasChildren && isExpanded && _isSidebarExpanded) {
        tiles.addAll(_buildMenuList(item.children!, indent: indent + 1));
      }

      return tiles;
    }).toList();
  }

  Widget _buildMenuTile({
    required MenuItem item,
    required bool isSelected,
    required bool isExpanded,
    required bool hasChildren,
    required bool isChild,
  }) {
    final primary = context.colors.primary;

    return Tooltip(
      message: _isSidebarExpanded ? '' : item.title,
      child: InkWell(
        onTap: () {
          setState(() {
            if (hasChildren && _isSidebarExpanded) {
              if (isExpanded) {
                _expandedMenus.remove(item.index);
              } else {
                _expandedMenus.add(item.index);
              }
            } else if (!hasChildren) {
              _selectedIndex = item.index;
            }
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: _isSidebarExpanded ? 8 : 0,
            vertical: isChild ? 4 : 6,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                isSelected && !hasChildren
                    ? primary.withOpacity(isChild ? 0.06 : 0.08)
                    : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment:
                _isSidebarExpanded
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
            children: [
              // Left accent bar for selected child items
              if (isChild && _isSidebarExpanded)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 3,
                  height: 24,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color:
                        isSelected && !hasChildren
                            ? primary
                            : Colors.transparent,
                  ),
                ),
              _buildBeautifulIcon(
                icon: item.icon,
                isSelected: isSelected && !hasChildren,
                isChild: isChild,
              ),
              if (_isSidebarExpanded) ...[
                SizedBox(width: isChild ? 10 : 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: (isChild
                            ? context.topology.textTheme.bodySmall
                            : context.topology.textTheme.titleSmall)
                        ?.copyWith(
                          color:
                              isSelected && !hasChildren
                                  ? primary
                                  : primary.withOpacity(isChild ? 0.65 : 0.78),
                          fontWeight:
                              isSelected && !hasChildren
                                  ? FontWeight.w600
                                  : (isChild
                                      ? FontWeight.w400
                                      : FontWeight.w500),
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasChildren)
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: primary.withOpacity(0.5),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedMenuWithPopup(MenuItem item, bool isExpanded) {
    return PopupMenuButton<MenuItem>(
      onSelected: (selectedItem) {
        setState(() {
          _selectedIndex = selectedItem.index;
        });
      },
      itemBuilder: (BuildContext context) {
        return _buildPopupMenuItems(item.children ?? []);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Tooltip(
        message: item.title,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Center(
            child: _buildBeautifulIcon(icon: item.icon, isSelected: false),
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<MenuItem>> _buildPopupMenuItems(List<MenuItem> items) {
    return items.map((item) {
      if (item.children != null && item.children!.isNotEmpty) {
        return PopupMenuItem<MenuItem>(
          child: PopupMenuButton<MenuItem>(
            onSelected: (selectedItem) {
              setState(() {
                _selectedIndex = selectedItem.index;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (BuildContext context) {
              return _buildPopupMenuItems(item.children!);
            },
            child: Row(
              children: [
                _buildBeautifulIcon(
                  icon: item.icon,
                  isSelected: false,
                  isChild: true,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.title,
                    style: context.topology.textTheme.bodySmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.colors.primary.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        );
      } else {
        return PopupMenuItem<MenuItem>(
          value: item,
          child: Row(
            children: [
              _buildBeautifulIcon(
                icon: item.icon,
                isSelected: false,
                isChild: true,
              ),
              const SizedBox(width: 10),
              Text(
                item.title,
                style: context.topology.textTheme.bodySmall?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        );
      }
    }).toList();
  }

  Widget _getBodyContent(MenuItem? currentMenuItem) {
    if (currentMenuItem == null) {
      return const Center(child: Text("No screen found"));
    }
    if (currentMenuItem.builder != null) {
      return currentMenuItem.builder!();
    }
    return currentMenuItem.screen ??
        Center(child: Text("${currentMenuItem.title} Content"));
  }
}
