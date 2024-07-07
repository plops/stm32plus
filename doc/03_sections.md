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