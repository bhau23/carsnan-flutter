import 'package:flutter/material.dart';
import '../../domain/entities/wash_type.dart';
import 'wash_type_info_dialog.dart';

class WashTypeSelector extends StatefulWidget {
  final WashType selectedWashType;
  final ValueChanged<WashType> onWashTypeChanged;

  const WashTypeSelector({
    super.key,
    required this.selectedWashType,
    required this.onWashTypeChanged,
  });

  @override
  State<WashTypeSelector> createState() => _WashTypeSelectorState();
}

class _WashTypeSelectorState extends State<WashTypeSelector>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _slideAnimation.value)),
          child: Opacity(
            opacity: _slideAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: theme.dividerColor.withAlpha(76)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildWashTypeOptions(theme)],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWashTypeOptions(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: WashType.values.map((washType) {
          return _buildWashTypeCard(washType, theme);
        }).toList(),
      ),
    );
  }

  Widget _buildWashTypeCard(WashType washType, ThemeData theme) {
    final isSelected = widget.selectedWashType == washType;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.dividerColor.withAlpha(76),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? theme.colorScheme.primary.withAlpha(25)
            : Colors.transparent,
      ),
      child: InkWell(
        onTap: () => widget.onWashTypeChanged(washType),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Radio button
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor,
                    width: 2,
                  ),
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),

              const SizedBox(width: 16),

              // Wash type info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      washType.displayName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getShortDescription(washType),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(125),
                      ),
                    ),
                  ],
                ),
              ),

              // See more button
              TextButton(
                onPressed: () => _showWashTypeInfo(washType),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: theme.colorScheme.primary,
                  backgroundColor: theme.colorScheme.primary.withAlpha(25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'See More',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getShortDescription(WashType washType) {
    switch (washType) {
      case WashType.waterless:
        return 'Eco-friendly cleaning without water';
      case WashType.rinseless:
        return 'Minimal water usage with special solutions';
      case WashType.bucket:
        return 'Traditional method with soap and water';
    }
  }

  void _showWashTypeInfo(WashType washType) {
    WashTypeInfoDialog.show(context, washType);
  }
}
