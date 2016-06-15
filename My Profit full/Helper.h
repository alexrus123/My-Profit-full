//
//  Helper.h
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/26/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface Helper : NSObject

+(UIView *)setMask: (UIView*)fadeView : (UIView *)YourSubview;
+(NSArray *)All12Month;
+(NSString*)CurrentMonth;
+(NSManagedObjectContext *)giveCoreDataPermissions;
+(NSString *)lastDayMonth: (NSInteger)Month;

+(void)NoDataLabel: (UIView *) view;
+(void)DrawCoordinates: (UIView *)view;
+(void)DrawCoordinatesLabelsY: (UIView *) view :(double)HighestIncomeValue : (double)HighestExpensesValue;

@end
