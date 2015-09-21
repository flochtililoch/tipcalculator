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

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateValues {
    if (self.billTextField.text.length > 0) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        
        NSArray *tipValues = @[[[NSDecimalNumber alloc]initWithFloat:.15], [[NSDecimalNumber alloc]initWithFloat:.18], [[NSDecimalNumber alloc]initWithFloat:.20]];
        NSDecimalNumber *tipValue = tipValues[self.tipControl.selectedSegmentIndex];
        
        NSDecimalNumber *billAmount = [[NSDecimalNumber alloc]initWithString:self.billTextField.text];
        NSDecimalNumber *tipAmount = [tipValue decimalNumberByMultiplyingBy:billAmount];
        NSDecimalNumber *totalAmount = [billAmount decimalNumberByAdding:tipAmount];

        self.billTextField.placeholder = [numberFormatter currencySymbol];
        self.tipLabel.text = [numberFormatter stringFromNumber:tipAmount];
        self.totalLabel.text = [numberFormatter stringFromNumber:totalAmount];
    } else {
        self.tipLabel.text = @"";
        self.totalLabel.text = @"";
    }
}

- (IBAction)onBillAmoutChange:(id)sender {
    [self updateValues];
}

- (IBAction)onTipPercentageChange:(id)sender {
    [self updateValues];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                        options:0
                                                          range:NSMakeRange(0, [newString length])];
    
    NSLog(@"FOOOO");
    if (numberOfMatches == 0)
        return NO;

    return YES;
}

@end
