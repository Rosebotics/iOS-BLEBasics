//
//  RHListSelectionDialog.m
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import "RHListSelectionDialog.h"

#import "UIView+SDCAutoLayout.h"
#import "DFBlunoDevice.h"

#define kSelectionCellIdentifier @"SelectionCellIdentifier"
#define kDefaultTableCellHeight 44.0
#define kStandardHorizontalPadding 20.0
#define kDefaultBorderColor [UIColor colorWithRed:0.6667 green:0.6667 blue:0.6667 alpha:1.0]


@interface RHListSelectionDialog()
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* listItems;
@property (nonatomic, strong) NSMutableArray* selectedIndexPaths;
@property (nonatomic, strong) void(^okCallback)(NSArray*);
@end

@implementation RHListSelectionDialog

- (id) initWithTitle:(NSString*) title
           listItems:(NSMutableArray*) listItems
          okCallback:(void(^)(NSArray* selectedIndexes)) okCallback {
    self = [super initWithTitle:title
                        message:nil
                       delegate:nil
              cancelButtonTitle:@"Cancel"
              otherButtonTitles:nil];
    if (self) {
        self.delegate = self;
        self.listItems = listItems;
        self.selectedIndexPaths = [[NSMutableArray alloc] init];
        self.okCallback = okCallback;


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
    if (buttonIndex == self.firstOtherButtonIndex) {
        if (self.okCallback != nil) {
            NSMutableArray* selectedIndexes = [[NSMutableArray alloc] init];
            for (NSIndexPath* indexPath in self.selectedIndexPaths) {
                [selectedIndexes addObject:[NSNumber numberWithInteger:indexPath.row]];
            }
            self.okCallback(selectedIndexes);
        }
    }
}


- (BOOL) alertViewShouldEnableFirstOtherButton:(SDCAlertView*) alertView {
    NSParameterAssert(self == alertView);
    return self.selectedIndexPaths.count > 0;
}


#pragma mark - UITableViewDataSource methods

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    return self.listItems.count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectionCellIdentifier];


    //cell.textLabel.text = self.listItems[indexPath.row];
    DFBlunoDevice* peripheral   = [self.listItems objectAtIndex:indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@", peripheral.name, peripheral.identifier];
    cell.textLabel.text = peripheral.identifier;
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


#pragma mark - UITableViewDelegate methods

- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.selectedIndexPaths.count > 0) {
            [tableView cellForRowAtIndexPath:self.selectedIndexPaths[0]].accessoryType = UITableViewCellAccessoryNone;
        }
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedIndexPaths removeAllObjects];
        [self.selectedIndexPaths addObject:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self notifyContentChanged];
        [self dismissWithClickedButtonIndex:self.firstOtherButtonIndex animated:YES];

}

@end
