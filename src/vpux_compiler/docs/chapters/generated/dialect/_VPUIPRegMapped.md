<!-- Autogenerated by mlir-tblgen; don't manually edit -->
# 'VPUIPRegMapped' Dialect

VPU NN Register Mapped RunTime Dialect
The **VPUIPRegMapped Dialect** represents NN RunTime IR together with RegMapped
    constructs in terms of the MLIR framework.

It allows to work with the graph schema inside the MLIR framework in order to:

* Validate it.
* Perform additional low level transformations/optimizations.

It handles such VPU-specifics as:

* Memory/executors hierarchy.
* HW barriers notion.
* Supported operation set.

Again, it represents also the register mapped configuration of the hardware registers.

[./VPUIPRegMapped/_ops_interfaces.md]

[TOC]

## Attribute definition

### RegisterAttr



This object represents closely a Register Attr
#### Parameters:

| Parameter | C++ type | Description |
| :-------: | :-------: | ----------- |
| reg | `vpux::VPUIPRegMapped::RegisterType` |  |

### RegisterFieldAttr



This object represents closely a RegisterField Attr
#### Parameters:

| Parameter | C++ type | Description |
| :-------: | :-------: | ----------- |
| regField | `vpux::VPUIPRegMapped::RegFieldType` |  |

### RegisterMappedAttr



This object represents closely a RegisterMapped Attr
#### Parameters:

| Parameter | C++ type | Description |
| :-------: | :-------: | ----------- |
| regMapped | `vpux::VPUIPRegMapped::RegMappedType` |  |

## Type constraint definition

### VPUIPRegMapped Index type
An index type containing the value as a parameter

### VPUIPRegMapped RegField Type
This object represents closely a RegField Type
### VPUIPRegMapped RegMapped Type
This object represents closely a RegMapped Type
### VPUIPRegMapped Register Type
This object represents closely a Register Type
## Operation definition

### `VPUIPRegMapped.ActKernelInvocation` (vpux::VPUIPRegMapped::ActKernelInvocationOp)

Activation Kernel Invocation


Syntax:

```
operation ::= `VPUIPRegMapped.ActKernelInvocation` attr-dict
              `range_index` `(` $range_index `:` type($range_index) `)`
              (`waits` `(` $waitBarriers^ `:` type($waitBarriers) `)`)?
              (`updates` `(` $updateBarriers^ `:` type($updateBarriers) `)`)?
              `tile` `(` $tile `)`
              `start_after` `(` $start_after `)`
              `clean_after` `(` $clean_after `)`
              `->` type(results)
```


Traits: AttrSizedOperandSegments, VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface, ExecutableTaskOpInterface, GetOffsetOfOpInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `tile` | ::mlir::IntegerAttr | 64-bit unsigned integer attribute
| `start_after` | ::mlir::IntegerAttr | 64-bit unsigned integer attribute
| `clean_after` | ::mlir::IntegerAttr | 64-bit unsigned integer attribute

#### Operands:

| Operand | Description |
| :-----: | ----------- |
| `waitBarriers` | VPUIPRegMapped Index type
| `updateBarriers` | VPUIPRegMapped Index type
| `range_index` | VPUIPRegMapped Index type

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.ActKernelRange` (vpux::VPUIPRegMapped::ActKernelRangeOp)

Activation Kernel Range


Syntax:

```
operation ::= `VPUIPRegMapped.ActKernelRange` attr-dict
              `kernel_text_index` `(` $kernel_text_index `:` type($kernel_text_index) `)`
              `kernel_args_index` `(` $kernel_args_index `:` type($kernel_args_index) `)`
              `kernel_entry_index` `(` $kernel_entry_index `:` type($kernel_entry_index) `)`
              `->` type(results)
