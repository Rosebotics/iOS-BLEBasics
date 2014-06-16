//
//  RHViewController.h
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RHBluetoothLEAdapter;

@interface RHViewController : UIViewController

@property (strong, nonatomic) RHBluetoothLEAdapter* bleAdapter;
@property (strong, nonatomic) IBOutlet UITextField* commandTextField;
@property (strong, nonatomic) IBOutlet UILabel* connectionStatusLabel;

- (IBAction) pressedSearch:(id) sender;
- (IBAction) pressedSend:(id) sender;
- (IBAction) textFieldEditingDidEnd:(id) sender;

@end
