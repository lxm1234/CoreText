//
//  Utils.m
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import "Utils.h"
#import "CoreTextData.h"
#import "CoreTextLinkData.h"

@implementation Utils
+ (CoreTextLinkData *)touchLinkInView:(UIView*)view atPoint:(CGPoint)point data:(CoreTextData*)data{
    CTFrameRef textFrame = data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(textFrame);
    if (!lines) {
        return nil;
    }
    CFIndex count = CFArrayGetCount(lines);
    CoreTextLinkData* foundLink = nil;
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    for (int i =0 ; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        if (CGRectContainsPoint(rect, point)) {
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect),point.y - CGRectGetMinY(rect));
            
            CFIndex idx = CTLineGetStringIndexForPosition(line, relativePoint);
            foundLink = [self linkAtIndex:idx linkArray:data.linkArray];
            return foundLink;
        }
    }
    return nil;
}
+(CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point{
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return  CGRectMake(point.x, point.y, width, height);
}
+(CoreTextLinkData*)linkAtIndex:(CFIndex)i linkArray:(NSArray*)linkArray{
    CoreTextLinkData*link = nil;
    for (CoreTextLinkData* data in linkArray) {
        if (NSLocationInRange(i, data.range)) {
            link = data;
            break;
        }
    }
    return link;
}
@end
