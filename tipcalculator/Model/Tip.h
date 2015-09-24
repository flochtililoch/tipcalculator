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

- (NSDecimalNumber *) getTipAmount;
- (NSDecimalNumber *) getTotalAmount;
- (void) clear;
- (void) setTipValueForIndex: (NSDecimalNumber *) value forIndex:(int) index;

@end