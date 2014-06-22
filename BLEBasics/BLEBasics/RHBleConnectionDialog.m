//
//  RHBleConnectionDialog.m
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import "RHBleConnectionDialog.h"

#import "UIView+SDCAutoLayout.h"
#import "DFBlunoDevice.h"

#define kSelectionCellIdentifier @"SelectionCellIdentifier"
#define kDefaultTableCellHeight 44.0
#define kStandardHorizontalPadding 20.0
#define kDefaultBorderColor [UIColor colorWithRed:0.6667 green:0.6667 blue:0.6667 alpha:1.0]

@interface RHBleConnectionDialog()
@property (nonatomic, strong) NSMutableArray* listItems;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) void(^deviceSelectedCallback)(DFBlunoDevice*);
@property (nonatomic, strong) void(^cancelCallback)();
@end


@implementation RHBleConnectionDialog

- (id) initWithListItems:(NSMutableArray*) listItems
  deviceSelectedCallback:(void(^)(DFBlunoDevice* bleDevice)) deviceSelectedCallback
          cancelCallback:(void(^)()) cancelCallback {
    self = [super initWithTitle:@"Select Bluno Device"
                        message:nil
                       delegate:nil
              cancelButtonTitle:@"Cancel"
              otherButtonTitles:nil];
    if (self) {
        self.delegate = self;
        self.listItems = listItems;
        self.deviceSelectedCallback = deviceSelectedCallback;
        self.cancelCallback = cancelCallback;

        self.tableView = [[UITableView alloc] init];
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSelectionCellIdentifier];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.layer.borderColor = kDefaultBorderColor.CGColor;
        self.tableView.layer.borderWidth = 1.0f;
        self.tableView.alwaysBounceVertical = NO;
        [self.contentView addSubview:self.tableView];
        [self.tableView sdc_centerInSuperview];
        [self notifyContentChanged];
    }
    return self;
}


- (void) notifyContentChanged {
    [self.tableView reloadData];
    [self _resizeTable];
    [super notifyContentChanged];
}


- (void) _resizeTable {
    CGFloat tableHeight = kDefaultTableCellHeight * MIN(self.listItems.count, 5.5);
    CGFloat tableWidth = SDCAlertViewWidth - 2.0 * kStandardHorizontalPadding;
    self.tableView.frame = CGRectMake(kStandardHorizontalPadding, 0.0, tableWidth, tableHeight);
}


#pragma mark - SDCAlertViewDelegate methods

- (void) alertView:(SDCAlertView*) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    NSParameterAssert(self == alertView);
    if (buttonIndex == self.cancelButtonIndex) {
        if (self.cancelCallback != nil) {
            self.cancelCallback();
        }
    }
}


#pragma mark - UITableViewDataSource methods

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    return self.listItems.count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectionCellIdentifier];
    DFBlunoDevice* peripheral   = [self.listItems objectAtIndex:indexPath.row];
    if (peripheral.name.length > 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", peripheral.name, peripheral.identifier];
    } else {
        cell.textLabel.text = peripheral.identifier;
    }
    return cell;
}


#pragma mark - UITableViewDelegate methods

- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    DFBlunoDevice* bleDevice = self.listItems[indexPath.row];
    if (self.deviceSelectedCallback != nil) {
        self.deviceSelectedCallback(bleDevice);
    }
    [self dismissWithClickedButtonIndex:-1 animated:YES];
}


@end
