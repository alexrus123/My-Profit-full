//
//  Helper.m
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/26/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 80.0

#import <Foundation/Foundation.h>
#import "Helper.h"

@interface Helper ()

@end

@implementation Helper

+(NSManagedObjectContext *)giveCoreDataPermissions{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    return context;
}

+(void)NoDataLabel: (UIView *) view{
    NSLog(@"EMPTY SCREEN:");
    UILabel *EmptyGraph = [[UILabel alloc] initWithFrame:CGRectMake(60, view.bounds.size.height/2-100, 300, 100)];
    EmptyGraph.font = [UIFont systemFontOfSize:15];
    EmptyGraph.numberOfLines = 0;
    EmptyGraph.textAlignment = NSTextAlignmentCenter;
    EmptyGraph.text = @"No DATA YET!!! \nTo start tap '+' in the top-left corner of the screen!!! Good luck...";
    EmptyGraph.tag = 11;
    [view addSubview:EmptyGraph];
}

+(void)DrawCoordinates: (UIView *)view{
    UIView * graphX = [[UIView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height-60, view.bounds.size.width, 2)];
    //graphX.backgroundColor = [UIColor blackColor];
    graphX.backgroundColor = [UIColor colorWithRed:(160/255.0) green:(97/255.0) blue:(5/255.0) alpha:1];
    [view addSubview:graphX];
    
    UIView *graphY = [[UIView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height-60, 2, -(view.bounds.size.height*2/3))];
    graphY.backgroundColor = [UIColor colorWithRed:(160/255.0) green:(97/255.0) blue:(5/255.0) alpha:1];
    //graphY.backgroundColor = [UIColor blackColor];
    [view addSubview:graphY];
}

+(void)DrawCoordinatesLabelsY: (UIView *) view :(double)HighestIncomeValue : (double)HighestExpensesValue{
    
    UILabel *HighVal = [[UILabel alloc] initWithFrame:CGRectMake(3, view.bounds.size.height-60-view.bounds.size.height*2/3, 40, 10)];//1.3
    HighVal.font = [UIFont systemFontOfSize:11];
    NSString *valLabel;
    if (HighestIncomeValue>HighestExpensesValue){
        valLabel = [@(HighestIncomeValue) stringValue];
    }else{valLabel = [@(HighestExpensesValue) stringValue];}
    HighVal.textColor = [UIColor whiteColor];
    HighVal.text = valLabel;
    HighVal.tag = 11;
    [view addSubview:HighVal];
    
    UILabel *MidVal = [[UILabel alloc] initWithFrame:CGRectMake(3, (view.bounds.size.height+60)/2, 40, 10)];
    MidVal.font = [UIFont systemFontOfSize:11];
    NSString *midValLabel;
    if (HighestIncomeValue>HighestExpensesValue){
        midValLabel = [@(HighestIncomeValue/2) stringValue];
    }else{midValLabel = [@(HighestExpensesValue/2) stringValue];}
    MidVal.textColor = [UIColor whiteColor];
    MidVal.text = midValLabel;
    MidVal.tag = 11;
    [view addSubview:MidVal];
}

+(NSString *)lastDayMonth: (NSInteger)Month{
    NSString *getMonth;
    Month = Month + 1;
    if (Month < 10) {
        getMonth = [NSString stringWithFormat:@"0%ld", (long)Month];
    }else{
        getMonth = [NSString stringWithFormat:@"%ld", (long)Month];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *getYear =[[Helper CurrentMonth] componentsSeparatedByString:@"-"][1];
    
    NSDate *curDate = [dateFormat dateFromString: [NSString stringWithFormat:@"01-%@-%@", getMonth, getYear]];
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    
    NSRange daysRange =[currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:curDate];
    
    //NSLog(@"LAST DAY: %@", @(daysRange.length).stringValue);
    NSString *lastDayMonth = [NSString stringWithFormat:@"%@-%@-%@",@(daysRange.length).stringValue,getMonth,getYear];
    return  lastDayMonth;
}

+(NSString*)CurrentMonth{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    return dateString;
}

+(NSArray *)All12Month{
    NSArray *MonthPickerData = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    return MonthPickerData;
}
+(UIView *)setMask: (UIView *)fadeView :(UIView *)YourSubview {
    UIView *mask = [[UIView alloc] initWithFrame: fadeView.frame];
    [mask setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.78]];
    [fadeView addSubview: mask];
    [fadeView addSubview: YourSubview];
    return mask;
}

///////Controlling view scroll/////

@end