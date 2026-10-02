
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/data/model/job_register_model/job_register_model.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/screen/job/job_item_details/item_cycles_screen.dart';
import 'package:inspect/screen/job/job_item_details/item_files_screen.dart';
import 'package:inspect/screen/job/job_item_details/item_overview_screen.dart';
import 'package:inspect/screen/job/job_item_details/item_reports_screen.dart';
import 'package:provider/provider.dart';

class JobItemDetailsScreen extends StatefulWidget {
  final Item? item;
  final Map<String, dynamic>? itemMap;

  final String jobId;

  const JobItemDetailsScreen({
    super.key,
    this.item,
    this.itemMap,
    required this.jobId,
  }) : assert(
         item != null || itemMap != null,
         'Either item or itemMap must be provided',
       );

  @override
  State<JobItemDetailsScreen> createState() => _JobItemDetailsScreenState();
}

class _JobItemDetailsScreenState extends State<JobItemDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  bool _isEditMode = false;

  final List<Tab> tabs = const [
    Tab(text: 'Overview'),
    Tab(text: 'Files'),
    Tab(text: 'Reports'),
    Tab(text: 'Cycles'),
  ];

  // ── Display fallbacks (used before / if provider has no currentItem) ───────

  String get _displayItemNo {
    if (widget.item?.itemNo != null) return widget.item!.itemNo!;
    final v = widget.itemMap?['itemNo'] ?? widget.itemMap?['item_no'] ?? '';
    return v.toString();
  }

  String get _displayLocation {
    if (widget.item?.detailedLocation != null) {
      return widget.item!.detailedLocation!;
    }
    final v =
        widget.itemMap?['detailedLocation'] ??
        widget.itemMap?['detailed_location'] ??
        widget.itemMap?['locationId'] ??
        '';
    return v.toString();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);

    // Disable edit toggle when not on Overview tab.
    _tabController.addListener(() {
      if (_isEditMode && _tabController.index != 0) {
        setState(() => _isEditMode = false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final provider = context.read<JobProvider>();

      if (widget.item != null) {
        provider.setCurrentItemDirect(widget.item!);
      } else if (widget.itemMap != null) {
        provider.setCurrentItemDirect(_itemFromMap(widget.itemMap!));
      }
    });

    debugPrint('JobItemDetailsScreen init — itemId: ${widget.item?.itemId}');
  }

  @override
  void dispose() {
    _tabController.dispose();
    context.read<JobProvider>().clearCurrentItem();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        backgroundColor: context.colors.onPrimary,
        elevation: 0,
      ),
      body: Consumer<JobProvider>(
        builder: (context, provider, child) {
          final providerItem = provider.currentItem;
          final itemNo = providerItem?.itemNo ?? _displayItemNo;
          final location = providerItem?.detailedLocation ?? _displayLocation;

          return Padding(
            padding: context.paddingHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (itemNo.isNotEmpty)
                  Text(
                    itemNo,
                    style: context.topology.textTheme.titleMedium?.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                if (location.isNotEmpty) ...[
                  context.vS,
                  Text(
                    location,
                    style: context.topology.textTheme.titleSmall?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ],

                context.vM,

                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    tabs: tabs,
                    labelColor: context.colors.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: context.colors.primary,
                    indicatorWeight: 3,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.zero,
                  ),
                ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ItemOverviewScreen(
                        item: widget.item,
                        itemMap: widget.itemMap,
                        jobId: widget.jobId,
                        isEditMode: _isEditMode,
                        onSaved: () => setState(() => _isEditMode = false),
                      ),

                      const ItemFilesScreen(),

                      ItemReportScreen(
                        item: widget.item ?? _itemFromMap(widget.itemMap!),
                      ),

                      const ItemCyclesScreen(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Map → Item conversion ──────────────────────────────────────────────────

  Item _itemFromMap(Map<String, dynamic> data) {
    String str(List<String> keys) {
      for (final k in keys) {
        final v = (data[k] ?? '').toString().trim();
        if (v.isNotEmpty) return v;
      }
      return '';
    }

    return Item(
      itemId: str(['itemId', 'itemID', 'item_id']),
      itemNo: str(['itemNo', 'item_no']),
      description: str(['description']),
      categoryId: str(['categoryId', 'categoryID', 'category_id']),
      locationId: str(['locationId', 'locationID', 'location_id']),
      detailedLocation: str([
        'detailedLocation',
        'detailed_location',
        'ItemLocation',
      ]),
      status: str(['status']),
      rfidNo: str(['rfidNo', 'RFIDNo', 'rfid_no']),
      manufacturer: str(['manufacturer']),
      swl: str(['swl']),
    );
  }
}
