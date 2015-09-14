//
//  YSortActionSheet.m
//
//  Created by yuvraj on 12/01/15.
//  Copyright (c) 2015 yuvrajsinh. All rights reserved.
//

#import "YActionSheet.h"

#define CELL_HEIGHT 45.0
#define TITLE_VIEW_HEIGHT 44.0
#define DISMISS_BUTTON_HEIGHT 65.0

#define kYActionTitleFontSize 17.0f

#define kYActionTitleColor [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0]
#define kYActionButtonTitleColor [UIColor blackColor]
#define kYOptionTextColor [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]
#define kYActionSeparatorColor [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0]
#define kYActionDoneButtonColor [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]

@implementation YActionSheet{
    NSString *title;
    NSString *dismissButtonTitle;
    NSArray *otherTitles;
    UITableView *tableViewOptions;
    UIButton *btnDismiss;
    BOOL dismissOnSelect;
}

@synthesize selectedIndex = _selectedIndex;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithTitle:(NSString *)titleText dismissButtonTitle:(NSString *)dismissTitle otherButtonTitles:(NSArray *)buttonTitles dismissOnSelect:(BOOL)dismiss{
    if (self = [super init]){
        title = [NSString stringWithString:titleText];
        dismissButtonTitle = [NSString stringWithString:dismissTitle];
        otherTitles = [NSArray arrayWithArray:buttonTitles];
        dismissOnSelect = dismiss;
        _selectedIndex = 0;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // Setup Dissmiss button
        [self setupDismissView];
        
        // Setup TableView
        [self setupTableView];
    }
    return self;
}

#pragma mark - View Setup Methods
- (void)setupDismissView{
    btnDismiss = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDismiss.backgroundColor = [UIColor clearColor];
    btnDismiss.frame = self.frame;
    btnDismiss.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [btnDismiss addTarget:self action:@selector(btnCancelActionSheetClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDismiss];
}

- (void)setupTableView{
    // Add TableView to show options
    tableViewOptions = [[UITableView alloc] initWithFrame:self.frame];
    tableViewOptions.backgroundColor = [UIColor whiteColor];
    tableViewOptions.dataSource = self;
    tableViewOptions.delegate = self;
    tableViewOptions.bounces = NO;
    tableViewOptions.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewOptions.showsVerticalScrollIndicator = NO;
    tableViewOptions.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:tableViewOptions];
}

#pragma mark - Show/Hide ActionSheet
- (void)showInViewController:(UIViewController *)inController withYActionSheetBlock:(YActionBlock)handler{
    blockHandler = handler;
    
    CGRect frame = inController.view.frame;
    self.frame = frame;
    
    // Calculate frame for dismiss button
    btnDismiss.frame = self.frame;
    
    // Calculate Height for TableView
    CGFloat optionsHeight = ((otherTitles.count>4) ? 4 : otherTitles.count) * CELL_HEIGHT;
    // Give extra space to indicate that table view is scrollable if more than 4 options available
    // extraHeight will help to show 4 and a half options
    CGFloat extraHeight = (otherTitles.count>4) ? 20.0 : 0.0;
    
    CGFloat totalHeight = TITLE_VIEW_HEIGHT + DISMISS_BUTTON_HEIGHT + optionsHeight + extraHeight;
    // Defalut set table frame to out of screen
    CGRect tableFrame = CGRectMake(0.0, frame.size.height, frame.size.width, totalHeight);
    tableViewOptions.frame = tableFrame;
    
    [inController.view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        
        // Animate TableView from bottom
        CGRect newFrame = tableViewOptions.frame;
        newFrame.origin.y = frame.size.height-totalHeight;
        tableViewOptions.frame = newFrame;
    } completion:^(BOOL finished) {
        
    }];
    [tableViewOptions reloadData];
}

- (void)dissmissActionSheet{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        // Animate TableView from bottom
        CGRect newFrame = tableViewOptions.frame;
        newFrame.origin.y = self.frame.size.height;
        tableViewOptions.frame = newFrame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Button Clicks
- (void)btnCancelActionSheetClick:(id)sender{
    if (blockHandler) {
        blockHandler(-1, YES);
    }
    
    [self dissmissActionSheet];
}

- (void)btnDismissActionSheetClick:(id)sender{
    
    if (blockHandler) {
        blockHandler(self.selectedIndex, NO);
    }
    
    [self dissmissActionSheet];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TITLE_VIEW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return DISMISS_BUTTON_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, TITLE_VIEW_HEIGHT)];
    lblTitle.backgroundColor = [UIColor whiteColor];
    lblTitle.textColor = kYActionTitleColor;
    lblTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:kYActionTitleFontSize];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    lblTitle.text = title;
    
    UIView *viewSeperator = [[UIView alloc] initWithFrame:CGRectMake(0.0, lblTitle.frame.size.height-1, lblTitle.frame.size.width, 1.0)];
    viewSeperator.backgroundColor = kYActionSeparatorColor;
    viewSeperator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [lblTitle addSubview:viewSeperator];
    
    return lblTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.backgroundColor = [UIColor whiteColor];
    btnDone.frame = CGRectMake(0.0, 0.0, self.frame.size.width, DISMISS_BUTTON_HEIGHT);
    btnDone.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    [btnDone setTitle:dismissButtonTitle forState:UIControlStateNormal];
    [btnDone setTitleColor:kYActionDoneButtonColor forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(btnDismissActionSheetClick:) forControlEvents:UIControlEventTouchUpInside];
    btnDone.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    UIView *viewSeperator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, btnDone.frame.size.width, 1.0)];
    viewSeperator.backgroundColor = kYActionDoneButtonColor;
    viewSeperator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    [btnDone addSubview:viewSeperator];
    
    return btnDone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return otherTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];

    UIView *viewSeperator = [cell.contentView viewWithTag:1111];
    if (!viewSeperator) {
        viewSeperator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 44.0, self.frame.size.width, 1.0)];
        viewSeperator.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
        viewSeperator.tag = 1111;
        viewSeperator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:viewSeperator];
    }
    
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1234];
    if (!imgView) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 11.0, 20.0, 20.0)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.tag = 1234;
        [cell.contentView addSubview:imgView];
    }
    
    // Check for selected/ non-selected row
    if (self.selectedIndex==indexPath.row){
        [imgView setImage:[UIImage imageNamed:@"check"]];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else
        [imgView setImage:[UIImage imageNamed:@"uncheck"]];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = kYOptionTextColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    cell.textLabel.text = [otherTitles objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1234];
    if (imgView) {
        [imgView setImage:[UIImage imageNamed:@"check"]];
    }
    
    //if dismiss on select is active
    if(dismissOnSelect==YES)
    {
        if (blockHandler) {
            blockHandler(self.selectedIndex, NO);
        }
        
        [self dissmissActionSheet];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    // Unselect this cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:1234];
    if (imgView) {
        [imgView setImage:[UIImage imageNamed:@"uncheck"]];
    }
}


@end
