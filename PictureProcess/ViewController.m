//
//  ViewController.m
//  PictureProcess
//
//  Created by CSX on 2017/1/18.
//  Copyright © 2017年 宗盛商业. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage.h>



@interface ViewController ()
{
    UIImage *inputImage;
    UIView *myView;
    UIView *bgView;
    UIView *OnView;
    UIImageView * newImageView;
    
    UISlider *slider;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
}
- (void)createView{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2);
    imageView.image = [UIImage imageNamed:@"default.jpg"];
    [self.view addSubview:imageView];
    
    inputImage = [UIImage imageNamed:@"default.jpg"];
    
    newImageView = [[UIImageView alloc]init];
    newImageView.frame = CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
    newImageView.image = inputImage;
    [self.view addSubview:newImageView];
    
    //自定义滑动条
//    bgView = [[UIView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-50, self.view.frame.size.width-40, 40)];
//    bgView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:bgView];
//    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(20, bgView.frame.size.height-20-3, bgView.frame.size.width-40, 6)];
//    showView.backgroundColor = [UIColor whiteColor];
//    [bgView addSubview:showView];
//    OnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, showView.frame.size.width/2, showView.frame.size.height)];
//    OnView.backgroundColor = [UIColor blueColor];
//    [showView addSubview:OnView];
//    myView = [[UIView alloc]init];
//    myView.center = CGPointMake(bgView.frame.size.width/2, bgView.frame.size.height/2);
//    myView.bounds = CGRectMake(0, 0, 40, 40);
//    [myView setBackgroundColor:[UIColor redColor]];
//    myView.layer.cornerRadius = 20;
//    myView.clipsToBounds = YES;
//    [bgView addSubview:myView];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(buttonChoose:)];
//    [myView addGestureRecognizer:pan];
    
    slider = [[UISlider alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-50, self.view.frame.size.width-40, 40)];
    [slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    slider.value = 0.5;
    [self.view addSubview:slider];
    
    
    
    
    
    //调节亮度
    [self AdjustBrightnessWithFloat:0];
    
    //添加滤镜
//    [self addFilter];
    
    
}

//- (void)buttonChoose:(UIPanGestureRecognizer *)sender{
//    
//    CGPoint translation = [sender translationInView:bgView];
//    
//    NSLog(@"%f",translation.x);
//    
//    if (myView.center.x<20) {
//        if (translation.x>0) {
//             myView.center = CGPointMake(myView.center.x+translation.x, myView.center.y);
//        }
//    }else if (myView.center.x>bgView.frame.size.width-20){
//        if (translation.x<0) {
//             myView.center = CGPointMake(myView.center.x+translation.x, myView.center.y);
//        }
//    }else{
//        myView.center = CGPointMake(myView.center.x+translation.x, myView.center.y);
//    }
//    OnView.frame = CGRectMake(0, 0, myView.center.x-20, OnView.frame.size.height);
//    
//    [sender setTranslation:CGPointMake(0, 0) inView:bgView];
//    
//    
//    CGFloat newValue = (CGFloat)((myView.center.x-20)-(bgView.frame.size.width-40)/2)/((bgView.frame.size.width-40)/2);
//    
//    
//    
//    
//    
//    //调节亮度
//    [self AdjustBrightnessWithFloat:newValue];
//    
//}

- (void)changeValue: (UISlider *)sender{
    
    //以0.5为中心左右范围（-1～1）
    
    float a = (float)(slider.value-0.5)/0.5;
    
    [self AdjustBrightnessWithFloat:a];
}


- (void)AdjustBrightnessWithFloat: (CGFloat)brightFloat{
    //创建一个高亮度的滤镜
    GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc]init];
    brightness.brightness = brightFloat;
    //设置要渲染的区域
    [brightness forceProcessingAtSize:inputImage.size];
    [brightness useNextFrameForImageCapture];
    
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:inputImage];
    //再加上滤镜
    [stillImageSource addTarget:brightness];
    //开始渲染
    [stillImageSource processImage];
    
    //获取渲染后的图片
    UIImage *newImage = [brightness imageFromCurrentFramebuffer];
    
    newImageView.image = newImage;
    
}


- (void)addFilter{
    
    /*
     部分滤镜是需要参数设置的
     参数这里都做默认处理
     有需要参数设置的可以ui界面设置优化
     */
    
    //伸展失真（哈哈镜）
//    GPUImageStretchDistortionFilter *disFilter =[[GPUImageStretchDistortionFilter alloc] init];
    //凸起失真，鱼眼效果
//    GPUImageBulgeDistortionFilter *disFilter = [[GPUImageBulgeDistortionFilter alloc] init];
    //收缩失真（凹面镜）
//    GPUImagePinchDistortionFilter *disFilter = [[GPUImagePinchDistortionFilter alloc] init];
    //水晶球效果
//    GPUImageGlassSphereFilter *disFilter = [[GPUImageGlassSphereFilter alloc] init];
    //球形折射，图形倒立
//    GPUImageSphereRefractionFilter *disFilter = [[GPUImageSphereRefractionFilter alloc] init];
    //卡通效果（黑色粗线描边）
//    GPUImageToonFilter *disFilter = [[GPUImageToonFilter alloc] init];
    
    //晕影，形成黑色圆形边缘，突出中间图像的效果
    GPUImageVignetteFilter *disFilter = [[GPUImageVignetteFilter alloc] init];
    //设置要渲染的区域
    [disFilter forceProcessingAtSize:inputImage.size];
    [disFilter useNextFrameForImageCapture];
    //获取数据源
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:inputImage];
    //添加上滤镜
    [stillImageSource addTarget:disFilter];
    //开始渲染
    [stillImageSource processImage];
    //获取渲染后的图片
    UIImage *newImage = [disFilter imageFromCurrentFramebuffer];
    //加载出来
    newImageView.image = newImage;
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
