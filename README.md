# open_file_safe_plus

[![pub package](https://img.shields.io/pub/v/open_file_safe_plus.svg)](https://pub.dev/packages/open_file_safe_plus)
[![License: BSD](https://img.shields.io/badge/license-BSD-blue.svg)](LICENSE)

Open local files with the platform's native viewer/app, from Flutter. Successor of [`open_file`](https://pub.dev/packages/open_file).

| Platform | Mechanism |
|---|---|
| Android | `Intent` |
| iOS | `UIDocumentInteractionController` (UTI) |
| macOS / Windows / Linux | native "open" shell command |
| Web | `dart:js_interop` (`resolveLocalFileSystemURL`) |

## Table of contents

- [Install](#install)
- [Usage](#usage)
- [Result](#result)
- [Android setup](#android-setup)
  - [Supported MIME types](#android-supported-mime-types)
  - [FileProvider conflicts](#fileprovider-conflicts-with-other-plugins)
  - [`com.android.support:appcompat-v7` version conflict](#appcompat-v7-version-conflict)
- [iOS setup](#ios-setup)
  - [Supported UTIs](#ios-supported-utis)
- [Changelog](#changelog)
- [License](#license)

## Install

```yaml
dependencies:
  open_file_safe_plus: ^0.0.6
```

## Usage

```dart
import 'package:open_file_safe_plus/open_file_safe_plus.dart';

final result = await OpenFileSafePlus.open('/sdcard/example.txt');
```

Optional parameters:

| Parameter | Type | Default | Description |
|---|---|---|---|
| `filePath` | `String?` | — | Absolute path to the file to open. |
| `type` | `String?` | `null` | Android MIME type override, e.g. `"application/pdf"`. |
| `uti` | `String?` | `null` | iOS UTI override, e.g. `"com.adobe.pdf"`. |
| `linuxDesktopName` | `String` | `"xdg"` | Linux opener prefix, e.g. `"gnome"` → `gnome-open`. |
| `linuxByProcess` | `bool` | `false` | On Linux, shell out via `Process.run('xdg-open', ...)` instead of the FFI-based opener. |

## Result

`open()` resolves to an `OpenResult`:

```dart
class OpenResult {
  ResultType type;   // done | fileNotFound | noAppToOpen | permissionDenied | error
  String message;
}
```

```dart
final result = await OpenFileSafePlus.open(path);
if (result.type == ResultType.done) {
  // opened successfully
} else {
  print('${result.type}: ${result.message}');
}
```

## Android setup

### Android supported MIME types

<details>
<summary>Expand extension → MIME type table</summary>

| Extension | MIME type |
|---|---|
| `.3gp` | `video/3gpp` |
| `.torrent` | `application/x-bittorrent` |
| `.kml` | `application/vnd.google-earth.kml+xml` |
| `.gpx` | `application/gpx+xml` |
| `.csv` | `application/vnd.ms-excel` |
| `.apk` | `application/vnd.android.package-archive` |
| `.asf` | `video/x-ms-asf` |
| `.avi` | `video/x-msvideo` |
| `.bin` | `application/octet-stream` |
| `.bmp` | `image/bmp` |
| `.c` | `text/plain` |
| `.class` | `application/octet-stream` |
| `.conf` | `text/plain` |
| `.cpp` | `text/plain` |
| `.doc` | `application/msword` |
| `.docx` | `application/vnd.openxmlformats-officedocument.wordprocessingml.document` |
| `.xls` | `application/vnd.ms-excel` |
| `.xlsx` | `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet` |
| `.exe` | `application/octet-stream` |
| `.gif` | `image/gif` |
| `.gtar` | `application/x-gtar` |
| `.gz` | `application/x-gzip` |
| `.h` | `text/plain` |
| `.htm` | `text/html` |
| `.html` | `text/html` |
| `.jar` | `application/java-archive` |
| `.java` | `text/plain` |
| `.jpeg` | `image/jpeg` |
| `.jpg` | `image/jpeg` |
| `.js` | `application/x-javascript` |
| `.log` | `text/plain` |
| `.m3u` | `audio/x-mpegurl` |
| `.m4a` | `audio/mp4a-latm` |
| `.m4b` | `audio/mp4a-latm` |
| `.m4p` | `audio/mp4a-latm` |
| `.m4u` | `video/vnd.mpegurl` |
| `.m4v` | `video/x-m4v` |
| `.mov` | `video/quicktime` |
| `.mp2` | `audio/x-mpeg` |
| `.mp3` | `audio/x-mpeg` |
| `.mp4` | `video/mp4` |
| `.mpc` | `application/vnd.mpohun.certificate` |
| `.mpe` | `video/mpeg` |
| `.mpeg` | `video/mpeg` |
| `.mpg` | `video/mpeg` |
| `.mpg4` | `video/mp4` |
| `.mpga` | `audio/mpeg` |
| `.msg` | `application/vnd.ms-outlook` |
| `.ogg` | `audio/ogg` |
| `.pdf` | `application/pdf` |
| `.png` | `image/png` |
| `.pps` | `application/vnd.ms-powerpoint` |
| `.ppt` | `application/vnd.ms-powerpoint` |
| `.pptx` | `application/vnd.openxmlformats-officedocument.presentationml.presentation` |
| `.prop` | `text/plain` |
| `.rc` | `text/plain` |
| `.rmvb` | `audio/x-pn-realaudio` |
| `.rtf` | `application/rtf` |
| `.sh` | `text/plain` |
| `.tar` | `application/x-tar` |
| `.tgz` | `application/x-compressed` |
| `.txt` | `text/plain` |
| `.wav` | `audio/x-wav` |
| `.wma` | `audio/x-ms-wma` |
| `.wmv` | `audio/x-ms-wmv` |
| `.wps` | `application/vnd.ms-works` |
| `.xml` | `text/plain` |
| `.z` | `application/x-compress` |
| `.zip` | `application/x-zip-compressed` |
| *(none)* | `*/*` |

</details>

### FileProvider conflicts with other plugins

If another plugin also declares a `FileProvider`, add this to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools"
          package="xxx.xxx.xxxxx">
    <application>
        ...
        <provider
                android:name="androidx.core.content.FileProvider"
                android:authorities="${applicationId}.fileProvider"
                android:exported="false"
                android:grantUriPermissions="true"
                tools:replace="android:authorities">
            <meta-data
                    android:name="android.support.FILE_PROVIDER_PATHS"
                    android:resource="@xml/filepaths"
                    tools:replace="android:resource" />
        </provider>
    </application>
</manifest>
```

and add `android/app/src/main/res/xml/filepaths.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <external-path name="external_storage_directory" path="." />
</resources>
```

### `appcompat-v7` version conflict

If `com.android.support:appcompat-v7` resolves to conflicting versions, add this to `android/build.gradle`:

```groovy
subprojects {
    project.configurations.all {
        resolutionStrategy.eachDependency { details ->
            if (details.requested.group == 'com.android.support'
                    && !details.requested.name.contains('multidex')) {
                details.useVersion "27.1.1"
            }
        }
    }
}
```

## iOS setup

`uti` is auto-detected from the file extension; pass it explicitly to override.

### iOS supported UTIs

<details>
<summary>Expand extension → UTI table</summary>

| Extension | UTI |
|---|---|
| `.rtf` | `public.rtf` |
| `.txt` | `public.plain-text` |
| `.html` | `public.html` |
| `.htm` | `public.html` |
| `.xml` | `public.xml` |
| `.tar` | `public.tar-archive` |
| `.gz` | `org.gnu.gnu-zip-archive` |
| `.gzip` | `org.gnu.gnu-zip-archive` |
| `.tgz` | `org.gnu.gnu-zip-tar-archive` |
| `.jpg` | `public.jpeg` |
| `.jpeg` | `public.jpeg` |
| `.png` | `public.png` |
| `.avi` | `public.avi` |
| `.mpg` | `public.mpeg` |
| `.mpeg` | `public.mpeg` |
| `.mp4` | `public.mpeg-4` |
| `.3gpp` | `public.3gpp` |
| `.3gp` | `public.3gpp` |
| `.mp3` | `public.mp3` |
| `.zip` | `com.pkware.zip-archive` |
| `.gif` | `com.compuserve.gif` |
| `.bmp` | `com.microsoft.bmp` |
| `.ico` | `com.microsoft.ico` |
| `.doc` | `com.microsoft.word.doc` |
| `.xls` | `com.microsoft.excel.xls` |
| `.ppt` | `com.microsoft.powerpoint.ppt` |
| `.wav` | `com.microsoft.waveform-audio` |
| `.wm` | `com.microsoft.windows-media-wm` |
| `.wmv` | `com.microsoft.windows-media-wmv` |
| `.pdf` | `com.adobe.pdf` |

</details>

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

[BSD](LICENSE)
