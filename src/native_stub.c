#include <stdint.h>
#include "moonbit.h"

#define PLATFORM_KIND_UNKNOWN 0
#define PLATFORM_KIND_WINDOWS 1
#define PLATFORM_KIND_LINUX   2
#define PLATFORM_KIND_DARWIN  3

MOONBIT_FFI_EXPORT int32_t moonrockz_directories_platform_kind(void) {
#ifdef _WIN32
  return PLATFORM_KIND_WINDOWS;
#elif defined(__APPLE__)
  return PLATFORM_KIND_DARWIN;
#elif defined(__linux__)
  return PLATFORM_KIND_LINUX;
#else
  return PLATFORM_KIND_UNKNOWN;
#endif
}
