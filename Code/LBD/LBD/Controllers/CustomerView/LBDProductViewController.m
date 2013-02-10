//
//  LBDProductViewController.m
//  LBD
//
//  Created by Pavan Itagi on 09/02/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "LBDProductViewController.h"
#import "LBDCustomPopUpView.h"
#import "TwilioDataSource.h"
#import "JSON.h"

@interface LBDProductViewController ()<LBDCustomPopUpViewDelegate, UIScrollViewDelegate, TwilioDataSourceDelegate>
{
    UIScrollView *mainScroll, *sideScroll;
    UIImageView *logoView, *homebgView;

}

@property(nonatomic, strong)TwilioDataSource *datasource;

@end

@implementation LBDProductViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addScrolls
{
    homebgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
//    [homebgView setImage:[UIImage imageNamed:@"Default"]];
    [homebgView setUserInteractionEnabled:YES];
    [homebgView setBackgroundColor:[UIColor whiteColor]];
    [homebgView setAlpha:0.0];
    [self.view addSubview:homebgView];
    [homebgView release];
        
    mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    [mainScroll setBackgroundColor:[UIColor clearColor]];
    [mainScroll setShowsVerticalScrollIndicator:NO];
    [mainScroll setBounces:NO];
    [mainScroll setScrollEnabled:NO];
    [mainScroll setUserInteractionEnabled:YES];
    [mainScroll setDecelerationRate:UIScrollViewDecelerationRateNormal];
    //[mainScroll setDelegate:self];
    [homebgView addSubview:mainScroll];
    
    UIImageView *tmpV=nil;
    float y=0;
    for(int i=0; i<100; i++)
    {
        tmpV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 748*i, 1024, 748)];
        [tmpV setImage:[UIImage imageNamed:[NSString stringWithFormat:@"v%d", i%5]]];
        [tmpV setTag:i+5000];
        [tmpV setBackgroundColor:[UIColor clearColor]];
        [tmpV setContentMode:UIViewContentModeCenter];
        [tmpV setUserInteractionEnabled:YES];
        [mainScroll addSubview:tmpV];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [tapGesture setNumberOfTapsRequired:2];
        [tmpV addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        [tmpV release];
        y=y+748;
    }
    
    [mainScroll setContentSize:CGSizeMake(1024, y)];
    
    UIImage *tmpImg = [UIImage imageNamed:@"Navvvv"];
    UIImageView *tmpView = [[UIImageView alloc] initWithFrame:CGRectMake(1668/2, 0, tmpImg.size.width, tmpImg.size.height)];
    [tmpView setImage:tmpImg];
    [tmpView setUserInteractionEnabled:YES];
    [homebgView addSubview:tmpView];
    [tmpView release];
    
    
    //[mainScroll scrollRectToVisible:CGRectMake(0, 748*1-2*(40+logoImg.size.height), 1024, 748) animated:NO];
    
    
    float w = tmpView.frame.size.width;
    sideScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, tmpView.frame.size.width, tmpView.frame.size.height)];
    [sideScroll setBackgroundColor:[UIColor clearColor]];
    [sideScroll setBounces:NO];
    [sideScroll setShowsVerticalScrollIndicator:NO];
    [sideScroll setUserInteractionEnabled:YES];
    [sideScroll setDecelerationRate:UIScrollViewDecelerationRateNormal];
    [sideScroll setDelegate:self];
    [tmpView addSubview:sideScroll];
    
    UIImageView *tmpS=nil;
    float ys=0;
    for(int i=0; i<100; i++)
    {
        UIImage *tmpI = [UIImage imageNamed:[NSString stringWithFormat:@"side_%d", i%5]];
        tmpS = [[UIImageView alloc] initWithFrame:CGRectMake(w/2-tmpI.size.width/2, (748/5)*i, tmpI.size.width, 136.0f)];
        [tmpS setImage:tmpI];
        [tmpS setContentMode:UIViewContentModeCenter];
        [tmpS setBackgroundColor:[UIColor clearColor]];
        [sideScroll addSubview:tmpS];
        [tmpS release];
        ys=ys+748/5;
    }
    [sideScroll setContentSize:CGSizeMake(w, ys)];
    
    [sideScroll scrollRectToVisible:CGRectMake(0, (748/5)*1, 1024, 748) animated:NO];
    
}

