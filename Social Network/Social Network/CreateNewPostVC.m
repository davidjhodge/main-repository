//
//  CreateNewPostVC.m
//  Social Network
//
//  Created by David Hodge on 11/7/14.
//  Copyright (c) 2014 Genesis Apps, LLC. All rights reserved.
//

#import "CreateNewPostVC.h"
#import "AmazonFetcher.h"

@interface CreateNewPostVC () <UITextViewDelegate, NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation CreateNewPostVC

#define PLACEHOLDER_TEXT @"What's on your mind?"

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Resize Text Content
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //[self initializeTextView];
    
    self.textView.text = nil;
    [self.textView becomeFirstResponder];
}

-(void)initializeTextView
{
    self.textView.delegate = self;
    self.textView.text = PLACEHOLDER_TEXT;
    self.textView.textColor = [UIColor lightGrayColor];
}

- (IBAction)uploadPost:(id)sender {
    
    NSString *contentText = [NSString stringWithFormat:@"%@",self.textView.text];
    
    contentText = [contentText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
   
    NSString *variablesForPHP = [NSString stringWithFormat:@"content=%@&likes=0&whoPosted=%@",contentText,[AmazonFetcher getUUID]];
    
    NSString *linkText = @"http://ec2-54-84-9-63.compute-1.amazonaws.com/php/TestServiceUploadPost.php?";
    linkText = [linkText stringByAppendingString:variablesForPHP];
    NSLog(@"%@",linkText);
    
    NSURL *url = [NSURL URLWithString:linkText];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

#pragma mark - NSURLConnection Delegate


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
    NSString *string = [NSString stringWithUTF8String:[_responseData bytes]];
    NSLog(@"%@",string);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@,%@",error,error.localizedDescription);
}


- (IBAction)cancel:(id)sender {
    
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
