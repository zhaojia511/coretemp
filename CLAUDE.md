# CLAUDE.md - AI Assistant Guide for CoreTemp (zzsports)

## Project Overview

CoreTemp is a Flutter-based cross-platform application that helps athletes track sports performance using Bluetooth Low Energy (BLE) connected sensors. The primary focus is core body temperature monitoring through specialized wearable sensors.

**Package Name:** `zzsports`
**Version:** 1.0.0+1
**Dart SDK:** >=3.0.3 <4.0.0

## Repository Structure

```
/home/user/coretemp/
├── lib/                          # Main application source code
│   ├── main.dart                 # Application entry point
│   ├── ble/                      # BLE communication module
│   │   ├── ble_manager.dart      # Central BLE singleton manager
│   │   ├── ble_scanner.dart      # Device scanning
│   │   ├── ble_device_connector.dart    # Connection lifecycle
│   │   ├── ble_device_interactor.dart   # Characteristic read/write
│   │   ├── ble_logger.dart       # BLE logging
│   │   ├── ble_status_monitor.dart      # Adapter status
│   │   └── reactive_state.dart   # Reactive state interface
│   ├── model/                    # Data models
│   │   ├── temperature.dart      # Base temperature class
│   │   ├── core_body_temperature.dart   # CBT data parsing
│   │   └── health_thermometer.dart      # HTS data parsing
│   ├── pages/                    # UI screens
│   │   ├── main_page.dart        # Bottom navigation hub
│   │   ├── home_page.dart        # Sport activity grid
│   │   ├── device_page.dart      # Device connection status
│   │   ├── device_card.dart      # Real-time temp display + chart
│   │   ├── devices_list_page.dart       # BLE scanning UI
│   │   ├── device_setting.dart   # Device settings
│   │   ├── setting_list_item.dart       # Settings widgets
│   │   ├── device_list_item.dart        # Device list item
│   │   ├── my_page.dart          # User profile
│   │   └── detail.dart           # Activity detail
│   ├── service/                  # Network services
│   │   └── http_service.dart     # Dio HTTP client
│   ├── common/                   # Common utilities
│   │   └── common.dart           # Type definitions
│   └── i18n/                     # Internationalization
│       └── translations.dart     # English/Chinese translations
├── test/                         # Unit and widget tests
├── doc/                          # Documentation (BLE spec PDF)
├── assets/                       # Image and media assets
├── android/                      # Android native code
├── ios/                          # iOS native code
├── macos/                        # macOS native code
├── linux/                        # Linux native code
├── windows/                      # Windows native code
├── web/                          # Web build files
├── pubspec.yaml                  # Dependencies and configuration
└── analysis_options.yaml         # Dart analysis rules
```

## Key Technologies & Dependencies

### Core Framework
- **Flutter** - Cross-platform UI framework
- **GetX** (v4.6.5) - State management, routing, dependency injection

### BLE & Connectivity
- **flutter_reactive_ble** (v5.1.1) - Reactive BLE communication
- **permission_handler** (v10.4.3) - Device permissions

### Data & Storage
- **isar** (v3.1.0+1) - NoSQL database
- **get_storage** (v2.1.1) - Key-value local storage
- **dio** (v5.3.0) - HTTP client

### UI & Visualization
- **syncfusion_flutter_charts** (v21.2.4) - Temperature charts
- **flex_color_scheme** (v7.1.2) - Material design themes
- **flutter_easyloading** (v3.0.5) - Loading dialogs

## Architecture Patterns

### State Management
The project uses **GetX** for state management with reactive streams:

```dart
// GetX controller pattern
class MainPageController extends GetxController {
  final pageIndex = 0.obs;
  // ...
}
```

### Singleton Pattern
BleManager is implemented as a singleton for global BLE access:

```dart
class BleManager {
  static final BleManager _sharedInstance = BleManager._();
  factory BleManager() => _sharedInstance;
  BleManager._() { /* initialization */ }
}
```

### Service Initialization
Services are initialized asynchronously at app startup in `main.dart`:

```dart
initServices() async {
  BleManager();
  await Get.putAsync<HttpService>(
    () async => await HttpService().init(baseUrl: "http://www.xueyazhushou.com"));
}
```

## BLE Service UUIDs (Critical)

When working with BLE code, use these standard UUIDs:

