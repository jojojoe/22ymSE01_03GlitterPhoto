//
//  GPyyTouchStuffVPrivate.h
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

#import <Foundation/Foundation.h>
#import "GPyyTouchStuffV.h"
@interface UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj;

@end

@interface TouchStuffView (Private)
- (void)touchViewButtonOppositTransform:(UIView *)touchView;
- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches;
- (CGAffineTransform)calculateTransformWithCenterAndPoint:(CGPoint)point;
- (void)updateOriginalTransformForTouches:(NSSet *)touches;

- (void)cacheBeginPointForTouches:(NSSet *)touches;
- (void)removeTouchesFromCache:(NSSet *)touches;

- (BOOL)shouldApplyTransform:(CGAffineTransform)transform;

//5.5
- (CGAffineTransform)singleOrientationCalculateTransformWithCenterAndPoint:(CGPoint)point;
- (void)logTheTransform:(CGAffineTransform) calculatedTransform;
@end
