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
    UIProgressView *process;
    UIImageView * newImageView;
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
    
    
    process = [[UIProgressView alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-50, self.view.frame.size.width-40, 20)];
    process.progress = 0.5;
    process.progressTintColor = [UIColor blueColor];
    [self.view addSubview:process];
    
    myView = [[UIView alloc]init];
    myView.center = CGPointMake(process.frame.size.width/2, process.frame.size.height/2);
    myView.bounds = CGRectMake(0, 0, 20, 20);
    [myView setBackgroundColor:[UIColor redColor]];
    myView.layer.cornerRadius = 10;
    myView.clipsToBounds = YES;
    [process addSubview:myView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(buttonChoose:)];
    [myView addGestureRecognizer:pan];
    
    
    
    
    //调节亮度
//    [self AdjustBrightnessWithFloat:0];
    
    //添加滤镜
    [self addFilter];
    
    
    

}
- (void)buttonChoose:(UIPanGestureRecognizer *)sender{
    
    CGPoint translation = [sender translationInView:process];
    
    NSLog(@"%f",translation.x);
    
    if (myView.center.x<0) {
        if (translation.x>0) {
             myView.center = CGPointMake(myView.center.x+translation.x, process.frame.size.height/2);
        }
    }else if (myView.center.x>process.frame.size.width){
        if (translation.x<0) {
             myView.center = CGPointMake(myView.center.x+translation.x, process.frame.size.height/2);
        }
    }else{
        myView.center = CGPointMake(myView.center.x+translation.x, process.frame.size.height/2);
    }
    
    process.progress = (CGFloat)myView.center.x/process.frame.size.width;
    
    [sender setTranslation:CGPointMake(0, 0) inView:process];
    
   
    CGFloat newValue = (CGFloat)(myView.center.x-process.frame.size.width/2)/(process.frame.size.width/2);
    
    
    
    
    
    //调节亮度
//    [self AdjustBrightnessWithFloat:newValue];
    
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
//    GPUImageStretchDistortionFilter *disFilter =[[GPUImageStretchDistortionFilter alloc] init];
//    GPUImageBulgeDistortionFilter *disFilter = [[GPUImageBulgeDistortionFilter alloc] init];
//    GPUImagePinchDistortionFilter *disFilter = [[GPUImagePinchDistortionFilter alloc] init];
//    GPUImageGlassSphereFilter *disFilter = [[GPUImageGlassSphereFilter alloc] init];
//    GPUImageSphereRefractionFilter *disFilter = [[GPUImageSphereRefractionFilter alloc] init];
//    GPUImageToonFilter *disFilter = [[GPUImageToonFilter alloc] init];
    
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
