import 'package:example/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:phone_form_field/phone_form_field.dart';

void main() {
  runApp(MyApp());
}

/// putting the widget at the top so it's easily findable in pub.dev example

Widget getPhoneField({
  required PhoneNumber initialValue,
  required SelectorConfig selectorConfig,
  required bool withLabel,
  required bool outlineBorder,
  required bool mobileOnly,
  required bool autovalidate,
  required Function(PhoneNumber?) onChanged,
  required Function(PhoneNumber?) onSaved,
}) {
  return PhoneFormField(
    lightParser: false,
    initialValue: initialValue,
    autofocus: true,
    selectorConfig: selectorConfig,
    decoration: InputDecoration(
      labelText: withLabel ? 'Phone' : null,
      border: outlineBorder ? OutlineInputBorder() : UnderlineInputBorder(),
    ),
    onChanged: onChanged,
    onSaved: onSaved,
    enabled: true,
    showFlagInInput: true,
    phoneNumberType: mobileOnly ? PhoneNumberType.mobile : null,
    autovalidateMode: autovalidate
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        ...GlobalMaterialLocalizations.delegates,
        PhoneFieldLocalization.delegate
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('de', ''),
        const Locale('fr', ''),
        const Locale('it', ''),
        const Locale('ru', ''),
        // ...
      ],
      title: 'Phone field demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      home: PhoneFormFieldScreen(),
    );
  }
}

class PhoneFormFieldScreen extends StatefulWidget {
  @override
  _PhoneFormFieldScreenState createState() => _PhoneFormFieldScreenState();
}

class _PhoneFormFieldScreenState extends State<PhoneFormFieldScreen> {
  PhoneNumber phoneNumber = PhoneParser().parseWithIsoCode('US', '');
  bool outlineBorder = true;
  bool withLabel = true;
  bool autovalidate = true;
  bool mobileOnly = false;
  SelectorConfig selectorConfig = SelectorConfigCoverSheet();

  _getSubmitState() {
    if (mobileOnly)
      return phoneNumber.validate(PhoneNumberType.mobile) ? () {} : null;
    return phoneNumber.validate(null) ? () {} : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Phone_form_field'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SwitchEl(
                      value: outlineBorder,
                      onChanged: (v) => setState(() => outlineBorder = v),
                      title: 'Outlined border',
                    ),
                    SwitchEl(
                      value: autovalidate,
                      onChanged: (v) => setState(() => autovalidate = v),
                      title: 'Autovalidate',
                    ),
                    SwitchEl(
                      value: withLabel,
                      onChanged: (v) => setState(() => withLabel = v),
                      title: 'Label',
                    ),
                    SwitchEl(
                      value: mobileOnly,
                      onChanged: (v) => setState(() => mobileOnly = v),
                      title: 'Mobile phone number only',
                    ),
                    Text('country selector: '),
                    SingleChildScrollView(
                      child: Row(
                        children: [
                          Radio(
                            value: SelectorConfigCoverSheet(),
                            groupValue: selectorConfig,
                            onChanged: (SelectorConfig? value) {
                              setState(() => selectorConfig =
                                  value ?? SelectorConfigCoverSheet());
                            },
                          ),
                          Text('cover sheet'),
                          Radio(
                            value: SelectorConfigBottomSheet(null),
                            groupValue: selectorConfig,
                            onChanged: (SelectorConfig? value) {
                              setState(() => selectorConfig =
                                  value ?? SelectorConfigCoverSheet());
                            },
                          ),
                          Text('bottom sheet'),
                          Radio(
                            value: SelectorConfigDialog(),
                            groupValue: selectorConfig,
                            onChanged: (SelectorConfig? value) {
                              setState(() => selectorConfig =
                                  value ?? SelectorConfigCoverSheet());
                            },
                          ),
                          Text('dialog'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    getPhoneField(
                      initialValue: phoneNumber,
                      selectorConfig: selectorConfig,
                      withLabel: withLabel,
                      outlineBorder: outlineBorder,
                      mobileOnly: mobileOnly,
                      autovalidate: autovalidate,
                      onChanged: (p) => setState(() => phoneNumber = p!),
                      onSaved: (p) => setState(() => phoneNumber = p!),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: _getSubmitState(),
                      child: Text('next'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(phoneNumber.toString()),
                    Text(
                        'is valid mobile number ${phoneNumber.validate(PhoneNumberType.mobile)}'),
                    Text(
                        'is valid fixed line number ${phoneNumber.validate(PhoneNumberType.fixedLine)}'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialCodeChipScreen extends StatefulWidget {
  @override
  _DialCodeChipScreenState createState() => _DialCodeChipScreenState();
}

class _DialCodeChipScreenState extends State<DialCodeChipScreen> {
  bool showDialCode = true;
  bool showFlag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Phone_form_field'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchEl(
              value: showDialCode,
              onChanged: (v) => setState(() => showDialCode = v),
              title: 'show dial code'),
          SwitchEl(
              value: showFlag,
              onChanged: (v) => setState(() => showFlag = v),
              title: 'show flag'),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              FlagDialCodeChip(
                country: Country('US'),
                showDialCode: showDialCode,
                showFlag: showFlag,
              ),
              SizedBox(
                width: 20,
              ),
              FlagDialCodeChip(
                country: Country('FR'),
                showDialCode: showDialCode,
                showFlag: showFlag,
              ),
              SizedBox(
                width: 20,
              ),
              FlagDialCodeChip(
                country: Country('BR'),
                showDialCode: showDialCode,
                showFlag: showFlag,
              ),
              SizedBox(
                width: 20,
              ),
              FlagDialCodeChip(
                country: Country('ES'),
                showDialCode: showDialCode,
                showFlag: showFlag,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CountrySelectorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Phone_form_field'),
      ),
      body: Container(
        child: CountrySelector(onCountrySelected: (c) {}),
      ),
    );
  }
}

class SwitchEl extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const SwitchEl({
    required this.value,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
        ),
        Text(title),
      ],
    );
  }
}
