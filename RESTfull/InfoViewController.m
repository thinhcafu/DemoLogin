//
//  InfoViewController.m
//  RESTfull
//
//  Created by ECEP2010 on 9/25/15.
//  Copyright (c) 2015 ECEP. All rights reserved.
//

#import "InfoViewController.h"
#import "DBManager.h"
#import <sqlite3.h>
#import "TestViewController.h"

@interface InfoViewController ()
{
    
    NSString *responeGetDataGlobal;
    NSMutableArray *arrGlobalCources;
}

@property (nonatomic, strong) DBManager *dbManager;
@end

@implementation InfoViewController

- (void)viewWillAppear:(BOOL)animated{
    
    // reload data
  //  [self loadData];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textViewinfo.text = self.content;
    
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    
    // Initialize the dbManager object
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dbCourse.sqlite"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshData:(id)sender{

    NSURL *url = [NSURL URLWithString:@"https://ilearnapi.ecepvn.org/all-data"];
    
    
    //NSString *get = [[NSString alloc] initWithFormat:token];
    
    //NSData *getData = [get  dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Acept"];
    [request setValue:self.content forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSLog(@"%@",request);
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"Response code: %ld", (long)[response statusCode]);
    if ([response statusCode] >= 200 && [response statusCode] < 300) {
        
        NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];

        responeGetDataGlobal = responseData;
        
        // parse JSON-------------------------------------------------------
        NSMutableArray *myObject;
        
        // NSDictionary *dictionary;
        myObject = [[NSMutableArray alloc]init];
        
        NSData *jsonSource = [responeGetDataGlobal dataUsingEncoding:NSUTF8StringEncoding];
        
        //NSLog(@"%@" , jsonSource);
        NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonSource options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *newCourses = [jsonObjects objectForKey:@"new_courses"];
        
        NSMutableArray *arrCource = [[NSMutableArray alloc] init];
        
        for (int i = 0 ; i < newCourses.count; i++) {
            NSDictionary *dict;
            dict = newCourses[i];
            //NSLog(@"Title of course %d is %@ \n \n", i+1, [dict objectForKey:@"title"]);
            [arrCource addObject:[dict objectForKey:@"title"]];
        }
        
        arrGlobalCources = arrCource;
        NSLog(@"%lu", (unsigned long)newCourses.count);
        NSLog(@"ket qua arrglobal: %@",arrGlobalCources[0]);
        NSLog(@"ket qua arrglobal: %@",arrGlobalCources[1]);
        NSLog(@"ket qua arrglobal: %@",arrGlobalCources[2]);
        NSLog(@"ket qua arrglobal: %@",arrGlobalCources[3]);
        
        // Save to DB
        NSString *query;
        for (int i=0; i<10; i++) {
            query = [NSString stringWithFormat:@"insert into tblCourse values(null, '%@')", arrGlobalCources[i]];
            NSLog(@"%@", query);
            
            // Execute the query
            [self.dbManager executeQuery:query];
            
            //if the query was successfully executed then pop the view controller.
            if (self.dbManager.affectedRows != 0) {
                NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
                // Pop the view controller.
                [self.navigationController popViewControllerAnimated:YES];

            }
            else{
                NSLog(@"Could not execute the query.");
            }
        }
        
    }

}

- (IBAction)viewData:(id)sender{

//    [self performSegueWithIdentifier:@"idViewData" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"idViewData"]) {
        UINavigationController *navigationController = (UINavigationController *) segue.destinationViewController;
        TestViewController *infoVC =  [navigationController viewControllers][0];
       infoVC.dataContent = @"Aaaaaa";
    }
}

@end
