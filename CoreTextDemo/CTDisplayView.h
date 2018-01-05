//
//  CTDisplayView.h
//  CoreTextDemo
//
//  Created by lxm on 2018/1/5.
//  Copyright © 2018年 lixiaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"
#import <CoreText/CoreText.h>

@interface CTDisplayView : UIView
@property (strong,nonatomic) CoreTextData* data;
@end
