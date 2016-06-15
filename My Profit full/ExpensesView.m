//
//  ExpensesView.m
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/12/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExpensesView.h"
#import "EditExpensesItem.h"
#import "Helper.h"

@interface ExpensesView ()
@end

@implementation ExpensesView
@synthesize context, ExpensesTable, allExpenses;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [Helper giveCoreDataPermissions];
    
    self.allExpenses = [self showExpenses];
    
    [self.SortPickMonth setBackgroundColor:[UIColor whiteColor]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.ExpensesTable reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.SortPickMonth.hidden = YES;
    
    self.SortView.hidden = YES;
    
    [self.grayView removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allExpenses count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Row is selected!!!");
    
    self.cellData = [self GetCellStrings:tableView : indexPath];
    
    [self performSegueWithIdentifier: @"showEditExpensesItem" sender: self];
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////// Enable Editing and Deleting Income//////////////////////////////////////////////

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self DeleteExpenses:[self GetCellDetails:tableView : indexPath]];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (NSArray *)GetCellStrings:(UITableView *)tableView : (NSIndexPath *) indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *dateT = selectedCell.textLabel.text;
    NSLog(@"CELL Date: %@", dateT);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *itemDate = [dateFormatter dateFromString:dateT];
    
    NSString *itemDetails = selectedCell.detailTextLabel.text;
    //NSLog(@"CELL itemDetails: %@", itemDetails);
    NSArray *array = [itemDetails componentsSeparatedByString:@","];
    
    NSString *itemAmountFromArray = array[0];
    NSString *itemAmount = [itemAmountFromArray stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"CELL Amount: %@", itemAmount);
    
    NSString *itemDescrFromArray = array[1];
    NSString *itemDescr = [itemDescrFromArray stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"CELL itemDescr: %@", itemDescr);
    
    NSString *itemID;
    itemID = [NSString stringWithFormat: @"%@-%@", [dateFormatter stringFromDate:itemDate], itemAmount];
    NSArray *myArray = [NSArray arrayWithObjects: dateT, itemAmount, itemDescr, nil];
    return myArray;
}

-(NSPredicate*)GetCellDetails: (UITableView *)tableView : (NSIndexPath *) indexPath{
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *dateT = selectedCell.textLabel.text;
    NSLog(@"CELL Date: %@", dateT);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *itemDate = [dateFormatter dateFromString:dateT];
    
    NSString *itemDetails = selectedCell.detailTextLabel.text;
    //NSLog(@"CELL itemDetails: %@", itemDetails);
    NSArray *array = [itemDetails componentsSeparatedByString:@","];
    
    NSString *itemAmountFromArray = array[0];
    NSString *itemAmount = [itemAmountFromArray stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"CELL Amount: %@", itemAmount);
    
    NSString *itemDescrFromArray = array[1];
    NSString *itemDescr = [itemDescrFromArray stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"CELL itemDescr: %@", itemDescr);
    
    NSString *itemID;
    itemID = [NSString stringWithFormat: @"%@-%@", [dateFormatter stringFromDate:itemDate], itemAmount];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"(id == %@) AND (amount == %@) AND (expenses_desc == %@)", itemID, itemAmount, itemDescr];
    return p;
}

-(void)DeleteExpenses:(NSPredicate*) predicate{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Expenses"];
    
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if(!error && result.count > 0){
        NSManagedObject *managedObject = result[0];
        [context deleteObject:managedObject];
        
        //Save context to write to store
        [context save:nil];
    }
    self.allExpenses = [self showExpenses];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////// Getting and building cell with income data //////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"expensesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // More initializations if needed.
    }
    // Set up the cell...
    
    ExpensesView *info = [self.allExpenses objectAtIndex:indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:[info valueForKey:@"date"]];
    cell.textLabel.text = stringFromDate;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [[info valueForKey:@"amount"] stringValue], [info valueForKey:@"expenses_desc"]];
    return cell;
}

