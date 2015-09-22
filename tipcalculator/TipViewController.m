//
//  ViewController.m
//  tipcalculator
//
//  Created by Florent Bonomo on 9/20/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

- (IBAction)onBillAmoutChange:(id)sender;
- (IBAction)onTipPercentageChange:(id)sender;

@property (strong, nonatomic) Tip *tip;
@property (strong, nonatomic) NSNumberFormatter *amountFormatter;
@property (strong, nonatomic) NSNumberFormatter *percentageFormatter;

@end


@implementation TipViewController

- (Tip *)tip {
    if (!_tip) {
        _tip = [Tip sharedInstance];
    }
    return _tip;
}

- (NSNumberFormatter *)amountFormatter {
    if (!_amountFormatter) {
        _amountFormatter = [[NSNumberFormatter alloc] init];
        [_amountFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    }
    return _amountFormatter;
}

- (NSNumberFormatter *)percentageFormatter {
    if (!_percentageFormatter) {
        _percentageFormatter = [[NSNumberFormatter alloc] init];
        [_percentageFormatter setNumberStyle: NSNumberFormatterPercentStyle];
    }
    return _percentageFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateValues];
    [self.billTextField becomeFirstResponder];
}

- (void)updateValues {
    
    // Update input fields with correct values / localization settings
    self.billTextField.placeholder = [self.amountFormatter currencySymbol];
    [self.tipControl removeAllSegments];
    for (NSUInteger i = 0; i < self.tip.tipValues.count; i++) {
        [self.tipControl insertSegmentWithTitle:[self.percentageFormatter stringFromNumber:self.tip.tipValues[i]]
                                        atIndex:i
                                       animated:NO];
    }
    self.tipControl.selectedSegmentIndex = self.tip.selectedTipIndex;

    // Update labels
    if (self.billTextField.text.length > 0) {
        self.tipLabel.text = [self.amountFormatter stringFromNumber:[self.tip getTipAmount]];
        self.totalLabel.text = [self.amountFormatter stringFromNumber:[self.tip getTotalAmount]];
    } else {
        self.tipLabel.text = @"";
        self.totalLabel.text = @"";
        
    }
}

- (IBAction)onBillAmoutChange:(id)sender {
    [self.tip setBillAmount:[[NSDecimalNumber alloc]initWithString:self.billTextField.text]];
    [self updateValues];
}

- (IBAction)onTipPercentageChange:(id)sender {
    self.tip.selectedTipIndex = (int) self.tipControl.selectedSegmentIndex;
    [self updateValues];
}

// Enforce decimal input only
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];
    
    if (numberOfMatches == 0) {
        return NO;
    }
    
    return YES;
}

@end
