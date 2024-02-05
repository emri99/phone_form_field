import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'localized_country.dart';

@Deprecated('Use [CountryButton] instead')
typedef CountryChip = CountryButton;

class CountryButton extends StatelessWidget {
  final Function()? onTap;
  final IsoCode isoCode;
  final bool showFlag;
  final bool showDialCode;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final double flagSize;
  final TextDirection? textDirection;
  final bool showIsoCode;
  final bool enabled;

  const CountryButton({
    super.key,
    required this.isoCode,
    required this.onTap,
    this.textStyle,
    this.showFlag = true,
    this.showDialCode = true,
    this.padding = const EdgeInsets.fromLTRB(12, 16, 4, 16),
    this.flagSize = 20,
    this.textDirection,
    this.showIsoCode = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = this.textStyle ??
        Theme.of(context).textTheme.labelMedium ??
        const TextStyle();
    final country = LocalizedCountry.fromContext(context, isoCode);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (showIsoCode) ...[
              Text(
                country.isoCode.name,
                style: textStyle.copyWith(
                  color: enabled ? null : Theme.of(context).disabledColor,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (showFlag) ...[
              CircleFlag(
                country.isoCode.name,
                size: flagSize,
              ),
              const SizedBox(width: 8),
            ],
            if (showDialCode) ...[
              Text(
                country.formattedCountryDialingCode,
                style: textStyle.copyWith(
                  color: enabled ? null : Theme.of(context).disabledColor,
                ),
                textDirection: textDirection,
              ),
            ],
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
