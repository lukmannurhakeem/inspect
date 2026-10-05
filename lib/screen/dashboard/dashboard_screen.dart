import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/storage/local_storage.dart';
import 'package:inspect/storage/local_storage_constant.dart';
import 'package:inspect/widget/common_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  String _firstName = '';
  String _lastName = '';
  String _email = '';

  String? _selectedCustomerId;
  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? _statistics;
  List<dynamic>? _items;
  bool _isDashboardLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _loadUserData();
    _animationController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initializeData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    _firstName = LocalStorage.getString(LocalStorageConstant.userFirstName);
    _lastName = LocalStorage.getString(LocalStorageConstant.userLastName);
    _email = LocalStorage.getString(LocalStorageConstant.userEmail);
  }

  Future<void> _initializeData() async {
    final customerProvider = context.read<CustomerProvider>();
    final siteProvider = context.read<SiteProvider>();

    await customerProvider.fetchCustomers(context);
    if (!mounted) return;

    final customers = customerProvider.customers;
    if (customers.isEmpty) return;

    final currentId = siteProvider.selectedCustomerId;
    final selected = customers.firstWhere(
          (c) => c.customerid == currentId,
      orElse: () => customers.first,
    );

    final customerId = selected.customerid;
    if (customerId == null) return;

    if (currentId != customerId) {
      siteProvider.setSelectedCustomer(
        customerId,
        name: selected.customername,
      );
    }

    await _loadDashboardData(customerId);
  }

  Future<void> _loadDashboardData(String customerId) async {
    if (_selectedCustomerId == customerId && _dashboardData != null) return;

    setState(() {
      _isDashboardLoading = true;
      _selectedCustomerId = customerId;
    });

    try {
      final repository = context.read<CustomerProvider>().customerRepository;

      final dashboard = await repository.getDashboardCustomer(customerId);
      final statistics = await repository.getDashboardStatistic(customerId);
      final items = await repository.getDashboardItems(customerId);

      if (!mounted) return;

      setState(() {
        _dashboardData = dashboard['data'];
        _statistics = statistics['data'];
        _items = items['data'] as List<dynamic>?;
      });
      _animationController
        ..reset()
        ..forward();
    } catch (e) {
      if (mounted) {
        CommonSnackbar.showError(
          context,
          'Failed to load dashboard data: $e',
        );
      }
    } finally {
      if (mounted) setState(() => _isDashboardLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final layout = _Layout.of(MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: layout.horizontalPadding,
            vertical: layout.verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(layout),
              const SizedBox(height: 16),
              _buildBody(layout),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(_Layout layout) {
    if (_dashboardData == null) {
      return _isDashboardLoading
          ? const _LoadingState()
          : const _EmptyState();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CustomerInfoCard(customer: _dashboardData?['customer']),
          const SizedBox(height: 24),
          _buildStatistics(layout),
          const SizedBox(height: 24),
          _buildDataCards(layout),
        ],
      ),
    );
  }

  Widget _buildHeader(_Layout layout) {
    return Container(
      padding: EdgeInsets.all(layout.isDesktop ? 20 : 16),
      decoration: _cardDecoration(bordered: false),
      child:
      layout.isDesktop
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildUserInfo(),
          const SizedBox(width: 24),
          SizedBox(width: 280, child: _buildCustomerDropdown()),
        ],
      )
          : Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _buildUserInfo(),
          ),
          const SizedBox(height: 16),
          _buildCustomerDropdown(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primary, primary.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            _firstName.isNotEmpty ? _firstName[0].toUpperCase() : 'U',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_firstName $_lastName'.trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDropdown() {
    return Consumer2<CustomerProvider, SiteProvider>(
      builder: (context, customerProvider, siteProvider, _) {
        final customers = customerProvider.customers;

        if (customerProvider.isFetching && customers.isEmpty) {
          return const _DropdownLoading();
        }

        final selectedId = siteProvider.selectedCustomerId;
        final hasSelected = customers.any((c) => c.customerid == selectedId);
        final primary = context.colors.primary;

        return DropdownButtonFormField<String>(
          value: hasSelected ? selectedId : null,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: 'Select Customer',
            prefixIcon: Icon(Icons.business_rounded, color: primary),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: _inputBorder(Colors.grey.shade300),
            enabledBorder: _inputBorder(Colors.grey.shade300),
            focusedBorder: _inputBorder(primary, width: 2),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items:
          customers
              .map(
                (customer) => DropdownMenuItem<String>(
              value: customer.customerid,
              child: Text(
                customer.customername ?? '-',
                overflow: TextOverflow.ellipsis,
                style: context.topology.textTheme.bodyMedium?.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            final name =
                customers
                    .firstWhere((c) => c.customerid == value)
                    .customername;
            siteProvider.setSelectedCustomer(value, name: name);
            _loadDashboardData(value);
          },
        );
      },
    );
  }

  Widget _buildStatistics(_Layout layout) {
    String value(String key) => '${_statistics?[key] ?? 0}';

    final stats = [
      _StatData(
        title: 'Total Sites',
        value: value('totalSites'),
        subtitle: 'Active: ${value('activeSites')}',
        icon: Icons.location_city_rounded,
        color: Colors.blue,
      ),
      _StatData(
        title: 'Total Items',
        value: value('totalItems'),
        subtitle: 'Active: ${value('activeItems')}',
        icon: Icons.inventory_2_rounded,
        color: Colors.green,
      ),
      _StatData(
        title: 'Total Reports',
        value: value('totalReports'),
        subtitle: 'Pending: ${value('pendingReports')}',
        icon: Icons.description_rounded,
        color: Colors.orange,
      ),
      _StatData(
        title: 'Total Jobs',
        value: value('totalJobs'),
        subtitle: 'Active: ${value('activeJobs')}',
        icon: Icons.work_rounded,
        color: Colors.purple,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layout.statColumns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: layout.statAspectRatio,
      ),
      itemCount: stats.length,
      itemBuilder: (_, index) => _StatCard(stat: stats[index]),
    );
  }

  Widget _buildDataCards(_Layout layout) {
    final cards = <Widget>[
      _DataCard(
        title: 'Sites',
        icon: Icons.location_city_rounded,
        color: Colors.blue,
        emptyMessage: 'No sites found',
        items: _asList(_dashboardData?['sites']),
        itemBuilder: (site) => _SiteItem(site: site),
      ),
      _DataCard(
        title: 'Items',
        icon: Icons.inventory_2_rounded,
        color: Colors.green,
        emptyMessage: 'No items found',
        items: _asList(_items),
        itemBuilder: (item) => _ItemItem(item: item),
      ),
      _DataCard(
        title: 'Recent Reports',
        icon: Icons.description_rounded,
        color: Colors.orange,
        emptyMessage: 'No reports found',
        items: _asList(_dashboardData?['reports']),
        itemBuilder: (report) => _ReportItem(report: report),
      ),
    ];

    if (layout.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            Expanded(child: cards[i]),
          ],
        ],
      );
    }

    return Column(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(height: 16),
          cards[i],
        ],
      ],
    );
  }
}

