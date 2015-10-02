//
//  ViewController.m
//  RESTfull
//
//  Created by ECEP2010 on 9/25/15.
//  Copyright (c) 2015 ECEP. All rights reserved.
//

#import "ViewController.h"
#import "InfoViewController.h"

@interface ViewController ()
{
    NSString *token;
    NSString *responeDataGlobal;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signinClicked:(id)sender {
    
    NSInteger success = 0;
    @try {
        if([[self.txtUserName text] isEqualToString:@""] || [[self.txtPassword text] isEqualToString:@""]){
            
            [self alertStatus:@"Please enter Username and Password" :@"Sign in Failed!" :0];
        }else{
        
            NSString *post = [[NSString alloc] initWithFormat:@"username=%@&password=%@",[self.txtUserName text],[self.txtPassword text]];
            NSLog(@"PostData: %@",post);
            
            NSURL *url = [NSURL URLWithString:@"http://ilearnapi.ecepvn.org/login"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Acept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            
            if ([response statusCode] >= 200 && [response statusCode] < 300) {
                
                NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                responeDataGlobal = responseData;
                
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
                
                success = [jsonData[@"success"] integerValue] + 1;
                NSLog(@"Success: %ld", (long)success);
                
                // Parse json
                NSMutableArray *myObject;
                myObject = [[NSMutableArray alloc] init];
                
                NSData *dataObject = [responseData dataUsingEncoding:NSUTF8StringEncoding ];
                
                NSDictionary *dictJSON = [NSJSONSerialization JSONObjectWithData:dataObject options:NSJSONReadingMutableContainers error:nil];
                // NSLog(@"%@", dictJSON);
                
                NSDictionary *user = [dictJSON objectForKey:@"user"];
                NSLog(@"%@",user);
                
                token = [user objectForKey:@"token"];
                NSLog(@"%@",token);

                
                if (success == 1) {
                    NSLog(@"Login SUCCESS");
                }else{
                
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus: error_msg :@"Sign in Failed" : 0];
                }
            }else{
            
                // if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed": @"Sign in Failed" : 0];
            }
            
        }
    }
    @catch (NSException *e) {
        
        NSLog(@"Exception: %@",e);
        [self alertStatus:@"Sign in Failed." :@"Error": 0];
        
    }
    if (success) {
         [self performSegueWithIdentifier:@"login_success" sender:self];
        
    }
    
}

- (void) alertStatus:(NSString *)msg : (NSString *)title : (int)tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"login_success"]) {
        // NavigationController --> rootViewController
        InfoViewController *infoVC =  (InfoViewController *) segue.destinationViewController;
        infoVC.content = token;//@"Aaaaaa";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}
@end
