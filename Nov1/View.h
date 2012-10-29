//
//  View.h
//  Nov1
//
//  Created by Scott Danzig on 10/27/12.
//  Copyright (c) 2012 Scott Danzig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface View : UIView {
    @private
    CGFloat viewWidth;
    CGFloat viewHeight;
    CGFloat textSize;
    CGFloat actualTextHeight;
    CGFloat bodyMargin;
    CGFloat bodyWidth;
    CGFloat bodyHeight;
    CGFloat stickWidth;
    CGFloat stickHeight;
    CGFloat colorBlockWidth;
    CGFloat textAreaWidth;
    CGFloat textAreaHeight;
    CGFloat numberYPos;
    NSString *labelFont;
    NSString *infoFont;
    NSString *numberFont;
    
    SystemSoundID soundFileObject;
}

@end
