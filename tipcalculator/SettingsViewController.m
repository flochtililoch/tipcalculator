//
//  SettingsViewController.m
//  tipcalculator
//
//  Created by Florent Bonomo on 9/20/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic) NSUserDefaults *settings;
@property (nonatomic) NSDecimalNumber *badServiceTipPercentage;
@property (nonatomic) NSDecimalNumber *averageServiceTipPercentage;
@property (nonatomic) NSDecimalNumber *goodServiceTipPercentage;
@property (nonatomic) NSDecimalNumber *outstandingServiceTipPercentage;

- (void)badServiceTipPercentageTextFieldDidFinishEditing:(UITextField *)textField;
- (void)averageServiceTipPercentageTextFieldDidFinishEditing:(UITextField *)textField;
- (void)goodServiceTipPercentageTextFieldDidFinishEditing:(UITextField *)textField;
- (void)outstandingServiceTipPercentageTextFieldDidFinishEditing:(UITextField *)textField;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load settings

    
    NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
    NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    
    self.settings = [NSUserDefaults standardUserDefaults];
    
    // Extract tip percentage values from settings
    self.badServiceTipPercentage = [self.settings objectForKey:@"badServiceTipPercentage"];
    self.averageServiceTipPercentage = [self.settings objectForKey:@"averageServiceTipPercentage"];
    self.goodServiceTipPercentage = [self.settings objectForKey:@"goodServiceTipPercentage"];
    self.outstandingServiceTipPercentage = [self.settings objectForKey:@"outstandingServiceTipPercentage"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Tip Percentages";
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Create an instance of UITableViewCell with default appearance
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // Set cell content
    if ([indexPath section] == 0) {
        
        // Create a textfield for user input
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(180, 5, 120, 35)];
        textField.adjustsFontSizeToFitWidth = YES;
        textField.placeholder = @"%";
        textField.textAlignment = NSTextAlignmentRight;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = self;
        [cell.contentView addSubview:textField];
        
        NSNumberFormatter *percentageFormatter = [[NSNumberFormatter alloc] init];
        [percentageFormatter setNumberStyle:NSNumberFormatterPercentStyle];

        // Set each cell's unique label and text field
        switch ([indexPath row]) {
            case 0:
                [cell.textLabel setText:@"Bad Service"];
                textField.text = [percentageFormatter stringFromNumber:self.badServiceTipPercentage];
                [textField addTarget:self
                              action:@selector(badServiceTipPercentageTextFieldDidFinishEditing:)
                    forControlEvents:UIControlEventEditingDidEnd];
                break;
                
            case 1:
                [cell.textLabel setText:@"Average Service"];
                textField.text = [percentageFormatter stringFromNumber:self.averageServiceTipPercentage];
                [textField addTarget:self
                              action:@selector(averageServiceTipPercentageTextFieldDidFinishEditing:)
                    forControlEvents:UIControlEventEditingDidEnd];
                break;
                
            case 2:
                [cell.textLabel setText:@"Good Service"];
                textField.text = [percentageFormatter stringFromNumber:self.goodServiceTipPercentage];
                [textField addTarget:self
                              action:@selector(goodServiceTipPercentageTextFieldDidFinishEditing:)
                    forControlEvents:UIControlEventEditingDidEnd];
                break;
                
            case 3:
                [cell.textLabel setText:@"Outstanding Service"];
                textField.text = [percentageFormatter stringFromNumber:self.outstandingServiceTipPercentage];
                [textField addTarget:self
                              action:@selector(outstandingServiceTipPercentageTextFieldDidFinishEditing:)
                    forControlEvents:UIControlEventEditingDidEnd];
                break;
                
            default:
                break;
        }
        
    }
    
    // Disable cell selection
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)badServiceTipPercentageTextFieldDidFinishEditing:(UITextField *)textField {
    
}

- (void)averageServiceTipPercentageTextFieldDidFinishEditing:(UITextField *)textField {
    
}

- (void)goodServiceTipPercentageTextFieldDidFinishEditing:(UITextField *)textField {
    
}

- (void)outstandingServiceTipPercentageTextFieldDidFinishEditing:(UITextField *)textField {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
