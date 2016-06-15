//
//  ViewController.h
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/8/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface MainView : UIViewController <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddBttn;
@property (nonatomic,strong) NSManagedObjectContext* context;
@property (weak, nonatomic) IBOutlet UITextField *AverageAmount;

- (IBAction)OpenIncomeView:(id)sender;
- (IBAction)OpenExpensesView:(id)sender;


@end

