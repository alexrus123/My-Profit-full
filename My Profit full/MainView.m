//
//  ViewController.m
//  My Profit full
//
//  Created by Aliaksei Lyskovich on 4/8/15.
//  Copyright (c) 2015 Aliaksei Lyskovich. All rights reserved.
//

#import "MainView.h"

@interface MainView ()
@property int whichView;
@end

@implementation MainView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [Helper giveCoreDataPermissions];
    
    [self drawIncome12Month:[self getIncomeByMonth:[self GetAnnualIncomeByMonth]]: [self getExpensesByMonth:[self GetAnnualExpensesByMonth]]];
    self.AverageAmount.textAlignment = NSTextAlignmentCenter;
    self.AverageAmount.text = [self CalculateAverage: [self getIncomeByMonth:[self GetAnnualIncomeByMonth]]: [self getExpensesByMonth:[self GetAnnualExpensesByMonth]]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
}
-(NSString *)CalculateAverage: (NSMutableDictionary *)income :(NSMutableDictionary *)expenses {
    double MonthIncome = 0;
    double MonthExpenses = 0;
    
    for (int i=1; i<=12; i++){
        MonthIncome += [[income objectForKey:[@(i) stringValue]]doubleValue];
        MonthExpenses += [[expenses objectForKey:[@(i) stringValue]]doubleValue];
    }
    MonthIncome = MonthIncome / 12;
    MonthExpenses = MonthExpenses / 12;
    NSString *result = ([NSString stringWithFormat:@"Annual Average: \n\n$%.2lf/$%.2lf", MonthIncome, MonthExpenses]);
    return result;
}
-(IBAction)AddBttn:(id)sender
{
    [self performSegueWithIdentifier: @"AddNewItemNow" sender: self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (self.whichView == 1) {
        [self drawIncome12Month:[self getIncomeByMonth:[self GetAnnualIncomeByMonth]]: [self getExpensesByMonth:[self GetAnnualExpensesByMonth]]];
        [self viewDidAppear:YES];
    }else if (self.whichView == 0){
        [self DrawGraph: [self CalculateIncome]: [self CalculateExpenses]];
    }
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"X location: %f", point.x);
    NSLog(@"Y Location: %f", point.y);
}

-(double)CalculateIncome{
    double incomeV = 0;
    for (NSManagedObject *info in [self showIncome]) {
        NSLog(@"Amount: %@", [info valueForKey:@"amount"]);
        incomeV = incomeV + [[info valueForKey:@"amount"] doubleValue];
    }
    return incomeV;
}

-(double)CalculateExpenses{
    double expensesV = 0;
    for (NSManagedObject *info in [self showExpenses]) {
        NSLog(@"Amount: %@", [info valueForKey:@"amount"]);
        expensesV = expensesV + [[info valueForKey:@"amount"] doubleValue];
    }
    return expensesV;
}

- (NSArray *)showIncome{
    
    NSDate *startDate;
    NSDate *endDate;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    
    startDate = [dateFormat dateFromString: [NSString stringWithFormat:@"01-%@", [Helper CurrentMonth]]];
    endDate = [dateFormat dateFromString: [NSString stringWithFormat:@"30-%@", [Helper CurrentMonth]]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Income" inManagedObjectContext:self.context]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:request error: &error];
    
    return fetchedObjects;
}

/*
//FULL LIFE OF APP AND DATA!!!!
- (NSArray *)showIncome{
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    self.context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Income" inManagedObjectContext:self.context];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error: &error];
    
    return fetchedObjects;
}*/

- (NSArray *)showExpenses{
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

/////////////////////////Drawing Graphs///////////////////////////////////////////////
-(void)DrawGraph: (double)income : (double)expenses{
    
    self.whichView = 1;
    
    for (UIView *subview in [self.view subviews]) {
        if ((subview.tag == 9)|| (subview.tag == 10) || (subview.tag == 11)) {
            [subview removeFromSuperview];
        }
    }
    
    double lineInc = 0;
    double lineExp = 0;
    
    if (income > expenses) {
        lineInc = self.view.bounds.size.height*2/3;
        if((expenses / income)>0.7){
            lineExp = self.view.bounds.size.height*((expenses/income)-0.4);
        }else{
            lineExp = self.view.bounds.size.height*(expenses/income);
        }
    } else
    if (income < expenses) {
        lineExp = self.view.bounds.size.height*2/3;
        if((income / expenses )>0.7){
            lineInc = self.view.bounds.size.height*((income/expenses)-0.4);
        }else{
            lineInc = self.view.bounds.size.height*(income/expenses);
        }
    } else
    if ((income == expenses) && ((income > 0) && (expenses > 0))) {
        lineInc = self.view.bounds.size.height*2/3;
        lineExp = self.view.bounds.size.height*2/3;
    } else
    if ((income == 0)||(expenses == 0)||((income == 0) && (expenses == 0))) {
        lineInc = 0;
        lineExp = 0;
        [Helper NoDataLabel:self.view];
    }
    /*
    UIView * lineMax = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/4, self.view.bounds.size.width, 1)];
    lineMax.backgroundColor = [UIColor grayColor];
    */
    UIView * lineIncome = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.8, self.view.bounds.size.height-60, 40, -lineInc)];
    lineIncome.backgroundColor = [UIColor greenColor];
    
    UIView * lineExpenses = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height-60, 40, -lineExp)];
    lineExpenses.backgroundColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    lineIncome.tag = 7;
    lineExpenses.tag = 8;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [self.view addSubview:lineIncome];
    [self.view addSubview:lineExpenses];
    //[self.view addSubview:lineMax];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////// FULL YEAR INCOME BY MONTH
-(NSMutableDictionary *)GetAnnualIncomeByMonth{
    
    NSDate *startDate;
    NSDate *endDate;
    
    NSMutableDictionary *all12Monthes = [[NSMutableDictionary alloc] init];
    
    for (int i=0; i<=11; i++){
        
        NSString *LastDayDate = [Helper lastDayMonth:i];
        //NSLog(@"MONTH: %@", LastDayDate);
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        
        NSString *getMonth = [LastDayDate componentsSeparatedByString:@"-"][1];
        NSString *getYear =[LastDayDate componentsSeparatedByString:@"-"][2];
        
        startDate = [dateFormat dateFromString: [NSString stringWithFormat:@"01-%@-%@", getMonth, getYear]];
        endDate = [dateFormat dateFromString: LastDayDate];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Income" inManagedObjectContext:self.context]];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:request error: &error];
        //NSLog(@"MONTH: %@", @(i));
        [all12Monthes setObject:fetchedObjects forKey: [@(i) stringValue]];
    }
    return all12Monthes;
}

-(NSMutableDictionary *)getIncomeByMonth: (NSMutableDictionary *)AnnualIncome{
    NSMutableDictionary *sumMonthlyIncome = [[NSMutableDictionary alloc] init];
    for (int i=0; i<=11; i++) {
        double incomeV = 0;
        for (NSManagedObject *info in [AnnualIncome objectForKey:[@(i) stringValue]]) {
            incomeV = incomeV + [[info valueForKey:@"amount"] doubleValue];
        }
        [sumMonthlyIncome setObject:[NSNumber numberWithDouble:incomeV] forKey:[@(i) stringValue]];
    }
    return sumMonthlyIncome;
}

-(NSMutableDictionary *)GetAnnualExpensesByMonth{
    
    NSDate *startDate;
    NSDate *endDate;
    
    NSMutableDictionary *all12Monthes = [[NSMutableDictionary alloc] init];

    for (int i=0; i<=11; i++){
        
        NSString *LastDayDate = [Helper lastDayMonth:i];
        //NSLog(@"MONTH: %@", LastDayDate);
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd-MM-yyyy"];
        
        NSString *getMonth = [LastDayDate componentsSeparatedByString:@"-"][1];
        NSString *getYear =[LastDayDate componentsSeparatedByString:@"-"][2];
        
        startDate = [dateFormat dateFromString: [NSString stringWithFormat:@"01-%@-%@", getMonth, getYear]];
        endDate = [dateFormat dateFromString: LastDayDate];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", startDate, endDate];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Expenses" inManagedObjectContext:self.context]];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *fetchedObjects = [self.context executeFetchRequest:request error: &error];
        //NSLog(@"MONTH: %@", @(i));
        [all12Monthes setObject:fetchedObjects forKey: [@(i) stringValue]];
    }
    return all12Monthes;
}

-(NSMutableDictionary *)getExpensesByMonth: (NSMutableDictionary *)AnnualExpenses{
    NSMutableDictionary *sumMonthlyExpenses = [[NSMutableDictionary alloc] init];
    for (int i=0; i<=11; i++) {
        double ExpensesV = 0;
        for (NSManagedObject *info in [AnnualExpenses objectForKey:[@(i) stringValue]]) {
            //NSLog(@"Amount: %@", [info valueForKey:@"amount"]);
            ExpensesV = ExpensesV + [[info valueForKey:@"amount"] doubleValue];
        }
        [sumMonthlyExpenses setObject:[NSNumber numberWithDouble:ExpensesV] forKey:[@(i) stringValue]];
    }
    return sumMonthlyExpenses;
}
-(double)getHighestIncomeValue: (NSMutableDictionary *)income{
    NSArray *aValuesArray = [income allValues];
    NSNumber *max = [aValuesArray valueForKeyPath:@"@max.intValue"];
    NSLog(@"MAX VALUE: %@", [max stringValue]);
    return [max doubleValue];
}
-(double)getHighestExpensesValue: (NSMutableDictionary *)income{
    NSArray *aValuesArray = [income allValues];
    NSNumber *max = [aValuesArray valueForKeyPath:@"@max.intValue"];
    NSLog(@"MAX VALUE: %@", [max stringValue]);
    return [max doubleValue];
}

