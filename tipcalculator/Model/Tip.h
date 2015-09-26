//
//  Tip.h
//  tipcalculator
//
//  Created by Florent Bonomo on 9/21/15.
//  Copyright © 2015 flochtililoch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tip : NSObject

@property (nonatomic) int defaultTipIndex;
@property (nonatomic) int selectedTipIndex;
@property (nonatomic) NSMutableArray *tipValues;
@property (nonatomic) NSDecimalNumber *billAmount;
@property (nonatomic) BOOL roundTotalAmount;

- (NSDecimalNumber *)getTipAmount;
- (NSDecimalNumber *)getFinalTipAmount;
- (NSDecimalNumber *)getTotalAmount;
- (NSDecimalNumber *)getFinalTotalAmount;
- (NSDecimalNumber *)getPocketChange;
- (void)clear;
- (void)setTipValueForIndex: (NSDecimalNumber *) value forIndex:(int) index;

@end