- (void)tapped:(UIGestureRecognizer *)sender
{
    UIView *superView = [sender view];
    
    CGPoint pointInView = [sender locationInView:superView];
    
    NSLog(@"Tapped page %d, %@", superView.tag, [NSValue valueWithCGPoint:pointInView]);
    
    
    LBDCustomPopUpView *popUp = [[LBDCustomPopUpView alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
    [popUp setBackgroundColor:[UIColor blackColor]];
    [popUp setCenter:pointInView];
    [popUp setDelegate:self];
    [superView addSubview:popUp];
    
}

-(void)startInitialAnimaton
{
    [self addScrolls];
    [homebgView setAlpha:1.0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 748)];
    [bgView setImage:[UIImage imageNamed:@"Default"]];
    [bgView setUserInteractionEnabled:YES];
    [self.view addSubview:bgView];
    [bgView release];
    
    UIImage *logoImg = [UIImage imageNamed:@"SplashLogo"];
    logoView = [[UIImageView alloc] initWithFrame:CGRectMake(1024/2-logoImg.size.width/2, 748/2-logoImg.size.height/2, logoImg.size.width, logoImg.size.height)];
    [logoView setImage:[UIImage imageNamed:@"SplashLogo"]];
    [logoView setBackgroundColor:[UIColor clearColor]];
    [logoView setAlpha:0.0];
    [logoView setUserInteractionEnabled:YES];
    [bgView addSubview:logoView];
    [logoView release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startInitialAnimaton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight))
    {
        return YES;
        
    }
    return NO;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"asjndajsnd - %f,%f", scrollView.contentOffset.x, scrollView.contentOffset.y);
    
//    if ([scrollView isEqual:sideScroll]) {
        //[mainScroll scrollRectToVisible:CGRectMake(0, scrollView.contentOffset.y/(748/5)*748, 1024, 748) animated:YES];
    [mainScroll setContentOffset:CGPointMake(0, scrollView.contentOffset.y/(748/5)*748 + 44.0f)];
//    }
//    else
//    {
//        [sideScroll scrollRectToVisible:CGRectMake(0, scrollView.contentOffset.y/(748/5)*748, sideScroll.frame.size.width, sideScroll.frame.size.height) animated:YES];
//    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float hm = (scrollView.contentOffset.y)/(748/5);
    int hmmm = hm*10;
    int hmm=hm;
    if((hmmm)%10 > 5)
    {
        hmm++;
    }
    //NSLog(@"hello - %d", hmm);
    
    [scrollView scrollRectToVisible:CGRectMake(0, (748/5)*hmm, 1024, 748) animated:YES];
    [mainScroll scrollRectToVisible:CGRectMake(0, scrollView.contentOffset.y/(748/5)*748 + 44.0f, 1024, 748) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    float hm = (scrollView.contentOffset.y)/(748/5);
    //    int hmmm = hm*10;
    //    int hmm=hm;
    //    if((hmmm)%10 > 5)
    //    {
    //        hmm++;
    //    }
    //    //NSLog(@"hello - %d", hmm);
    //
    //    [scrollView scrollRectToVisible:CGRectMake(0, (748/5)*hmm, 1024, 748) animated:YES];
    if(!decelerate && scrollView)
    {
    float hm = (scrollView.contentOffset.y)/(748/5);
    int hmmm = hm*10;
    int hmm=hm;
    if((hmmm)%10 > 5)
    {
        hmm++;
    }
    //NSLog(@"hello - %d", hmm);
    
    [scrollView scrollRectToVisible:CGRectMake(0, (748/5)*hmm, 1024, 748) animated:YES];
    
        [mainScroll scrollRectToVisible:CGRectMake(0, scrollView.contentOffset.y/(748/5)*748 + 44.0f, 1024, 748) animated:YES];
    }
}

- (void)continueButtonClickedForCoordinate:(CGPoint)point forView:(id)view
{
    UIImageView *img = (UIImageView *)view;
    
    NSLog(@"selected page %d", img.tag - 5000);
    // Add Question at this co-ordinate
    NSLog(@"Ask question for co-orduinate at %@", [NSValue valueWithCGPoint:point]);
    
    // allocate the data source and record the queries
    if(!self.datasource)
        self.datasource = [[TwilioDataSource alloc]initWithUserName:@"LBD"];
    
    self.datasource.dataSourceDelegate = self;
    [self.datasource recordQuerys];
    
}

#pragma mark - Twilio datasource delegate
- (void)didReceiveRecordedUrl:(NSString *)url
{
    NSString *urlTobeSent = [url stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSDictionary *dict =@{@"question_audio_url":urlTobeSent,@"client_user_id":@"108099534"};
    
    NSData *postData = [[NSString stringWithFormat:@"data=%@",[dict JSONRepresentation]] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:@"http://192.168.1.94:3000/question_answers/add.json"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    //NSString *responseString = [[NSString alloc] initWithFormat:@"%@", responseData];
    NSLog(@"responseData: %@", responseData);
}
@end