//
//  EditItem.h
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/18/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface EditIncomeItem : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *EditAmount;
@property (strong, nonatomic) IBOutlet UILabel *EditDate;
@property (weak, nonatomic) IBOutlet UITextView *EditDescription;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (nonatomic,strong) NSManagedObjectContext* context;

- (IBAction)ShowDatePicker:(id)sender;
- (IBAction)UpdateCoreData:(id)sender;
- (IBAction)BackBttn:(id)sender;

@property NSString *Amount;
@property NSString *Date;
@property NSString *Description;


@end