- (NSArray *)showExpenses{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expenses" inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error: &error];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[fetchedObjects count]];
    NSEnumerator *enumerator = [fetchedObjects reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

////////////////////////////////////////////////////////////////////////////////////////////
/////////////Sending data/////////////////////////////////////////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Sending data to Edit Item View Controller
    if ([segue.identifier isEqualToString:@"showEditExpensesItem"]) {
        EditExpensesItem *destViewController = segue.destinationViewController;
        destViewController.Date = _cellData[0];
        destViewController.Amount = _cellData[1];
        destViewController.Description = _cellData[2];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BackBttn:(id)sender{
    [self performSegueWithIdentifier: @"MainView" sender: self];
}

/////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////Sorting procedures and functions
- (IBAction)showSortView:(id)sender {
    self.SortPickMonth.hidden = YES;
    if (self.SortView.hidden == YES) {
        self.SortView.hidden = NO;
    }
    else{
        self.SortView.hidden = YES;
    }
}

- (IBAction)SortByDateBttn:(id)sender {
    if(self.SortDate == 0){
        [self SortDateDown];
    }else{
        [self SortDateUp];
    }
}

- (IBAction)SortByAmount:(id)sender {
    if(self.SortAmount == 0){
        [self SortAmountDown];
    }else{
        [self SortAmountUp];
    }
}

- (IBAction)SortThisMonth:(id)sender {
    self.allExpenses = [self showThisMonthExpenses];
    [self viewDidAppear:YES];
}

- (IBAction)SortSelectMonth:(id)sender {
    if (self.SortPickMonth.hidden == YES) {
        self.grayView = [Helper setMask:self.view: self.SortPickMonth];
        self.SortPickMonth.hidden = NO;
    } else {
        self.SortPickMonth.hidden = YES;
        [self.grayView removeFromSuperview];
    }
}

- (NSArray *)showThisMonthExpenses{
    
    NSDate *startDate;
    NSDate *endDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    startDate = [dateFormat dateFromString: [NSString stringWithFormat:@"01-%@", [Helper CurrentMonth]]];
    endDate = [dateFormat dateFromString: [NSString stringWithFormat:@"30-%@", [Helper CurrentMonth]]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Expenses" inManagedObjectContext:self.context]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:request error: &error];
    
    return fetchedObjects;
}

-(void)SortAmountUp{
    self.SortAmount = 0;
    NSLog(@"Sorting by Amount Up");
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:NO];
    self.allExpenses = [self.allExpenses sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    [self.ExpensesTable reloadData];
}
-(void)SortAmountDown{
    self.SortAmount = 1;
    NSLog(@"Sorting by Amount Down");
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"amount" ascending:YES];
    self.allExpenses = [self.allExpenses sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    [self.ExpensesTable reloadData];
}
-(void)SortDateUp{
    self.SortDate = 0;
    NSLog(@"Sorting by Date Up");
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    self.allExpenses = [self.allExpenses sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    [self.ExpensesTable reloadData];
}
-(void)SortDateDown{
    self.SortDate = 1;
    NSLog(@"Sorting by Date Down");
    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    self.allExpenses = [self.allExpenses sortedArrayUsingDescriptors:@[dateSortDescriptor]];
    [self.ExpensesTable reloadData];
}
- (IBAction)SortReset:(id)sender {
    self.allExpenses = [self showExpenses];
    [self.SortSelectMonth setTitle:@"Select Month" forState:UIControlStateNormal];
    [self.ExpensesTable reloadData];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
////// Month Picker View
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)SelectMonthCategory
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)SelectMonthCategory numberOfRowsInComponent:(NSInteger)component
{
    return [Helper All12Month].count;
}

- (NSString *) pickerView: (UIPickerView *) SelectMonthCategory titleForRow: (NSInteger) row forComponent: (NSInteger) component{
    return [[Helper All12Month] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)SelectMonthCategory didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *setTitle = ([NSString stringWithFormat:@"Month: %@",[[Helper All12Month] objectAtIndex:row]]);
    
    [self.SortSelectMonth setTitle:setTitle forState:UIControlStateNormal];
    
    self.allExpenses = [self showSelectedMonthExpenses: row];
    //NSLog(@"ROW: %@", [@(row) stringValue]);
    [self viewDidAppear:YES];
}

- (NSArray *)showSelectedMonthExpenses: (NSInteger)Month{
    NSDate *startDate;
    NSDate *endDate;
    
    NSString *LastDayDate = [Helper lastDayMonth:Month];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    NSString *getMonth = [LastDayDate componentsSeparatedByString:@"-"][1];
    NSString *getYear =[[Helper CurrentMonth] componentsSeparatedByString:@"-"][1];
    
    startDate = [dateFormat dateFromString: [NSString stringWithFormat:@"01-%@-%@", getMonth, getYear]];
    endDate = [dateFormat dateFromString: LastDayDate];
    
    //NSLog(@"START DATE: %@", startDate);
    //NSLog(@"END DATE: %@", endDate);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Expenses" inManagedObjectContext:self.context]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:request error: &error];
    
    return fetchedObjects;
}
@end