//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"
#import "Utils.h"
@implementation CTDisplayView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
    for (CoreTextImageData* data in self.data.imageArray) {
        UIImage* image = [UIImage imageNamed:data.name];
        CGContextDrawImage(context, data.imagePosition,image.CGImage);
    }
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupEvents];
    }
    return self;
}
-(void)setupEvents{
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapGestureDetected:)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
    self.userInteractionEnabled = YES;
}

-(void)userTapGestureDetected:(UIGestureRecognizer*)recognizer{
    CGPoint point = [recognizer locationInView:self];
    for (CoreTextImageData* data in self.data.imageArray) {
        CGRect imageRect = data.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        if (CGRectContainsPoint(rect, point)) {
            NSLog(@"bingo");
            break;
        }
    }
    CoreTextLinkData* linkData = [Utils touchLinkInView:self atPoint:point data:self.data];
    if (linkData) {
        NSLog(@"hint link!");
        return;
    }
}
@end
