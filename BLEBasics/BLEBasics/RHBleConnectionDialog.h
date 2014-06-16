//
//  RHBleConnectionDialog.h
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import "RHListSelectionDialog.h"
@class DFBlunoDevice;

@interface RHBleConnectionDialog : RHListSelectionDialog
- (id) initWithListItems:(NSMutableArray*) listItems
          deviceSelectedCallback:(void(^)(DFBlunoDevice* bleDevice)) deviceSelectedCallback;
@end