class _Layout {
  const _Layout({required this.isDesktop, required this.isTablet});

  factory _Layout.of(double width) =>
      _Layout(isDesktop: width >= 1024, isTablet: width >= 768);

  final bool isDesktop;
  final bool isTablet;

  double get horizontalPadding => isDesktop ? 32 : (isTablet ? 24 : 16);
  double get verticalPadding => isDesktop ? 24 : 16;
  int get statColumns => isDesktop ? 4 : (isTablet ? 2 : 1);
  double get statAspectRatio => isDesktop ? 1.2 : (isTablet ? 1.5 : 2.5);
}

const _cardShadow = [
  BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
];

BoxDecoration _cardDecoration({double radius = 16, bool bordered = true}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: bordered ? Border.all(color: Colors.grey.shade200) : null,
    boxShadow: _cardShadow,
  );
}

OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: width),
  );
}

List<dynamic> _asList(dynamic value) => value is List ? value : const [];

String _text(dynamic value, [String fallback = '-']) {
  final text = value?.toString() ?? '';
  return text.isEmpty ? fallback : text;
}

DateTime? _parseDate(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());

String _formatDate(dynamic value) {
  final date = _parseDate(value);
  return date == null ? _text(value) : DateFormat('MMM dd, yyyy').format(date);
}

bool _isExpiringSoon(dynamic value) {
  final date = _parseDate(value);
  if (date == null) return false;
  final days = date.difference(DateTime.now()).inDays;
  return days >= 0 && days <= 30;
}

Color _statusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'available':
    case 'approved':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'draft':
      return Colors.blue;
    case 'unavailable':
    case 'rejected':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

class _StatData {
  const _StatData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading dashboard...',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final primary = context.colors.primary;
    final textTheme = context.topology.textTheme;

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height - kToolbarHeight,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/bg_3.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomLeft,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No customer found',
                    style: textTheme.titleMedium?.copyWith(color: primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a customer to view dashboard data',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(color: primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownLoading extends StatelessWidget {
  const _DropdownLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Loading...',
            style: context.topology.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerInfoCard extends StatelessWidget {
  const _CustomerInfoCard({this.customer});

  final Map<String, dynamic>? customer;

  @override
  Widget build(BuildContext context) {
    final data = customer;
    if (data == null) return const SizedBox.shrink();

    final primary = context.colors.primary;
    final logo = _text(data['logo'], '');
    final address = _text(data['address'], '');
    final fallbackIcon = Icon(Icons.business_rounded, size: 36, color: primary);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.05), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: _cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary.withOpacity(0.1), primary.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primary.withOpacity(0.2), width: 2),
            ),
            child:
            logo.isEmpty
                ? fallbackIcon
                : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                logo,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallbackIcon,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _text(data['customerName'], 'Unknown'),
                  style: context.topology.textTheme.titleLarge?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (address.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _IconText(
                      icon: Icons.location_on_rounded,
                      text: address,
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.stat});

