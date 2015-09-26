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

@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *tipLabels;
@property (strong, nonatomic) NSNumberFormatter *percentageFormatter;
@property (strong, nonatomic) Tip *tip;

- (IBAction)onTipPercentageStepperChange:(id)sender;

@end

@implementation SettingsViewController

- (NSArray *)sections {
    if (!_sections) {
        _sections = @[@"Tip Percentages"];
    }
    return _sections;
}

- (NSArray *)tipLabels {
    if (!_tipLabels) {
        _tipLabels = @[@"Bad Service", @"Average Service", @"Good Service", @"Great Service"];
    }
    return _tipLabels;
}

- (NSNumberFormatter *)percentageFormatter {
    if (!_percentageFormatter) {
        _percentageFormatter = [[NSNumberFormatter alloc] init];
        [_percentageFormatter setNumberStyle: NSNumberFormatterPercentStyle];
    }
    return _percentageFormatter;
}

- (Tip *)tip {
    if (!_tip) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        _tip = appDelegate.tipModel;
    }
    return _tip;
}

- (IBAction)onTipPercentageStepperChange:(id)sender {
    UIStepper *stepper = sender;
    
    // Update tip percentage model with selected stepper value
    NSDecimalNumber *newTipValue = [[NSDecimalNumber alloc] initWithDouble:(stepper.value / (double) 100)];
    [self.tip setTipValueForIndex:newTipValue forIndex:(int) stepper.tag];
    
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sections[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.tipLabels count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if([indexPath section] == 0) {

        cell = [tableView dequeueReusableCellWithIdentifier:@"TipSettingCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TipSettingCell"];
        }

        NSDecimalNumber *tipValue = self.tip.tipValues[[indexPath row]];

        UIStepper *stepper = cell.contentView.subviews[0];
        [stepper setTag:[indexPath row]];
        stepper.value = [tipValue doubleValue] * (double) 100;

        UILabel *title = cell.contentView.subviews[1];
        UILabel *details = cell.contentView.subviews[2];
        [details setText:self.tipLabels[[indexPath row]]];
        [title setText:[self.percentageFormatter stringFromNumber:tipValue]];

    }
    return cell;
}

@end
