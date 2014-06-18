//
//  RHBleConnectionDialog.m
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import "RHBleConnectionDialog.h"


@interface RHBleConnectionDialog()
@property (nonatomic, strong) NSMutableArray* listItems;
@end


@implementation RHBleConnectionDialog

- (id) initWithListItems:(NSMutableArray*) listItems
  deviceSelectedCallback:(void(^)(DFBlunoDevice* bleDevice)) deviceSelectedCallback {
    self = [super initWithTitle:@"Select a device"
        allowMultipleSelections:NO
        dismissOnFirstSelection:YES
                      listItems:listItems
                     okCallback:^(NSArray *selectedIndexes) {
                         if (selectedIndexes.count == 1 && deviceSelectedCallback != nil) {
                             deviceSelectedCallback(selectedIndexes[0]);
                         }
                     }];
    if (self) {
        self.listItems = listItems;
    }
    return self;


}

- (void) notifyContentChanged {
    [super notifyContentChanged];
}

@end
