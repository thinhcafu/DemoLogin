//
//  InfoViewController.h
//  RESTfull
//
//  Created by ECEP2010 on 9/25/15.
//  Copyright (c) 2015 ECEP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <sqlite3.h>

@interface InfoViewController : UIViewController

@property (strong, nonatomic) NSString *databasePath;

@property (nonatomic) sqlite3 *DB;

@property (weak, nonatomic) IBOutlet UITextView *textViewinfo;
@property (nonatomic, strong) NSString *content;

- (IBAction)refreshData:(id)sender;

- (IBAction)viewData:(id)sender;

@end
