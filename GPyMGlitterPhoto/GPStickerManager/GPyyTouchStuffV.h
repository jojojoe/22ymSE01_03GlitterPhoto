//
//  GPyyTouchStuffV.h
//  GPyMGlitterPhoto
//
//  Created by Joe on 2022/1/17.
//

#import <UIKit/UIKit.h>
#import "UIView_FrameTool.h"
#import "UIColor+ColorTool.h"
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


@class TouchStuffView,PTTouchRotateImage;
@protocol TouchStuffViewDelegate <NSObject>
@optional
- (void)viewTouchDown:(TouchStuffView*)sender;
- (void)viewTouchUp:(TouchStuffView*)sender;
- (void)viewTouchMoved:(TouchStuffView*)sender;
- (void)viewDoubleClick:(TouchStuffView *)sender;
- (void)viewSingleClick:(TouchStuffView *)sender;
- (void)viewDeleteBtnClick:(TouchStuffView *)sender;
- (void)viewEditBtnClick:(TouchStuffView *)sender;
- (void)viewTouchEnd:(TouchStuffView *)sender;

@end

@interface TouchStuffView : UIView
{
    CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
    
}
@property (nonatomic,assign)id<TouchStuffViewDelegate> delegate;
//david add
- (CGAffineTransform)viewTransform;
- (void)setupOriginalTransform:(CGFloat)rotoate;
- (void)flipHorizontal;
- (void)flipVertical;
- (void)setHilight:(BOOL)flag;

@property (nonatomic, strong) UIImageView *rotateButton;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) BOOL isFlip;
@property (nonatomic, assign) CGAffineTransform touchTransform;
@property (nonatomic) BOOL panGestureDetected;
@property (nonatomic) CGPoint panBeginPoint;
@property (nonatomic, assign) BOOL isHilightStatus;
- (void)resetTransform:(CGAffineTransform)transform;


@property (nonatomic, strong) NSString *patternName;
@property (nonatomic, strong) NSString *gradientName;


@property (nonatomic, assign) BOOL hasMasked;
@property (nonatomic, assign) BOOL isEditing;


- (void)rotateButtonPanGestureDetected:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)clearMaskPath;

- (void)updateBtnOppositTransform;
- (BOOL)shouldApplyTransform:(CGAffineTransform)transform;

//5.5
- (CGAffineTransform)singleOrientationCalculateTransformWithCenterAndPoint:(CGPoint)point orientation:(NSString *)orientation;// hor ver;

- (void)storeFinalTransform:(CGAffineTransform)transform;

@property (nonatomic, assign) BOOL isAutoFlat;

@end
