//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Florent Bonomo on 9/20/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@property (strong, nonatomic) NSNumberFormatter *percentageFormatter;
- (IBAction)onTipPercentageStepperChange:(id)sender;

@end

@implementation SettingsViewController

- (Tip *)tip {
    if (!_tip) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        _tip = appDelegate.tipModel;
    }
    return _tip;
}

- (NSNumberFormatter *)percentageFormatter {
    if (!_percentageFormatter) {
        _percentageFormatter = [[NSNumberFormatter alloc] init];
        [_percentageFormatter setNumberStyle: NSNumberFormatterPercentStyle];
    }
    return _percentageFormatter;
}

- (IBAction)onTipPercentageStepperChange:(id)sender {
    UIStepper *stepper = sender;
    NSDecimalNumber *newTipValue = [[NSDecimalNumber alloc] initWithDouble:(stepper.value / (double) 100)];
    [self.tip setTipValueForIndex:newTipValue forIndex:(int) stepper.tag];
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *sections = @[
                          @"Tip Percentages"
                        ];
    return sections[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipSettingCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TipSettingCell"];
    }
    
    NSArray *tipLabels = @[
                           @"Bad Service",
                           @"Average Service",
                           @"Good Service",
                           @"Outstanding Service"
                         ];
    UIStepper *stepper = cell.contentView.subviews[0];
    NSDecimalNumber *tipValue = self.tip.tipValues[[indexPath row]];
    [stepper setTag:[indexPath row]];
    stepper.value = [tipValue doubleValue] * (double) 100;
    UILabel *title = cell.contentView.subviews[1];
    UILabel *details = cell.contentView.subviews[2];
    
    [details setText:tipLabels[[indexPath row]]];
    [title setText:[self.percentageFormatter stringFromNumber:tipValue]];
    
    return cell;
}

@end
