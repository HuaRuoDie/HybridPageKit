//
//  BannerViewController.m
//  HybridPageKit
//
//  Created by dequanzhu.
//  Copyright © 2018 HybridPageKit. All rights reserved.
//

#import "BannerViewController.h"
#import "ArticleApi.h"
#import "ArticleModel.h"


@interface BannerViewController ()
@property(nonatomic,strong,readwrite)UILabel *bannerView;
@property(nonatomic,strong,readwrite)ArticleApi *api;
@property(nonatomic,strong,readwrite)ArticleModel *articleModel;
@property(nonatomic,strong,readwrite)HotCommentController *commentController;
@end

@implementation BannerViewController
-(instancetype)init{
    self = [super initWithDefaultWebView:NO];
    if (self) {
        [self getRemoteData];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:({
        _bannerView  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200.f)];
        _bannerView.backgroundColor = [UIColor whiteColor];
        _bannerView.textAlignment = NSTextAlignmentCenter;
        _bannerView.numberOfLines = 0;
        _bannerView.font = [UIFont systemFontOfSize:40.f];
        _bannerView.text = @"HybridPageKit \n BannerView";
        _bannerView.textColor = [UIColor colorWithRed:28.f/255.f green:135.f/255.f blue:219.f/255.f alpha:1.f];
        
        [_bannerView.layer addSublayer:({
            CALayer *bottomLine = [[CALayer alloc]init];
            bottomLine.frame = CGRectMake(0, _bannerView.bounds.size.height -1, _bannerView.bounds.size.width, 1.f);
            bottomLine.backgroundColor = [UIColor lightGrayColor].CGColor;
            bottomLine;
        })];
        
        _bannerView;
    })];
}

- (__kindof UIView *)getBannerView{
    return _bannerView;
}

- (NSArray *)getComponentControllerArray{
    _commentController = [[HotCommentController alloc]init];
    
    return @[
             [[RelateNewsController alloc]init],
             _commentController,
             [[MediaController alloc]init]
             ];
}

-(CGFloat)componentsGap{
    return 10.f;
}

- (void)pullToRefreshOperation{
    [_commentController pullToRefresh];
}

-(void)getRemoteData{
    __weak typeof(self) wself = self;
    _api = [[ArticleApi alloc]initWithApiType:kArticleApiTypeArticle completionBlock:^(NSDictionary *responseDic, NSError *error) {

        wself.articleModel = [[ArticleModel alloc]initWithDic:responseDic];
        //component callback for data
        [wself setArticleDetailModel:wself.articleModel inWebViewComponents:nil outWebViewComponents:wself.articleModel.outWebViewComponents];
        [wself reLayoutOutWebViewComponents];
    }];
}
@end