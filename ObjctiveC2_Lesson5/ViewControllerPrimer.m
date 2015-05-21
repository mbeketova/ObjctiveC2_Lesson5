//
//  ViewControllerPrimer.m
//  ObjctiveC2_Lesson5
//
//  Created by Admin on 21.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "ViewControllerPrimer.h"

@interface ViewControllerPrimer ()

@property (nonatomic, strong) NSThread * thread;
@property (nonatomic, strong) NSMutableArray * threadArray;

@end

@implementation ViewControllerPrimer

- (void)viewDidLoad {
    [super viewDidLoad];
//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
    /* 1) самое простое решение: распараллеливание очереди через селектор:
     
     [self performSelectorInBackground:@selector(memoryCrash) withObject:nil];
     
     UIView * someView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
     someView.backgroundColor = [UIColor redColor];
     [self.view addSubview:someView];
     
     */
//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
    
    
    /* 2) с помощью селектора так же можно заблокировать дальнейшее выполнение программы (т.е. сначала выполнится цикл и после этого только загрузка квадрата)
     
     [self performSelectorOnMainThread:@selector(memoryCrash) withObject:nil waitUntilDone:YES];
     
     UIView * someView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
     someView.backgroundColor = [UIColor redColor];
     [self.view addSubview:someView];
     
     */

//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
    
    /*3)распараллеливание с помощью класса Thread:
     
     NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(memoryCrash) object:nil];
     [thread start];*/
//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
    
    /*4) пример распараллеливания задач с прерыванием с помощью класса Thread
     
     
     self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(memoryCrashTwo) object:nil];
     self.thread.name = @"memoryCrashTwo";
     [self.thread start];
     
     UIView * someView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
     someView.backgroundColor = [UIColor redColor];
     [self.view addSubview:someView];
     
     [self performSelector:@selector(cancleThread) withObject:nil afterDelay:3]; //отмена выполнения операции произойдет через 3 секунды */

//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
    
    
    /*5)  пример - как записывать в один массив данные из двух потоков с помощью класса Thread
     
     self.threadArray = [[NSMutableArray alloc]init];
     
     self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(memoryCrashTree:) object:@"Thread 1111"];
     self.thread.name = @"ThreadOne";
     
     
     NSThread * threadTwo = [[NSThread alloc]initWithTarget:self selector:@selector(memoryCrashTree:) object:@"Thread 2222"];
     threadTwo.name = @"ThreadTwo";
     
     [self.thread start];
     [threadTwo start];
     
     UIView * someView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
     someView.backgroundColor = [UIColor redColor];
     [self.view addSubview:someView];
     
     [self performSelector:@selector(showThreadArray) withObject:nil afterDelay:3]; //вызов через 3 секунды
     */
    
//----------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------
    //6)  GCD или Grand Central Dispatch — механизм распаралеливания задач
    
    //выполняем код в фоне: (аналог примера 1)
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 2), ^{
        [self memoryCrash]; // Код, который должен выполниться в фоне
    });
    
    UIView * someView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    someView.backgroundColor = [UIColor redColor];
    [self.view addSubview:someView];
//----------------------------------------------------------------------------------------------------------------
    
/*    //Выполняем код в фоне и вызываем главный поток:
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Код, который должен выполниться в фоне
        [self memoryCrashTwo];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Код, который выполниться в главном потоке
            UIView * someView = [[UIView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
            someView.backgroundColor = [UIColor blueColor];
            [self.view addSubview:someView];
        });
    });
    
  */

//----------------------------------------------------------------------------------------------------------------

    /*      //Ждем выполнения задачи: (аналог 5 примера)
     
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     // Код, который должен выполниться в фоне
     
     [self memoryCrashThree];
     
     dispatch_sync(dispatch_get_main_queue(), ^{
     // Код, который нужно выполнить в главном потоке
     [self memoryCrashFour];
     // Мы ждем, пока он выполниться
     });
     // Продолжаем работать в фоновом потоке
     
     [self memoryCrashThree];
     
     });  */

//----------------------------------------------------------------------------------------------------------------

    
    //в примере ниже очередь распределяется последовательно:
   /* dispatch_queue_t queue = dispatch_queue_create("myqueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        [self memoryCrash];
    });
    
    dispatch_async(queue, ^{
        [self memoryCrashTwo];
    });*/
    
//----------------------------------------------------------------------------------------------------------------
    //в примере ниже показывается, как запустить какую-либо процедуру один раз
    dispatch_once_t onceTask;
    dispatch_once (& onceTask, ^{
        // запустить что-то один раз
    });

//----------------------------------------------------------------------------------------------------------------
    
    
    double seconds = 1000.0;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_MSEC);
    dispatch_after(time, dispatch_get_main_queue (), ^{
        //здесь пишется код для анимации
    });
//----------------------------------------------------------------------------------------------------------------

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) memoryCrash { //метод для показа примеров 1-3/6
    for (int i = 0; i < 5000; i++) {
        NSLog(@"i: %i", i);
    }
}

- (void) memoryCrashTwo { //метод для показа примера 4/6
    @autoreleasepool { //autoreleasepool - нужно чтобы не уничтожались объекты
        
        
        
        for (int i = 5000; i > 0 ; i--) {
            
            
            if (!self.thread.cancelled) {
             NSLog(@"i: %i", i);
             }
             
             else {
             [self performSelectorOnMainThread:@selector(showAlertThread) withObject:nil waitUntilDone:YES];
             
             break;
             }
            
        }
    }
}



- (void) cancleThread {//метод для показа примера 4
    
    NSLog(@"Thread - %@ is cancled", self.thread.name);
    [self.thread cancel];
}


- (void) showAlertThread {//метод для показа примера 4
    UIAlertView * alertview = [[UIAlertView alloc]initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Thread - %@ is cancled", self.thread.name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertview show];
}


- (void) memoryCrashTree:(NSString *)string { //метод для показа примера 5
    
    
    NSLog(@"Thread %@ is started", [[NSThread currentThread]name]);
    
    @synchronized (self) { //блок для разграничения потоков
        
        @autoreleasepool {
            
            for (int i = 0; i < 10000; i++) {
                
                
                [self.threadArray addObject:string];
                
            }
        }
    }
    
    NSLog(@"Thread %@ is finished", [[NSThread currentThread]name]);
}

- (void) showThreadArray { //метод для показа примера 5
    
    NSLog(@"self.threadArray %@", self.threadArray);
    
}






@end
