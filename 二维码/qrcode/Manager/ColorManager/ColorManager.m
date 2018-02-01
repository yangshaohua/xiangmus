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
                             @"0xFFC1C1",
                             @"0xFFB90F",
                             @"0xFF8C00",
                             @"0xFF7F50",
                             @"0xFF3030",
                             
                             @"0xEEEE00",
                             @"0xEEC900",
                             @"0xEE3A8C",
                             @"0xEE00EE",
                             @"0xEE0000",
                             
                             @"0x8B8378",
                             @"0x8B7500",
                             @"0x8B4789",
                             @"0x8B4500",
                             @"0x8B0000",
                             
                             @"0x00FF00",
                             @"0x00EE76",
                             @"0x00BFFF",
                             @"0x008B45",
                             @"0x006400",
                             
                             @"0x778899",
                             @"0x737373",
                             @"0x5C5C5C",
                             @"0x3D3D3D",
                             @"0x000000",nil];
    
    return array;
}

+ (NSMutableArray *)logoArray
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                             @"logo0",
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
