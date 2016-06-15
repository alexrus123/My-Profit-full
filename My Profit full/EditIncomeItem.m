//
//  EditIncomeItem.m
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/18/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditIncomeItem.h"

@interface EditIncomeItem ()
@end

@implementation EditIncomeItem
@synthesize context;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [Helper giveCoreDataPermissions];
    //Passing values from Income View Controller Item
    self.EditAmount.text = self.Amount;
    self.EditDate.text = self.Date;
    self.EditDescription.text = self.Description;
    self.EditDescription.delegate = self;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
    [self.DatePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerChanged:(UIDatePicker *)datePicker{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:datePicker.date];
    NSLog(@"TODAY DATE: %@", strDate);
    self.EditDate.text = strDate;
}

- (IBAction)ShowDatePicker:(id)sender {
    [self.EditAmount resignFirstResponder];
    [self.EditDescription resignFirstResponder];
    //self.UIDatePick.hidden = NO;
    if (self.DatePicker.hidden == NO) {
        self.DatePicker.hidden = YES;
    } else {
        self.DatePicker.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.DatePicker.hidden = YES;
    [self.EditAmount resignFirstResponder];
    [self.EditDescription resignFirstResponder];
}


//////////////////////////////////////////////////////////////////////////////////////////////////////
///////// Updating core data: Deleting old line and Creating new line in Income Entity
- (IBAction)UpdateCoreData:(id)sender {
    //Updating Core data with values from the View Controller
    //Step 1 - Deleting old value
    
    [self DeleteIncome:[self GetCellDetails]];
    
    //Step 2 - Adding New Value to the Core Data
    [self updatingData];
    
    //Sending user back to the Income List
    [self performSegueWithIdentifier: @"EditIncomeToIncomeView" sender: self];
}

-(void)updatingData{
    NSString *itemID;
    NSLog(@"Saving Income");
    
    NSManagedObject *Income = [NSEntityDescription insertNewObjectForEntityForName:@"Income" inManagedObjectContext:self.context];
    
    [Income setValue:@([self.EditAmount.text doubleValue]) forKey:@"amount"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateT = [dateFormatter dateFromString:self.EditDate.text];
    //NSLog(@"DATA-DATA:", dateT);
    [Income setValue: dateT forKey:@"date"];
    
    //[Income setValue:self.DescriptionField.text forKey:@"income_desc"];
    [Income setValue:[self.EditDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  forKey:@"income_desc"];
    
    itemID = [NSString stringWithFormat: @"%@-%@", [dateFormatter stringFromDate:dateT], self.EditAmount.text];
    
    [Income setValue:[itemID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]  forKey:@"id"];
    
    NSError *error;
    if (![self.context save: &error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

-(NSPredicate*)GetCellDetails{
    
    NSString *dateT = self.Date;
    NSLog(@"Updating Date: %@", dateT);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *itemDate = [dateFormatter dateFromString:dateT];
    
    NSString *itemAmount = [self.Amount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"Updating Amount: %@", itemAmount);
    
    NSString *itemDescr = [self.Description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"Updating itemDescr: %@", itemDescr);
    
    NSString *itemID;
    itemID = [NSString stringWithFormat: @"%@-%@", [dateFormatter stringFromDate:itemDate], itemAmount];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"(id == %@) AND (amount == %@) AND (income_desc == %@)", itemID, itemAmount, itemDescr];
    return p;
}

-(void)DeleteIncome:(NSPredicate*) predicate{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Income"];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(!error && result.count > 0){
        NSManagedObject *managedObject = result[0];
        [context deleteObject:managedObject];
        
        //Save context to write to store
        [context save:nil];
    }
}
/////////////End of Deleting and Updating Core Data
- (IBAction)BackBttn:(id)sender {
    [self performSegueWithIdentifier: @"EditIncomeToIncomeView" sender: self];
}

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