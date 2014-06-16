//
//  RHBlunoViewController.m
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import "RHBlunoViewController.h"

#import "RHListSelectionDialog.h"


@interface RHBlunoViewController ()

@end

@implementation RHBlunoViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    self.blunoManager = [DFBlunoManager sharedInstance];
    self.blunoManager.delegate = self;
    self.aryDevices = [[NSMutableArray alloc] init];
}


- (BOOL) sendCommand:(NSString*) commandString {
    if (!self.blunoDev.bReadyToWrite) {
        return NO;
    }
    NSString* strWithTerminator = [NSString stringWithFormat:@"%@\n", commandString];
    NSData* data = [strWithTerminator dataUsingEncoding:NSUTF8StringEncoding];
    [self.blunoManager writeDataToDevice:data Device:self.blunoDev];
    return YES;
}

- (void) onCommandReceived:(NSString*) receivedCommand {

}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showConnectionsAlertView {
    [self.aryDevices removeAllObjects];

    [[[RHListSelectionDialog alloc] initWithTitle:@"Hi Dave"
                          allowMultipleSelections:NO
                          dismissOnFirstSelection:YES
                                        listItems:@[@"Dave", @"Bob", @"Frank"]
                                       okCallback:^(NSArray *selectedIndexes) {
                                           NSLog(@"selectedIndexes = %@", selectedIndexes);
                                       }] show];
    [self.blunoManager scan];
}


#pragma mark- DFBlunoDelegate

-(void) bleDidUpdateState:(BOOL) bleSupported {
    if (bleSupported) {
        [self.blunoManager scan];
    }
}


-(void) didDiscoverDevice:(DFBlunoDevice*) dev {
    BOOL bRepeat = NO;
    for (DFBlunoDevice* bleDevice in self.aryDevices) {
        if ([bleDevice isEqual:dev]) {
            bRepeat = YES;
            break;
        }
    }
    if (!bRepeat) {
        [self.aryDevices addObject:dev];
    }
    // TODO: Add this device to the table and update the dialog.
    NSLog(@"New device: %@", self.aryDevices);
}


- (void) readyToCommunicate:(DFBlunoDevice*) dev  {
    self.blunoDev = dev;
}


- (void) didDisconnectDevice:(DFBlunoDevice*) dev {
    self.blunoDev = nil;
}


- (void) didWriteData:(DFBlunoDevice*) dev {

}


- (void) didReceiveData:(NSData*)data Device:(DFBlunoDevice*) dev {
    NSString* receivedStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* messages = [receivedStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString* message in messages) {
        [self onCommandReceived: message];
    }
}

@end
