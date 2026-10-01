
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/get_customer_model/get_customer_model.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:inspect/widget/common_dialog.dart';
import 'package:inspect/widget/common_dropdown.dart';
import 'package:inspect/widget/common_textfield.dart';
import 'package:provider/provider.dart';

enum CustomerSearchColumn {
  name('Name'),
  code('Account Code'),
  division('Division'),
  status('Status'),
  agent('Agent');

  const CustomerSearchColumn(this.label);

  final String label;
}

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 800),
    vsync: this,
  );
  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeOutCubic,
  );

  CustomerSearchColumn? selectedColumn;
  dynamic selectedValue;
  bool _isSearchFocused = false;

  bool get _hasActiveFilter => selectedColumn != null && selectedValue != null;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await context.read<CustomerProvider>().fetchCustomers(context);
    if (mounted) _animationController.forward();
  }

  void _onSearchChanged() {
    if (mounted) setState(() {});
  }

  void _clearFilter() {
    setState(() {
      selectedColumn = null;
      selectedValue = null;
    });
  }

  void _openCreate() =>
      NavigationService().navigateTo(NavigationRoutes.createCustomer);

  void _editCustomer(Customer customer) {
    NavigationService().navigateTo(
      NavigationRoutes.createCustomer,
      arguments: {'isEdit': true, 'customerData': customer},
    );
  }

  String? _stringValue(Customer customer, CustomerSearchColumn column) {
    switch (column) {
      case CustomerSearchColumn.name:
        return customer.customername;
      case CustomerSearchColumn.code:
        return customer.accountCode;
      case CustomerSearchColumn.division:
        return customer.divisionname;
      case CustomerSearchColumn.agent:
        return customer.agentName;
      case CustomerSearchColumn.status:
        return null;
    }
  }

  List<dynamic> _getColumnValues(
    List<Customer> customers,
    CustomerSearchColumn column,
  ) {
    if (column == CustomerSearchColumn.status) return [true, false];
    return customers
        .map((c) => _stringValue(c, column))
        .whereType<String>()
        .where((value) => value.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  String _getValueLabel(CustomerSearchColumn column, dynamic value) {
    if (column == CustomerSearchColumn.status) {
      return value == true ? 'Archived' : 'Active';
    }
    return value.toString();
  }

  bool _matchesSearch(Customer customer, String query) => [
    customer.customername,
    customer.accountCode,
    customer.divisionname,
    customer.agent,
    customer.agentName,
  ].any((value) => (value ?? '').toLowerCase().contains(query));

  bool _matchesFilter(Customer customer) {
    final column = selectedColumn!;
    if (column == CustomerSearchColumn.status) {
      return (customer.archived ?? false) == selectedValue;
    }
    return _stringValue(customer, column) == selectedValue;
  }

  List<Customer> _getFilteredCustomers(List<Customer> customers) {
    final query = _searchController.text.toLowerCase().trim();

    return customers.where((customer) {
      if (query.isNotEmpty && !_matchesSearch(customer, query)) return false;
      if (_hasActiveFilter && !_matchesFilter(customer)) return false;
      return true;
    }).toList();
  }

  TextStyle? _small({
    double opacity = 1,
    FontWeight? weight,
    double? size,
    Color? color,
  }) => context.topology.textTheme.bodySmall?.copyWith(
    color: color ?? context.colors.primary.withOpacity(opacity),
    fontWeight: weight,
    fontSize: size,
  );

  ButtonStyle _primaryButtonStyle(
    EdgeInsets padding, {
    double elevation = 0,
  }) => ElevatedButton.styleFrom(
    backgroundColor: context.colors.primary,
    foregroundColor: Colors.white,
    padding: padding,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: elevation,
  );

  BoxDecoration _pillDecoration({bool bordered = false}) {
    final primary = context.colors.primary;

    return BoxDecoration(
      gradient: LinearGradient(
        colors: [primary.withOpacity(0.12), primary.withOpacity(0.06)],
      ),
      borderRadius: BorderRadius.circular(20),
      border: bordered ? Border.all(color: primary.withOpacity(0.3)) : null,
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Error',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showDeleteDialog(Customer customer) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => _DeleteCustomerDialog(
            customer: customer,
            onConfirm: () => _performDelete(dialogContext, customer),
          ),
    );
  }

  Future<void> _performDelete(
    BuildContext dialogContext,
    Customer customer,
  ) async {
    final customerId = customer.customerid;
    if (customerId == null) {
      Navigator.of(dialogContext).pop();
      _showErrorSnackbar('Cannot delete: Customer ID is missing');
      return;
    }

    await context.read<CustomerProvider>().deleteCustomer(context, customerId);
    if (mounted) Navigator.of(dialogContext).pop();
  }

  Widget _filterRow(String label, Widget field) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: _small(weight: FontWeight.w600)),
        ),
        Expanded(flex: 2, child: field),
      ],
    );
  }

  void _showFilterDialog(List<Customer> customers) {
    CustomerSearchColumn? tempColumn = selectedColumn;
    dynamic tempValue = selectedValue;

    CommonDialog.show(
      context,
      widget: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final column = tempColumn;
          final columnValues =
              column == null
                  ? <dynamic>[]
                  : _getColumnValues(customers, column);

          return Container(
            constraints: BoxConstraints(
              maxHeight: dialogContext.screenHeight * 0.5,
              minHeight: dialogContext.screenHeight * 0.3,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _filterRow(
                  'Filter By',
                  CommonDropdown<CustomerSearchColumn>(
                    value: column,
                    items: [
                      DropdownMenuItem<CustomerSearchColumn>(
                        value: null,
                        child: Text(
                          'Select Column',
                          style: _small(opacity: 0.6),
                        ),
                      ),
                      ...CustomerSearchColumn.values.map(
                        (col) => DropdownMenuItem<CustomerSearchColumn>(
                          value: col,
                          child: Text(col.label, style: _small()),
                        ),
                      ),
                    ],
                    onChanged:
                        (value) => setDialogState(() {
                          tempColumn = value;
                          tempValue = null;
                        }),
                  ),
                ),
                context.vS,
                _filterRow(
                  'Value',
                  column == null
                      ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: context.colors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          'Select a column first',
                          style: _small(opacity: 0.5),
                        ),
                      )
                      : CommonDropdown<dynamic>(
                        value: tempValue,
                        items: [
                          DropdownMenuItem<dynamic>(
                            value: null,
                            child: Text('All', style: _small(opacity: 0.6)),
                          ),
                          ...columnValues.map(
                            (value) => DropdownMenuItem<dynamic>(
                              value: value,
                              child: Text(
                                _getValueLabel(column, value),
                                style: _small(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged:
                            (value) =>
                                setDialogState(() => tempValue = value),
                      ),
                ),
                context.vL,
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        text: 'Clear',
                        onPressed: () {
                          _clearFilter();
                          NavigationService().goBack();
                        },
                      ),
                    ),
                    context.hS,
                    Expanded(
                      child: CommonButton(
                        text: 'Apply',
                        onPressed: () {
                          setState(() {
                            selectedColumn = tempColumn;
                            selectedValue = tempValue;
                          });
                          NavigationService().goBack();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.customers.isEmpty) {
          return _buildLoadingState();
        }
        if (provider.customers.isEmpty) return _buildEmptyState();

        final allCustomers = provider.customers;
        return _buildMainLayout(
          _getFilteredCustomers(allCustomers),
          allCustomers,
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading customers...',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait',
              style: _small(color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final primary = context.colors.primary;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: Opacity(
                opacity: 0.5,
                child: Image.asset(
                  'assets/images/bg_2.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  height: context.screenHeight * 0.60,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primary.withOpacity(0.1),
                            primary.withOpacity(0.05),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.people_rounded,
                        size: 80,
                        color: primary.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'No customers yet',
                      style: context.topology.textTheme.headlineSmall?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Create your first customer to get started',
                      textAlign: TextAlign.center,
                      style: context.topology.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _openCreate,
                      icon: const Icon(Icons.add_rounded, size: 24),
                      label: const Text('Create Customer'),
                      style: _primaryButtonStyle(
                        const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainLayout(
    List<Customer> filteredCustomers,
    List<Customer> allCustomers,
  ) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;
    final padding = isDesktop ? 32.0 : (width >= 768 ? 24.0 : 16.0);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(isDesktop),
                      const SizedBox(height: 24),
                      _buildSearchBar(allCustomers, isDesktop),
                      const SizedBox(height: 16),
                      _buildFilterChip(),
                      const SizedBox(height: 16),
                      _buildResultsCount(filteredCustomers.length),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              _buildCustomersList(filteredCustomers, padding),
            ],
          ),
        ),
      ),
      floatingActionButton:
          isDesktop
              ? null
              : FloatingActionButton.extended(
                onPressed: _openCreate,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Create'),
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
              ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    final primary = context.colors.primary;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.08), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.people_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customers',
                  style: context.topology.textTheme.titleLarge?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage your customer accounts',
                  style: _small(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _openCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Customer'),
              style: _primaryButtonStyle(
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar(List<Customer> allCustomers, bool isDesktop) {
    final primary = context.colors.primary;
    final focused = _isSearchFocused;

    return Focus(
      onFocusChange: (hasFocus) => setState(() => _isSearchFocused = hasFocus),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: focused ? primary : Colors.grey.shade200,
            width: focused ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  focused
                      ? primary.withOpacity(0.1)
                      : Colors.black.withOpacity(0.02),
              blurRadius: focused ? 12 : 8,
              offset: Offset(0, focused ? 4 : 2),
            ),
          ],
        ),
        child: CommonTextField(
          controller: _searchController,
          hintText:
              isDesktop
                  ? 'Search by name, account code, division, or agent...'
                  : 'Search customers...',
          style: context.topology.textTheme.bodyMedium?.copyWith(
            color: primary,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: primary.withOpacity(0.6),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(Icons.clear_rounded, color: primary),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                  tooltip: 'Clear search',
                ),
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color:
                      _hasActiveFilter
                          ? primary.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: primary.withOpacity(_hasActiveFilter ? 1 : 0.5),
                  ),
                  onPressed: () => _showFilterDialog(allCustomers),
                  tooltip: 'Filter customers',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip() {
    final column = selectedColumn;
    if (column == null || selectedValue == null) {
      return const SizedBox.shrink();
    }

    final primary = context.colors.primary;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _clearFilter,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: _pillDecoration(bordered: true),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_alt_rounded, size: 18, color: primary),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${column.label}: ${_getValueLabel(column, selectedValue)}',
                        style: _small(weight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCount(int count) {
    final primary = context.colors.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: _pillDecoration(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people_rounded, size: 18, color: primary),
                const SizedBox(width: 8),
                Text(
                  '$count ${count == 1 ? 'customer' : 'customers'}',
                  style: _small(weight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Consumer<CustomerProvider>(
            builder:
                (context, provider, _) => IconButton(
                  icon: Icon(Icons.refresh_rounded, color: primary),
                  onPressed:
                      provider.isLoading
                          ? null
                          : () => provider.fetchCustomers(context),
                  tooltip: 'Refresh',
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomersList(List<Customer> customers, double padding) {
    if (customers.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildNoResultsState(),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 100),
      sliver: SliverToBoxAdapter(child: _buildCustomersTable(customers)),
    );
  }

  Widget _buildCustomersTable(List<Customer> customers) {
    return RefreshIndicator(
      onRefresh:
          () => context.read<CustomerProvider>().fetchCustomers(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: LayoutBuilder(
          builder:
              (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth - 16,
                  ),
                  child: DataTable(
                    showCheckboxColumn: false,
                    columnSpacing: 20,
                    dataRowMinHeight: 60,
                    dataRowMaxHeight: 60,
                    columns: _buildTableColumns(),
                    rows: [
                      for (final (index, customer) in customers.indexed)
                        _buildTableRow(customer, index.isEven),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return ['Customer', 'Division', 'Agent', 'Status', 'Actions']
        .map(
          (label) => DataColumn(
            label: Expanded(
              child: Text(
                label,
                style: context.topology.textTheme.titleSmall?.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  DataRow _buildTableRow(Customer customer, bool isEven) {
    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
        (_) => isEven ? context.colors.primary.withOpacity(0.05) : null,
      ),
      onSelectChanged:
          (_) => NavigationService().navigateTo(
            NavigationRoutes.customerDetails,
            arguments: customer,
          ),
      cells: [
        DataCell(_buildNameCell(customer)),
        DataCell(Text(customer.divisionname ?? '-', style: _small())),
        DataCell(Text(customer.agentName ?? '-', style: _small())),
        DataCell(_buildStatusBadge(customer.archived ?? false)),
        DataCell(_buildActions(customer)),
      ],
    );
  }

  Widget _buildNameCell(Customer customer) {
    final accountCode = customer.accountCode;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CustomerAvatar(customer: customer),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.customername ?? 'Unknown',
              style: _small(weight: FontWeight.w600),
            ),
            if (accountCode != null) ...[
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '# $accountCode',
                  style: _small(weight: FontWeight.w600, size: 10),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isArchived) {
    final accent = isArchived ? Colors.grey : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withOpacity(isArchived ? 0.15 : 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isArchived ? Colors.grey.shade500 : Colors.green.shade600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isArchived ? 'Archived' : 'Active',
            style: _small(
              color: accent.shade700,
              size: 11,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(Customer customer) {
    const constraints = BoxConstraints(minWidth: 36, minHeight: 36);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.edit_rounded,
            color: context.colors.primary,
            size: 18,
          ),
          onPressed: () => _editCustomer(customer),
          tooltip: 'Edit Customer',
          padding: const EdgeInsets.all(8),
          constraints: constraints,
        ),
        const SizedBox(width: 4),
        Consumer<CustomerProvider>(
          builder:
              (context, provider, _) => IconButton(
                icon: const Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                  size: 18,
                ),
                onPressed:
                    provider.isLoading
                        ? null
                        : () => _showDeleteDialog(customer),
                tooltip: 'Delete Customer',
                padding: const EdgeInsets.all(8),
                constraints: constraints,
              ),
        ),
      ],
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade100, Colors.grey.shade50],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'No customers found',
              style: context.topology.textTheme.titleLarge?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search or filter criteria',
              textAlign: TextAlign.center,
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                _clearFilter();
              },
              icon: const Icon(Icons.clear_all_rounded),
              label: const Text('Clear Filters'),
              style: _primaryButtonStyle(
                const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerAvatar extends StatelessWidget {
  final Customer customer;

  const _CustomerAvatar({required this.customer});

  @override
  Widget build(BuildContext context) {
    final name = customer.customername;
    final initial =
        name != null && name.isNotEmpty ? name[0].toUpperCase() : 'C';
    final logo = customer.logo;

    final fallback = Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );

    if (logo == null || logo.isEmpty) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        logo,
        width: 34,
        height: 34,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}

class _DeleteCustomerDialog extends StatelessWidget {
  final Customer customer;
  final VoidCallback onConfirm;

  const _DeleteCustomerDialog({
    required this.customer,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final accountCode = customer.accountCode;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 16,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade50, Colors.orange.shade100],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.orange.shade700,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Delete Customer?',
              style: context.topology.textTheme.titleLarge?.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to delete this customer? This action cannot be undone.',
              style: context.topology.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade50, Colors.white],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  _CustomerAvatar(customer: customer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.customername ?? 'Unknown',
                          style: context.topology.textTheme.titleSmall
                              ?.copyWith(
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (accountCode != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Code: $accountCode',
                              style: context.topology.textTheme.bodySmall
                                  ?.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This action is permanent and cannot be reversed',
                      style: context.topology.textTheme.bodySmall?.copyWith(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Consumer<CustomerProvider>(
                    builder:
                        (context, provider, _) => ElevatedButton(
                          onPressed: provider.isLoading ? null : onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child:
                              provider.isLoading
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete_rounded, size: 18),
                                      SizedBox(width: 6),
                                      Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
