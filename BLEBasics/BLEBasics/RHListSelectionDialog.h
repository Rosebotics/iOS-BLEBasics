//
//  RHListSelectionDialog.h
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import "SDCAlertView.h"

@interface RHListSelectionDialog : SDCAlertView <SDCAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

- (id) initWithTitle:(NSString*) title
allowMultipleSelections:(BOOL) allowMultipleSelections
dismissOnFirstSelection:(BOOL) dismissOnFirstSelection
           listItems:(NSArray*) listItems
          okCallback:(void(^)(NSArray* selectedIndexes)) okCallback;

@end