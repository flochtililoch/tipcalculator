//
//  Tip.m
//  tipcalculator
//
//  Created by Florent Bonomo on 9/21/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import "Tip.h"

@interface Tip()

@property (nonatomic) NSUserDefaults *settings;

@end


@implementation Tip

- (id)init {
    if (self = [super init])  {
        self.selectedTipIndex = self.defaultTipIndex;
    }
    return self;
}

- (void)clear {
    (void) [self init];
    self.billAmount = nil;
    self.roundTotalAmount = NO;
}

@synthesize settings = _settings;

- (NSUserDefaults *)settings {
    if (!_settings) {
        // Load default settings from preferences list file, then merge with user's defaults
        NSURL *defaultPrefsFile = [[NSBundle mainBundle] URLForResource:@"DefaultPreferences" withExtension:@"plist"];
        NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];

        _settings = [NSUserDefaults standardUserDefaults];

    }
    return _settings;
}

- (void)setSettings:(NSUserDefaults *)settings {
    if (_settings != settings) {
        _settings = settings;
        
        // Automatically persists settings on changes
        [_settings synchronize];
    }
}

- (NSMutableArray *)tipValues {
    if (!_tipValues) {
        _tipValues = [[NSMutableArray alloc] init];
        for (NSString *tipValue in [self.settings objectForKey:@"tipValues"]) {
            [_tipValues addObject:[NSDecimalNumber decimalNumberWithString:tipValue]];
        }
    }
    return _tipValues;
}

- (void)persistTipValues {
    NSMutableArray *defaultTipValues = [[NSMutableArray alloc] init];
    for (NSDecimalNumber *tipValue in self.tipValues) {
        [defaultTipValues addObject:[tipValue stringValue]];
    }
    
    // Persists tip values back in user's defaults
    [self.settings setObject:[defaultTipValues copy] forKey:@"tipValues"];
}

- (void)setTipValueForIndex: (NSDecimalNumber *) value forIndex:(int) index {
    [self.tipValues replaceObjectAtIndex:index withObject:value];
    [self persistTipValues];
}

- (int)defaultTipIndex {
    if (!_defaultTipIndex) {
        _defaultTipIndex = [[self.settings objectForKey:@"defaultTipIndex"] intValue];
    }
    return _defaultTipIndex;
}

- (NSDecimalNumber *)getTipAmount {
    return [self.tipValues[self.selectedTipIndex] decimalNumberByMultiplyingBy:self.billAmount];
}

- (NSDecimalNumber *)getFinalTipAmount {
    NSDecimalNumber *finalTipAmount = [self getTipAmount];
    if (self.roundTotalAmount) {
        NSDecimalNumber *pocketChange = [self getPocketChange];
        finalTipAmount = [finalTipAmount decimalNumberByAdding:pocketChange];
    }
    return finalTipAmount;
}

- (NSDecimalNumber *)getTotalAmount {
    return [self.billAmount decimalNumberByAdding:[self getTipAmount]];
}

- (NSDecimalNumber *)getFinalTotalAmount {
    return [self.billAmount decimalNumberByAdding:[self getFinalTipAmount]];
}

- (BOOL)roundTotalAmount {
    if (!_roundTotalAmount) {
        _roundTotalAmount = NO;
    }
    return _roundTotalAmount;
}

- (NSDecimalNumber *)getPocketChange {
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                             scale:0
                                                                                  raiseOnExactness:NO
                                                                                   raiseOnOverflow:NO
                                                                                  raiseOnUnderflow:NO
                                                                               raiseOnDivideByZero:NO];
    NSDecimalNumber *totalAmountWithPocketChange = [[self getTotalAmount] decimalNumberByRoundingAccordingToBehavior:behavior];
    NSDecimalNumber *pocketChange = [totalAmountWithPocketChange decimalNumberBySubtracting:[self getTotalAmount]];

    return pocketChange;
}


@end
