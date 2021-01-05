# Statistics

Statistics is a Swift package for interacting with Statistics Sweden's Open Data API.

## Installation

Statistics is available through Swift Package Manager. To install it, simply include it in your package dependency list:

```swift
dependencies: [
    .package(url: "https://github.com/devmaximilian/Statistics.git", from: "1.0.0"),
]
```
– alternatively using Xcode via File > Swift Packages > Add Package Dependency...

## Usage

```swift
let client = Statistics.defaultClient

// Get root navigation structure
client.navigationPublisher(for: .root)
    .assertNoFailure()
    .map(\.text)
    .sink { links in {
        print(links) // -> ["Labour market", "Population", ...]
    }
```

---

### Legal disclaimer

The developer and this package are not affiliated with or endorsed by Statistics Sweden. Any products and services provided through this package are not supported or warrantied by Statistics Sweden.

### License

See LICENSE for license details concerning this package. Read more about using Statistics Sweden's Open Data API [here](https://www.scb.se/vara-tjanster/oppna-data/) for details concerning the data provided by their API.
