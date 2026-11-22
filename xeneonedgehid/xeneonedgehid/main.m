// GPLv3 license. See LICENSE file for more information.
// Created by Andrew Hirst

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <IOKit/hid/IOHIDManager.h>

const uint8_t _virtualHidDescriptor[] = {
    0x05, 0x0D,        // Usage Page (Digitizer)
    0x09, 0x04,        // Usage (Touch Screen)
    0xA1, 0x01,        // Collection (Application)
    0x85, 0x0D,        //   Report ID (13)
    0x05, 0x0D,        //   Usage Page (Digitizer)
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x02,        //   Collection (Logical)
    0x09, 0x42,        //     Usage (Tip Switch)
    0x09, 0x47,        //     Usage (Confidence)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x01,        //     Logical Maximum (1)
    0x75, 0x01,        //     Report Size (1)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x95, 0x02,        //     Report Count (2)
    0x81, 0x01,        //     Input (Const,Array,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x51,        //     Usage (0x51)
    0x75, 0x04,        //     Report Size (4)
    0x25, 0x0F,        //     Logical Maximum (15)
    0x95, 0x01,        //     Report Count (1)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x01,        //     Usage Page (Generic Desktop Ctrls)
    0x26, 0xFF, 0x3F,  //     Logical Maximum (16383)
    0x75, 0x10,        //     Report Size (16)
    0x55, 0x0E,        //     Unit Exponent (-2)
    0x65, 0x11,        //     Unit (System: SI Linear, Length: Centimeter)
    0x09, 0x30,        //     Usage (X)
    0x35, 0x00,        //     Physical Minimum (0)
    0x46, 0x79, 0x08,  //     Physical Maximum (2169)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x26, 0x7F, 0x25,  //     Logical Maximum (9599)
    0x46, 0x8A, 0x03,  //     Physical Maximum (906)
    0x09, 0x31,        //     Usage (Y)
    0x81, 0x02,        //     Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x05, 0x0D,        //     Usage Page (Digitizer)
    0xC0,              //   End Collection
    0x27, 0xFF, 0xFF, 0x00, 0x00,  //   Logical Maximum (65534)
    0x75, 0x10,        //   Report Size (16)
    0x95, 0x01,        //   Report Count (1)
    0x09, 0x56,        //   Usage (0x56)
    0x81, 0x02,        //   Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x09, 0x54,        //   Usage (0x54)
    0x15, 0x00,        //   Logical Minimum (0)
    0x25, 0x7F,        //   Logical Maximum (127)
    0x95, 0x01,        //   Report Count (1)
    0x75, 0x08,        //   Report Size (8)
    0x81, 0x02,        //   Input (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position)
    0x85, 0x0A,        //   Report ID (10)
    0x09, 0x55,        //   Usage (0x55)
    0x95, 0x01,        //   Report Count (1)
    0x25, 0x0F,        //   Logical Maximum (15)
    0xB1, 0x02,        //   Feature (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position,Non-volatile)
    0xC0,              // End Collection
    0x05, 0x0D,        // Usage Page (Digitizer)
    0x09, 0x0E,        // Usage (0x0E)
    0xA1, 0x01,        // Collection (Application)
    0x85, 0x21,        //   Report ID (33)
    0x09, 0x22,        //   Usage (Finger)
    0xA1, 0x00,        //   Collection (Physical)
    0x09, 0x52,        //     Usage (0x52)
    0x09, 0x53,        //     Usage (0x53)
    0x15, 0x00,        //     Logical Minimum (0)
    0x25, 0x0A,        //     Logical Maximum (10)
    0x75, 0x08,        //     Report Size (8)
    0x95, 0x02,        //     Report Count (2)
    0xB1, 0x02,        //     Feature (Data,Var,Abs,No Wrap,Linear,Preferred State,No Null Position,Non-volatile)
    0xC0,              //   End Collection
    0xC0,              // End Collection
};

dispatch_queue_t _mainQueue;
CFRunLoopRef _mainRunLoop;

uint8_t _reportBuffer[64] = { 0 };
IOHIDUserDeviceRef _virtualHidDevice = NULL;
IOHIDDeviceRef _hidDevice = NULL;

void HidInputReportCallback(void* context, IOReturn result, void* sender, IOHIDReportType type, uint32_t reportID, uint8_t* report, CFIndex reportLength)
{
    if (result != kIOReturnSuccess) return;
    
    if (reportID == 0x0D)
    {
        assert(reportLength == 54);
        
        for (int i = 0; i < 10; i++)
        {
            uint8_t* pFinger = &report[1 + (5 * i)];
            if (*pFinger & 0x01)
            {
                *pFinger |= 0x02;
            }
        }
    }
    
    if (IOHIDUserDeviceHandleReportWithTimeStamp(_virtualHidDevice, mach_absolute_time(), report, reportLength) != kIOReturnSuccess)
    {
        fprintf(stderr, "Failed send HID report.\n");
    }
}

void HidManagerDeviceRemoved(void* context, IOReturn result, void* sender, IOHIDDeviceRef hidDevice)
{
    if (result != kIOReturnSuccess || hidDevice != _hidDevice) return;
    
    printf("Xeneon Edge disconnected...");
    
    if (_virtualHidDevice)
    {
        IOHIDUserDeviceCancel(_virtualHidDevice);
    }
    
    _hidDevice = NULL;
}

