# Prompt:

Write section 4.


# Response

## 4. Core Library Components

stm32plus offers a range of fundamental C++ components that simplify embedded development. These components abstract away hardware details, providing a more user-friendly and portable programming experience.

### 4.1 Memory Management

Efficient memory management is essential in resource-constrained embedded systems. stm32plus provides the following classes for handling memory:

- **`Memblock<T>`:** This template class manages blocks of data on the heap. It provides methods for allocation, assignment, resizing, and access.  Assignment creates copies rather than transferring ownership, ensuring data integrity. Data copying uses `memcpy`, making it suitable for simple types and POD structures. 

- **`scoped_array<T>`:** This smart pointer manages dynamically allocated arrays (created with `new []`). It automatically deallocates memory using `delete []` when the pointer goes out of scope, preventing memory leaks.

- **`scoped_ptr<T>`:**  Similar to `scoped_array`, this smart pointer manages dynamically allocated objects (created with `new`). It automatically deallocates memory using `delete` upon destruction.

- **`linked_ptr<T>`:** This smart pointer employs reference counting for managing object lifetime. A circular linked list tracks all pointers referencing an object. When the last `linked_ptr` to an object is destroyed, the object is deleted. This is especially useful for managing objects within STL containers, but note that circular references can lead to memory leaks.

### 4.2 Streams

Streams provide a consistent interface for reading and writing data from various sources and destinations. stm32plus implements standard stream concepts, enabling familiar programming patterns:

- **`InputStream`:** Abstract base class defining methods for reading data sequentially from a source. Includes overloaded `>>` operators for convenient data input.

- **`OutputStream`:** Abstract base class for writing data sequentially to a destination. Includes overloaded `<<` operators for writing various data types.

- **`Reader`:** Extends `InputStream` with `readLine` for reading lines of text, handling different line ending conventions (LF, CRLF).

- **`BufferedInputOutputStream`:** Base class for streams that use a memory buffer, providing read and write capabilities.

- **`ByteArrayOutputStream`:** Writes data to an automatically resizing memory block on the heap. Useful for accumulating data.

- **`ByteArrayInputStream`:** Reads data from a user-supplied byte array.

- **`CircularBufferInputOutputStream`:** Implements a circular buffer for reading and writing data. Ideal for situations where data is produced and consumed at different rates, such as in interrupt-driven communication.

- **`LinearBufferInputOutputStream`:** Uses a linear buffer for reading and writing, similar to a traditional memory buffer.

- **`TextOutputStream`:** Extends `OutputStream` with the ability to write text representations of various data types using the overloaded `<<` operator.

- **`StlStringInputStream`:** Reads data from an STL string, providing an `InputStream` interface.

- **`ReadAheadInputStream`:** Wraps another `InputStream` and provides read-ahead capabilities, improving performance in cases where reading small amounts of data is costly.

- **`LzgDecompressionStream`:** Decompresses data from an `InputStream` using the LZG compression algorithm, allowing for efficient storage and retrieval of data.

- **`ConnectedInputOutputStream`:** Connects an `InputStream` to an `OutputStream`, facilitating the transfer of data between them.

### 4.3 Error Handling

`ErrorProvider` provides a structured error handling mechanism. It is a global singleton that stores an error code along with provider identification and an optional 32-bit cause value. 

### 4.4 Timing

stm32plus offers several classes and utilities for handling time-related operations:

- **`MillisecondTimer`:** A global millisecond counter based on the SysTick timer. Provides delays and time measurement in milliseconds.

- **`MicrosecondDelay`:** Utilizes a timer (default TIM6) to provide microsecond-level delays.

- **`TimeProvider`:** An abstract base class for providing time information, typically used by file systems to timestamp file and directory operations.

- **`RtcTimeProvider`:** Uses the real-time clock (RTC) as the time source.

- **`NullTimeProvider`:** A dummy time provider always returning zero, useful for testing or when time information is not critical.

### 4.5 String Utilities

Several utilities simplify string manipulation:

- **`StringUtil`:** A namespace containing various static utility functions, including:
    - **`itoa`:** Converts an integer to a C-style string.
    - **`modp_uitoa10`:** Optimized uint32_t to C-string conversion.
    - **`modp_dtoa`:** Optimized double to C-string conversion with configurable precision.
    - **`toHex`:** Converts a byte array to a hexadecimal string representation.

- **`TokenisedString`:** Breaks a string into components based on delimiters, making it easy to parse strings with multiple parts.

- **`StdStringUtil`:** Namespace for working with STL strings, including functions for trimming whitespace and tokenizing strings.

- **`Ascii`:** A wrapper class for converting numeric types to ASCII and providing a convenient `const char *` cast operator for output.

### 4.6 Debugging

Debugging embedded systems can be challenging. stm32plus includes utilities to assist with this:

- **`SemiHosting`:** Allows sending debug messages to the host computer's console via the debugger connection. Useful when a physical USART is not available or desired.

- **`HeapMonitor`:**  Periodically gathers heap usage statistics and outputs them to an `OutputStream`. Useful for tracking memory usage over time.

- **`UsartHeapMonitor`:**  Extends `HeapMonitor` to send heap statistics over a USART connection. 


# Prompt: 

Write section 6.

[Comment: This isn't much better than the outline]

# Response:


## 6. Other Peripherals and Features 

stm32plus provides support for a wide range of STM32 peripherals. Access to each peripheral is provided using type-safe C++ classes that can be configured with a set of features declared as C++ template parameters. This section gives a rundown of all the supported peripherals and features, and shows how you can include them in your project. 

### 6.1 ADC (Analog-to-Digital Converter) 

The ADC allows you to convert an analog voltage level on one of its pins to a digital number that can be used by your firmware. 

- **`Adc`**: This is the base class for all ADC functionality and is inherited by `AdcPeripheral` (below). You won't normally need to interact with this class directly. 
- **`AdcPeripheral`**: This generic template class is used as a base for the device-specific specialisations, e.g. `Adc1`.
- **`Adc1`, `Adc2`, `Adc3`**: Device-specific typedefs to allow convenient access to an ADC peripheral. For example, `Adc1<MyFeature1,MyFeature2>` will give you an instance of ADC #1 with the desired features baked in.  
- **Features:** All the ADC feature classes are parameterised by their ADC number (1..3), allowing you to create them for different ADC instances.
    - **`AdcClockPrescalerFeature`**: Set the prescaler for the ADC clock. The prescaler can be 2, 4 or 8. For example, `AdcClockPrescalerFeature<4>` will divide the APB clock by 4.
    - **`AdcRegularChannelFeature`**: This feature allows you to initialise a set of regular channels and their conversion sample time in a single statement. The feature is parameterised by the ADC number, the sample time (e.g. `ADC_SampleTime_3Cycles`) and the list of channels (0..18). For example, `Adc1Cycle56RegularChannelFeature<0,2,5>` will initialise channels 0, 2 and 5 on ADC1 with a sample time of 56 cycles. 
    - **`AdcInjectedChannelFeature`**: Similar to `AdcRegularChannelFeature` but for injected channels (0..3).
    - **`AdcScanModeFeature`**: Configure the ADC to convert its channels in 'scan' mode. When in scan mode the channels will be converted in sequence starting at rank 1. Scan mode is optional and if not configured then only channel rank 1 is used and the other ranks are ignored. You can optionally configure the ADC to raise the 'end-of-conversion' flag either at the end of each individual channel conversion (END_AFTER_EACH_CHANNEL) or at the end of the configured group of channels (END_AFTER_WHOLE_GROUP), the latter being the default. 
    - **`AdcTriggerFeature`**: Configure an ADC to start converting when triggered by a timer or EXTI line. For example, `AdcTimer1Channel3RisingTriggerFeature` will trigger the ADC on the rising edge of the output compare signal of Timer 1, channel 3.
    - **`AdcInterruptFeature`**: This feature enables interrupt handling on a given ADC peripheral. The interrupt can be configured to fire on any combination of end-of-conversion, injected end-of-conversion, overflow and analog watchdog. You can also use this feature to set the priority of the NVIC IRQ channel using `setNvicPriorities()`.
    - **`AdcAnalogWatchdogFeature`**: Configure the built-in analog watchdog that can fire an interrupt when the voltage on a channel crosses pre-defined thresholds.
    - **`AdcTemperatureSensorFeature`**: Initialise the temperature sensor channel of the ADC. For example, `Adc1Cycle144TemperatureSensorFeature` will initialise the sensor on ADC1 with a sample time of 144 cycles.  
    - **`AdcInternalReferenceVoltageFeature`**: Initialise the internal reference voltage channel of the ADC. Similar to `AdcTemperatureSensorFeature`.
    - **`AdcMultiFeature`**: Configure an ADC to run in multi-mode. In multi-mode ADC peripherals are joined to form a single ADC with multiple channels (though the maximum number of channels per ADC is still 18).  For example, `AdcDualRegularSimultaneousDmaMode1Feature` will initialise ADC1 as the master for regular simultaneous conversion mode using DMA mode 1. 

### 6.2 CAN (Controller Area Network)

The CAN peripheral is a specialised device for communicating over a network. It is typically used in industrial applications where timing and reliability are important considerations.

- **`Can`**: This is the base class for all CAN functionality. It inherits from `CanPeripheral` and should not usually be used directly.
- **`CanPeripheral`**: This generic template class is used as a base for the device-specific specialisations, e.g. `Can1` and `Can2`.
- **`Can1`, `Can2`**: Device-specific typedefs to allow convenient access to a CAN peripheral. For example, `Can1<Can1FilterBypassFeature>` will give you an instance of CAN #1 with the filter bypassed so that all incoming messages arrive in FIFO 0.  

- **Features:**
    - **`Can1FilterBypassFeature`**: Bypass the input filtering of CAN #1. When bypassed all incoming messages are placed into FIFO #0.
    - **`Can2FilterBypassFeature`**: Bypass the input filtering of CAN #2. When bypassed all incoming messages are placed into FIFO #0.
    - **`CanSilentModeFeature`**: Enable silent mode. In silent mode the peripheral does not participate in bus activity though it does detect error conditions. 
    - **`CanLoopbackModeFeature`**: Enable loopback mode. In loopback mode the peripheral transmits to itself allowing internal validation of transmit and receive functionality.
    - **`Can1InterruptFeature`**: This feature is very similar to `I2CInterruptFeature` (above) in that it provides a type-safe event based API for handling CAN interrupts. You can subscribe to events that are raised on any of the interrupt conditions listed in the enumeration CanEventType in `CanEventSource.h`. Use `enableInterrupts()` to select the interrupts you want to handle. 

### 6.3 CRC (Cyclic Redundancy Check) 

The CRC unit computes a 32-bit 'checksum' of an input stream of bytes. Checksum algorithms are a simple but often effective way to detect the possibility of data corruption in a block of data.

- **`CrcBase`**: This base class manages the calculation state variables.
- **`CrcPeripheral`**: This template class provides the implementation of the CRC peripheral, parameterised by the endianness of the MCU (Endian::BIG_ENDIAN_MCU or Endian::LITTLE_ENDIAN_MCU) as a static_assert will be raised if this is omitted.  The default padding byte (0) used when an input stream is not a multiple of 32 bits can be customised using the `crc_padding` member of the parameters class. For example, `CrcPeripheral<Endian::BIG_ENDIAN_MCU> crc({0xff})`. 
- **`CrcBigEndian`**: A convenience typedef for the common case of the CRC unit operating in a mode that's compatible with the CRC calculation units in PC based utilities such as ZIP. 
- **`CrcLittleEndian`**: A convenience typedef for when you want to use the default CRC mode of the STM32.
- **`CrcOutputStream`**: This stream allows you to conveniently compute the CRC of a stream of data written to it. Just attach your CRC implementation (e.g. `CrcBigEndian` or `CrcLittleEndian`) to this stream using the constructor and you can use the familiar stream output operators, for example... `CrcOutputStream os(crc); os << "Hello World!";`

### 6.4 DAC (Digital-to-Analog Converter)

The DAC can be used to output a voltage on one of its pins proportional to the digital number in a register.  

- **`Dac`**: This is the base class for all DAC functionality. It should not normally be used directly.
- **`DacPeripheral`**: This generic template class is used as a base for the device-specific specialisations, e.g. `Dac1` and `Dac2`.
- **`Dac1`, `Dac2`**: Device-specific typedefs to allow convenient access to a DAC peripheral. For example, `Dac1<DacChannel112BitLeftAlignmentFeature>` will give you an instance of DAC #1 with 12-bit left alignment.
- **Features:**
    - **`DacDataAlignmentFeature`**: This feature configures the alignment of the data that you will write to the peripheral. The data can be aligned to 8 or 12 bits and the MSB of the data can be aligned to the left or right. `DacChannel112BitLeftAlignmentFeature`, `DacChannel112BitRightAlignmentFeature`, `DacChannel18BitRightAlignmentFeature` are provided as typedefs. Note that only right alignment is available for 8-bit data.
    - **`DacDualChannelFeature`**: This feature configures both DAC channels to be written simultaneously from a single word. Two 8-bit values are packed into a single 16-bit word for 8-bit alignment. For 12-bit alignment the format depends on left or right alignment and is described in the register description in the ST Microelectronics reference manual. You are expected to pack your data for transfer according to the correct format.  `DacDualChannel12BitLeftAlignmentFeature`, `DacDualChannel12BitRightAlignmentFeature` and `DacDualChannel8BitRightAlignmentFeature` are provided as typedefs.

### 6.5 DMA (Direct Memory Access)

DMA allows you to transfer data between memory locations and peripheral registers without using the CPU. 

- **`Dma`**: This base class contains everything common to all DMA channels. Each DMA channel is itself a peripheral with associated traits, e.g. the clock to use. Therefore this base class is templated by its peripheral name (e.g. `PERIPHERAL_DMA1_1`) and inherits from the peripheral class `DmaPeripheral`.
- **`Dma1ChannelN`**:  These are the convenience typedefs for all the DMA channels on DMA controller #1. For example, `Dma1Channel2<>` will give you a DMA channel object for DMA1, channel 2. Note that you may need to specify the transfer word size using the template parameter `TDataSize`.  For example, `Dma1Channel2<DMA_MemoryDataSize_Word>`.
- **`Dma2ChannelN`**: Same as `Dma1ChannelN` but for DMA #2.
- **Features:** The features available vary according to whether the channel belongs to DMA #1 or DMA #2 and on the capabilities of that channel.
    - **`DmaInterruptFeature`**: Enable interrupt handling on this DMA channel. The interrupts can be configured to fire on any combination of complete, half-complete and transfer error events.  Use `enableInterrupts()` to select the events you want to handle. 
    - **`DmaMemoryCopyFeature`**: Copy data from one memory location to another. For example, `DmaMemoryCopyFeature<DMA_MemoryDataSize_Word>` will copy data using 32-bit word transfers.
    - **`DmaMemoryFillFeature`**: Fill a block of memory with a constant value. Similar to `DmaMemoryCopyFeature`.
    - **`PwmFadeTimerDmaFeature`**: Automatically fade PWM duty cycle with a timer. 
    - **`DmaFsmcLcdMemoryCopyFeature`**: Copy data to an LCD display connected via the FSMC peripheral.
    - **`SpiDmaWriterFeature`**: Write data to an SPI peripheral. For example, `SpiDmaWriterFeature<Spi1PeripheralTraits>` will use DMA to write to SPI #1.
    - **`SpiDmaReaderFeature`**: Read data from an SPI peripheral. Similar to `SpiDmaWriterFeature`.
    - **`UsartDmaWriterFeature`**: Write data to a USART peripheral. Similar to `SpiDmaWriterFeature`.
    - **`UsartDmaReaderFeature`**: Read data from a USART peripheral. Similar to `SpiDmaWriterFeature`.
    - **`I2CDmaWriterFeature`**: Write data to an I2C peripheral. Similar to `SpiDmaWriterFeature`.
    - **`I2CDmaReaderFeature`**: Read data from an I2C peripheral. Similar to `SpiDmaWriterFeature`.
    - **`I2SDmaWriterFeature`**: Write data to an I2S peripheral. Similar to `SpiDmaWriterFeature`.
    - **`I2SDmaReaderFeature`**: Read data from an I2S peripheral. Similar to `SpiDmaWriterFeature`.
    - **`SdioDmaReaderFeature`**: Read data from an SDIO peripheral. 
    - **`SdioDmaWriterFeature`**: Write data to an SDIO peripheral.
    - **`AdcDmaFeature`**: Write ADC conversion data to memory.
    - **`AdcMultiDmaFeature`**: Write multi-mode ADC conversion data to memory. 
    - **`DacDmaWriterFeature`**: Write data to a DAC peripheral.

### 6.6 EXTI (External Interrupt)

EXTI allows you to trigger an interrupt on the rising/falling edge of a signal on a GPIO pin. 

- **`ExtiPeripheral`**: A generic template class to encapsulate an EXTI line, parameterised with the EXTI line number (0..22 on the F4).  Typedef aliases are defined in `config/exti.h` such as `Exti0`, `Exti1`...
- **`ExtiInterruptEnabler`**: Enables the interrupt handler for an EXTI line by setting its NVIC interrupt priority. Typedefs are defined in `config/exti.h` such as `ExtiInterruptEnabler<0>`, `ExtiInterruptEnabler<1>` ... You don't need to manually instantiate this class. It's automatically used by the `ExtiPeripheral` template specialisations.

### 6.7 FSMC/FMC (Flexible Static Memory Controller)

The FSMC/FMC is a specialised peripheral that allows the MCU to easily access externally connected memory devices. This includes SRAM, NAND flash and also LCD panels. 

- **`FsmcPeripheral`**: Generic template for FSMC/FMC banks. The specific instances of the peripheral inherit from this. The template parameter is the bank that this peripheral is connected to.
- **`FsmcSram`**: Interface class for connecting and controlling external SRAM. This class handles the GPIO pin configuration.  
- **`FsmcNand`**: Interface class for connecting and controlling external NAND flash memory. Similar to `FsmcSram` but with a different pin configuration. 
- **Timing Classes:** 
    - **`FsmcAddressDataSetupTiming`**: Base class for devices that just need simple address and data setup timings.
    - **`FsmcNandTiming`**: A simple helper class that sets up the structure required for an FSMC NAND device.
    - **`FsmcSramTiming`**: Same as above, but for SRAM devices. 
    - **`Fsmc8080LcdTiming`**: Helper for LCD devices that use the 8080 interface.


### 6.8 GPIO (General Purpose Input/Output)

The GPIO peripheral can be configured for input or output or alternative function modes, such as to be used by SPI or I2C.

- **`Gpio`**: The base class for configuring and interacting with GPIO pins. This class is never used directly by the user. Instead it's included in your project by the higher-level feature classes such as `DigitalOutputFeature`.
- **`GpioPortBase`**: This base class manages the array of pointers to the Gpio objects. Its purpose is to avoid some of the virtual inheritance issues that would arise if GpioPort were to inherit directly from Gpio. 
- **`GpioPort`**: This template class provides the ability to configure an entire 16-bit GPIO port, including alternate functions, in a single declaration. The two template parameters are the port base address (e.g. `GPIOA_BASE`) and the list of features that you want to include. A typical example would be: `GpioC<DefaultDigitalInputFeature<1,7,13>,DefaultDigitalOutputFeature<8,9,15>>`. This declaration will initialise GPIOC pins 1, 7 and 13 for input and pins 8, 9 and 15 for output. Other features can be added to your port declarations to include alternate function pins.
- **`GpioPinRef`**: Sometimes it's useful to have a simple reference to a port and a pin. For example, when you want to quickly set or reset an LED without the overhead of the Gpio class. The GpioPinRef can be constructed from a `Gpio` object or you can create it directly, for example: `GpioPinRef(GPIOE,GPIO_Pin_1);`. 
- **Features:** 
    - **`DigitalOutputFeature`**:  Initialise pins as a digital output. The feature is parameterised by the GPIO speed (e.g. GPIO_Speed_50MHz), the output type (PUSH_PULL or OPEN_DRAIN), the pull-up/down setting (PUPD_NONE, PUPD_UP or PUPD_DOWN), and a list of pins (0..15).  For example, `DefaultDigitalOutputFeature<1,2,5>` will set pins 1, 2 and 5 to be outputs on the GPIO port.
    - **`DigitalInputFeature`**: Initialise a list of pins as digital inputs. Similar to `DigitalOutputFeature`.
    - **`AlternateFunctionFeature`**: Initialise a list of pins for alternate function mode. This feature is used extensively by the stm32plus peripheral classes to enable, for example, the pins for I2C or SPI. You can use this directly if your alternate function is not one of those supported by the convenience features such as `DefaultTim1AlternateFunctionFeature`.
    - **`AnalogInputFeature`**: Initialise a list of pins as analog input pins. Analog input pins are required for use with the ADC peripheral. 

### 6.9 I2C (Inter-Integrated Circuit)

The I2C peripheral is a 2-wire serial interface protocol for low-speed communications with devices. It's a very common protocol for interfacing with peripherals such as EEPROMs, RTCs and ADCs.

- **`I2C`**: The base class for all I2C functionality. Inherits from `I2CPeripheral`. The I2C peripheral is very similar across the MCU families so there are no specialisations of this class.
- **`I2CPeripheral`**: This generic template class is used as a base for the device-specific specialisations, e.g. `I2C1_Default` and `I2C1_Remap`.
- **`I2C1`, `I2C2`, `I2C3`**: These are the convenience typedefs that will create instances of an I2C peripheral configured with your selection of features and the default pins for that peripheral. If you need to use alternative pins then the pre-defined remap types can be used, for example `I2C2_Remap1`.
- **Features:** 
    - **`I2CSingleByteMasterPollingFeature`**: This feature supports the common use case of accessing a slave I2C device that has a 1-byte 'register' index and a single byte data size.  For example, most accelerometers.  Convenience functions such as `resetBits` and `setBits` are provided for interacting with the bits in the device's 8-bit registers.
    - **`I2CTwoByteMasterPollingFeature`**: This feature supports accessing a slave I2C device that has a 2-byte address and a single byte data size. For example, an EEPROM. Similar to the single byte feature but for devices with more than 255 registers.
    - **`I2CMasterPollingFeature`**: This is the base for the single and double byte features above.
    - **`I2CInterruptFeature`**: This feature is very similar to `SpiInterruptFeature` (above) in that it provides a type-safe event based API for handling I2C interrupts. You can subscribe to events that are raised on any of the interrupt conditions listed in the enumeration `I2CEventType` in `I2CEventSource.h`.  Use `enableInterrupts()` to select the events you want to handle.
    - **`I2CSlaveFeature`**: Provides functions for a peripheral acting as a slave on the I2C bus.
    - **`I2CSecondSlaveFeature`**: This feature enables a second slave address that can be used to access the peripheral. The second address can have fewer bits than the default address, if required. 


### 6.10 I2S (Inter-IC Sound)

The I2S peripheral is a specialised version of SPI that is often used for interfacing with audio devices. 

- **`I2S`**: The base class for all I2S functionality. This inherits from `I2SPeripheral` and should not usually be used directly.
- **`I2SPeripheral`**: This generic template class is used as a base for the device-specific specialisations, e.g. `I2S2` and `I2S3`.
- **`I2S2`, `I2S3`**: Device-specific typedefs to allow convenient access to an I2S peripheral. For example, `I2S3<>` will give you an instance of I2S #3.
- **Features:** 
    - **`I2SInterruptFeature`**: Similar to `SpiInterruptFeature` but for the I2S peripheral. You subscribe to events that are defined in the `SpiEventType` enumeration in `SpiEventSource.h`. 
 
### 6.10 RNG (Random Number Generator)

The RNG peripheral is for generating a stream of random 32-bit words. The F4 uses a hardware random number generator and the F1 provides a software implementation of the WELL512 algorithm.  

- **`Rng`**: The base class for the random number generator. This is templated to allow the inclusion of optional features but the default (`DefaultRng`) has no features.
- **`DefaultRng`**: A convenience typedef for the common case of a feature-less RNG. 
- **Features:** 
    - **`RngInterruptFeature`**: This feature is available only for the F4. It allows you to receive notifications asynchronously via the `RngEventType` enumeration in `RngEventSource.h` when a random number is available. This avoids having to poll the peripheral's ready flag. You can also use this feature to set the NVIC priority of the IRQ.

### 6.11 RTC (Real-Time Clock)

The real-time clock allows your firmware to access real time and date information. The clock source can be the internal low-speed oscillator, the external 32.768kHz oscillator or, for the F4, the HSE divided down. 

- **`RtcBase`**: Base class for RTC implementations. This class manages the interface to the underlying peripheral library.
- **`Rtc`**: The template class for creating an instance of the RTC. A frequency provider class is required and at least one of the interrupt features must be specified.
- **Features:** 
    - **`RtcLsiClockFeature`**: This feature configures the RTC to run from the internal low speed oscillator.  It's parameterised with a class that implements a `getLsiFrequency()` method. `RtcMeasuredLsiFrequencyProvider` is provided for the F4 that can measure the LSI frequency for increased accuracy. `Rtc32kHzLsiFrequencyProvider` is provided for the F1 that uses a fixed assumption of 32768kHz. 
    - **`RtcLseClockFeature`**: Configure the RTC to run from the external low speed oscillator. 
    - **`RtcSecondInterruptFeature`**: Configure an interrupt to fire once per second. This is a simple and accurate way to trigger actions periodically in your firmware, for example to poll a touch screen or update an LCD display.
    - **`RtcAlarmInterruptFeature`**:  This feature provides access to the STM32's built-in alarm functionality. The alarm can be configured to trigger on any combination of the date/time components. 

### 6.12 SDIO (Secure Digital Input/Output)

The SDIO peripheral is for interfacing with SD, SDHC and MMC memory cards. Support is provided for 1, 4 and 8 bit bus modes. 

- **`SdCardBase`**: Base class for SD card implementations. Provides the interface to the underlying peripheral driver. 
- **`SdCard`**: The template class for creating an instance of the SDIO.  Must include at least one of the IO features.
- **`SdioDmaSdCard`**: This is a concrete class that brings together all the required features to form a complete SD card interface that can be accessed like a block device. This class is intended for maximum performance and makes use of the DMA controller and interrupts to access the peripheral.
- **Features:**
    - **`SdCardSdioFeature`**: Initialises the SDIO peripheral and provides access to the SD card commands that are defined in the SD card standard. You can manually control the SDIO clock dividers for initialisation and data transfer speed. Alternatively you can set the constructor parameter to 'true' (the default) and this feature will automatically attempt to set them up for target speeds of 400kHz (init) and 24MHz (transfer). 
    - **`SdioInterruptFeature`**: Enables handling of SDIO interrupts via a type-safe event-based API. You can subscribe to events that are defined in the `SdioEventType` enumeration in `SdioEventSource.h`. Use `enableInterrupts()` to select the events you want to handle.  
 
### 6.13 SPI (Serial Peripheral Interface)

The SPI peripheral is a common choice for interfacing with all sorts of external peripherals. Support is provided for all four SPI peripherals with all the remapping options.  

- **`Spi`**: The base class for all SPI functionality. It inherits from `SpiPeripheral` and the device-specific `SpiDeviceIo` class that handles the slightly different I/O commands in the ST peripheral driver.
- **`SpiPeripheral`**: This generic template class is used as a base for the device-specific specialisations, e.g. `Spi1` and `Spi2`. 
- **`Spi1`, `Spi2`, `Spi3`**: Convenience typedefs that define an SPI peripheral with the default pins and your selected features. Alternative pin configurations can be accessed via the remapping typedefs. For example, `Spi1_Remap1`.
- **Features:**
    - **`SpiInterruptFeature`**: This feature is very similar to `I2CInterruptFeature` (above) in that it provides a type-safe event based API for handling SPI interrupts. You can subscribe to events that are raised on any of the interrupt conditions listed in the enumeration `SpiEventType` in `SpiEventSource.h`. Use `enableInterrupts()` to select the interrupts you want to handle. 
    - **`SpiPollingInputStream`**: This class implements the `InputStream` interface and allows for convenient polling reception of data from an SPI peripheral.
    - **`SpiPollingOutputStream`**: This class implements the `OutputStream` interface and allows for convenient polling transmission of data to an SPI peripheral.
 
### 6.14 Timer

The timers are incredibly flexible and powerful peripherals that can be used for a wide range of applications such as PWM output, input capture, and event generation. There are many features available for timers, see the examples and header files for more information.

- **`Timer`**: The base class for all timer functionality. Manages the basic timebase configuration, enabling/disabling and basic operations such as setting the prescaler.
- **`TimerPeripheral`**: Generic template for timer peripherals. 
- **`AdvancedControlTimer`**: Base class for advanced control timers (TIM1, TIM8). These timers have the most features and are often used for PWM output.
- **`GeneralPurposeTimer`**: Base class for general purpose timers (TIM2..5, TIM9..14). These timers have a subset of the features of the advanced control timers and are often used for tasks such as input capture and event generation.
- **`BasicTimer`**: Base class for basic timers (TIM6, TIM7). These timers have the least features and are often used as simple counters or for generating triggers for other peripherals.
- **`Timer1`, `Timer2`...**: Convenience typedefs that allow access to specific timers.
- **Features:**
    - **`TimerInterruptFeature`**: Enables interrupt handling on a timer. You can subscribe to a range of events as defined in the `TimerEventType` enumeration in `TimerEventSource.h`. For example, `EVENT_COMPARE1` or `EVENT_UPDATE`. Use `enableInterrupts()` to select the events you want to handle.  
    - **`TimerChannel1Feature`, `TimerChannel2Feature`...**: The 4 channels (1..4) of each timer have features to support use as input captures, output compares and PWM. 
    - **`TimerInternalClockFeature`**: This feature configures the timer to use the internal clock as its source.
    - **`TimerMasterFeature`**: This feature configures the timer as a master for one or more slave timers. For example, `TimerUpdateMasterFeature` will make the timer a master, using the Update event as the trigger. 
    - **`TimerSlaveFeature`**: This feature configures the timer as a slave for another timer.  `TimerSlaveFeature` is a generic feature that allows you to configure the timer as a slave to another timer using one of the four possible triggers and a range of possible slave modes. 
    - **`TimerBreakFeature`**: This feature supports the break functionality available on some timers. When a break input is received the timer outputs are disabled and forced to a predefined level. 
    - **`TimerExternalMode1ClockFeature`**: This feature configures the timer to use an external clock as a trigger. The counter can count at each rising or falling edge on a selected input.
    - **`TimerInternalTriggerClockFeature`**: This feature configures the timer to use the update or compare event of another timer as its clock.
    - **`TimerEncoderFeature`**: This feature configures the timer to use its channels 1 and 2 as inputs from a quadrature encoder. The timer's counter will then tick up and down as the encoder is operated. You can use this feature to implement a rotary encoder interface for your firmware.



# Prompt:

Write section 7.

# Response: