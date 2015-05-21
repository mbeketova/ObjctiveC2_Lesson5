//
//  ViewController.m
//  ObjctiveC2_Lesson5
//
//  Created by Admin on 20.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "ViewController.h"

//ДЗ - представить свой вариант перегрузки системы.
//Сделать несколько циклов работающих одновременно и распределить их параллельными потоками используя рассмотренные в уроке инструменты.

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray * arrayThread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Ниже сначала загружается красный квадратик, потом наполнение массива циклом 1, синий квадратик, потом цикл 2 и цикл 3
    //Таким образом я распределила последовательность наполнения массива и прорисовки квадратов
    
    self.arrayThread = [[NSMutableArray alloc]init];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Выполняем код в фоне и вызываем главный поток
        UIView * someView = [[UIView alloc]initWithFrame:(CGRectMake(100, 100, 100, 100))];
        someView.backgroundColor = [UIColor redColor];
        [self.view addSubview:someView];
        
        [self memoryCrashOne:@"111"];

        
        dispatch_sync(dispatch_get_main_queue(), ^{
            // Код, который нужно выполнить в главном потоке
            
            UIView * someView = [[UIView alloc]initWithFrame:(CGRectMake(100, 200, 100, 100))];
            someView.backgroundColor = [UIColor blueColor];
            [self.view addSubview:someView];
            
            
            // Мы ждем, пока он выполниться
        });
        // Продолжаем работать в фоновом потоке
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Код, который должен выполниться в фоне
            [self memoryCrashTwo:@"222"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Код, который выполниться в главном потоке

                [self memoryCrashThree:@"333"];
                
                NSLog(@"%@", self.arrayThread);
                
            });
        });

    });
    

        

}

- (void) memoryCrashOne: (NSString*)string {
    @autoreleasepool {
        
        for (int i = 100; i > 0 ; i--) {
            
            [self.arrayThread addObject:string];
            
        }
    }
}


- (void) memoryCrashTwo: (NSString*)string {
    @autoreleasepool {
        
        for (int j = 0; j < 100 ; j++) {
           
            [self.arrayThread addObject:string];
            
        }
    }
}

- (void) memoryCrashThree : (NSString*)string {
    @autoreleasepool {
        
        for (int j = 0; j < 100 ; j++) {
            
            [self.arrayThread addObject:string];
            
        }
    }
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