void HidManagerDeviceMatched(void* context, IOReturn result, void* sender, IOHIDDeviceRef hidDevice)
{
    if (result != kIOReturnSuccess) return;
    
    if (_hidDevice)
    {
        printf("A Xeneon Edge touchscreen is already connected. Only one device can be connected at a time.\n");
        return;
    }
    
    printf("Xeneon Edge touchscreen connected!\n");
    
    // Find the display
    uint32_t displayCount = 0;
    CGError res = CGGetOnlineDisplayList(0, nil, &displayCount);
    if (res != kCGErrorSuccess)
    {
        fprintf(stderr, "Failed to get the online display count.\n");
        return;
    }
    
    NSString* displayUUID = NULL;
    
    for (uint32_t i = 0; i < 20; i++)
    {
        for (NSScreen *screen in [NSScreen screens])
        {
            if ([screen.localizedName isEqualToString:@"XENEON EDGE"])
            {
                CFUUIDRef uuid = CGDisplayCreateUUIDFromDisplayID(screen.CGDirectDisplayID);
                if (uuid != NULL)
                {
                    displayUUID = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
                    CFRelease(uuid);
                }
                break;
            }
        }
        
        if (!displayUUID)
        {
            printf("Wating for Xeneon Edge screen to connect...\n");
            usleep(500000);
        }
        else break;
    }

    if (displayUUID)
    {
        printf("Found Xeneon Edge screen. Starting virtual HID device...\n");
    }
    else
    {
        fprintf(stderr, "Could not find the Xeneon Edge screen.\n");
        return;
    }
    
    // Open the HID device
    if (IOHIDDeviceOpen(hidDevice, kIOHIDOptionsTypeSeizeDevice) != kIOReturnSuccess)
    {
        fprintf(stderr, "Failed to open HID device.\n");
        return;
    }
    
    CFIndex reportSize = sizeof(_reportBuffer);
    CFNumberRef reportSizeProp = (CFNumberRef)IOHIDDeviceGetProperty(hidDevice, CFSTR(kIOHIDMaxInputReportSizeKey));
    if (reportSizeProp && CFGetTypeID(reportSizeProp) == CFNumberGetTypeID())
    {
        CFNumberGetValue(reportSizeProp, kCFNumberCFIndexType, &reportSize);
        
        if (reportSize > sizeof(_reportBuffer))
        {
            fprintf(stderr, "The HID report size is larger then the allocated buffer.\n");
            return;
        }
    }
    
    // Create the virtual HID device
    NSDictionary *virtualHidProps = @{
        @kIOHIDReportDescriptorKey: [NSData dataWithBytes:_virtualHidDescriptor length:sizeof(_virtualHidDescriptor)],
        @kIOHIDVendorIDKey: @0x1209,
        @kIOHIDProductIDKey: @0x0001,
        @kIOHIDProductKey: @"XENEON EDGE Touch (Virtual)",
        @kIOHIDManufacturerKey: @"CORSAIR",
        @kIOHIDTransportKey: @"Virtual",
        @"displayUUID": displayUUID
    };
    
    _virtualHidDevice = IOHIDUserDeviceCreateWithProperties(kCFAllocatorDefault, (__bridge CFDictionaryRef)virtualHidProps, 0);
    if (!_virtualHidDevice)
    {
        IOHIDDeviceClose(hidDevice, kIOHIDOptionsTypeNone);
        printf("Failed to create virtual HID device.");
        return;
    }
    
    _hidDevice = hidDevice;
    
    IOHIDUserDeviceSetDispatchQueue(_virtualHidDevice, _mainQueue);
    IOHIDUserDeviceSetCancelHandler(_virtualHidDevice, ^{
        CFRelease(_virtualHidDevice);
        _virtualHidDevice = NULL;
    });
    IOHIDUserDeviceActivate(_virtualHidDevice);
    
    IOHIDDeviceRegisterInputReportCallback(hidDevice, _reportBuffer, reportSize, HidInputReportCallback, NULL);
}

IOHIDManagerRef CreateHidManager(void)
{
    IOHIDManagerRef manager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    if (!manager) return NULL;
    
    NSDictionary* managerFilter = @{
        @kIOHIDVendorIDKey: @0x27c0,
        @kIOHIDProductIDKey: @0x0859,
        @kIOHIDDeviceUsagePageKey: @13,
        @kIOHIDDeviceUsageKey: @4,
        @kIOHIDTransportKey: @"USB",
    };
    
    IOHIDManagerSetDeviceMatching(manager, (__bridge CFDictionaryRef)managerFilter);
    
    IOHIDManagerRegisterDeviceMatchingCallback(manager, HidManagerDeviceMatched, NULL);
    IOHIDManagerRegisterDeviceRemovalCallback(manager, HidManagerDeviceRemoved, NULL);
    
    IOHIDManagerScheduleWithRunLoop(manager, _mainRunLoop, kCFRunLoopDefaultMode);
    IOHIDManagerOpen(manager, kIOHIDOptionsTypeNone);
    
    return manager;
}

int main(int argc, const char * argv[])
{
    _mainRunLoop = CFRunLoopGetCurrent();
    _mainQueue = dispatch_get_main_queue();
    
    IOHIDManagerRef manager = CreateHidManager();
    if (!manager)
    {
        fprintf(stderr, "Failed to create the HID manager.\n");
        return -1;
    }
    
    printf("Xeneon Edge HID utility running...\n");
    
    CFRunLoopRun();
    
    // Cleanup
    IOHIDManagerClose(manager, kIOHIDOptionsTypeNone);
    IOHIDManagerUnscheduleFromRunLoop(manager, _mainRunLoop, kCFRunLoopDefaultMode);
    CFRelease(manager);
    
    return 0;
}
