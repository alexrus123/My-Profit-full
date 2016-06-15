//
//  NewItemView.m
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/9/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewItemView.h"
#import "Helper.h"

@interface NewItemView ()

@end

@implementation NewItemView
@synthesize UIDatePick, DateLabel;
@synthesize context;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    // Do any additional setup after loading the view, typically from a nib.
    self.context = [Helper giveCoreDataPermissions];
    
    _CategoryPickerData = @[@"Income", @"Expenses"];
    self.UILabelCategory.text = self.CategoryPickerData[0];
    
    self.UIPickCategory.dataSource = self;
    self.UIPickCategory.delegate = self;
    
    self.DescriptionField.delegate = self;
    
    //self.DateLabel.textColor = [UIColor whiteColor];
    self.DateLabel.text = [self TodayDate];
    self.UIDatePick.datePickerMode = UIDatePickerModeDate;
    [self.UIDatePick addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.UIDatePick.hidden = YES;
    self.UIPickCategory.hidden = YES;
    self.UIDatePickViewUnder.hidden = YES;
    [self.AmountField resignFirstResponder];
    [self.DescriptionField resignFirstResponder];
    NSLog(@"ViewTapped");
}
- (IBAction)BackBttn:(id)sender{
    [self performSegueWithIdentifier: @"MainView" sender: self];
}

-(NSString*)TodayDate{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"TODAY DATE: %@", dateString);
    return dateString;
}

- (void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    NSLog(@"TODAY DATE: %@", strDate);
    self.DateLabel.text = strDate;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)UIPickCategory
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)UIPickCategory numberOfRowsInComponent:(NSInteger)component
{
    return _CategoryPickerData.count;
}

- (NSString *) pickerView: (UIPickerView *) UIPickCategory
              titleForRow: (NSInteger) row forComponent: (NSInteger) component{
    return [_CategoryPickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)UIPickCategory didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.UILabelCategory.text = [self.CategoryPickerData objectAtIndex:row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)UIPickCategory attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:[_CategoryPickerData objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (IBAction)ShowDateBttn:(id)sender
{
    [self.AmountField resignFirstResponder];
    [self.DescriptionField resignFirstResponder];
    //self.UIDatePick.hidden = NO;
    if (self.UIDatePick.hidden == NO) {
        self.UIDatePick.hidden = YES;
        self.UIDatePickViewUnder.hidden = YES;
    } else {
        if (self.UIPickCategory.hidden == NO) {
            self.UIPickCategory.hidden = YES;
        }
        self.UIDatePickViewUnder.hidden = NO;
        self.UIDatePick.hidden = NO;
    }
}

- (IBAction)SaveBttn:(id)sender {
    NSString *itemID;
    if ([self.UILabelCategory.text isEqualToString:@"Income"]) {
        NSLog(@"Saving Income");
        
        NSManagedObject *Income = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Income"
                                           inManagedObjectContext:self.context];
        
        [Income setValue:@([self.AmountField.text doubleValue]) forKey:@"amount"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateT = [dateFormatter dateFromString:self.DateLabel.text];
        //NSLog(@"DATA-DATA:", dateT);
        [Income setValue: dateT forKey:@"date"];
        
        //[Income setValue:self.DescriptionField.text forKey:@"income_desc"];
        [Income setValue:[self.DescriptionField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  forKey:@"income_desc"];
        
        itemID = [NSString stringWithFormat: @"%@-%@", [dateFormatter stringFromDate:dateT], self.AmountField.text];
        //itemID = [dateFormatter stringFromDate:dateT] + self.AmountField.text;
        //[formatter stringFromDate:[info valueForKey:@"date"]];
        [Income setValue:[itemID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  forKey:@"id"];
        
        NSError *error;
        if (![self.context save: &error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
    }
    else if([self.UILabelCategory.text isEqualToString: @"Expenses"]){
        NSLog(@"Saving Expenses");
        
        NSManagedObject *Income = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"Expenses"
                                   inManagedObjectContext:self.context];
        
        [Income setValue:@([self.AmountField.text doubleValue]) forKey:@"amount"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *dateT = [dateFormatter dateFromString:self.DateLabel.text];
        //NSLog(@"DATA-DATA:", dateT);
        [Income setValue: dateT forKey:@"date"];
        
        //[Income setValue:self.DescriptionField.text forKey:@"income_desc"];
        [Income setValue:[self.DescriptionField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  forKey:@"expenses_desc"];
        
        itemID = [NSString stringWithFormat: @"%@-%@", [dateFormatter stringFromDate:dateT], self.AmountField.text];
        //itemID = [dateFormatter stringFromDate:dateT] + self.AmountField.text;
        //[formatter stringFromDate:[info valueForKey:@"date"]];
        [Income setValue:[itemID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  forKey:@"id"];
        
        NSError *error;
        if (![self.context save: &error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }
}

- (IBAction)ShowPicker:(id)sender{
    [self.AmountField resignFirstResponder];
    [self.DescriptionField resignFirstResponder];
    NSString *GetLabelText;
    GetLabelText = self.UILabelCategory.text;
    NSUInteger indexOfTheObject = [self.CategoryPickerData indexOfObject: GetLabelText];
    [self.UIPickCategory reloadAllComponents];
    [self.UIPickCategory selectRow:indexOfTheObject inComponent:0 animated:YES];
    if (self.UIPickCategory.hidden == NO) {
        self.UIPickCategory.hidden = YES;
    }
    else{
        if (self.UIDatePick.hidden == NO) {
            self.UIDatePick.hidden = YES;
            self.UIDatePickViewUnder.hidden = YES;
        }
        self.UIPickCategory.hidden = NO;
    }
}

// Call this method somewhere in your view controller setup code.
/*
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}*/


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    self.UIDatePick.hidden = YES;
    self.UIDatePickViewUnder.hidden = YES;
    const int movementDistance = -90; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end