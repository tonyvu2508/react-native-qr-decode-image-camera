#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "BarcodeDetector.h"

@interface QRScanReader : NSObject<RCTBridgeModule>
- (void)onBarcodesDetected:(NSDictionary *)event;
@end
