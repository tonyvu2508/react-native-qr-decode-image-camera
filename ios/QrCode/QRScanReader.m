#import "QRScanReader.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>

@import MLKitVision;
@import MLImage;
@interface QRScanReader()

@end
@implementation QRScanReader

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(readerQR:(NSString *)fileUrl success:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *result = [self readerQR:fileUrl];
    if(result){
      success(result);
    }else{
      NSString *domain = @"";
      NSString *desc = NSLocalizedString(@"No related QR code", @"");
      NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
      NSError *error = [NSError errorWithDomain:domain
                                           code:404
                                       userInfo:userInfo];
      failure(error);
    }
  });
  
  
  
}

-(NSArray*)readerQR:(NSString*)fileUrl{
  fileUrl = [fileUrl stringByReplacingOccurrencesOfString:@"file://" withString:@""];
  
  CIContext *context = [CIContext contextWithOptions:nil];
  
  // CIDetector(CIDetector(Can be used for face recognition) for image analysis，Declare a CIDetector，And set the recognition type CIDetectorTypeQRCode
  CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
  NSData *fileData = [[NSData alloc] initWithContentsOfFile:fileUrl];
  CIImage *ciImage = [CIImage imageWithData:fileData];
  NSArray *features = [detector featuresInImage:ciImage];
  if(!features || features.count==0){
    return nil;
  }
  //3. Get scan results
//  CIQRCodeFeature *feature = [features objectAtIndex:0];
//  NSString *scannedResult = feature.messageString;
//  return scannedResult;
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (int i = 0; i<features.count; i++) {
        CIQRCodeFeature *feature = [features objectAtIndex:i];
        NSString *scannedResult = feature.messageString;
        if(scannedResult.length>0){
            [result addObject:scannedResult];
        }
        
    }
    return result;
}

- (void)onBarcodesDetected:(NSDictionary *)event
{
    
}

RCT_EXPORT_METHOD(readQRVision:(NSString *)fileUrl success:(RCTPromiseResolveBlock)success failure:(RCTResponseErrorBlock)failure){
  dispatch_sync(dispatch_get_main_queue(), ^{
    NSArray *result = [self readQRVision:fileUrl];
    if(result){
      success(result);
    }else{
      NSString *domain = @"";
      NSString *desc = NSLocalizedString(@"No related QR code", @"");
      NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
      NSError *error = [NSError errorWithDomain:domain
                                           code:404
                                       userInfo:userInfo];
      failure(error);
    }
  });
  
  
  
}

-(NSArray*)readQRVision:(NSString*)fileUrl{
    fileUrl = [fileUrl stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSURL *url = [NSURL URLWithString:fileUrl];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];

    BarcodeDetector * barcode = [[BarcodeDetector alloc] init];
    NSArray<MLKBarcode *> *barcodes;
    [barcode findBarcodesInImage:img completed:^(NSArray *barcodes) {
        NSDictionary *eventBarcode = @{@"type" : @"barcode", @"barcodes" : barcodes};
    }];
    NSArray *arr1 = @[fileUrl];
    return arr1;
//    NSString *scannedResult = @"";
//    scannedResult = [test objectAtIndex:0];
//    return test;
}

@end
