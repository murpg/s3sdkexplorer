Welcome to our amazing S3 Amazon Explorer.
## Important Links
* Source: https://github.com/murpg/s3sdkexplorer
* Issues: https://github.com/murpg/s3sdkexplorer/issues
* S3 SDK: https://github.com/murpg/s3sdkexplorer

## Installation

Use CommandBox to install the module:

```
box install s3sdkexplorer
```

## Settings

You will have to create a struct called `s3sdkexplorer` in your ColdBox configuration `config/Coldbox.cfc` in order for the SDK to connect to Amazon with your credentials:

```
s3sdkexplorer = {
    // Your amazon access key
    accessKey = "",
    // Your amazon secret key
    secretKey = "",
    // The default encryption character set
    encryption_charset = "utf-8",
    // SSL mode or not on cfhttp calls.
    ssl = false,
    // Temp directory before uploading to s3
    tempuploaddirectory = "/tmp"
};
```

Once installed just visit the entry point: `/s3sdkexplorer` and enjoy your S3 Buckets.