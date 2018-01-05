//
//  CTFrameParse.m
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import "CTFrameParse.h"
#import "CoreTextImageData.h"
#import "CoreTextLinkData.h"

@implementation CTFrameParse

+ (CoreTextData*) parseTemplateFile:(NSString*)path config:(CTFrameParserConfig*)config{
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArrary = [NSMutableArray array];
    NSAttributedString* content = [self loadTemplateFile:path config:config imageArray:imageArray linkArray:linkArrary];
    CoreTextData* data =  [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArrary;
    return data;
}

+(NSAttributedString*)loadTemplateFile:(NSString*)path config:(CTFrameParserConfig*)config imageArray:(NSMutableArray*)imageArray
    linkArray:(NSMutableArray*)linkArray{
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc]init];
    if (data) {
        NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary* dic in array) {
                NSString* type = dic[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString* as = [self parseAttributedContentFromNSDictionary:dic config:config];
                    [result appendAttributedString:as];
                }else if([type isEqualToString:@"img"]){
                    CoreTextImageData *imageData = [[CoreTextImageData alloc]init];
                    imageData.name = dic[@"name"];
                    //imageData.postion = [result length];
                    [imageArray addObject:imageData];
                    NSAttributedString*as = [self parseImageDataFromNSDictionary:dic config:config];
                    [result appendAttributedString:as];
                } else if([type isEqualToString:@"link"]){
                    NSUInteger startPos = result.length;
                    NSAttributedString* as = [self parseAttributedContentFromNSDictionary:dic config:config];
                    [result appendAttributedString:as];
                    
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    CoreTextLinkData *linkData = [[CoreTextLinkData alloc]init];
                    linkData.url = dic[@"url"];
                    linkData.title = dic[@"content"];
                    linkData.range = linkRange;
                    [linkArray addObject:linkData];
                }
            }
        }
    }
    return result;
}

static CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat deascentCallback(void *ref){
    return 0;
}
static CGFloat widthCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}
+(NSAttributedString*)parseImageDataFromNSDictionary:(NSDictionary*)dict config:(CTFrameParserConfig*)config{
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = deascentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void*)(dict));
    unichar objectReplacementChar = 0xFFFC;
    NSString* content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary* attrubutes = [self attributesWithConfig:config];
    NSMutableAttributedString* space = [[NSMutableAttributedString alloc]initWithString:content attributes:attrubutes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),kCTRunDelegateAttributeName ,delegate);
    CFRelease(delegate);
    return space;
    
}
+ (NSAttributedString*)parseAttributedContentFromNSDictionary:(NSDictionary*)dict config:(CTFrameParserConfig*)config{
    NSMutableDictionary* attributes = [self attributesWithConfig:config];
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    CGFloat fontSize = [dict[@"size"] floatValue];
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString* content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}
+(UIColor*)colorFromTemplate:(NSString*)name{
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if([name isEqualToString:@"red"]){
        return [UIColor redColor];
    } else if([name isEqualToString:@"black"]){
        return [UIColor blackColor];
    } else {
        return nil;
    }
}

+ (NSDictionary*)attributesWithConfig:(CTFrameParserConfig*)config{
    CGFloat fontSize = config.fontsize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpace = config.lineSpace;
    const CFIndex kNumberOfSetting = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSetting]={
        {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpace}
        ,{kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&lineSpace}
        ,{kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&lineSpace}
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings,kNumberOfSetting);
    UIColor* textColor = config.textColor;
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    //dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}

+ (CoreTextData*) parseContent:(NSString*)content config:(CTFrameParserConfig*)config {
    NSDictionary* attributes = [self attributesWithConfig:config];
    NSAttributedString* contentString = [[NSAttributedString alloc]initWithString:content attributes:attributes];
    return [self parseAttributedContent:content config:config];
}
+ (CoreTextData*) parseAttributedContent:(NSMutableAttributedString*)content config:(CTFrameParserConfig*)config {
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat height = coreTextSize.height;
    
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:height];
    CoreTextData* data = [[CoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = height;
    
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}
+(CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(CTFrameParserConfig*)config height:(CGFloat)height{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}
@end
