//
//  RHBluetoothLEAdapter.m
//  BLEBasics
//
//  Created by David Fisher on 6/15/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import "RHBluetoothLEAdapter.h"

#import "RHBleConnectionDialog.h"


@interface RHBluetoothLEAdapter()
@property(strong, nonatomic) DFBlunoManager* blunoManager;
@property(strong, nonatomic) DFBlunoDevice* blunoDevice;
@property(strong, nonatomic) NSMutableArray* aryDevices;
@property (nonatomic, strong) void(^connectionCallback)(BOOL);
@property (nonatomic, strong) void(^receiveCallback)(NSString*);
@property (nonatomic, strong) RHBleConnectionDialog* connectionDialog;
@end


@implementation RHBluetoothLEAdapter

- (id) initWithConnectionCallback:(void(^)(BOOL isConnected)) connectionCallback
                  receiveCallback:(void(^)(NSString* commandReceived)) receiveCallback {
    self = [super init];
    if (self) {
        self.connectionCallback = connectionCallback;
        self.receiveCallback = receiveCallback;
        self.blunoManager = [DFBlunoManager sharedInstance];
        self.blunoManager.delegate = self;
        self.aryDevices = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void) showConnectionDialog {
    self.connectionDialog = [[RHBleConnectionDialog alloc] initWithListItems:self.aryDevices
                                                      deviceSelectedCallback:^(DFBlunoDevice* bleDevice) {
                                                          NSLog(@"bleDevice = %@", bleDevice);
                                                      }];
    [self.connectionDialog show];
}


- (BOOL) sendCommand:(NSString*) commandString {
    if (!self.blunoDevice.bReadyToWrite) {
        return NO;
    }
    NSString* strWithTerminator = [NSString stringWithFormat:@"%@\n", commandString];
    NSData* data = [strWithTerminator dataUsingEncoding:NSUTF8StringEncoding];
    [self.blunoManager writeDataToDevice:data Device:self.blunoDevice];
    return YES;
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
        if ([self.connectionDialog isVisible]) {
            [self.connectionDialog notifyContentChanged];
        }
    }
}


- (void) readyToCommunicate:(DFBlunoDevice*) dev  {
    self.blunoDevice = dev;
    if (self.connectionCallback != nil) {
        self.connectionCallback(YES);
    }
}


- (void) didDisconnectDevice:(DFBlunoDevice*) dev {
    self.blunoDevice = nil;
    if (self.connectionCallback != nil) {
        self.connectionCallback(NO);
    }
}


- (void) didWriteData:(DFBlunoDevice*) dev {
}


- (void) didReceiveData:(NSData*)data Device:(DFBlunoDevice*) dev {
    NSString* receivedStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* messages = [receivedStr componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString* message in messages) {
        if (self.receiveCallback != nil) {
            self.receiveCallback(message);
        }
    }
}

@end