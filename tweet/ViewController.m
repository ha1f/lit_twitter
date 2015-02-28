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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [array count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    UITextView *tweetTextView = (UITextView *)[cell viewWithTag:3];
    UILabel *usernamelabel   = (UILabel *)[cell viewWithTag:5];
    UILabel *useridlabel = (UILabel *)[cell viewWithTag:2];
    UIImageView *userImageView = (UIImageView *)[cell viewWithTag:4];
    NSLog(@"dict");
    
    NSDictionary *tweet = array[indexPath.row];
    NSDictionary *userInfo = tweet[@"user"];
    
    tweetTextView.text = [NSString stringWithFormat:@"%@",tweet[@"text"]];
    NSLog(@"sn");
    useridlabel.text = [NSString stringWithFormat:@"@%@",userInfo[@"screen_name"]];
    usernamelabel.text = [NSString stringWithFormat:@"%@",userInfo[@"name"]];
    
    
    NSString *userImagePath = userInfo[@"profile_image_url"];
    NSURL *userImagePathUrl = [[NSURL alloc] initWithString:userImagePath];
    NSData *userImagePathData = [[NSData alloc] initWithContentsOfURL:userImagePathUrl];
    userImageView.image = [[UIImage alloc] initWithData:userImagePathData];
    
    return cell;
    
}

-(IBAction)refreshbutton{
    [self twittertl];
}

- (IBAction)tweetbutton{
    SLComposeViewController *TweetPostViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [self presentViewController:TweetPostViewController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self twittertl];
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
                
                [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlResponse, NSError *error) {
                    array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                    if(array.count != 0){
                        dispatch_async(dispatch_get_main_queue(), ^{[timelineview reloadData];});
                    }
                    
                }];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
        
    }];
    
}

@end
