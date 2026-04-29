import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_snackbar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/textfeild/custom_text_feild_widget.dart';
import 'package:sixvalley_vendor_app/features/shipping/controllers/shipping_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class NoestSettingsCardWidget extends StatefulWidget {
  const NoestSettingsCardWidget({super.key});

  @override
  State<NoestSettingsCardWidget> createState() =>
      _NoestSettingsCardWidgetState();
}

class _NoestSettingsCardWidgetState extends State<NoestSettingsCardWidget> {
  final TextEditingController _guidController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();

  bool _status = false;
  bool _isInitialDataLoaded = false;
  bool _isExpanded = false;

  @override
  void dispose() {
    _guidController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  void _setInitialData(ShippingController shipProv) {
    final noest = shipProv.noestSettingsModel;
    if (noest != null && !_isInitialDataLoaded) {
      _guidController.text = noest.noestGuid ?? '';
      _tokenController.text = noest.apiToken ?? '';
      _status = (noest.status ?? 0) == 1;
      _isInitialDataLoaded = true;
    }
  }

  void _showMessage(bool isSuccess, String message) {
    showCustomSnackBarWidget(
      message.isNotEmpty
          ? message
          : isSuccess
              ? (getTranslated('updated_successfully', context) ?? 'Success')
              : 'Something went wrong',
      context,
      isError: !isSuccess,
      sanckBarType: isSuccess ? SnackBarType.success : SnackBarType.warning,
    );
  }

  Widget _buildMethodChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeExtraSmall,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: .20),
        ),
      ),
      child: Text(
        text,
        style: robotoRegular.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: Dimensions.fontSizeSmall,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShippingController>(
      builder: (context, shipProv, child) {
        _setInitialData(shipProv);

        final noest = shipProv.noestSettingsModel;
        final isConnected = (noest?.isConnected ?? 0) == 1;
        final connectedSince = noest?.connectedSince;
        final isBusy =
            shipProv.isNoestLoading || shipProv.isNoestConnectionLoading;

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimensions.paddingSizeMedium,
            0,
            Dimensions.paddingSizeMedium,
            Dimensions.paddingSizeSmall,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              boxShadow: ThemeShadow.getShadow(context),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: false,
                onExpansionChanged: (value) {
                  setState(() {
                    _isExpanded = value;
                  });
                },
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeExtraSmall,
                ),
                childrenPadding: const EdgeInsets.fromLTRB(
                  Dimensions.paddingSizeDefault,
                  0,
                  Dimensions.paddingSizeDefault,
                  Dimensions.paddingSizeDefault,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        getTranslated('noest_shipping_settings', context) ??
                            'NOEST Shipping Settings',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isConnected
                            ? Theme.of(context)
                                .primaryColor
                                .withValues(alpha: .12)
                            : Theme.of(context)
                                .colorScheme
                                .error
                                .withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isConnected
                            ? (getTranslated('connected', context) ??
                                'Connected')
                            : (getTranslated('not_connected', context) ??
                                'Not Connected'),
                        style: robotoRegular.copyWith(
                          fontSize: 11,
                          color: isConnected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: !_isExpanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _guidController.text.isNotEmpty
                              ? _guidController.text
                              : (getTranslated('test_connection', context) ??
                                  'Tap to configure NOEST'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      )
                    : null,
                children: [
                  if (connectedSince != null &&
                      connectedSince.toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: Dimensions.paddingSizeSmall),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${getTranslated('connected_since', context) ?? 'Connected since'}: $connectedSince',
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                      ),
                    ),
                  Text(
                    getTranslated(
                          'use_your_vendor_guid_and_api_token_to_connect_your_noest_account_from_the_app',
                          context,
                        ) ??
                        'Use your vendor GUID and API Token to connect your NOEST account from the app.',
                    style: robotoRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeSmall,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(
                    getTranslated('noest_guid', context) ?? 'NOEST GUID',
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  CustomTextFieldWidget(
                    controller: _guidController,
                    hintText: getTranslated('enter_noest_guid', context) ??
                        'Enter NOEST GUID',
                    border: true,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(
                    getTranslated('noest_api_token', context) ??
                        'NOEST API Token',
                    style: titilliumRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  CustomTextFieldWidget(
                    controller: _tokenController,
                    hintText: getTranslated('enter_noest_api_token', context) ??
                        'Enter NOEST API Token',
                    border: true,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          getTranslated('status', context) ?? 'Status',
                          style: robotoRegular.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      FlutterSwitch(
                        value: _status,
                        activeColor: Theme.of(context).primaryColor,
                        width: 48,
                        height: 25,
                        toggleSize: 20,
                        padding: 2,
                        onToggle: (value) {
                          setState(() {
                            _status = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  Text(
                    getTranslated('available_delivery_methods', context) ??
                        'Available delivery methods',
                    style: robotoMedium.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Wrap(
                    spacing: Dimensions.paddingSizeSmall,
                    runSpacing: Dimensions.paddingSizeSmall,
                    children: shipProv.noestDeliveryMethods.map((method) {
                      final translatedName = getTranslated(
                              method.title ?? method.name ?? '', context) ??
                          (method.title ?? method.name ?? '')
                              .replaceAll('_', ' ');
                      return _buildMethodChip(context, translatedName);
                    }).toList(),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isBusy
                          ? null
                          : () {
                              final noestGuid = _guidController.text.trim();
                              final apiToken = _tokenController.text.trim();

                              if (noestGuid.isEmpty) {
                                _showMessage(
                                  false,
                                  getTranslated(
                                          'please_enter_noest_guid', context) ??
                                      'Please enter NOEST GUID',
                                );
                                return;
                              }

                              if (apiToken.isEmpty) {
                                _showMessage(
                                  false,
                                  getTranslated('please_enter_noest_api_token',
                                          context) ??
                                      'Please enter NOEST API Token',
                                );
                                return;
                              }

                              shipProv.testNoestConnection(noestGuid, apiToken,
                                  (bool isSuccess, String message) {
                                _showMessage(
                                  isSuccess,
                                  message.isNotEmpty
                                      ? message
                                      : (getTranslated(
                                              'noest_connection_test_completed',
                                              context) ??
                                          'NOEST connection test completed'),
                                );
                              });
                            },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: BorderSide(color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeExtraSmall),
                        ),
                      ),
                      child: shipProv.isNoestConnectionLoading
                          ? SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : Text(
                              getTranslated('test_connection', context) ??
                                  'Test Connection',
                              style: robotoMedium.copyWith(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isBusy
                          ? null
                          : () {
                              final noestGuid = _guidController.text.trim();
                              final apiToken = _tokenController.text.trim();

                              if (noestGuid.isEmpty) {
                                _showMessage(
                                  false,
                                  getTranslated(
                                          'please_enter_noest_guid', context) ??
                                      'Please enter NOEST GUID',
                                );
                                return;
                              }

                              if (apiToken.isEmpty) {
                                _showMessage(
                                  false,
                                  getTranslated('please_enter_noest_api_token',
                                          context) ??
                                      'Please enter NOEST API Token',
                                );
                                return;
                              }

                              shipProv.saveNoestSettings(
                                noestGuid,
                                apiToken,
                                _status ? 1 : 0,
                                (bool isSuccess, String message) {
                                  _showMessage(
                                    isSuccess,
                                    message.isNotEmpty
                                        ? message
                                        : (getTranslated(
                                                'noest_settings_saved_successfully',
                                                context) ??
                                            'NOEST settings saved successfully'),
                                  );
                                },
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              Dimensions.paddingSizeExtraSmall),
                        ),
                        elevation: 0,
                      ),
                      child: shipProv.isNoestLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              getTranslated('save', context) ?? 'Save',
                              style: robotoMedium.copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
