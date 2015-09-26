//
//  ViewController.m
//  tipcalculator
//
//  Created by Florent Bonomo on 9/20/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "TipViewController.h"
#import "AppDelegate.h"

@interface TipViewController ()

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UIView *resultsView;
@property (strong, nonatomic) Tip *tip;
@property (strong, nonatomic) NSNumberFormatter *amountFormatter;
@property (strong, nonatomic) NSNumberFormatter *percentageFormatter;

- (IBAction)onBillAmoutChange:(id)sender;
- (IBAction)onTipPercentageChange:(id)sender;
- (IBAction)onTotalLabelTap:(id)sender;

@end


@implementation TipViewController

- (Tip *)tip {
    if (!_tip) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        _tip = appDelegate.tipModel;
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
    
    self.resultsView.hidden = YES;
    
    // Update values when app comes back from background
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateValues)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateValues];
    [self.billTextField becomeFirstResponder];
}

- (void)updateValues {
    
    // Update text field placeholder with correct localized currency symbol
    self.billTextField.placeholder = [self.amountFormatter currencySymbol];
    
    // Update segmented control with latest tip values
    [self.tipControl removeAllSegments];
    for (NSUInteger i = 0; i < self.tip.tipValues.count; i++) {
        [self.tipControl insertSegmentWithTitle:[self.percentageFormatter stringFromNumber:self.tip.tipValues[i]]
                                        atIndex:i
                                       animated:NO];
    }
    self.tipControl.selectedSegmentIndex = self.tip.selectedTipIndex;

    if (self.tip.billAmount) {

        // Pop results view up as soon as results exist
        if (self.resultsView.hidden == YES) {
            self.resultsView.alpha = 0;
            self.resultsView.hidden = NO;
            [UIView animateWithDuration:.2 animations:^{
                self.resultsView.center = CGPointMake(self.resultsView.center.x, self.resultsView.center.y - 200);
                self.resultsView.alpha = 1;
            }];
        }

        // Set amount labels with local-formatted values
        self.tipLabel.text = [self.amountFormatter stringFromNumber:[self.tip getFinalTipAmount]];
        self.totalLabel.text = [self.amountFormatter stringFromNumber:[self.tip getFinalTotalAmount]];

    } else {
    
        // Fade results view away as soon as results are cleared
        if (self.resultsView.hidden == NO) {
            self.resultsView.alpha = 1;
            [UIView animateWithDuration:.2 animations:^{
                self.resultsView.alpha = 0;
            }completion:^(BOOL finished) {
                self.resultsView.hidden = YES;
            }];
        }
        
        // Clear labels
        self.billTextField.text = @"";
        self.tipLabel.text = @"";
        self.totalLabel.text = @"";
    }
}

- (IBAction)onBillAmoutChange:(id)sender {
    
    // toggle rounding setting off
    self.tip.roundTotalAmount = NO;
    
    if (self.billTextField.text.length > 0) {
        
        // Parse bill amount input value according to locale settings and set result to model
        NSDecimalNumber *newBillAmount = [[NSDecimalNumber alloc]initWithString:self.billTextField.text
                                                                         locale:[NSLocale currentLocale]];
        [self.tip setBillAmount:newBillAmount];
    } else {
        
        // Clear bill amount model value
        [self.tip setBillAmount:nil];
    }
    
    [self updateValues];
}

- (IBAction)onTipPercentageChange:(id)sender {

    // toggle rounding setting off
    self.tip.roundTotalAmount = NO;
    
    // Update model with latest selected tip percentage
    self.tip.selectedTipIndex = (int) self.tipControl.selectedSegmentIndex;
    
    [self updateValues];
}

- (IBAction)onTotalLabelTap:(id)sender {
    
    // toggle rounding setting
    self.tip.roundTotalAmount = !self.tip.roundTotalAmount;

    [self updateValues];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([0-9]+)?((\\.|,)([0-9]{0,2})?)?$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];

    // Enforce decimal input only
    return numberOfMatches != 0;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return NO;
}

@end
