//
//  ViewController.m
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParse.h"
#import "CTFrameParserConfig.h"
#import "UIView+frameAdjust.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CTDisplayView *ctView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CTFrameParserConfig* config = [[CTFrameParserConfig alloc]init];
    //config.textColor = [UIColor blackColor];
    config.width = self.ctView.width;
    NSString* path = [[NSBundle mainBundle]pathForResource:@"content" ofType:@"json"];
    CoreTextData* data = [CTFrameParse parseTemplateFile:path config:config];
    self.ctView.data = data;
    self.ctView.height = data.height;
    self.ctView.backgroundColor = [UIColor whiteColor];
//    NSString* content = @"对于上面的例子，我们给增加了一个奖都发了；奋斗开发的开发快乐；奋斗发快递费；咖啡的开发；疯狂的疯狂的疯狂大方\n\n解决的办法的咖啡；对开发的撒开发；";
//    NSDictionary *attr = [CTFrameParse attributesWithConfig:config];
//    NSMutableAttributedString* attrString= [[NSMutableAttributedString alloc]initWithString:content attributes:attr];
//    [attrString addAttribute:NSForegroundColorAttributeName
//                       value:[UIColor redColor] range:NSMakeRange(0, 7)];
//    CoreTextData* data = [CTFrameParse parseAttributedContent:attrString config:config];
//    if (data) {
//        self.ctView.data = data;
//        self.ctView.height = data.height;
//        self.ctView.backgroundColor = [UIColor yellowColor];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
