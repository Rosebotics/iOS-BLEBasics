//
//  RHBlunoViewController.h
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBlunoManager.h"

@interface RHBlunoViewController : UIViewController<DFBlunoDelegate>
@property(strong, nonatomic) DFBlunoManager* blunoManager;
@property(strong, nonatomic) DFBlunoDevice* blunoDev;
@property(strong, nonatomic) NSMutableArray* aryDevices;

- (BOOL) sendCommand:(NSString*) commandString;
- (void) onCommandReceived:(NSString*) receivedCommand;

@end
