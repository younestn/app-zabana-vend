import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/features/shop/domain/models/seller_badge_model.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class VendorBadgeWidget extends StatelessWidget {
  final SellerBadgeModel? badge;
  final bool showPlaceholder;

  const VendorBadgeWidget({
    super.key,
    required this.badge,
    this.showPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    if (badge == null && !showPlaceholder) {
      return const SizedBox.shrink();
    }

    final Color accentColor = _resolveColor(context, badge?.color);
    final bool isManual = badge?.isManual ?? false;
    final String badgeName = _badgeName(context);
    final String badgeIcon = _badgeIcon();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: accentColor.withValues(alpha: 0.16)),
      ),
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated('your_current_badge', context) ?? '',
            style: robotoBold.copyWith(
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          if (badge == null)
            Text(
              getTranslated('badge_not_evaluated_yet', context) ?? '',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor,
              ),
            )
          else ...[
            Wrap(
              spacing: Dimensions.paddingSizeExtraSmall,
              runSpacing: Dimensions.paddingSizeExtraSmall,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: Dimensions.paddingSizeExtraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Wrap(
                    spacing: Dimensions.paddingSizeExtraSmall,
                    runSpacing: Dimensions.paddingSizeVeryTiny,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        badgeIcon,
                        style:
                            const TextStyle(fontSize: Dimensions.fontSizeLarge),
                      ),
                      Text(
                        badgeName,
                        style: robotoBold.copyWith(color: accentColor),
                      ),
                    ],
                  ),
                ),
                if (badge?.complianceScore != null)
                  _MetaChip(
                    label:
                        '${getTranslated('compliance_score', context) ?? ''}: ${badge!.complianceScore!.toStringAsFixed(0)}%',
                  ),
                if (badge?.level != null)
                  _MetaChip(
                    label:
                        '${getTranslated('badge_level', context) ?? ''}: ${badge!.level}',
                  ),
                _MetaChip(
                  label: isManual
                      ? (getTranslated('badge_assigned_by_admin', context) ??
                          '')
                      : (getTranslated('automatic_badge', context) ?? ''),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            Text(
              getTranslated('badge_based_on_performance', context) ?? '',
              style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _badgeName(BuildContext context) {
    final String localizedName = getTranslated(badge?.key, context) ?? '';
    if (localizedName.isNotEmpty && localizedName != badge?.key) {
      return localizedName;
    }

    final String rawName = badge?.name?.trim() ?? '';
    if (rawName.isNotEmpty) {
      return rawName;
    }

    return getTranslated('seller_badge', context) ?? '';
  }

  String _badgeIcon() {
    final Map<String, String> keyMap = <String, String>{
      'new_seller': '✨',
      'rising_seller': '🌱',
      'verified_seller': '✅',
      'trusted_seller': '🛡️',
      'elite_seller': '👑',
    };

    final Map<String, String> iconMap = <String, String>{
      'sparkles': '✨',
      'seedling': '🌱',
      'badge-check': '✅',
      'shield-check': '🛡️',
      'crown': '👑',
    };

    return keyMap[badge?.key] ?? iconMap[badge?.icon] ?? badge?.icon ?? '🏷️';
  }

  Color _resolveColor(BuildContext context, String? rawColor) {
    final Color fallback = Theme.of(context).primaryColor;
    if (rawColor == null || rawColor.trim().isEmpty) {
      return fallback;
    }

    final String hex = rawColor.replaceFirst('#', '').trim();
    if (hex.length != 6 && hex.length != 8) {
      return fallback;
    }

    final String normalizedHex = hex.length == 6 ? 'FF$hex' : hex;
    final int? value = int.tryParse(normalizedHex, radix: 16);
    return value == null ? fallback : Color(value);
  }
}

class _MetaChip extends StatelessWidget {
  final String label;

  const _MetaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    if (label.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeSmall,
        vertical: Dimensions.paddingSizeVeryTiny,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      ),
      child: Text(
        label,
        style: robotoRegular.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}
