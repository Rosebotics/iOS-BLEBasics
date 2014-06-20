//
//  RHViewController.m
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import "RHViewController.h"

#import "RHBluetoothLEAdapter.h"

@interface RHViewController ()
@property (nonatomic) int lastLeftDutyCycleSent;
@property (nonatomic) int lastRightDutyCycleSent;
@property (nonatomic, strong) NSDate* lastTimeSent;

@end

@implementation RHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bleAdapter = [[RHBluetoothLEAdapter alloc] initWithConnectionCallback:^(BOOL isConnected) {
        self.connectionStatusLabel.text = isConnected ? @"Ready!" : @"Not ready";
    }
                                                               receiveCallback:^(NSString* commandReceived) {
                                                                   self.receivedCommands.text = commandReceived;
                                                               }];

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver: self
                           selector: @selector(onJoystickChanged:)
                               name: @"StickChanged"
                             object: nil];

    self.lastLeftDutyCycleSent = 0;
    self.lastRightDutyCycleSent = 0;
    self.lastTimeSent = [NSDate date];
}


- (IBAction)pressedSearch:(id)sender {
    [self.bleAdapter showConnectionDialog];
}


- (IBAction)pressedSend:(id)sender {
    if ([self.bleAdapter sendCommand:self.commandTextField.text]) {
        self.commandTextField.text = @"";
    } else {
        self.receivedCommands.text = @"Command not sent.";
        [self performSelector:@selector(clearReceivedCommands) withObject:nil afterDelay:2.0];
    }
}


- (void) clearReceivedCommands {
    self.receivedCommands.text = @"";
}


// Sent a PWM command when the joystick moves.
- (void) onJoystickChanged:(id)notification {
    NSDictionary *dict = [notification userInfo];
    NSValue *vdir = [dict valueForKey:@"dir"];
    CGPoint dir = [vdir CGPointValue];

    // X is 1.00 at the right (-1 at the left)
    // Y is 1.00 at the bottom (-1 at the top)
    CGFloat horzValue = dir.x * 255.0;  // -255 (left) to 255 (right)
    CGFloat vertValue = -dir.y * 255.0; // -255 (bottom) to 255 (top)

    // Make near center readings exactly center
    horzValue = abs(horzValue) < 30.0 ? 0 : horzValue;
    vertValue = abs(vertValue) < 30.0 ? 0 : vertValue;

    // Mix the analog joystick values to make pwm values. (simple mix)
    int leftDutyCycle = vertValue + horzValue; // If joystick is right make the left PWM higher.
    int rightDutyCycle = vertValue - horzValue; // If joystick is left make the right PWM higher.

    // Cap the duty cycle values at -255 and 255
    leftDutyCycle = leftDutyCycle > 255 ? 255 : leftDutyCycle;
    rightDutyCycle = rightDutyCycle > 255 ? 255 : rightDutyCycle;
    leftDutyCycle = leftDutyCycle < -255 ? -255 : leftDutyCycle;
    rightDutyCycle = rightDutyCycle < -255 ? -255 : rightDutyCycle;

    // Determine if the change is worth mentioning to the tank.
    // Must be a big enough change and we don't want to overload the buffer.
    NSTimeInterval timeSinceLastSendS = -[self.lastTimeSent timeIntervalSinceNow];
    if ((timeSinceLastSendS > 0.2 &&
         (abs(leftDutyCycle - self.lastLeftDutyCycleSent) > 5 ||
          abs(rightDutyCycle - self.lastRightDutyCycleSent) > 5)) ||
        leftDutyCycle == 0 || rightDutyCycle == 0) {
        self.lastLeftDutyCycleSent = leftDutyCycle;
        self.lastRightDutyCycleSent = rightDutyCycle;
        self.lastTimeSent = [NSDate date];
        NSString* strTemp = [NSString stringWithFormat:@"PWM %d %d", leftDutyCycle, rightDutyCycle];
        [self.bleAdapter sendCommand:strTemp];
    }
    [self.commandTextField resignFirstResponder];
}

@end
