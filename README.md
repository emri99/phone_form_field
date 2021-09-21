# phone_form_field

Flutter phone input integrated with flutter internationalization

## Features

- Totally cross platform, this is a dart only package / dependencies
- Internationalization
- Phone formatting localized by region
- Phone number validation (built-in validators included for main use cases) 
- Support autofill and copy paste
- Extends Flutter's FormField
- Uses dart phone_numbers_parser for parsing


## Demo

Demo available at https://cedvdb.github.io/phone_form_field/

![demo img](https://raw.githubusercontent.com/cedvdb/phone_number_input/main/demo_image.png)

## Usage

```dart

// works without any param
PhoneFormField();

// all params
PhoneFormField(
  controller: null,     // controller & initialValue value
  initialValue: null,   // can't be supplied simultaneously
  shouldFormat: true    // default 
  autofocus: false,     // default
  autofillHints: [AutofillHints.telephoneNumber], // default to null
  defaultCountry: 'US', // default 
  decoration: InputDecoration(
    labelText: 'Phone',          // default to null
    border: OutlineInputBorder() // default to UnderlineInputBorder(),
    // ...
  ),
  selectorNavigator: const BottomSheetNavigator(), // default to bottom sheet but you can customize how the selector is shown by extending CountrySelectorNavigator
  enabled: true,          // default
  showFlagInInput: true,  // default
  autovalidateMode: AutovalidateMode.onUserInteraction, // default 
  validator: PhoneValidator.invalidMobile(),   // default PhoneValidator.invalid()
  cursorColor: Theme.of(context).colorScheme.primary,  // default null
  onSaved: (PhoneNumber p) => print('saved $p'),   // default null
  onChanged: (PhoneNumber p) => print('saved $p'), // default null
  restorationId: 'phoneRestorationId'
)

```

## Built-in validators

* required : `PhoneValidator.required`
* invalid : `PhoneValidator.invalid` (default value when no validator supplied)
* invalid mobile number : `PhoneValidator.invalidMobile`
* invalid fixed line number : `PhoneValidator.invalidFixedLine`
* invalid type : `PhoneValidator.invalidType`
* invalid country : `PhoneValidator.invalidCountry`
* none : `PhoneValidator.none` (this can be used to disable default invalid validator)

### Validators details

* Each validator has an optional `errorText` property to override built-in translated text
* Most of them have an optional `allowEmpty` (default is true) preventing to flag an empty field as invalid. Consider using a composed validator with a first `PhoneValidator.required` when a different text is needed for empty field.

### Composing validators

Validator can be a composed set of validators built-in or custom validator using `PhoneValidator.compose`, see usage section.

Note that when composing validators, the sorting is important as the error message displayed is the first validator failing.

```dart
PhoneFormField(
  // ...
  validator: PhoneValidator.compose([
    // list of validators to use
    PhoneValidator.required(errorText: "You must enter a value"),
    PhoneValidator.invalidMobile(),
  // ...
  ]),
)
```


## Internationalization

  Include the delegate

  ```dart
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        PhoneFieldLocalization.delegate
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('fr', ''),
        const Locale('ru', ''),
        // ...
      ],
  ```

  That's it.

  
  A bunch of languages are built-in:

    - 'ar',
    - 'de',
    - 'en',
    - 'es',
    - 'fr',
    - 'hin',
    - 'it',
    - 'nl',
    - 'pt',
    - 'ru',
    - 'zh',
  
  
   If one of the language you target is not supported you can submit a
  pull request with the translated file in src/l10n
