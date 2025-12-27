// base.td - Base TableGen definitions for SiGo chip support packages
// This file defines the fundamental classes for describing chip architectures,
// memory layouts, peripherals, and interrupt configurations.

#ifndef _BASE_TD
#define _BASE_TD

//===----------------------------------------------------------------------===//
// Memory Units
//===----------------------------------------------------------------------===//

class MemoryUnit<int value> {
  int value = value;
}

def Byte : MemoryUnit<1>;
def KB : MemoryUnit<1024>;
def MB : MemoryUnit<1048576>;

//===----------------------------------------------------------------------===//
// Access Modes
//===----------------------------------------------------------------------===//

class AccessMode<string value> {
  string value = value;
}

def Read : AccessMode<"R">;
def Write : AccessMode<"W">;
def ReadWrite : AccessMode<"RW">;
def ReadExec : AccessMode<"RX">;
def ReadWriteExec : AccessMode<"RWX">;

//===----------------------------------------------------------------------===//
// FPU Types
//===----------------------------------------------------------------------===//

class FPUType<string value, list<string> features = []> {
  string value = value;
  list<string> features = features;
}

def NoFPU : FPUType<"none", []>;
def SoftFP : FPUType<"soft", []>;
def FPv4SP : FPUType<"fpv4-sp-d16", ["vfp4d16sp"]>;
def FPv5SP : FPUType<"fpv5-sp-d16", ["fp-armv8d16sp"]>;
def FPv5DP : FPUType<"fpv5-d16", ["fp-armv8d16"]>;

//===----------------------------------------------------------------------===//
// Ranges
//===----------------------------------------------------------------------===//

class Range<int offset, int width> {
  int offset = offset;
  int width = width;
}

class BitRange<int offset, int width> : Range<offset, width>;
class ByteRange<int offset, int width> : Range<offset, width>;

//===----------------------------------------------------------------------===//
// Memory Ranges
//===----------------------------------------------------------------------===//

class MemoryRange<string name, int offset, int width, AccessMode access,
                  bit executable = 0, string description = ""> {
  string name = name;
  int offset = offset;
  int width = width;
  AccessMode access = access;
  bit executable = executable;
  string description = description;
}

//===----------------------------------------------------------------------===//
// Interrupts
//===----------------------------------------------------------------------===//

class Interrupt<string name, int line, string description = ""> {
  string name = name;
  int line = line;
  string description = description;
}

//===----------------------------------------------------------------------===//
// Registers and Fields
//===----------------------------------------------------------------------===//

class Enum<string name, int value, string description = ""> {
  string name = name;
  int value = value;
  string description = description;
}

class Field<string name, int offset, int width, AccessMode access = ReadWrite,
            string description = "", list<Enum> enums = []> {
  string name = name;
  int offset = offset;
  int width = width;
  AccessMode access = access;
  string description = description;
  list<Enum> enums = enums;
}

class Register<string name, int offset, int width, list<Field> fields = [],
               string description = ""> {
  string name = name;
  int offset = offset;
  int width = width;
  list<Field> fields = fields;
  string description = description;
  int count = 1;
}

class RepeatingRegister<string name, int count, int offset, int width,
                        list<Field> fields = [], string description = "">
    : Register<name, offset, width, fields, description> {
  let count = count;
}

//===----------------------------------------------------------------------===//
// Peripherals
//===----------------------------------------------------------------------===//

class PeripheralType<string name, string description = ""> {
  string name = name;
  string description = description;
  list<Register> registers = [];
  int accessWidth = 32;
  int count = 1;
  string arrayLabel = "";
}

class PeripheralInstance<string name, int base, PeripheralType type> {
  string name = name;
  int base = base;
  PeripheralType type = type;
}

class PeripheralGroup<string name, list<PeripheralInstance> instances> {
  string name = name;
  list<PeripheralInstance> instances = instances;
}

//===----------------------------------------------------------------------===//
// Architecture
//===----------------------------------------------------------------------===//

class Architecture<string arch, string name> {
  string arch = arch;
  string name = name;
  list<string> tags = [];
  list<string> features = [];
  string triple = "";
  int alignment = 4;
  FPUType fpu = NoFPU;
  list<string> runtimePackages = [];
}

//===----------------------------------------------------------------------===//
// Variants and Series
//===----------------------------------------------------------------------===//

class Variant<string name, list<MemoryRange> memories, list<Interrupt> interrupts,
              MemoryUnit stackSize, list<string> tags = [], string description = ""> {
  string name = name;
  list<MemoryRange> memories = memories;
  list<Interrupt> interrupts = interrupts;
  int stackSize = stackSize.value;
  list<string> tags = tags;
  string description = description;
}

class Series<string name, Architecture arch> {
  string name = name;
  Architecture arch = arch;
  list<Variant> variants = [];
  list<PeripheralType> peripheralTypes = [];
  list<string> runtimePackages = [];
}

#endif // _BASE_TD