| Service | UUID |
|---------|------|
| Core Body Temperature Service | `00002100-5B1E-4347-B07C-97B514DAE121` |
| Health Thermometer Service | `1809` |
| Battery Service | `180F` |
| Device Information | `180A` |
| Legacy Private Service | `00004200-F366-40B2-AC37-70CCE0AA83B1` |

| Characteristic | UUID |
|----------------|------|
| Core Body Temperature | `00002101-5B1E-4347-B07C-97B514DAE121` |
| Temperature Measurement | `2A1C` |
| Battery Level | `2A19` |

## Data Models

### Temperature Data Format
Core body temperature data is 8 bytes:
- Bytes 1-2: Core temperature (value / 100.0)
- Bytes 3-4: Skin temperature (value / 100.0)
- Byte 8, bits 0-2: Data quality (0=invalid, 1=poor, 2=fair, 3=good, 4=excellent)
- Byte 8, bits 4-5: HRM state

Special value: `0xFF7F` (32767) indicates invalid temperature.

### Model Classes
Models extend `Equatable` for value comparison:

```dart
class CoreBodyTemperature extends Equatable {
  @override
  List<Object?> get props => [coreTemperature];
}
```

## Development Commands

### Flutter Commands
```bash
# Get dependencies
flutter pub get

# Run static analysis
flutter analyze

# Run tests
flutter test

# Generate Isar models
flutter pub run build_runner build

# Generate launcher icons
flutter pub run flutter_launcher_icons:main

# Build for platforms
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
flutter build macos      # macOS
flutter build windows    # Windows
flutter build linux      # Linux
```

### Android Configuration
- Min SDK: 21
- Namespace: `com.zzsports.zzsports`
- Kotlin enabled

## Coding Conventions

### File Naming
- Use snake_case for file names: `ble_manager.dart`, `core_body_temperature.dart`
- Group related files in directories: `ble/`, `model/`, `pages/`, `service/`

### Code Style
- Follow `flutter_lints` rules (configured in `analysis_options.yaml`)
- Use `const` constructors where possible
- Models should implement `Equatable` for value equality
- Use enums with factory methods for parsing:

```dart
enum CBTQuality {
  invalid, poor, fair, good, excellent, unavailable;

  static CBTQuality qualityFromIndex(int index) {
    if (index >= 0 && index < CBTQuality.values.length) {
      return CBTQuality.values[index];
    }
    return CBTQuality.unavailable;
  }
}
```

### GetX Conventions
- Use `.obs` for reactive variables
- Use `Get.put()` / `Get.putAsync()` for dependency injection
- Use `GetMaterialApp` as root widget
- Controllers extend `GetxController`

### Widget Structure
- Pages are in `lib/pages/`
- Use descriptive widget names: `DeviceCard`, `SettingListItem`
- Separate list items into their own widgets

## Important Notes for AI Assistants

### When Modifying BLE Code
1. Always reference the BLE spec document in `/doc/`
2. Use the correct service/characteristic UUIDs from `ble_manager.dart`
3. Handle connection state changes properly
4. Consider battery level and device status

### When Adding New Features
1. Follow GetX patterns for state management
2. Add new pages to `lib/pages/`
3. Add new models to `lib/model/`
4. Register services in `main.dart` if needed

### When Working with Temperature Data
1. Temperature values are in 1/100 degree units (divide by 100.0)
2. Support both Celsius and Fahrenheit (check bit 3 of first byte)
3. Check for invalid values (32767 = `0xFF7F`)
4. Include data quality assessment in UI

### Testing Considerations
- Widget tests go in `/test/`
- BLE operations require mocking the `flutter_reactive_ble` package
- Use `flutter test` to run all tests

## External Resources

- GitHub: https://github.com/CoreBodyTemp/CoreBodyTemp
- Developer Docs: https://help.corebodytemp.com/en/articles/10447028-developer-information
- Changelog: https://help.corebodytemp.com/en/articles/10447021-core-changelog

## Supported Platforms

| Platform | Status | Notes |
|----------|--------|-------|
| Android | Supported | API 21+ (Lollipop) |
| iOS | Supported | Requires Xcode |
| Web | Supported | PWA enabled |
| macOS | Supported | Desktop app |
| Windows | Supported | Desktop app |
| Linux | Supported | Desktop app |
