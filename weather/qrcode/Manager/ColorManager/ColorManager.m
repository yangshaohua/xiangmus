//
//  ColorManager.m
//  MortgageCalculator
//
//  Created by yangshaohua on 2018/1/16.
//  Copyright © 2018年 yangshaohua. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager
+ (NSMutableArray *)colorArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @"0x000000",
                             @"0xff0000",
                             @"0xd0d0d0",
                             @"0x00ff00",
                             @"0x0000ff",
                             @"0x00FFFF",
                             @"0x9400d3",
                             @"0x00BFFF",
                             @"0xE9967A",
                             @"0xF8F8FF",
                             @"0xDCDCDC",
                             @"0xB22222",
                             @"0x1E90FF",
                             @"0xBDB76B",
                             @"0xF0FFFF",
                             @"0xF5F5DC",
                             @"0xA52A2A",
                             @"0x7FFFD4",nil];
    
    return array;
}

+ (NSMutableArray *)logoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @"logo1",
                             @"logo2",
                             @"logo3",
                             @"logo4",
                             @"logo5",
                             @"logo6",
                             @"logo7",
                             @"logo8",nil];
    
    return array;
}
@end
