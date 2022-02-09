//
//  UIView_FrameTool.h
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

#import <UIKit/UIKit.h>

@interface UIView(Frame)

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)x;

- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)y;

- (CGFloat)maxX;
- (CGFloat)maxY;

@end