```


Traits: VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface, GetOffsetOfOpInterface

#### Operands:

| Operand | Description |
| :-----: | ----------- |
| `kernel_text_index` | VPUIPRegMapped Index type
| `kernel_args_index` | VPUIPRegMapped Index type
| `kernel_entry_index` | VPUIPRegMapped Index type

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.ActShaveRt` (vpux::VPUIPRegMapped::ActShaveRtOp)

Declaration of Act Shave Management Kernel


Syntax:

```
operation ::= `VPUIPRegMapped.ActShaveRt` attr-dict `kernel` `(` $kernel_path `)` `->` type(results)
```


Traits: DeclarationOp, VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `kernel_path` | ::mlir::StringAttr | string attribute

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.ConfigureBarrier` (vpux::VPUIPRegMapped::ConfigureBarrierOp)

A task to configure the setup for a barrier


Syntax:

```
operation ::= `VPUIPRegMapped.ConfigureBarrier` attr-dict
              `<` $id `,` $next_same_id `>`
              `->` type(results)
```


Traits: DeclarationOp, VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `id` | ::mlir::IntegerAttr | 8-bit signless integer attribute
| `next_same_id` | ::mlir::IntegerAttr | 32-bit signed integer attribute
| `producer_count` | ::mlir::IntegerAttr | 8-bit unsigned integer attribute
| `consumer_count` | ::mlir::IntegerAttr | 8-bit unsigned integer attribute

#### Results:

| Result | Description |
| :----: | ----------- |
| `barrier` | VPUIPRegMapped Index type

### `VPUIPRegMapped.DPUInvariant` (vpux::VPUIPRegMapped::DPUInvariantOp)

DPU Invariant Op


Syntax:

```
operation ::= `VPUIPRegMapped.DPUInvariant` attr-dict
              `input` `(` $input  `:` type($input) `)`
              (`input_sparsity_map` `(` $input_sparsity_map^  `:` type($input_sparsity_map) `)`)?
              (`input_storage_element_table` `(` $input_storage_element_table^  `:` type($input_storage_element_table) `)`)?
              (`weights` `(` $weights^  `:` type($weights) `)`)?
              (`weights_sparsity_map` `(` $weights_sparsity_map^  `:` type($weights_sparsity_map) `)`)?
              (`weight_table` `(` $weight_table^  `:` type($weight_table) `)`)?
              `parent_input` `(` $parent_input `:` type($parent_input) `)`
              (`parent_input_sparsity_map` `(` $parent_input_sparsity_map^  `:` type($parent_input_sparsity_map) `)`)?
              (`parent_input_storage_element_table` `(` $parent_input_storage_element_table^  `:` type($parent_input_storage_element_table) `)`)?
              `parent_output` `(` $parent_output `:` type($parent_output) `)`
              (`parent_output_sparsity_map` `(` $parent_output_sparsity_map^  `:` type($parent_output_sparsity_map) `)`)?
              (`outputs` `(` $output_buffs^ `:` type($output_buffs) `)`)?
              (`output_sparsity_map_buff` `(` $output_sparsity_map_buff^  `:` type($output_sparsity_map_buff) `)`)?
              (`profiling_data` `(` $profiling_data^  `:` type($profiling_data) `)`)?
              (`waits` `(` $waitBarriers^ `:` type($waitBarriers) `)`)?
              (`updates` `(` $updateBarriers^ `:` type($updateBarriers) `)`)?
              `->` type($index)
              `PPE` `:` $ppe
