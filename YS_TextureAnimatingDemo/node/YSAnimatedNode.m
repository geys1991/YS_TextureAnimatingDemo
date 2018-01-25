//
//  YSAnimatedNode.m
//  YS_TextureAnimatingDemo
//
//  Created by geys1991 on 2018/1/25.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "YSAnimatedNode.h"

#define YSAnimatingStatusTypeOneWay 0

typedef NS_ENUM(NSInteger, YSAnimatingStatus) {
    YSAnimatingStatusNone = 0,
    YSAnimatingStatusBigger,
    YSAnimatingStatusSmaller,
    YSAnimatingStatusStop,
};

@interface YSAnimatedNode ()

@property (nonatomic, strong) ASButtonNode *btnNode;

@property (nonatomic, strong) ASDisplayNode *spaceNode;

@property (nonatomic, assign) YSAnimatingStatus animatingStatus;

@end

@implementation YSAnimatedNode
{
    BOOL isAnimated;
}

-(instancetype)init
{
    self = [super init];
    if ( self ) {
        self.automaticallyManagesSubnodes = YES;
        isAnimated = NO;
    }
    return self;
}

-(void)didLoad
{
    [super didLoad];
    
    [self.btnNode addTarget: self action: @selector(clickAction) forControlEvents: ASControlNodeEventTouchUpInside];
}

- (void)clickAction
{
    NSLog(@"asdasdasd");
    isAnimated = !isAnimated;
    self.animatingStatus ++;
    [self transitionLayoutWithAnimation: YES
                     shouldMeasureAsync: NO
                  measurementCompletion: nil];
}

- (void)animateLayoutTransition:(id<ASContextTransitioning>)context
{
    CGRect spaceNodeFromNodeFrame = [context initialFrameForNode: self.spaceNode];
    CGRect spaceNodeToNodeFrame = [context finalFrameForNode: self.spaceNode];
    //    self.spaceNode.frame = spaceNodeFromNodeFrame;
    
    CGRect btnNodeFromNodeFrame = [context initialFrameForNode: self.btnNode];
    CGRect btnNodeToNodeFrame = [context finalFrameForNode: self.btnNode];
    //    self.btnNode.frame = btnNodeFromNodeFrame;
    
    [UIView animateWithDuration: 0.2 animations:^{
        self.spaceNode.frame = spaceNodeToNodeFrame;
        self.btnNode.frame = btnNodeToNodeFrame;
        // 计算 父 Node 的大小
        CGSize fromSize = [context layoutForKey:ASTransitionContextFromLayoutKey].size;
        CGSize toSize = [context layoutForKey:ASTransitionContextToLayoutKey].size;
        BOOL isResized = (CGSizeEqualToSize(fromSize, toSize) == NO);
        if (isResized == YES) {
            CGPoint position = self.frame.origin;
            self.frame = CGRectMake(position.x, position.y, toSize.width, toSize.height);
        }
        
    } completion:^(BOOL finished) {
        
#if YSAnimatingStatusTypeOneWay
        [context completeTransition: finished];
#else
        self.animatingStatus ++;
        if ( self.animatingStatus != YSAnimatingStatusStop ) {
            [self transitionLayoutWithAnimation: YES
                             shouldMeasureAsync: NO
                          measurementCompletion: nil];
        }else{
            self.animatingStatus = YSAnimatingStatusNone;
            [context completeTransition: finished];
        }
#endif
    }];
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    CGFloat spaceHeight = 20;
    if (
#if YSAnimatingStatusTypeOneWay
        isAnimated
#else
        self.animatingStatus == YSAnimatingStatusBigger
#endif
        ) {
        spaceHeight = 40;
    }else {
        spaceHeight = 20;
    }
    
    CGSize spaceFrame = CGSizeMake(320, spaceHeight);
    self.spaceNode.style.preferredSize = spaceFrame;
    
    CGSize btnFrame = CGSizeMake(320, 20);
    self.btnNode.style.preferredSize = btnFrame;
    
    ASStackLayoutSpec *stackSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection: ASStackLayoutDirectionVertical
                                                                           spacing: 10
                                                                    justifyContent: ASStackLayoutJustifyContentStart
                                                                        alignItems: ASStackLayoutAlignItemsStart
                                                                          children: @[self.spaceNode, self.btnNode]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets: UIEdgeInsetsMake(20, 20, 20, 20) child: stackSpec];;
}

-(ASDisplayNode *)spaceNode
{
    if ( !_spaceNode ) {
        _spaceNode = [[ASDisplayNode alloc] init];
        _spaceNode.backgroundColor = [UIColor purpleColor];
    }
    return _spaceNode;
}

- (ASButtonNode *)btnNode
{
    if ( !_btnNode ) {
        _btnNode = [[ASButtonNode alloc] init];
        _btnNode.backgroundColor = [UIColor cyanColor];
        [_btnNode setTitle: @"Click" withFont: [UIFont systemFontOfSize: 13] withColor: [UIColor blackColor] forState: UIControlStateNormal];
    }
    return _btnNode;
}


@end
