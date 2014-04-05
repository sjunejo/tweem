//
//  LandingViewController.m
//  Tweem
//
//  Created by Sadruddin Junejo on 21/03/2014.
//  Copyright (c) 2014 SJunejo. All rights reserved.
//

#import "LandingViewController.h"
#import "WebController.h"

@interface LandingViewController ()

@end

@implementation LandingViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)JSONPrompt:(id)sender {
    // Welp
    [[WebController sharedInstance] sendWebRequestWithURL:@"https://api.twitter.com/1.1/search/tweets.json"];
    
}
@end
