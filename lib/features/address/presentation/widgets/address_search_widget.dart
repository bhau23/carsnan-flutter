import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/location_service.dart';
import '../cubit/address_cubit.dart';
import '../cubit/address_state.dart';

class AddressSearchWidget extends StatefulWidget {
  final Function(LocationResult) onLocationSelected;
  final VoidCallback onCurrentLocationTap;

  const AddressSearchWidget({
    super.key,
    required this.onLocationSelected,
    required this.onCurrentLocationTap,
  });

  @override
  State<AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<AddressSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Search options row
        Row(
          children: [
            // Search field
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search for area, street name...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: theme.colorScheme.primary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              context.read<AddressCubit>().clearState();
                              setState(() {
                                _showSuggestions = false;
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.mediumPadding,
                      vertical: AppSizes.mediumPadding,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _showSuggestions = value.isNotEmpty;
                    });
                    
                    // Cancel previous timer
                    _debounceTimer?.cancel();
                    
                    if (value.trim().isNotEmpty) {
                      // Set new timer for debounced search
                      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                        if (mounted && _searchController.text == value && value.trim().isNotEmpty) {
                          context.read<AddressCubit>().searchAddresses(value);
                        }
                      });
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(width: AppSizes.smallPadding),
            
            // Current location button
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: IconButton(
                onPressed: widget.onCurrentLocationTap,
                icon: Icon(
                  Icons.my_location,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'Use current location',
              ),
            ),
          ],
        ),
        
        // Search suggestions
        if (_showSuggestions) _buildSearchSuggestions(context, theme),
      ],
    );
  }

  Widget _buildSearchSuggestions(BuildContext context, ThemeData theme) {
    return BlocBuilder<AddressCubit, AddressState>(
      builder: (context, state) {
        if (state is AddressLoading) {
          return Container(
            margin: const EdgeInsets.only(top: AppSizes.smallPadding),
            padding: const EdgeInsets.all(AppSizes.mediumPadding),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Searching...'),
              ],
            ),
          );
        }

        if (state is SearchResults) {
          if (state.results.isEmpty) {
            return Container(
              margin: const EdgeInsets.only(top: AppSizes.smallPadding),
              padding: const EdgeInsets.all(AppSizes.mediumPadding),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search_off,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'No results found for "${state.query}"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            margin: const EdgeInsets.only(top: AppSizes.smallPadding),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.mediumRadius),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: state.results.asMap().entries.map((entry) {
                final index = entry.key;
                final result = entry.value;
                final isLast = index == state.results.length - 1;
                
                return InkWell(
                  onTap: () {
                    widget.onLocationSelected(result);
                    _searchController.text = result.address;
                    _focusNode.unfocus();
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.mediumPadding),
                    decoration: BoxDecoration(
                      border: isLast ? null : Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            result.address,
                            style: theme.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
