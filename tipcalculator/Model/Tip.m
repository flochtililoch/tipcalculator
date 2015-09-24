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
    [self init].billAmount = nil;
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

- (NSDecimalNumber *)getTotalAmount {
    return [self.billAmount decimalNumberByAdding:[self getTipAmount]];
}

@end
