//
//  StartPageViewController.m
//  pactSampleApp
//
//  Created by Joe Mathew on 25/07/2015.
//  Copyright (c) 2015 Joe Mathew. All rights reserved.
//

#import<unistd.h>
#import<netdb.h>
#import "StartPageViewController.h"
#import "PCNewsTableVC.h"

#define kWebDataUrl @"https://dl.dropboxusercontent.com/u/746330/facts.json"

@interface StartPageViewController (){
    __block NSData *responseData;
    __block NSMutableDictionary *webResponse;
}
@property(nonatomic, retain)UIActivityIndicatorView *spinner;

@end

@implementation StartPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *getDataButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect]autorelease];
    [getDataButton setTitle:@"Get Data" forState:UIControlStateNormal];
    [getDataButton addTarget:self
                      action:@selector(didTapGetDataButton:)
            forControlEvents:UIControlEventTouchUpInside];
    getDataButton.frame = CGRectMake(self.view.frame.size.width/2 - 50, self.view.frame.size.height/2 - 20, 100.0, 40.0);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:getDataButton];
}

// -------------------------------------------------------------------------------
//	- (IBAction)didTapGetDataButton:(id)sender
//  Handler for 'Get Data' Button tap action
// -------------------------------------------------------------------------------
- (IBAction)didTapGetDataButton:(id)sender {
    if ([self isNetworkAvailable]) {
        UIButton *button = (UIButton *)sender;
        if ([button.currentTitle  isEqual: @"Get Data"]) {
            [sender setTitle:@"Cancel" forState:UIControlStateNormal];
            [self fetchWebData];
        } else {
            [sender setTitle:@"Get Data" forState:UIControlStateNormal];
        }
    } else {
        UIAlertView *networkAlert = [[[UIAlertView alloc]initWithTitle:@"You're Offline!"
                                                               message:@"Looks like you're not connected to the internet!"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles: nil] autorelease];
        [networkAlert show];
    }
}

// -------------------------------------------------------------------------------
//	- (void)fetchWebData
//  Gets data from the Web service as JSON and show the Table
// -------------------------------------------------------------------------------
- (void)fetchWebData {
    
    //Show activity indicator since it may take some time to fetch the data
    _spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]autorelease];
    _spinner.center = self.view.center;
    _spinner.hidesWhenStopped = YES;
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
    PCNewsTableVC *pcTableVC = [[[PCNewsTableVC alloc]init] autorelease];
    UINavigationController *navigationController = [[[UINavigationController alloc] init] autorelease];
    navigationController.viewControllers=[NSArray arrayWithObject:pcTableVC];

    //Fetch web data asynchronously
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error          = nil;
        NSURL * const searchURL = [NSURL URLWithString:kWebDataUrl];
        NSString *string        = [NSString stringWithContentsOfURL:searchURL
                                                            encoding:NSISOLatin1StringEncoding
                                                               error:&error];
        responseData            = [string dataUsingEncoding:NSUTF8StringEncoding];
        webResponse             = [NSJSONSerialization JSONObjectWithData:responseData
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:&error];
        pcTableVC.tableTitle    = webResponse[@"title"];
        pcTableVC.rowData       = webResponse[@"rows"];
        
        dispatch_async(dispatch_get_main_queue(),^{
            [_spinner stopAnimating];   //We got the data; dismiss the spinner
            if (nil != responseData) {
                //Show the Table with data
                [self presentViewController:navigationController animated:YES completion:nil];
            }
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// -------------------------------------------------------------------------------
//	-(BOOL)isNetworkAvailable
//  Check if network is available
// -------------------------------------------------------------------------------
-(BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        return NO;
    }
    else{
        return YES;
    }
}

@end
