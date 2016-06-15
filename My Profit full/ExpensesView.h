//
//  ExpensesView.h
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/12/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface ExpensesView : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *ExpensesTable;
@property (nonatomic,retain) NSArray *allExpenses;
@property (weak, nonatomic) IBOutlet UIView *SortView;
@property (weak, nonatomic) IBOutlet UIPickerView *SortPickMonth;
@property (weak, nonatomic) IBOutlet UIButton *SortSelectMonth;
@property (nonatomic,strong) NSManagedObjectContext *context;

@property UIView *grayView;
@property NSArray *cellData;
@property int SortDate;
@property int SortAmount;

- (IBAction)BackBttn:(id)sender;
- (IBAction)showSortView:(id)sender;
- (IBAction)SortByDateBttn:(id)sender;
- (IBAction)SortByAmount:(id)sender;
- (IBAction)SortThisMonth:(id)sender;
- (IBAction)SortSelectMonth:(id)sender;
- (IBAction)SortReset:(id)sender;

@end