```


Traits: AttrSizedOperandSegments, HasOnlyGraphRegion, NoTerminator, SingleBlock, VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface, ExecutableTaskOpInterface, GetOffsetOfOpInterface, RegionKindInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `task_type` | vpux::VPUIP::NCETaskTypeAttr | NCE task type
| `mpe_frequent_mode` | vpux::VPU::MPEModeAttr | MPE Mode
| `kernel_size` | ::mlir::ArrayAttr | 64-bit integer array attribute
| `kernel_strides` | ::mlir::ArrayAttr | 64-bit integer array attribute
| `kernel_padding` | vpux::VPU::PaddingAttr | DictionaryAttr with field(s): 'left', 'right', 'top', 'bottom' (each field having its own constraints)
| `activation_window_channel_length` | mlir::IntegerAttr | Integer attribute
| `is_continued` | ::mlir::UnitAttr | unit attribute
| `cm_sp_pattern` | mlir::IntegerAttr | Integer attribute
| `input_channels_compression` | ::mlir::UnitAttr | unit attribute
| `is_segmented` | ::mlir::UnitAttr | unit attribute
| `out_channel_offset` | mlir::IntegerAttr | Integer attribute
| `is_superdense` | ::mlir::UnitAttr | unit attribute
| `input_se_size` | mlir::IntegerAttr | Integer attribute
| `output_se_size` | mlir::IntegerAttr | Integer attribute
| `start_after` | ::mlir::IntegerAttr | 64-bit unsigned integer attribute
| `clean_after` | ::mlir::IntegerAttr | 64-bit unsigned integer attribute

#### Operands:

| Operand | Description |
| :-----: | ----------- |
| `input` | memref of 16-bit float or bfloat16 type or QuantizedType values
| `input_sparsity_map` | memref of 1-bit signless integer values
| `input_storage_element_table` | memref of 32-bit signless integer values
| `weights` | memref of 16-bit float or bfloat16 type or QuantizedType values
| `weights_sparsity_map` | memref of 1-bit signless integer values
| `weight_table` | memref of 32-bit signed integer values
| `parent_input` | memref of any type values or VPUIP buffer type to describe the buffer tiling
| `parent_input_sparsity_map` | memref of 1-bit signless integer values
| `parent_input_storage_element_table` | memref of 32-bit signless integer values
| `parent_output` | memref of any type values or VPUIP buffer type to describe the buffer tiling
| `parent_output_sparsity_map` | memref of 1-bit signless integer values
| `output_buffs` | memref of 16-bit float or 32-bit float or bfloat16 type or QuantizedType values
| `output_sparsity_map_buff` | memref of 1-bit signless integer values
| `profiling_data` | memref of 64-bit unsigned integer values
| `waitBarriers` | VPUIPRegMapped Index type
| `updateBarriers` | VPUIPRegMapped Index type

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.DPUVariant` (vpux::VPUIPRegMapped::DPUVariantOp)

DPU Variant Op


Traits: VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface, GetOffsetOfOpInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `start` | ::mlir::ArrayAttr | 64-bit integer array attribute
| `end` | ::mlir::ArrayAttr | 64-bit integer array attribute
| `pad` | vpux::VPU::PaddingAttr | DictionaryAttr with field(s): 'left', 'right', 'top', 'bottom' (each field having its own constraints)
| `mpe_mode` | vpux::VPU::MPEModeAttr | MPE Mode
| `cluster_id` | mlir::IntegerAttr | Integer attribute

#### Operands:

| Operand | Description |
| :-----: | ----------- |
| `Invariant` | VPUIPRegMapped Index type

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.DeclareKernelArgs` (vpux::VPUIPRegMapped::DeclareKernelArgsOp)

Declaration of Software Kernel .args


Syntax:

```
operation ::= `VPUIPRegMapped.DeclareKernelArgs` attr-dict `kernel_path` `(` $kernel_path `)` `->` type(results)
```


Traits: DeclarationOp, VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `kernel_path` | ::mlir::StringAttr | string attribute

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.DeclareKernelEntry` (vpux::VPUIPRegMapped::DeclareKernelEntryOp)

Declaration of Kernel Entry


Syntax:

```
operation ::= `VPUIPRegMapped.DeclareKernelEntry` attr-dict `kernel_path` `(` $kernel_path `)` `->` type(results)
```


