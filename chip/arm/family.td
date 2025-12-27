// family.td - ARM architecture family definitions
// Defines base architectures for ARM Cortex-M processors

#ifndef _ARM_FAMILY_TD
#define _ARM_FAMILY_TD

include "base.td"

//===----------------------------------------------------------------------===//
// ARM Cortex-M0/M0+ (ARMv6-M)
//===----------------------------------------------------------------------===//

def CortexM0 : Architecture<"arm", "cortex-m0"> {
  let tags = ["arm", "cortexm", "cortexm0", "armv6m"];
  let features = [];
  let triple = "thumbv6m-none-eabi";
  let alignment = 4;
  let fpu = NoFPU;
  let runtimePackages = ["pkg.si-go.dev/chip/arm/cortexm/runtime"];
}

def CortexM0Plus : Architecture<"arm", "cortex-m0plus"> {
  let tags = ["arm", "cortexm", "cortexm0plus", "armv6m"];
  let features = [];
  let triple = "thumbv6m-none-eabi";
  let alignment = 4;
  let fpu = NoFPU;
  let runtimePackages = ["pkg.si-go.dev/chip/arm/cortexm/runtime"];
}

//===----------------------------------------------------------------------===//
// ARM Cortex-M3 (ARMv7-M)
//===----------------------------------------------------------------------===//

def CortexM3 : Architecture<"arm", "cortex-m3"> {
  let tags = ["arm", "cortexm", "cortexm3", "armv7m"];
  let features = [];
  let triple = "thumbv7m-none-eabi";
  let alignment = 4;
  let fpu = NoFPU;
  let runtimePackages = ["pkg.si-go.dev/chip/arm/cortexm/runtime"];
}

//===----------------------------------------------------------------------===//
// ARM Cortex-M4 (ARMv7E-M)
//===----------------------------------------------------------------------===//

def CortexM4 : Architecture<"arm", "cortex-m4"> {
  let tags = ["arm", "cortexm", "cortexm4", "armv7em"];
  let features = ["dsp"];
  let triple = "thumbv7em-none-eabi";
  let alignment = 4;
  let fpu = FPv4SP;
  let runtimePackages = ["pkg.si-go.dev/chip/arm/cortexm/runtime"];
}

//===----------------------------------------------------------------------===//
// ARM Cortex-M7 (ARMv7E-M)
//===----------------------------------------------------------------------===//

def CortexM7 : Architecture<"arm", "cortex-m7"> {
  let tags = ["arm", "cortexm", "cortexm7", "armv7em"];
  let features = ["dsp"];
  let triple = "thumbv7em-none-eabihf";
  let alignment = 4;
  let fpu = FPv5DP;
  let runtimePackages = ["pkg.si-go.dev/chip/arm/cortexm/runtime"];
}

//===----------------------------------------------------------------------===//
// ARM Cortex-M23 (ARMv8-M Baseline)
//===----------------------------------------------------------------------===//

def CortexM23 : Architecture<"arm", "cortex-m23"> {
  let tags = ["arm", "cortexm", "cortexm23", "armv8m", "armv8m.base"];
  let features = [];
  let triple = "thumbv8m.base-none-eabi";
  let alignment = 4;
  let fpu = NoFPU;
  let runtimePackages = ["pkg.si-go.dev/chip/arm/cortexm/runtime"];
}

//===----------------------------------------------------------------------===//
// ARM Cortex-M33 (ARMv8-M Mainline)
//===----------------------------------------------------------------------===//

def CortexM33 : Architecture<"arm", "cortex-m33"> {
  let tags = ["arm", "cortexm", "cortexm33", "armv8m", "armv8m.main"];
  let features = ["dsp"];
  let triple = "thumbv8m.main-none-eabi";
  let alignment = 4;
  let fpu = FPv5SP;
  let runtimePackages = ["pkg.si-go.dev/chip/arm/cortexm/runtime"];
}

//===----------------------------------------------------------------------===//
// ARM Cortex-M55 (ARMv8.1-M Mainline)
//===----------------------------------------------------------------------===//

def CortexM55 : Architecture<"arm", "cortex-m55"> {
  let tags = ["arm", "cortexm", "cortexm55", "armv8.1m", "armv8.1m.main"];
  let features = ["dsp", "mve"];
  let triple = "thumbv8.1m.main-none-eabihf";
  let alignment = 4;
  let fpu = FPv5DP;
  let runtimePackages = ["pkg.si-go.dev/chip/arm/cortexm/runtime"];
}

#endif // _ARM_FAMILY_TD
