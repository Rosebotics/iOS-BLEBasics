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

@end

@implementation RHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bleAdapter = [[RHBluetoothLEAdapter alloc] initWithConnectionCallback:^(BOOL isConnected) {
        self.connectionStatusLabel.text = isConnected ? @"Ready!" : @"Not ready";
    }
                                                               receiveCallback:^(NSString* commandReceived) {
                                                                   // TODO: Display the message.
                                                               }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedSearch:(id)sender {
    [self.bleAdapter showConnectionDialog];
}

- (IBAction)pressedSend:(id)sender {
    NSLog(@"TODO: Implement send for %@", self.commandTextField.text);
    [self.bleAdapter sendCommand:self.commandTextField.text];
}

- (IBAction)textFieldEditingDidEnd:(id)sender {
    NSLog(@"TODO: Implement same send");
}

@end
