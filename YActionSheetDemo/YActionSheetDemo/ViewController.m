//
//  ViewController.m
//  YActionSheetDemo
//
//  Created by yuvraj on 9/8/15.
//  Copyright (c) 2015 yuvrajsinh. All rights reserved.
//

#import "ViewController.h"
#import "YActionSheet.h"

@interface ViewController (){
    NSArray *arrOptions;
    NSInteger selectedIndex;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    arrOptions = @[@"One", @"Two", @"Three", @"Four", @"Five"];
    selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnOpenActionSheetClick:(id)sender{
    YActionSheet *options = [[YActionSheet alloc] initWithTitle:@"Options"
                                                         dismissButtonTitle:@"Done"
                                                         otherButtonTitles:arrOptions
                                                   dismissOnSelect:NO];
    [options setSelectedIndex:selectedIndex];
    [options showInViewController:self withYActionSheetBlock:^(NSInteger buttonIndex, BOOL isCancel) {
        if (isCancel){
            NSLog(@"cancelled");
        }
        else{
            selectedIndex = buttonIndex;
            self.lblSelectedOption.text = arrOptions[selectedIndex];
        }
    }];
}

@end
