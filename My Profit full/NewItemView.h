//
//  NewItemView.h
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/9/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Helper.h"

@interface NewItemView : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

- (IBAction)ShowPicker:(id)sender;
- (IBAction)ShowDateBttn:(id)sender;
- (IBAction)SaveBttn:(id)sender;
- (IBAction)BackBttn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *UIDatePick;
@property (weak, nonatomic) IBOutlet UIView *UIDatePickViewUnder;
@property (strong, nonatomic) IBOutlet UIPickerView *UIPickCategory;
@property (weak, nonatomic) IBOutlet UILabel *UILabelCategory;
@property (weak, nonatomic) IBOutlet UITextField *AmountField;
@property (weak, nonatomic) IBOutlet UITextField *DescriptionField;
@property (strong, nonatomic) NSManagedObjectContext* context;

@property NSArray *CategoryPickerData;


@end
