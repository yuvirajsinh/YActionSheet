//
//  YSortActionSheet.h
//
//  Created by yuvraj on 12/01/15.
//  Copyright (c) 2015 yuvrajsinh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YActionBlock)(NSInteger buttonIndex, BOOL isCancel);

@interface YActionSheet : UIView <UITableViewDataSource, UITableViewDelegate>{
    YActionBlock blockHandler;
}

@property (readwrite, nonatomic) NSInteger selectedIndex;

- (id)initWithTitle:(NSString *)titleText dismissButtonTitle:(NSString *)dismissTitle otherButtonTitles:(NSArray *)buttonTitles dismissOnSelect:(BOOL)dismiss;

- (void)showInViewController:(UIViewController *)inController withYActionSheetBlock:(YActionBlock)handler;

@end
