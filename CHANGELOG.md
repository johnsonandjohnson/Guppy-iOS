# Changelog
All notable changes to this project will be documented in this file. Guppy adheres to [semantic versioning](http://semver.org/).


## Unreleased

## Releases

### 0.9.0

#### Added

* Support for dynamic font sizes

#### Changed

* Minimum iOS version supported is now iOS 13.0
* Improved contrast of success status in dark mode
* Improved VoiceOver accessibility

#### Fixed

* Fixed issue where search bar text was not readable in dark mode
* Fixed issue where unknown status was not readable in dark mode

---

### 0.8.0

#### Added

* Support for Swift Package Manager

#### Changed

* Minimum iOS version supported is now iOS 12.0
* Removed deprecated `SniffURLProtocol` & `getSniffURLProtocol()`

---

### 0.7.0

#### Added

* Support for dark mode on iOS 13

#### Fixed

* Resolved Swift 5.1 warning on Xcode 11.2
* Fixed search bar appearance with iOS 13

---

### 0.6.1

#### Changed

* Moved repository location

---

### 0.6.0

#### Changed

* Changed to use systemFont for display
* Renamed `SniffURLProtocol` to `GuppyURLProtocol`
* Deprecated `getSniffURLProtocol()`

#### Fixed

* Fixed issue where `motionBegan` was intercepted and did not call super
* Fixed issue where json decoding used ascii encoding instead of utf8

---

### 0.5.1

#### Fixed
* Resolved issue where large POST request bodies were not displayed
* Resolved memory leak of SniffURLProtocol caused by urlSession not being invalidated

---

### 0.5.0
* Initial Release!
 
---