  final _StatData stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stat.title,
                  style: context.topology.textTheme.titleSmall?.copyWith(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _IconBox(icon: stat.icon, color: stat.color, size: 24),
            ],
          ),
          const Spacer(),
          Text(
            stat.value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: stat.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.emptyMessage,
    required this.items,
    required this.itemBuilder,
  });

  static const _maxVisible = 5;

  final String title;
  final IconData icon;
  final Color color;
  final String emptyMessage;
  final List<dynamic> items;
  final Widget Function(Map<String, dynamic> item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final visible =
    items
        .take(_maxVisible)
        .map((e) => itemBuilder(Map<String, dynamic>.from(e as Map)))
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBox(icon: icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: context.topology.textTheme.titleMedium?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${items.length}',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (visible.isEmpty)
            _EmptyMessage(message: emptyMessage)
          else
            for (var i = 0; i < visible.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              visible[i],
            ],
        ],
      ),
    );
  }
}

class _SiteItem extends StatelessWidget {
  const _SiteItem({required this.site});

  final Map<String, dynamic> site;

  @override
  Widget build(BuildContext context) {
    final archived = site['archived'] == true;
    final address = _text(site['address'], '');

    return _ItemContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _ItemTitle(_text(site['siteName'], 'Unknown Site')),
              ),
              const SizedBox(width: 8),
              _StatusBadge(
                label: archived ? 'Archived' : 'Active',
                color: archived ? Colors.red : Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _IconText(
            icon: Icons.qr_code_rounded,
            text: _text(site['siteCode']),
            fontWeight: FontWeight.w500,
          ),
          if (address.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _IconText(icon: Icons.location_on_rounded, text: address),
            ),
        ],
      ),
    );
  }
}

class _ItemItem extends StatelessWidget {
  const _ItemItem({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final status = _text(item['status'], 'Unknown');

    return _ItemContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _ItemTitle(_text(item['itemNo'], 'Unknown Item'))),
              const SizedBox(width: 8),
              _StatusBadge(label: status, color: _statusColor(status)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _text(item['description'], 'No description'),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _IconText(
                icon: Icons.category_rounded,
                text: _text(item['categoryName']),
                fontSize: 11,
              ),
              _IconText(
                icon: Icons.numbers_rounded,
                text: 'SN: ${_text(item['serialNumber'])}',
                fontSize: 11,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportItem extends StatelessWidget {
  const _ReportItem({required this.report});

  final Map<String, dynamic> report;

  @override
  Widget build(BuildContext context) {
    final status = _text(report['status'], 'UNKNOWN');
    final expiryDate = report['expiryDate'];
    final isExpiring = _isExpiringSoon(expiryDate);

    return _ItemContainer(
      highlight: isExpiring,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _ItemTitle(
                  _text(report['reportTypeName'], 'Unknown Report'),
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 8),
              _StatusBadge(
                label: status.toUpperCase(),
                color: _statusColor(status),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _IconText(
            icon: Icons.inventory_2_rounded,
            text: _text(report['itemNo']),
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _IconText(
                  icon: Icons.person_rounded,
                  text: _text(report['inspectedBy']),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(report['reportDate']),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (expiryDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _ExpiryTag(
                label: 'Expires: ${_formatDate(expiryDate)}',
                isExpiring: isExpiring,
              ),
            ),
        ],
      ),
    );
  }
}

class _ExpiryTag extends StatelessWidget {
  const _ExpiryTag({required this.label, required this.isExpiring});

  final String label;
  final bool isExpiring;

  @override
  Widget build(BuildContext context) {
    final foreground =
    isExpiring ? Colors.orange.shade800 : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient:
        isExpiring
            ? LinearGradient(
          colors: [Colors.orange.shade50, Colors.orange.shade100],
        )
            : null,
        color: isExpiring ? null : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isExpiring ? Colors.orange.shade300 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpiring
                ? Icons.warning_amber_rounded
                : Icons.calendar_today_rounded,
            size: 14,
            color: foreground,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: foreground,
              fontWeight: isExpiring ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isExpiring) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.shade600,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'SOON',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ItemContainer extends StatelessWidget {
  const _ItemContainer({required this.child, this.highlight = false});

  final Widget child;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? Colors.orange.shade200 : Colors.grey.shade200,
          width: highlight ? 2 : 1,
        ),
        boxShadow:
        highlight
            ? [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      child: child,
    );
  }
}

class _ItemTitle extends StatelessWidget {
  const _ItemTitle(this.text, {this.maxLines = 1});

  final String text;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: context.topology.textTheme.titleSmall?.copyWith(
        color: context.colors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  const _IconText({
    required this.icon,
    required this.text,
    this.fontSize = 12,
    this.fontWeight,
  });

  final IconData icon;
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: fontSize + 2, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey.shade600,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: size, color: color),
    );
  }
}

class _EmptyMessage extends StatelessWidget {
  const _EmptyMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}