Traits: DeclarationOp, VPUIPRegMapped_SingleOutputAsIndexOp

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `kernel_path` | ::mlir::StringAttr | string attribute

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.DeclareKernelText` (vpux::VPUIPRegMapped::DeclareKernelTextOp)

Declaration of Software Kernel .text 


Syntax:

```
operation ::= `VPUIPRegMapped.DeclareKernelText` attr-dict `kernel_path` `(` $kernel_path `)` `->` type(results)
```


Traits: DeclarationOp, VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `kernel_path` | ::mlir::StringAttr | string attribute

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.KernelParams` (vpux::VPUIPRegMapped::KernelParamsOp)

Kernel Params


Syntax:

```
operation ::= `VPUIPRegMapped.KernelParams` attr-dict
              `inputs` `(` $inputs `:` type($inputs) `)`
              `outputs` `(` $outputs `:` type($outputs) `)`
              `kernel_type` `(` $kernel_type `)`
              `kernel_params` `(` $kernel_params `)`
              `->` type(results)
```


Traits: AttrSizedOperandSegments, VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface, GetOffsetOfOpInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `kernel_type` | ::mlir::StringAttr | string attribute
| `kernel_params` | ::mlir::ElementsAttr | constant vector/tensor attribute

#### Operands:

| Operand | Description |
| :-----: | ----------- |
| `inputs` | memref of any type values
| `outputs` | memref of any type values

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.MappedInference` (vpux::VPUIPRegMapped::MappedInferenceOp)

Task representing the MappedInference structure


Syntax:

```
operation ::= `VPUIPRegMapped.MappedInference` attr-dict
              (`dmas` `(` $dmaTasks^ `:` type($dmaTasks) `)`)?
              (`invariants` `(` $invariantTasks^ `:` type($invariantTasks) `)`)?
              (`variants` `(` $variantTasks^ `:` type($variantTasks) `)`)?
              (`actKernelRanges` `(` $actKernelRanges^ `:` type($actKernelRanges) `)`)?
              (`actKernelInvocations` `(` $actKernelInvocations^ `:` type($actKernelInvocations) `)`)?
              (`barriers` `(` $barrierTasks^ `:` type($barrierTasks) `)` )?
              (`actShaveRt` `(` $actShaveRt^ `:` type($actShaveRt) `)` )?
              (`actShaveStacks` `(` $actShaveStacks^ `:` type($actShaveStacks) `)`)?
              `dmaCount` `(` $dmaCount `)`
              `invariantCount` `(` $invariantCount `)`
              `variantCount` `(` $variantCount `)`
              `actKernelRangesCount` `(` $actKernelRangesCount `)`
              `actKernelInvocationsCount` `(` $actKernelInvocationsCount `)`
              `barrierCount` `(` $barrierCount `)`
              `->` type(results)
```


Traits: AttrSizedOperandSegments, VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface, GetOffsetOfOpInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `dmaCount` | ::mlir::ArrayAttr | 64-bit integer array attribute
| `invariantCount` | ::mlir::IntegerAttr | 32-bit unsigned integer attribute
| `variantCount` | ::mlir::IntegerAttr | 32-bit unsigned integer attribute
| `actKernelRangesCount` | ::mlir::IntegerAttr | 32-bit unsigned integer attribute
| `actKernelInvocationsCount` | ::mlir::IntegerAttr | 32-bit unsigned integer attribute
| `barrierCount` | ::mlir::IntegerAttr | 32-bit unsigned integer attribute

#### Operands:

| Operand | Description |
| :-----: | ----------- |
| `dmaTasks` | VPUIPRegMapped Index type
| `invariantTasks` | VPUIPRegMapped Index type
| `variantTasks` | VPUIPRegMapped Index type
| `actKernelRanges` | VPUIPRegMapped Index type
| `actKernelInvocations` | VPUIPRegMapped Index type
| `barrierTasks` | VPUIPRegMapped Index type
| `actShaveRt` | VPUIPRegMapped Index type
| `actShaveStacks` | memref of any type values

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.NNDMA` (vpux::VPUIPRegMapped::NNDMAOp)

