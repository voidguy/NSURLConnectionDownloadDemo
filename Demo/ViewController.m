//
//  ViewController.m
//  Demo
//
//  Created by wtwo on 16/7/16.
//  Copyright © 2016年 wtwo. All rights reserved.
//

#import "ViewController.h"

static NSString *const kRequestURL = @"https://github.com/rs/SDWebImage/archive/master.zip";

@interface ViewController ()<NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, assign) long long totalLength;
@property (nonatomic, assign) long long currentLength;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.progress = 0;
    NSURL *url = [NSURL URLWithString:kRequestURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection.alloc initWithRequest:request delegate:self startImmediately:NO];
    _connection = connection;
}

- (IBAction)startDownLoad:(id)sender {
    [self.connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"收到相应");
    self.totalLength = response.expectedContentLength;
    NSLog(@"totalLength: %lld", response.expectedContentLength);
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingString:response.suggestedFilename];
    [NSFileManager.defaultManager createFileAtPath:filePath contents:nil attributes:nil];
    self.filePath = filePath;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    [handle seekToEndOfFile];
    [handle writeData:data];
    self.currentLength += data.length;
    NSLog(@"接受数据: 本次长度: %lu,已接受长度：%lld", (unsigned long)data.length, self.currentLength);
    self.progressView.progress = 1.0 * self.currentLength / self.totalLength;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"请求失败");
    if (!error) {
        NSLog(@"error: %@", error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"请求完成");
}


@end