-(void)drawIncome12Month: (NSMutableDictionary *)income :(NSMutableDictionary *)expenses {
    
    double HighestIncomeValue = [self getHighestIncomeValue: income];
    double HighestExpensesValue = [self getHighestExpensesValue: expenses];
    double hunprline = self.view.bounds.size.height*2/3;
    
    self.whichView = 0;
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag == 7) {
            [subview removeFromSuperview];
        }
        if (subview.tag == 8) {
            [subview removeFromSuperview];
        }
    }
    NSLog(@"DRAWIIIIINNNGGG:");
    
    if ((HighestIncomeValue == 0) && (HighestExpensesValue == 0)) {
        [Helper NoDataLabel:self.view];
    }
    
    else
    {
    
        int k = self.view.bounds.size.width/12;
        int curK = -5;
        double MonthIncome = 0;
        double MonthExpenses = 0;
    
        for (int i=11; i >= 0; i--){
            double lineInc;
            double lineExp;
        
            MonthIncome = [[income objectForKey:[@(i) stringValue]]doubleValue];
            MonthExpenses = [[expenses objectForKey:[@(i) stringValue]]doubleValue];
        
            lineInc = 0;
            lineExp = 0;
        
            if(HighestIncomeValue == HighestExpensesValue){
                if (MonthIncome == HighestIncomeValue) {
                    lineInc = hunprline;
                    lineExp = lineInc * MonthExpenses / HighestIncomeValue;
                }else
                    if (MonthExpenses == HighestExpensesValue) {
                        lineExp = hunprline;
                        lineInc = lineExp * MonthIncome / HighestExpensesValue;
                }else
                    if (MonthIncome > MonthExpenses){
                        lineInc = hunprline * MonthIncome / HighestIncomeValue;
                        lineExp = lineInc * MonthExpenses / HighestExpensesValue;
                }else
                    if (MonthIncome < MonthExpenses){
                        lineExp = hunprline * MonthExpenses / HighestIncomeValue;
                        lineInc = lineExp * MonthIncome / HighestIncomeValue;
                    }
            }
            if (HighestIncomeValue > HighestExpensesValue) {
                if (MonthIncome == HighestIncomeValue) {
                    lineInc = hunprline;
                    lineExp = lineInc * MonthExpenses / HighestIncomeValue;
                }else
                    if (MonthIncome > MonthExpenses){
                        lineInc = hunprline * MonthIncome / HighestIncomeValue;
                        lineExp = lineInc * MonthExpenses / HighestExpensesValue;
                    }else
                        if (MonthIncome < MonthExpenses){
                            lineExp = hunprline * MonthExpenses / HighestIncomeValue;
                            lineInc = lineExp * MonthIncome / HighestIncomeValue;
                        }
            }
            if (HighestExpensesValue > HighestIncomeValue){
                if (MonthExpenses == HighestExpensesValue) {
                    lineExp = hunprline;
                    lineInc = lineExp * MonthIncome / HighestExpensesValue;
                }else
                    if (MonthExpenses > MonthIncome){
                        lineExp = hunprline * MonthExpenses / HighestExpensesValue;
                        lineInc = lineExp * MonthIncome / HighestIncomeValue;
                }else
                    if (MonthExpenses  < MonthIncome){
                        lineInc = hunprline * MonthIncome / HighestExpensesValue;
                        lineExp = lineInc * MonthExpenses / HighestExpensesValue;
                    }
            }
        
            if(isnan(lineInc)){
                lineInc = 0;
            }
            if (isnan(lineExp)) {
                lineExp = 0;
            }
        
            NSLog(@"Mon:%@ Inc:%@ Exp:%@", @(i),[@(MonthIncome) stringValue],[@(MonthExpenses) stringValue]);
            UIView *lineMIncome = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - (curK + k), self.view.bounds.size.height-60, 6, -lineInc)];
            lineMIncome.backgroundColor = [UIColor greenColor];
            
            UIView *lineMExpenses = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - (curK + k - 6), self.view.bounds.size.height-60, 6, -lineExp)];
            lineMExpenses.backgroundColor = [UIColor redColor];
            lineMIncome.tag = 9;
            lineMExpenses.tag = 10;
            [self.view addSubview: lineMIncome];
            [self.view addSubview: lineMExpenses];
            
            if (i == 2) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - (curK + k)-3, self.view.bounds.size.height-60, 60, 15)];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [UIColor whiteColor];
                label.text = @"Mar";
                label.tag = 11;
                [self.view addSubview:label];
            }
            if (i == 5) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - (curK + k)-3, self.view.bounds.size.height-60, 60, 15)];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [UIColor whiteColor];
                label.text = @"Jun";
                label.tag = 11;
                [self.view addSubview:label];
            }
            if (i == 8) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - (curK + k)-3, self.view.bounds.size.height-60, 60, 15)];
                label.font = [UIFont systemFontOfSize:11];
                label.textColor = [UIColor whiteColor];
                label.text = @"Sep";
                label.tag = 11;
                [self.view addSubview:label];
            }
            
            curK = curK + k;
        }
        
        [Helper DrawCoordinates:self.view];
            
        [Helper DrawCoordinatesLabelsY:self.view :HighestIncomeValue : HighestExpensesValue];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OpenIncomeView:(id)sender {
    [self performSegueWithIdentifier: @"IncomeView" sender: self];
}

- (IBAction)OpenExpensesView:(id)sender {
    [self performSegueWithIdentifier: @"ExpensesView" sender: self];
}
@end