NN DMA task


Syntax:

```
operation ::= `VPUIPRegMapped.NNDMA` attr-dict
              `inputs` `(` $input `:` type($input) `)`
              (`outputs` `(` $output_buffs^ `:` type($output_buffs) `)`)?
              ( `previousDMA` `(` $previousDMAIdx^ `:` type($previousDMAIdx) `)`)?
              (`waits` `(` $waitBarriers^ `:` type($waitBarriers) `)`)?
              (`updates` `(` $updateBarriers^ `:` type($updateBarriers) `)`)?
              `start_after` `(` $start_after `)`
              `clean_after` `(` $clean_after `)`
              `->` type(results)
```


Traits: AttrSizedOperandSegments, VPUIPRegMapped_SingleOutputAsIndexOp

Interfaces: BinaryOpInterface, ExecutableTaskOpInterface, GetOffsetOfOpInterface

#### Attributes:

| Attribute | MLIR Type | Description |
| :-------: | :-------: | ----------- |
| `compression` | ::mlir::UnitAttr | unit attribute
| `start_after` | ::mlir::IntegerAttr | 64-bit unsigned integer attribute
| `clean_after` | ::mlir::IntegerAttr | 64-bit unsigned integer attribute
| `is_out_of_order` | ::mlir::UnitAttr | unit attribute
| `is_critical` | ::mlir::UnitAttr | unit attribute
| `port` | mlir::IntegerAttr | Integer attribute
| `dma_descriptor` | vpux::VPUIP::DmaDescriptorAttr | DictionaryAttr with field(s): 'numPlanes', 'len', 'srcWidth', 'srcStride', 'srcPlaneStride', 'dstWidth', 'dstStride', 'dstPlaneStride' (each field having its own constraints)

#### Operands:

| Operand | Description |
| :-----: | ----------- |
| `input` | memref of any type values
| `output_buffs` | memref of any type values
| `previousDMAIdx` | VPUIPRegMapped Index type
| `waitBarriers` | VPUIPRegMapped Index type
| `updateBarriers` | VPUIPRegMapped Index type

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

### `VPUIPRegMapped.NetworkMetadata` (vpux::VPUIPRegMapped::NetworkMetadataOp)

Network Metadata Op


Syntax:

```
operation ::= `VPUIPRegMapped.NetworkMetadata` attr-dict `->` type(results)
```


Interfaces: BinaryOpInterface

#### Results:

| Result | Description |
| :----: | ----------- |
| `index` | VPUIPRegMapped Index type

## Type definition

### IndexType

VPUIPRegMapped Index type

An index type containing the value as a parameter

#### Parameters:

| Parameter | C++ type | Description |
| :-------: | :-------: | ----------- |
| value | `uint32_t` |  |

### RegFieldType

VPUIPRegMapped RegField Type

This object represents closely a RegField Type
#### Parameters:

| Parameter | C++ type | Description |
| :-------: | :-------: | ----------- |
| width | `uint8_t` |  |
| pos | `uint8_t` |  |
| value | `uint64_t` |  |
| name | `std::string` |  |

### RegMappedType

VPUIPRegMapped RegMapped Type

This object represents closely a RegMapped Type
#### Parameters:

| Parameter | C++ type | Description |
| :-------: | :-------: | ----------- |
| name | `std::string` |  |
| regs | `::mlir::ArrayAttr` | array of Registers |

### RegisterType

VPUIPRegMapped Register Type

This object represents closely a Register Type
#### Parameters:

| Parameter | C++ type | Description |
| :-------: | :-------: | ----------- |
| size | `uint32_t` |  |
| name | `std::string` |  |
| address | `uint32_t` |  |
| regFields | `::mlir::ArrayAttr` | array of RegisterFields |
