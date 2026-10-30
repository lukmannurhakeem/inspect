import 'package:flutter/material.dart';
import 'package:inspect/core/extension/theme_extension.dart';
import 'package:inspect/provider/category_provider.dart';
import 'package:inspect/provider/job_item_create_provider.dart';
import 'package:inspect/provider/job_provider.dart';
import 'package:inspect/provider/site_provider.dart';
import 'package:inspect/screen/job/job_item_create/job_item_form_models.dart';
import 'package:inspect/screen/job/job_item_create/job_item_form_widgets.dart';
import 'package:inspect/widget/common_button.dart';
import 'package:provider/provider.dart';

export 'package:inspect/screen/job/job_item_create/category_selection_dialog.dart';
export 'package:inspect/screen/job/job_item_create/job_item_form_models.dart'
    show ItemNoCreationMode, BatchItemResult;

class JobItemCreateScreen extends StatelessWidget {
  const JobItemCreateScreen({
    super.key,
    required this.jobId,
    this.selectedCategory,
    this.preloadedFields = const [],
    this.isEditMode = false,
    this.existingItem,
  });

  final String jobId;
  final CategoryItem? selectedCategory;
  final List<Map<String, dynamic>> preloadedFields;
  final bool isEditMode;
  final Map<String, dynamic>? existingItem;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (ctx) => JobItemCreateProvider(
            jobId: jobId,
            categoryProvider: ctx.read<CategoryProvider>(),
            jobProvider: ctx.read<JobProvider>(),
            siteProvider: ctx.read<SiteProvider>(),
            selectedCategory: selectedCategory,
            preloadedFields: preloadedFields,
            isEditMode: isEditMode,
            existingItem: existingItem,
          ),
      child: const _JobItemCreateView(),
    );
  }
}

class _JobItemCreateView extends StatefulWidget {
  const _JobItemCreateView();

  @override
  State<_JobItemCreateView> createState() => _JobItemCreateViewState();
}

class _JobItemCreateViewState extends State<_JobItemCreateView> {
  bool _popped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<JobItemCreateProvider>().initialize(context);
    });
  }

  void _pop({bool saved = false}) {
    if (_popped || !mounted) return;
    _popped = true;
    Navigator.of(context).pop(saved);
  }

  Future<void> _save() async {
    final result = await context.read<JobItemCreateProvider>().save(context);
    if (!mounted) return;
    if (result.message != null) _showResult(result);
    if (result.shouldPop) _pop(saved: true);
  }

  void _showResult(SaveResult result) {
    final (IconData icon, Color color, int seconds) = switch (result.status) {
      SaveStatus.success => (Icons.check_circle_outline, Colors.green, 3),
      SaveStatus.offline => (Icons.save, Colors.blue, 4),
      SaveStatus.offlineFallback => (Icons.warning, Colors.orange, 4),
      SaveStatus.invalid || SaveStatus.failure => (
        Icons.error_outline,
        Colors.red,
        3,
      ),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(result.message!)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JobItemCreateProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              p.isEditMode ? Icons.edit : Icons.add_box,
              color: context.colors.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              p.isEditMode ? 'Edit Job Item' : 'Create Job Item',
              style: context.topology.textTheme.titleMedium?.copyWith(
                color: context.colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.primary),
        backgroundColor: context.colors.onPrimary,
        elevation: 0,
        leading: IconButton(
          onPressed: _pop,
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(child: _buildBody(context, p)),
    );
  }

  Widget _buildBody(BuildContext context, JobItemCreateProvider p) {
    if (p.isLoading) {
      return _LoadingView(
        p.isEditMode ? 'Updating job item...' : 'Saving job item...',
      );
    }
    if (p.isLoadingFields) return const _LoadingView('Loading fields...');
    return context.isTablet
        ? _TabletLayout(onSave: _save)
        : _MobileLayout(onSave: _save);
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          CircularProgressIndicator(color: context.colors.primary),
          Text(
            message,
            style: context.topology.textTheme.bodyMedium?.copyWith(
              color: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JobItemCreateProvider>();

    return SingleChildScrollView(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          context.vM,
          const JobItemFormHeader(),
          if (p.sections.isEmpty)
            const EmptyFields()
          else
            FormFieldSections(p.sections.entries),
          CommonButton(text: p.saveLabel, onPressed: onSave),
          context.vL,
        ],
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout({required this.onSave});

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<JobItemCreateProvider>();
    final sections = p.sections.entries.toList();
    final half = (sections.length / 2).ceil();

    return Padding(
      padding: context.paddingHorizontal,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const JobItemFormHeader(),
                        if (sections.isEmpty)
                          const EmptyFields()
                        else
                          FormFieldSections(sections.take(half)),
                      ],
                    ),
                  ),
                ),
                context.hXl,
                Expanded(
                  child: SingleChildScrollView(
                    child: FormFieldSections(sections.skip(half)),
                  ),
                ),
              ],
            ),
          ),
          context.vL,
          SizedBox(
            width: 200,
            child: CommonButton(text: p.saveLabel, onPressed: onSave),
          ),
          context.vM,
        ],
      ),
    );
  }
}
