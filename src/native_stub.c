#include <stdint.h>
#include "moonbit.h"

// 0 = Unknown, 1 = Windows, 2 = Linux, 3 = Darwin
MOONBIT_FFI_EXPORT int32_t moonrockz_directories_platform_kind(void) {
#ifdef _WIN32
  return 1;
#elif defined(__APPLE__)
  return 3;
#elif defined(__linux__)
  return 2;
#else
  return 0;
#endif
}
