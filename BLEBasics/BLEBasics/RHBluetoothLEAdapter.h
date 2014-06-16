//
//  RHBluetoothLEAdapter.h
//  BLEBasics
//
//  Created by David Fisher on 6/15/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DFBlunoManager.h"


@interface RHBluetoothLEAdapter : NSObject <DFBlunoDelegate>

- (id) initWithConnectionCallback:(void(^)(BOOL isConnected)) connectionCallback
                  receiveCallback:(void(^)(NSString* commandReceived)) receiveCallback;
- (void) showConnectionDialog;
- (BOOL) sendCommand:(NSString*) commandString;

@end
