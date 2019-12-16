# Changelog
All notable changes to this project will be documented in this file. Guppy adheres to [semantic versioning](http://semver.org/).


## Unreleased

---

#### Fixed

* Resolved Swift 5.1 warning on Xcode 11.2

---

## Releases

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
