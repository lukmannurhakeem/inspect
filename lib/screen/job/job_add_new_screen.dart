import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/navigation/navigation_route.dart';
import 'package:inspect/navigation/navigation_service.dart';
import 'package:inspect/provider/customer_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:provider/provider.dart';

class JobAddNewScreen extends StatefulWidget {
  const JobAddNewScreen({super.key});

  @override
  State<JobAddNewScreen> createState() => _JobAddNewScreen();
}

class _JobAddNewScreen extends State<JobAddNewScreen> {
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((results) {
      if (mounted) {
        setState(() {
          _isOffline = results.every((r) => r == ConnectivityResult.none);
        });
      }
    });
    final customerProvider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );
    customerProvider.fetchCustomers(context);
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    if (mounted) {
      setState(() {
        _isOffline = results.every((r) => r == ConnectivityResult.none);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image at bottom right
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset(
            'assets/images/bg_2.png',
            fit: BoxFit.contain,
            alignment: Alignment.bottomRight,
            height: context.screenHeight * 0.70,
          ),
        ),

        // Foreground content
        Container(
          width: double.infinity,
          height: context.screenHeight - kToolbarHeight * 2,
          padding: context.paddingHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Offline banner ──────────────────────────────────────────
              if (_isOffline)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  color: Colors.orange.shade700,
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'You are offline. Showing cached data. Job will be saved locally and synced when connected.',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              context.vXxl,

              // Customer Dropdown
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Customer',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Consumer2<CustomerProvider, SiteProvider>(
                      builder: (context, customerProvider, siteProvider, _) {
                        final customers = customerProvider.customers;

                        return DropdownButtonFormField<String>(
                          value: siteProvider.selectedCustomerId,
                          decoration: InputDecoration(
                            hintText: 'Select Customer',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            hintStyle: context.topology.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey),
                          ),
                          items:
                              customers.map((customer) {
                                return DropdownMenuItem<String>(
                                  value: customer.customerid,
                                  child: Text(
                                    customer.customername ?? '-',
                                    style: context.topology.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.colors.primary,
                                        ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            final selectedCustomer = customers.firstWhere(
                              (c) => c.customerid == value,
                            );

                            siteProvider.setSelectedCustomer(
                              value,
                              name: selectedCustomer.customername,
                            );

                            if (value != null) {
                              siteProvider.fetchSiteByCustomerId(
                                context,
                                value,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Site Dropdown
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Site',
                      style: context.topology.textTheme.titleSmall?.copyWith(
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Consumer<SiteProvider>(
                      builder: (context, siteProvider, _) {
                        final sites = siteProvider.sitesCustomerList;
                        final isEnabled =
                            siteProvider.selectedCustomerId != null &&
                            sites.isNotEmpty;

                        return DropdownButtonFormField<String>(
                          value: siteProvider.selectedCustomerIdSite,
                          decoration: InputDecoration(
                            hintText:
                                siteProvider.selectedCustomerId == null
                                    ? 'Select Customer First'
                                    : (sites.isEmpty
                                        ? 'No Sites Available'
                                        : 'Select Site'),
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            hintStyle: context.topology.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey),
                          ),
                          items:
                              sites.map((site) {
                                return DropdownMenuItem<String>(
                                  value: site.siteid,
                                  child: Text(
                                    '${site.siteName ?? site.siteCode ?? '-'} (${site.siteCode ?? ''})',
                                    style: context.topology.textTheme.bodySmall
                                        ?.copyWith(
                                          color: context.colors.primary,
                                        ),
                                  ),
                                );
                              }).toList(),
                          onChanged:
                              isEnabled
                                  ? (value) {
                                    final selectedSite = sites.firstWhere(
                                      (s) => s.siteid == value,
                                    );

                                    siteProvider.setSelectedCustomerById(
                                      value,
                                      name:
                                          selectedSite.siteName ??
                                          selectedSite.siteCode,
                                    );
                                  }
                                  : null,
                        );
                      },
                    ),
                  ),
                ],
              ),

              context.vXxl,

              // Next Button
              Consumer<SiteProvider>(
                builder: (context, siteProvider, child) {
                  final canProceed =
                      siteProvider.selectedCustomerIdSite != null &&
                      siteProvider.selectedCustomerIdSite!.isNotEmpty;

                  return CommonButton(
                    onPressed:
                        canProceed
                            ? () {
                              NavigationService().navigateTo(
                                NavigationRoutes.jobAddNewDetailsScreen,
                                arguments: {
                                  // UUIDs → sent in API body
                                  'customerId':
                                      siteProvider.selectedCustomerId ?? '',
                                  'siteId':
                                      siteProvider.selectedCustomerIdSite ?? '',
                                  // Display names → used for jobID prefix & AppBar
                                  'customerName':
                                      siteProvider.selectedCustomerName ?? '',

                                  'siteName':
                                      siteProvider.selectedCustomerSiteName ??
                                      '',
                                },
                              );
                            }
                            : null,
                    text: 'Next',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
