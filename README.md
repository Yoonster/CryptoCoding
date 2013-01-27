#### Description & Original Crypto provider link:
```html
https://github.com/nicklockwood/CryptoCoding
```

#### Summary of Manager example
The idea of editing through visible plist to save in device's documentary was really great from Nick's TodoList sample.
Nick's Crypto API already contains serializing one class object that can have multiple resource can save which ever object belongs into that class.
But even if you were deciding to use visible plist from NSBundle directory, the non-secure plist file still remainning in the .app (simulator directory .app->right click->show packages).
So I have added some basic idea delete the file from bundle list whenever you are done, and this resolves the problem.

```objc
// #ifdef RELEASE
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Fact" ofType:@"plist"];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    if ([filemanager fileExistsAtPath:path]) {
        [filemanager removeItemAtPath:path error:nil];
    }
// #endif
```

#### Usage of confidential manager
For store purpose:
```obj
    ConfidentialManager *confidential = [ConfidentialManager shared];
    NSArray *stocks = [NSArray arrayWithObjects:@"apple", @"intel", @"google", nil];
    NSMutableDictionary *person = [[NSMutableDictionary alloc] init];
    [person setObject:@"eye" forKey:@"kEye"];
    [person setObject:@"nose" forKey:@"kNose"];
    [person setObject:@"lips" forKey:@"kLips"];
    
    [confidential addBundlePlistContent:@"Fact"];
    [confidential addContent:stocks forKey:@"kStock"];
    [confidential addContent:person forKey:@"kPerson"];
    [confidential save];
    [person release];
```
For usecase:
```obj
    ConfidentialManager *confidential = [ConfidentialManager shared];
    NSLog(@"%@", [confidential.contents description]);
```

You are more than welcome to fix my writing in readme document. Thanks
