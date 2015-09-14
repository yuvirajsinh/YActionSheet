![License](http://img.shields.io/badge/license-MIT-orange.png)

# YActionSheet
Custom Selectable Action Sheet. YActionSheet provides you ability to see your selected option in ActionSheet view.

# How to use
1) Drag YActionSheet directory to your xCode Project.

2) Make sure "Copy items if needed" is selected.

3) Import YActionSheet.h in file where you want to use it.
```objc
#import "YActionSheet.h"
```

4) Initialize YActionSheet
```objc
YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"Options"
                                                         dismissButtonTitle:@"Title"
                                                         otherButtonTitles:@[@"One", @"Two", @"Three", @"Four", @"Five"];
                                                   dismissOnSelect:NO];
```
5) Open YActionSheet
```objc
[options showInViewController:self withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel) {
        // Handle block completion
    }];
```
# Configurations
Set pre selected option index. Call this before showing YActionSheet.
```objc
[options setSelectedIndex:selectedIndex];
```
