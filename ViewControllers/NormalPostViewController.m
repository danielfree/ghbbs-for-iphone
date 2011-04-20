    //
//  NormalPostViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 12/4/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "NormalPostViewController.h"
@interface NormalPostViewController ()
- (void) fetchNextPostFrom:(Post *)post;
- (void) fetchPreviousPostFrom:(Post *)post;
@end


@implementation NormalPostViewController

- (id) initWithBid:(NSString *)_bid Post:(Post *)_post
{
    if ((self = [super init]))
    {
        assert(_post != nil);
        assert(_bid != nil);
        bid = [_bid copy];
        pid = [_post.pid copy];
        isSticky = _post.isStick;
        forward = YES;
        currentPost = _post;
    }
    return self;
}

#pragma mark -
#pragma mark Override
- (void) loadData:(NSArray *)_posts
{
    if ([_posts count] == 1) {
        [posts insertObject:[_posts objectAtIndex:0] atIndex:0];
        currentPost = [posts objectAtIndex:0];
    }
//    
//    int index;
//    if (forward) 
//    {
//        index = [posts count];
//        [posts addObjectsFromArray:_posts];
//    }
//    else {
//        for(id obj in _posts)
//        {
//            [posts insertObject:obj atIndex:0];
//        }
//        index = 0;
//    }
//    assert(_posts != nil);
//    currentPost = [posts objectAtIndex:index];
}

- (void) fetchFirstPost
{
    assert(bid != nil);
    assert(pid != nil);
    NSMutableString * feedURLString;
    
    if (isSticky) 
    {
        feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/con?bid=%@&f=%@&s=1", bid, pid];
    }
    else 
    {
        feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/con?bid=%@&f=%@", bid, pid];
    }
    NSURL * url = [NSURL URLWithString:feedURLString];
    [self fetchPostWithURL:url];
}

- (void) fetchHeadPost
{
    assert(bid != nil);
    assert(currentPost.pid != nil);
    NSMutableString * feedURLString;
    NSMutableString *gid = [currentPost.pid copy];
    if (currentPost.gid != nil) {
        gid = [currentPost.gid copy];
    }
    NSLog(@"pid = %@, gid = %@",pid, currentPost.gid);
    feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/con?bid=%@&f=%@", bid, gid];
    [gid release];
    NSURL * url = [NSURL URLWithString:feedURLString];
    [self fetchPostWithURL:url];
}

- (void) fetchNextPostFrom:(Post *)post
{
    assert(forward);
    assert(post != nil);
    NSMutableString * feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/con?bid=%@&f=%@&a=n", bid, currentPost.pid];
    NSURL * url = [NSURL URLWithString:feedURLString];
    NSLog(@"pid: %@",currentPost.pid);
    [self fetchPostWithURL:url];
}

- (void) fetchPreviousPostFrom:(Post *)post
{
    assert(!forward);
    assert(post != nil);
    NSMutableString * feedURLString = [NSString stringWithFormat:@"http://bbs.fudan.sh.cn/bbs/con?bid=%@&f=%@&a=p", bid, currentPost.pid];
    NSURL * url = [NSURL URLWithString:feedURLString];
     NSLog(@"pid: %@",currentPost.pid);
    [self fetchPostWithURL:url];
}

- (void) viewPrevious
{
    [super viewPrevious];
    forward = NO;
//    uint index = [posts indexOfObject:currentPost];
//    assert(index != NSNotFound);
//    if(index > 0)
//    {
//        currentPost = [posts objectAtIndex:index - 1];
//        [self refresh];
//    }
//    else
//    {
        [self fetchPreviousPostFrom:currentPost];
//    }
}

- (void) viewNext
{
    [super viewNext];
    forward = YES;
//    uint index = [posts indexOfObject:currentPost];
//    assert(index != NSNotFound);
//    if(index < [posts count] - 1)
//    {
//        currentPost = [posts objectAtIndex:index + 1];
//        [self refresh];
//    }
//    else 
//    {
        [self fetchNextPostFrom:currentPost];
//    }
}


#pragma mark -
#pragma mark View lifecycle
- (void) loadView
{
    [super loadView];
    
    CGSize viewSize = self.view.frame.size;
    CGRect toolbarFrame = CGRectMake(0, viewSize.height - 44.0, viewSize.width, 44.0);
    UIToolbar *myToolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    myToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin ;
    UIBarButtonItem *goPrev = [[UIBarButtonItem alloc] initWithTitle:@"上篇" style:UIBarButtonItemStyleBordered target:self action:@selector(viewPrevious)];
    UIBarButtonItem *goNext = [[UIBarButtonItem alloc] initWithTitle:@"下篇" style:UIBarButtonItemStyleBordered target:self action:@selector(viewNext)];
    UIBarButtonItem *goFirst = [[UIBarButtonItem alloc] initWithTitle:@"顶楼" style:UIBarButtonItemStyleBordered target:self action:@selector(fetchHeadPost)];
    UIBarButtonItem *goThread = [[UIBarButtonItem alloc] initWithTitle:@"展开主题" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonClick:)];
    UIBarButtonItem *goThreadFromHere = [[UIBarButtonItem alloc] initWithTitle:@"向后展开" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonClick:)];
    NSArray *buttons = [[NSArray alloc] initWithObjects:goPrev, goNext,goFirst, goThread, goThreadFromHere, nil];
    [goPrev release];
    [goNext release];
    [goFirst release];
    [goThread release];
    [goThreadFromHere release];
    
    [myToolbar setItems:buttons animated:NO];
    [myToolbar setBarStyle:UIBarStyleBlack];
    myToolbar.translucent = YES;
    [buttons release];
    [self.view addSubview:myToolbar];
    
    [myToolbar release];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}




- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)dealloc {
    [super dealloc];
}


@end
