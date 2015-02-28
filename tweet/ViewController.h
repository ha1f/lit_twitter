//
//  ViewController.h
//  tweet
//
//  Created by 山口 智生 on 2015/02/22.
//  Copyright (c) 2015年 Tomoki Yamaguchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


{
    NSArray *array;
    IBOutlet UITableView *timelineview;
    
}

- (IBAction)tweetbutton;
- (IBAction)refreshbutton;
- (void)twittertl;


@end

