//
//  ViewController.m
//  YS_TextureAnimatingDemo
//
//  Created by geys1991 on 2018/1/25.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "ViewController.h"
#import "YSAnimatedNode.h"

@interface ViewController ()

@property (nonatomic, strong) YSAnimatedNode *animatedNode;

@end

@implementation ViewController

-(instancetype)init
{
    self = [super initWithNode: [[ASDisplayNode alloc] init]];
    if ( self ) {
        //        self.node.automaticallyManagesSubnodes = YES;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.node addSubnode: self.animatedNode];
    self.animatedNode.backgroundColor = [UIColor redColor];
}

-(void)viewWillLayoutSubviews
{
    CGSize size = [self.animatedNode layoutThatFits:ASSizeRangeMake(CGSizeZero, CGSizeMake(self.view.frame.size.width - 40, 300))].size;
    self.animatedNode.frame = CGRectMake(20, 20, size.width, size.height);
}

- (YSAnimatedNode *)animatedNode
{
    if ( !_animatedNode ) {
        _animatedNode = [[YSAnimatedNode alloc] init];
    }
    return _animatedNode;
}

- (void)actionClick
{
    [self.animatedNode clickAction];
}

@end
