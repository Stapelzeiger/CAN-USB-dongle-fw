/*
    ChibiOS - Copyright (C) 2006-2014 Giovanni Di Sirio

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

#ifndef _USBCFG_H_
#define _USBCFG_H_

#include <hal.h>

extern cdc_linecoding_t serial_usb_linecoding;
extern const USBConfig usbcfg;
extern SerialUSBConfig serusbcfg1;
extern SerialUSBConfig serusbcfg2;

#endif  /* _USBCFG_H_ */

/** @} */
