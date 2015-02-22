//
//  ViewController.m
//  tweet
//
//  Created by 山口 智生 on 2015/02/22.
//  Copyright (c) 2015年 Tomoki Yamaguchi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)tweetbutton{
    SLComposeViewController *TweetPostViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self presentViewController:TweetPostViewController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)twittertl{
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountype = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //認証の確認
    [account requestAccessToAccountsWithType:accountype options:nil completion:^(BOOL granted, NSError *error){
        if(granted == YES){
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountype];
            if([arrayOfAccounts count] > 0){
                ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:@"100" forKey:@"count"];
                [parameters setObject:@"1" forKey:@"include_entities"];
                
                SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:parameters];
                posts.account = twitterAccount;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                
                [posts performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    
                }];
            }
        }
       
        
        
        
    }];
    
}

@end
