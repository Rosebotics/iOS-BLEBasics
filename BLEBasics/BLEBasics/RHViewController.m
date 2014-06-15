//
//  RHViewController.m
//  BLEBasics
//
//  Created by David Fisher on 6/14/14.
//  Copyright (c) 2014 Rose-Hulman. All rights reserved.
//

#import "RHViewController.h"

#import "RHListSelectionDialog.h"

@interface RHViewController ()

@end

@implementation RHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[[RHListSelectionDialog alloc] initWithTitle:@"Hi Dave"
                          allowMultipleSelections:NO
                          dismissOnFirstSelection:YES
                                        listItems:@[@"Dave", @"Bob", @"Frank"]
                                       okCallback:^(NSArray *selectedIndexes) {
                                           NSLog(@"selectedIndexes = %@", selectedIndexes);
                                       }] show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
