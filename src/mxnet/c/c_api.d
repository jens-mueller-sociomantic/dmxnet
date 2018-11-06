/*******************************************************************************

    Bindings for the MXNet C API

    This module contains D bindings for the functionality described in the
    upstream `mxnet/c_api.h` header file.  For details, please consult the
    original header documentation: <http://mxnet.io/doxygen/c__api_8h.html>

    This module was generated from mxnet/c_api.h v0.10.0
    (<https://github.com/dmlc/mxnet/blob/v0.10.0/include/mxnet/c_api.h>).

    When using this module you need to link against the `libmxnet` library.

    Copyright:
        Copyright (c) 2015 MXNet contributors.

    License:
        Licensed under the Apache License, Version 2.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at

            <http://www.apache.org/licenses/LICENSE-2.0>

        Unless required by applicable law or agreed to in writing, software
        distributed under the License is distributed on an "AS IS" BASIS,
        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
        See the License for the specific language governing permissions and
        limitations under the License.

*******************************************************************************/

module mxnet.c.c_api;


/*!
 *  Copyright (c) 2015 by Contributors
 * \file c_api.h
 * \brief C API of mxnet
 */

extern (C):

/*! \brief Inhibit C++ name-mangling for MXNet functions. */

// __cplusplus

/*! \brief Keep the default value in C++ */

// __cplusplus

/*! \brief MXNET_DLL prefix for windows */

/*! \brief manually define unsigned int */
alias uint mx_uint;
/*! \brief manually define float */
alias float mx_float;
// all the handles are simply void *
// will be casted internally to specific pointers types
// these typedefs are mainly used for readablity reasons
/*! \brief handle to NDArray */
alias void* NDArrayHandle;
/*! \brief handle to a mxnet narray function that changes NDArray */
alias const(void)* FunctionHandle;
/*! \brief handle to a function that takes param and creates symbol */
alias void* AtomicSymbolCreator;
/*! \brief handle to a symbol that can be bind as operator */
alias void* SymbolHandle;
/*! \brief handle to a AtomicSymbol */
alias void* AtomicSymbolHandle;
/*! \brief handle to an Executor */
alias void* ExecutorHandle;
/*! \brief handle a dataiter creator */
alias void* DataIterCreator;
/*! \brief handle to a DataIterator */
alias void* DataIterHandle;
/*! \brief handle to KVStore */
alias void* KVStoreHandle;
/*! \brief handle to RecordIO */
alias void* RecordIOHandle;
/*! \brief handle to MXRtc*/
alias void* RtcHandle;

alias void function (const(char)*, NDArrayHandle, void*) ExecutorMonitorCallback;

struct NativeOpInfo
{
    void function (int, float**, int*, uint**, int*, void*) forward;
    void function (int, float**, int*, uint**, int*, void*) backward;
    void function (int, int*, uint**, void*) infer_shape;
    void function (char***, void*) list_outputs;
    void function (char***, void*) list_arguments;
    // all functions also pass a payload void* pointer
    void* p_forward;
    void* p_backward;
    void* p_infer_shape;
    void* p_list_outputs;
    void* p_list_arguments;
}

struct NDArrayOpInfo
{
    bool function (int, void**, int*, void*) forward;
    bool function (int, void**, int*, void*) backward;
    bool function (int, int*, uint**, void*) infer_shape;
    bool function (char***, void*) list_outputs;
    bool function (char***, void*) list_arguments;
    bool function (const(int)*, const(int)*, const(int)*, int*, int**, void*) declare_backward_dependency;
    // all functions also pass a payload void* pointer
    void* p_forward;
    void* p_backward;
    void* p_infer_shape;
    void* p_list_outputs;
    void* p_list_arguments;
    void* p_declare_backward_dependency;
}

alias int function () MXGenericCallback;

struct MXCallbackList
{
    int num_callbacks;
    int function ()* callbacks;
    void** contexts;
}

enum CustomOpCallbacks
{
    kCustomOpDelete = 0,
    kCustomOpForward = 1,
    kCustomOpBackward = 2
}

enum CustomOpPropCallbacks
{
    kCustomOpPropDelete = 0,
    kCustomOpPropListArguments = 1,
    kCustomOpPropListOutputs = 2,
    kCustomOpPropListAuxiliaryStates = 3,
    kCustomOpPropInferShape = 4,
    kCustomOpPropDeclareBackwardDependency = 5,
    kCustomOpPropCreateOperator = 6,
    kCustomOpPropInferType = 7
}

/*size*/ /*ptrs*/ /*tags*/
/*reqs*/ /*is_train*/
/*state*/
alias int function (int, void**, int*, const(int)*, const(int), void*) CustomOpFBFunc;
/*state*/
alias int function (void*) CustomOpDelFunc;
/*args*/ /*state*/
alias int function (char***, void*) CustomOpListFunc;
/*num_input*/ /*ndims*/
/*shapes*/ /*state*/
alias int function (int, int*, uint**, void*) CustomOpInferShapeFunc;
/*num_input*/ /*types*/ /*state*/
alias int function (int, int*, void*) CustomOpInferTypeFunc;
/*out_grad*/ /*in_data*/
/*out_data*/ /*num_deps*/
/*rdeps*/ /*state*/
alias int function (const(int)*, const(int)*, const(int)*, int*, int**, void*) CustomOpBwdDepFunc;
/*ctx*/ /*num_inputs*/
/*shapes*/ /*ndims*/
/*dtypes*/ /*ret*/
/*state*/
alias int function (const(char)*, int, uint**, int*, int*, MXCallbackList*, void*) CustomOpCreateFunc;
/*op_type*/ /*num_kwargs*/
/*keys*/ /*values*/
/*ret*/
alias int function (const(char)*, const(int), const(char*)*, const(char*)*, MXCallbackList*) CustomOpPropCreator;

/*!
 * \brief return str message of the last error
 *  all function in this file will return 0 when success
 *  and -1 when an error occured,
 *  MXGetLastError can be called to retrieve the error
 *
 *  this function is threadsafe and can be called by different thread
 *  \return error info
 */
const(char)* MXGetLastError ();

//-------------------------------------
// Part 0: Global State setups
//-------------------------------------
/*!
 * \brief Seed the global random number generators in mxnet.
 * \param seed the random number seed.
 * \return 0 when success, -1 when failure happens.
 */
int MXRandomSeed (int seed);
/*!
 * \brief Notify the engine about a shutdown,
 *  This can help engine to print less messages into display.
 *
 *  User do not have to call this function.
 * \return 0 when success, -1 when failure happens.
 */
int MXNotifyShutdown ();
/*!
 * \brief Set up configuration of profiler
 * \param mode indicate the working mode of profiler,
 *  record anly symbolic operator when mode == 0,
 *  record all operator when mode == 1
 * \param filename where to save trace file
 * \return 0 when success, -1 when failure happens.
 */
int MXSetProfilerConfig (int mode, const(char)* filename);
/*!
 * \brief Set up state of profiler
 * \param state indicate the working state of profiler,
 *  profiler not running when state == 0,
 *  profiler running when state == 1
 * \return 0 when success, -1 when failure happens.
 */
int MXSetProfilerState (int state);

/*! \brief Save profile and stop profiler */
int MXDumpProfile ();

/*! \brief Set the number of OMP threads to use */
int MXSetNumOMPThreads (int thread_num);

//-------------------------------------
// Part 1: NDArray creation and deletion
//-------------------------------------
/*!
 * \brief create a NDArray handle that is not initialized
 *  can be used to pass in as mutate variables
 *  to hold the result of NDArray
 * \param out the returning handle
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayCreateNone (NDArrayHandle* out_);
/*!
 * \brief create a NDArray with specified shape
 * \param shape the pointer to the shape
 * \param ndim the dimension of the shape
 * \param dev_type device type, specify device we want to take
 * \param dev_id the device id of the specific device
 * \param delay_alloc whether to delay allocation until
 *    the narray is first mutated
 * \param out the returning handle
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayCreate (const(mx_uint)* shape, mx_uint ndim, int dev_type, int dev_id, int delay_alloc, NDArrayHandle* out_);

/*!
 * \brief create a NDArray with specified shape and data type
 * \param shape the pointer to the shape
 * \param ndim the dimension of the shape
 * \param dev_type device type, specify device we want to take
 * \param dev_id the device id of the specific device
 * \param delay_alloc whether to delay allocation until
 *    the narray is first mutated
 * \param dtype data type of created array
 * \param out the returning handle
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayCreateEx (const(mx_uint)* shape, mx_uint ndim, int dev_type, int dev_id, int delay_alloc, int dtype, NDArrayHandle* out_);
/*!
 * \brief create a NDArray handle that is loaded from raw bytes.
 * \param buf the head of the raw bytes
 * \param size size of the raw bytes
 * \param out the returning handle
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayLoadFromRawBytes (const(void)* buf, size_t size, NDArrayHandle* out_);
/*!
 * \brief save the NDArray into raw bytes.
 * \param handle the NDArray handle
 * \param out_size size of the raw bytes
 * \param out_buf the head of returning memory bytes.
 * \return 0 when success, -1 when failure happens
 */
int MXNDArraySaveRawBytes (NDArrayHandle handle, size_t* out_size, const(char*)* out_buf);
/*!
 * \brief Save list of narray into the file.
 * \param fname name of the file.
 * \param num_args number of arguments to save.
 * \param args the array of NDArrayHandles to be saved.
 * \param keys the name of the NDArray, optional, can be NULL
 * \return 0 when success, -1 when failure happens
 */
int MXNDArraySave (const(char)* fname, mx_uint num_args, NDArrayHandle* args, const(char*)* keys);
/*!
 * \brief Load list of narray from the file.
 * \param fname name of the file.
 * \param out_size number of narray loaded.
 * \param out_arr head of the returning narray handles.
 * \param out_name_size size of output name arrray.
 * \param out_names the names of returning NDArrays, can be NULL
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayLoad (const(char)* fname, mx_uint* out_size, NDArrayHandle** out_arr, mx_uint* out_name_size, const(char**)* out_names);
/*!
 * \brief Perform a synchronize copy from a continugous CPU memory region.
 *
 *  This function will call WaitToWrite before the copy is performed.
 *  This is useful to copy data from existing memory region that are
 *  not wrapped by NDArray(thus dependency not being tracked).
 *
 * \param handle the NDArray handle
 * \param data the data source to copy from.
 * \param size the memory size we want to copy from.
 */
int MXNDArraySyncCopyFromCPU (NDArrayHandle handle, const(void)* data, size_t size);
/*!
 * \brief Perform a synchronize copyto a continugous CPU memory region.
 *
 *  This function will call WaitToRead before the copy is performed.
 *  This is useful to copy data from existing memory region that are
 *  not wrapped by NDArray(thus dependency not being tracked).
 *
 * \param handle the NDArray handle
 * \param data the data source to copy into.
 * \param size the memory size we want to copy into.
 */
int MXNDArraySyncCopyToCPU (NDArrayHandle handle, void* data, size_t size);
/*!
 * \brief Wait until all the pending writes with respect NDArray are finished.
 *  Always call this before read data out synchronizely.
 * \param handle the NDArray handle
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayWaitToRead (NDArrayHandle handle);
/*!
 * \brief Wait until all the pending read/write with respect NDArray are finished.
 *  Always call this before write data into NDArray synchronizely.
 * \param handle the NDArray handle
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayWaitToWrite (NDArrayHandle handle);
/*!
 * \brief wait until all delayed operations in
 *   the system is completed
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayWaitAll ();
/*!
 * \brief free the narray handle
 * \param handle the handle to be freed
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayFree (NDArrayHandle handle);
/*!
 * \brief Slice the NDArray along axis 0.
 * \param handle the handle to the NDArray
 * \param slice_begin The beginning index of slice
 * \param slice_end The ending index of slice
 * \param out The NDArrayHandle of sliced NDArray
 * \return 0 when success, -1 when failure happens
 */
int MXNDArraySlice (NDArrayHandle handle, mx_uint slice_begin, mx_uint slice_end, NDArrayHandle* out_);
/*!
 * \brief Index the NDArray along axis 0.
 * \param handle the handle to the NDArray
 * \param idx the index
 * \param out The NDArrayHandle of output NDArray
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayAt (NDArrayHandle handle, mx_uint idx, NDArrayHandle* out_);
/*!
 * \brief Reshape the NDArray.
 * \param handle the handle to the narray
 * \param ndim number of dimensions of new shape
 * \param dims new shape
 * \param out the NDArrayHandle of reshaped NDArray
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayReshape (NDArrayHandle handle, int ndim, int* dims, NDArrayHandle* out_);
/*!
 * \brief get the shape of the array
 * \param handle the handle to the narray
 * \param out_dim the output dimension
 * \param out_pdata pointer holder to get data pointer of the shape
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayGetShape (NDArrayHandle handle, mx_uint* out_dim, const(mx_uint*)* out_pdata);
/*!
 * \brief get the content of the data in NDArray
 * \param handle the handle to the narray
 * \param out_pdata pointer holder to get pointer of data
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayGetData (NDArrayHandle handle, void** out_pdata);
/*!
 * \brief get the type of the data in NDArray
 * \param handle the handle to the narray
 * \param out_dtype pointer holder to get type of data
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayGetDType (NDArrayHandle handle, int* out_dtype);
/*!
 * \brief get the context of the NDArray
 * \param handle the handle to the narray
 * \param out_dev_type the output device type
 * \param out_dev_id the output device id
 * \return 0 when success, -1 when failure happens
 */
int MXNDArrayGetContext (NDArrayHandle handle, int* out_dev_type, int* out_dev_id);
//--------------------------------
// Part 2: functions on NDArray
//--------------------------------
/*!
 * \brief list all the available functions handles
 *   most user can use it to list all the needed functions
 * \param out_size the size of returned array
 * \param out_array the output function array
 * \return 0 when success, -1 when failure happens
 */
int MXListFunctions (mx_uint* out_size, FunctionHandle** out_array);
/*!
 * \brief get the function handle by name
 * \param name the name of the function
 * \param out the corresponding function handle
 * \return 0 when success, -1 when failure happens
 */
int MXGetFunction (const(char)* name, FunctionHandle* out_);
/*!
 * \brief Get the information of the function handle.
 * \param fun The function handle.
 * \param name The returned name of the function.
 * \param description The returned description of the function.
 * \param num_args Number of arguments.
 * \param arg_names Name of the arguments.
 * \param arg_type_infos Type information about the arguments.
 * \param arg_descriptions Description information about the arguments.
 * \param return_type Return type of the function.
 * \return 0 when success, -1 when failure happens
 */
int MXFuncGetInfo (FunctionHandle fun, const(char*)* name, const(char*)* description, mx_uint* num_args, const(char**)* arg_names, const(char**)* arg_type_infos, const(char**)* arg_descriptions, const(char*)* return_type);
/*!
 * \brief get the argument requirements of the function
 * \param fun input function handle
 * \param num_use_vars how many NDArrays to be passed in as used_vars
 * \param num_scalars scalar variable is needed
 * \param num_mutate_vars how many NDArrays to be passed in as mutate_vars
 * \param type_mask the type mask of this function
 * \return 0 when success, -1 when failure happens
 * \sa MXFuncInvoke
 */
int MXFuncDescribe (FunctionHandle fun, mx_uint* num_use_vars, mx_uint* num_scalars, mx_uint* num_mutate_vars, int* type_mask);
/*!
 * \brief invoke a function, the array size of passed in arguments
 *   must match the values in the
 * \param fun the function
 * \param use_vars the normal arguments passed to function
 * \param scalar_args the scalar qarguments
 * \param mutate_vars the mutate arguments
 * \return 0 when success, -1 when failure happens
 * \sa MXFuncDescribeArgs
 */
int MXFuncInvoke (FunctionHandle fun, NDArrayHandle* use_vars, mx_float* scalar_args, NDArrayHandle* mutate_vars);
/*!
 * \brief invoke a function, the array size of passed in arguments
 *   must match the values in the
 * \param fun the function
 * \param use_vars the normal arguments passed to function
 * \param scalar_args the scalar qarguments
 * \param mutate_vars the mutate arguments
 * \param num_params number of keyword parameters
 * \param param_keys keys for keyword parameters
 * \param param_vals values for keyword parameters
 * \return 0 when success, -1 when failure happens
 * \sa MXFuncDescribeArgs
 */
int MXFuncInvokeEx (FunctionHandle fun, NDArrayHandle* use_vars, mx_float* scalar_args, NDArrayHandle* mutate_vars, int num_params, char** param_keys, char** param_vals);
/*!
 * \brief invoke a nnvm op and imperative function
 * \param creator the op
 * \param num_inputs number of input NDArrays
 * \param inputs input NDArrays
 * \param num_outputs number of output NDArrays
 * \param outputs output NDArrays
 * \param num_params number of keyword parameters
 * \param param_keys keys for keyword parameters
 * \param param_vals values for keyword parameters
 * \return 0 when success, -1 when failure happens
 */
int MXImperativeInvoke (AtomicSymbolCreator creator, int num_inputs, NDArrayHandle* inputs, int* num_outputs, NDArrayHandle** outputs, int num_params, const(char*)* param_keys, const(char*)* param_vals);
/*!
 * \brief set whether to record operator for autograd
 * \param is_train 1 when training, 0 when testing
 * \param prev returns the previous status before this set.
 * \return 0 when success, -1 when failure happens
 */
int MXAutogradSetIsTraining (int is_training, int* prev);
/*!
 * \brief mark NDArrays as variables to compute gradient for autograd
 * \param num_var number of variable NDArrays
 * \param var_handles variable NDArrays
 * \return 0 when success, -1 when failure happens
 */
int MXAutogradMarkVariables (mx_uint num_var, NDArrayHandle* var_handles, mx_uint* reqs_array, NDArrayHandle* grad_handles);
/*!
 * \brief compute the gradient of outputs w.r.t variabels
 * \param num_output number of output NDArray
 * \param output_handles output NDArrays
 * \return 0 when success, -1 when failure happens
 */
int MXAutogradComputeGradient (mx_uint num_output, NDArrayHandle* output_handles);
//--------------------------------------------
// Part 3: symbolic configuration generation
//--------------------------------------------
/*!
 * \brief list all the available operator names, include entries.
 * \param out_size the size of returned array
 * \param out_array the output operator name array.
 * \return 0 when success, -1 when failure happens
 */
int MXListAllOpNames (mx_uint* out_size, const(char**)* out_array);
/*!
 * \brief list all the available AtomicSymbolEntry
 * \param out_size the size of returned array
 * \param out_array the output AtomicSymbolCreator array
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolListAtomicSymbolCreators (mx_uint* out_size, AtomicSymbolCreator** out_array);

/*!
 * \brief Get the name of an atomic symbol.
 * \param creator the AtomicSymbolCreator.
 * \param name The returned name of the creator.
 */
int MXSymbolGetAtomicSymbolName (AtomicSymbolCreator creator, const(char*)* name);
/*!
 * \brief Get the detailed information about atomic symbol.
 * \param creator the AtomicSymbolCreator.
 * \param name The returned name of the creator.
 * \param description The returned description of the symbol.
 * \param num_args Number of arguments.
 * \param arg_names Name of the arguments.
 * \param arg_type_infos Type informations about the arguments.
 * \param arg_descriptions Description information about the arguments.
 * \param key_var_num_args The keyword argument for specifying variable number of arguments.
 *            When this parameter has non-zero length, the function allows variable number
 *            of positional arguments, and will need the caller to pass it in in
 *            MXSymbolCreateAtomicSymbol,
 *            With key = key_var_num_args, and value = number of positional arguments.
 * \param return_type Return type of the function, can be Symbol or Symbol[]
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolGetAtomicSymbolInfo (AtomicSymbolCreator creator, const(char*)* name, const(char*)* description, mx_uint* num_args, const(char**)* arg_names, const(char**)* arg_type_infos, const(char**)* arg_descriptions, const(char*)* key_var_num_args, const(char*)* return_type);
/*!
 * \brief Create an AtomicSymbol.
 * \param creator the AtomicSymbolCreator
 * \param num_param the number of parameters
 * \param keys the keys to the params
 * \param vals the vals of the params
 * \param out pointer to the created symbol handle
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolCreateAtomicSymbol (AtomicSymbolCreator creator, mx_uint num_param, const(char*)* keys, const(char*)* vals, SymbolHandle* out_);
/*!
 * \brief Create a Variable Symbol.
 * \param name name of the variable
 * \param out pointer to the created symbol handle
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolCreateVariable (const(char)* name, SymbolHandle* out_);
/*!
 * \brief Create a Symbol by grouping list of symbols together
 * \param num_symbols number of symbols to be grouped
 * \param symbols array of symbol handles
 * \param out pointer to the created symbol handle
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolCreateGroup (mx_uint num_symbols, SymbolHandle* symbols, SymbolHandle* out_);
/*!
 * \brief Load a symbol from a json file.
 * \param fname the file name.
 * \param out the output symbol.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolCreateFromFile (const(char)* fname, SymbolHandle* out_);
/*!
 * \brief Load a symbol from a json string.
 * \param json the json string.
 * \param out the output symbol.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolCreateFromJSON (const(char)* json, SymbolHandle* out_);
/*!
 * \brief Save a symbol into a json file.
 * \param symbol the input symbol.
 * \param fname the file name.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolSaveToFile (SymbolHandle symbol, const(char)* fname);
/*!
 * \brief Save a symbol into a json string
 * \param symbol the input symbol.
 * \param out_json output json string.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolSaveToJSON (SymbolHandle symbol, const(char*)* out_json);
/*!
 * \brief Free the symbol handle.
 * \param symbol the symbol
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolFree (SymbolHandle symbol);
/*!
 * \brief Copy the symbol to another handle
 * \param symbol the source symbol
 * \param out used to hold the result of copy
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolCopy (SymbolHandle symbol, SymbolHandle* out_);
/*!
 * \brief Print the content of symbol, used for debug.
 * \param symbol the symbol
 * \param out_str pointer to hold the output string of the printing.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolPrint (SymbolHandle symbol, const(char*)* out_str);
/*!
 * \brief Get string name from symbol
 * \param symbol the source symbol
 * \param out The result name.
 * \param success Whether the result is contained in out.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolGetName (SymbolHandle symbol, const(char*)* out_, int* success);
/*!
 * \brief Get string attribute from symbol
 * \param symbol the source symbol
 * \param key The key of the symbol.
 * \param out The result attribute, can be NULL if the attribute do not exist.
 * \param success Whether the result is contained in out.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolGetAttr (SymbolHandle symbol, const(char)* key, const(char*)* out_, int* success);
/*!
 * \brief Set string attribute from symbol.
 *  NOTE: Setting attribute to a symbol can affect the semantics(mutable/immutable) of symbolic graph.
 *
 *  Safe recommendaton: use  immutable graph
 *  - Only allow set attributes during creation of new symbol as optional parameter
 *
 *  Mutable graph (be careful about the semantics):
 *  - Allow set attr at any point.
 *  - Mutating an attribute of some common node of two graphs can cause confusion from user.
 *
 * \param symbol the source symbol
 * \param key The key of the symbol.
 * \param value The value to be saved.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolSetAttr (SymbolHandle symbol, const(char)* key, const(char)* value);
/*!
 * \brief Get all attributes from symbol, including all descendents.
 * \param symbol the source symbol
 * \param out_size The number of output attributes
 * \param out 2*out_size strings representing key value pairs.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolListAttr (SymbolHandle symbol, mx_uint* out_size, const(char**)* out_);
/*!
 * \brief Get all attributes from symbol, excluding descendents.
 * \param symbol the source symbol
 * \param out_size The number of output attributes
 * \param out 2*out_size strings representing key value pairs.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolListAttrShallow (SymbolHandle symbol, mx_uint* out_size, const(char**)* out_);
/*!
 * \brief List arguments in the symbol.
 * \param symbol the symbol
 * \param out_size output size
 * \param out_str_array pointer to hold the output string array
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolListArguments (SymbolHandle symbol, mx_uint* out_size, const(char**)* out_str_array);
/*!
 * \brief List returns in the symbol.
 * \param symbol the symbol
 * \param out_size output size
 * \param out_str_array pointer to hold the output string array
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolListOutputs (SymbolHandle symbol, mx_uint* out_size, const(char**)* out_str_array);
/*!
 * \brief Get a symbol that contains all the internals.
 * \param symbol The symbol
 * \param out The output symbol whose outputs are all the internals.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolGetInternals (SymbolHandle symbol, SymbolHandle* out_);
/*!
 * \brief Get a symbol that contains only direct children.
 * \param symbol The symbol
 * \param out The output symbol whose outputs are the direct children.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolGetChildren (SymbolHandle symbol, SymbolHandle* out_);
/*!
 * \brief Get index-th outputs of the symbol.
 * \param symbol The symbol
 * \param index the Index of the output.
 * \param out The output symbol whose outputs are the index-th symbol.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolGetOutput (SymbolHandle symbol, mx_uint index, SymbolHandle* out_);
/*!
 * \brief List auxiliary states in the symbol.
 * \param symbol the symbol
 * \param out_size output size
 * \param out_str_array pointer to hold the output string array
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolListAuxiliaryStates (SymbolHandle symbol, mx_uint* out_size, const(char**)* out_str_array);
/*!
 * \brief Compose the symbol on other symbols.
 *
 *  This function will change the sym hanlde.
 *  To achieve function apply behavior, copy the symbol first
 *  before apply.
 *
 * \param sym the symbol to apply
 * \param name the name of symbol
 * \param num_args number of arguments
 * \param keys the key of keyword args (optional)
 * \param args arguments to sym
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolCompose (SymbolHandle sym, const(char)* name, mx_uint num_args, const(char*)* keys, SymbolHandle* args);
/*!
 * \brief Get the gradient graph of the symbol
 *
 * \param sym the symbol to get gradient
 * \param num_wrt number of arguments to get gradient
 * \param wrt the name of the arguments to get gradient
 * \param out the returned symbol that has gradient
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolGrad (SymbolHandle sym, mx_uint num_wrt, const(char*)* wrt, SymbolHandle* out_);
/*!
 * \brief infer shape of unknown input shapes given the known one.
 *  The shapes are packed into a CSR matrix represented by arg_ind_ptr and arg_shape_data
 *  The call will be treated as a kwargs call if key != nullptr or num_args==0, otherwise it is positional.
 *
 * \param sym symbol handle
 * \param num_args numbe of input arguments.
 * \param keys the key of keyword args (optional)
 * \param arg_ind_ptr the head pointer of the rows in CSR
 * \param arg_shape_data the content of the CSR
 * \param in_shape_size sizeof the returning array of in_shapes
 * \param in_shape_ndim returning array of shape dimensions of eachs input shape.
 * \param in_shape_data returning array of pointers to head of the input shape.
 * \param out_shape_size sizeof the returning array of out_shapes
 * \param out_shape_ndim returning array of shape dimensions of eachs input shape.
 * \param out_shape_data returning array of pointers to head of the input shape.
 * \param aux_shape_size sizeof the returning array of aux_shapes
 * \param aux_shape_ndim returning array of shape dimensions of eachs auxiliary shape.
 * \param aux_shape_data returning array of pointers to head of the auxiliary shape.
 * \param complete whether infer shape completes or more information is needed.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolInferShape (SymbolHandle sym, mx_uint num_args, const(char*)* keys, const(mx_uint)* arg_ind_ptr, const(mx_uint)* arg_shape_data, mx_uint* in_shape_size, const(mx_uint*)* in_shape_ndim, const(mx_uint**)* in_shape_data, mx_uint* out_shape_size, const(mx_uint*)* out_shape_ndim, const(mx_uint**)* out_shape_data, mx_uint* aux_shape_size, const(mx_uint*)* aux_shape_ndim, const(mx_uint**)* aux_shape_data, int* complete);
/*!
 * \brief partially infer shape of unknown input shapes given the known one.
 *
 *  Return partially inferred results if not all shapes could be inferred.
 *  The shapes are packed into a CSR matrix represented by arg_ind_ptr and arg_shape_data
 *  The call will be treated as a kwargs call if key != nullptr or num_args==0, otherwise it is positional.
 *
 * \param sym symbol handle
 * \param num_args numbe of input arguments.
 * \param keys the key of keyword args (optional)
 * \param arg_ind_ptr the head pointer of the rows in CSR
 * \param arg_shape_data the content of the CSR
 * \param in_shape_size sizeof the returning array of in_shapes
 * \param in_shape_ndim returning array of shape dimensions of eachs input shape.
 * \param in_shape_data returning array of pointers to head of the input shape.
 * \param out_shape_size sizeof the returning array of out_shapes
 * \param out_shape_ndim returning array of shape dimensions of eachs input shape.
 * \param out_shape_data returning array of pointers to head of the input shape.
 * \param aux_shape_size sizeof the returning array of aux_shapes
 * \param aux_shape_ndim returning array of shape dimensions of eachs auxiliary shape.
 * \param aux_shape_data returning array of pointers to head of the auxiliary shape.
 * \param complete whether infer shape completes or more information is needed.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolInferShapePartial (SymbolHandle sym, mx_uint num_args, const(char*)* keys, const(mx_uint)* arg_ind_ptr, const(mx_uint)* arg_shape_data, mx_uint* in_shape_size, const(mx_uint*)* in_shape_ndim, const(mx_uint**)* in_shape_data, mx_uint* out_shape_size, const(mx_uint*)* out_shape_ndim, const(mx_uint**)* out_shape_data, mx_uint* aux_shape_size, const(mx_uint*)* aux_shape_ndim, const(mx_uint**)* aux_shape_data, int* complete);

/*!
 * \brief infer type of unknown input types given the known one.
 *  The types are packed into a CSR matrix represented by arg_ind_ptr and arg_type_data
 *  The call will be treated as a kwargs call if key != nullptr or num_args==0, otherwise it is positional.
 *
 * \param sym symbol handle
 * \param num_args numbe of input arguments.
 * \param keys the key of keyword args (optional)
 * \param arg_type_data the content of the CSR
 * \param in_type_size sizeof the returning array of in_types
 * \param in_type_data returning array of pointers to head of the input type.
 * \param out_type_size sizeof the returning array of out_types
 * \param out_type_data returning array of pointers to head of the input type.
 * \param aux_type_size sizeof the returning array of aux_types
 * \param aux_type_data returning array of pointers to head of the auxiliary type.
 * \param complete whether infer type completes or more information is needed.
 * \return 0 when success, -1 when failure happens
 */
int MXSymbolInferType (SymbolHandle sym, mx_uint num_args, const(char*)* keys, const(int)* arg_type_data, mx_uint* in_type_size, const(int*)* in_type_data, mx_uint* out_type_size, const(int*)* out_type_data, mx_uint* aux_type_size, const(int*)* aux_type_data, int* complete);
//--------------------------------------------
// Part 4: Executor interface
//--------------------------------------------
/*!
 * \brief Delete the executor
 * \param handle the executor.
 * \return 0 when success, -1 when failure happens
 */
int MXExecutorFree (ExecutorHandle handle);
/*!
 * \brief Print the content of execution plan, used for debug.
 * \param handle the executor.
 * \param out_str pointer to hold the output string of the printing.
 * \return 0 when success, -1 when failure happens
 */
int MXExecutorPrint (ExecutorHandle handle, const(char*)* out_str);
/*!
 * \brief Executor forward method
 *
 * \param handle executor handle
 * \param is_train int value to indicate whether the forward pass is for evaluation
 * \return 0 when success, -1 when failure happens
 */
int MXExecutorForward (ExecutorHandle handle, int is_train);
/*!
 * \brief Excecutor run backward
 *
 * \param handle execute handle
 * \param len lenth
 * \param head_grads NDArray handle for heads' gradient
 *
 * \return 0 when success, -1 when failure happens
 */
int MXExecutorBackward (ExecutorHandle handle, mx_uint len, NDArrayHandle* head_grads);

/*!
 * \brief Get executor's head NDArray
 *
 * \param handle executor handle
 * \param out_size output narray vector size
 * \param out out put narray handles
 * \return 0 when success, -1 when failure happens
 */
int MXExecutorOutputs (ExecutorHandle handle, mx_uint* out_size, NDArrayHandle** out_);

/*!
 * \brief Generate Executor from symbol
 *
 * \param symbol_handle symbol handle
 * \param dev_type device type
 * \param dev_id device id
 * \param len length
 * \param in_args in args array
 * \param arg_grad_store arg grads handle array
 * \param grad_req_type grad req array
 * \param aux_states_len length of auxiliary states
 * \param aux_states auxiliary states array
 * \param out output executor handle
 * \return 0 when success, -1 when failure happens
 */
int MXExecutorBind (SymbolHandle symbol_handle, int dev_type, int dev_id, mx_uint len, NDArrayHandle* in_args, NDArrayHandle* arg_grad_store, mx_uint* grad_req_type, mx_uint aux_states_len, NDArrayHandle* aux_states, ExecutorHandle* out_);
/*!
 * \brief Generate Executor from symbol,
 *  This is advanced function, allow specify group2ctx map.
 *  The user can annotate "ctx_group" attribute to name each group.
 *
 * \param symbol_handle symbol handle
 * \param dev_type device type of default context
 * \param dev_id device id of default context
 * \param num_map_keys size of group2ctx map
 * \param map_keys keys of group2ctx map
 * \param map_dev_types device type of group2ctx map
 * \param map_dev_ids device id of group2ctx map
 * \param len length
 * \param in_args in args array
 * \param arg_grad_store arg grads handle array
 * \param grad_req_type grad req array
 * \param aux_states_len length of auxiliary states
 * \param aux_states auxiliary states array
 * \param out output executor handle
 * \return 0 when success, -1 when failure happens
 */
int MXExecutorBindX (SymbolHandle symbol_handle, int dev_type, int dev_id, mx_uint num_map_keys, const(char*)* map_keys, const(int)* map_dev_types, const(int)* map_dev_ids, mx_uint len, NDArrayHandle* in_args, NDArrayHandle* arg_grad_store, mx_uint* grad_req_type, mx_uint aux_states_len, NDArrayHandle* aux_states, ExecutorHandle* out_);
/*!
 * \brief Generate Executor from symbol,
 *  This is advanced function, allow specify group2ctx map.
 *  The user can annotate "ctx_group" attribute to name each group.
 *
 * \param symbol_handle symbol handle
 * \param dev_type device type of default context
 * \param dev_id device id of default context
 * \param num_map_keys size of group2ctx map
 * \param map_keys keys of group2ctx map
 * \param map_dev_types device type of group2ctx map
 * \param map_dev_ids device id of group2ctx map
 * \param len length
 * \param in_args in args array
 * \param arg_grad_store arg grads handle array
 * \param grad_req_type grad req array
 * \param aux_states_len length of auxiliary states
 * \param aux_states auxiliary states array
 * \param shared_exec input executor handle for memory sharing
 * \param out output executor handle
 * \return 0 when success, -1 when failure happens
 */
int MXExecutorBindEX (SymbolHandle symbol_handle, int dev_type, int dev_id, mx_uint num_map_keys, const(char*)* map_keys, const(int)* map_dev_types, const(int)* map_dev_ids, mx_uint len, NDArrayHandle* in_args, NDArrayHandle* arg_grad_store, mx_uint* grad_req_type, mx_uint aux_states_len, NDArrayHandle* aux_states, ExecutorHandle shared_exec, ExecutorHandle* out_);
/*!
 * \brief set a call back to notify the completion of operation
 */
int MXExecutorSetMonitorCallback (ExecutorHandle handle, scope ExecutorMonitorCallback callback, void* callback_handle);
//--------------------------------------------
// Part 5: IO Interface
//--------------------------------------------
/*!
 * \brief List all the available iterator entries
 * \param out_size the size of returned iterators
 * \param out_array the output iteratos entries
 * \return 0 when success, -1 when failure happens
 */
int MXListDataIters (mx_uint* out_size, DataIterCreator** out_array);
/*!
 * \brief Init an iterator, init with parameters
 * the array size of passed in arguments
 * \param handle of the iterator creator
 * \param num_param number of parameter
 * \param keys parameter keys
 * \param vals parameter values
 * \param out resulting iterator
 * \return 0 when success, -1 when failure happens
 */
int MXDataIterCreateIter (DataIterCreator handle, mx_uint num_param, const(char*)* keys, const(char*)* vals, DataIterHandle* out_);
/*!
 * \brief Get the detailed information about data iterator.
 * \param creator the DataIterCreator.
 * \param name The returned name of the creator.
 * \param description The returned description of the symbol.
 * \param num_args Number of arguments.
 * \param arg_names Name of the arguments.
 * \param arg_type_infos Type informations about the arguments.
 * \param arg_descriptions Description information about the arguments.
 * \return 0 when success, -1 when failure happens
 */
int MXDataIterGetIterInfo (DataIterCreator creator, const(char*)* name, const(char*)* description, mx_uint* num_args, const(char**)* arg_names, const(char**)* arg_type_infos, const(char**)* arg_descriptions);
/*!
 * \brief Free the handle to the IO module
 * \param handle the handle pointer to the data iterator
 * \return 0 when success, -1 when failure happens
 */
int MXDataIterFree (DataIterHandle handle);
/*!
 * \brief Move iterator to next position
 * \param handle the handle to iterator
 * \param out return value of next
 * \return 0 when success, -1 when failure happens
 */
int MXDataIterNext (DataIterHandle handle, int* out_);
/*!
 * \brief Call iterator.Reset
 * \param handle the handle to iterator
 * \return 0 when success, -1 when failure happens
 */
int MXDataIterBeforeFirst (DataIterHandle handle);

/*!
 * \brief Get the handle to the NDArray of underlying data
 * \param handle the handle pointer to the data iterator
 * \param out handle to underlying data NDArray
 * \return 0 when success, -1 when failure happens
 */
int MXDataIterGetData (DataIterHandle handle, NDArrayHandle* out_);
/*!
 * \brief Get the image index by array.
 * \param handle the handle pointer to the data iterator
 * \param out_index output index of the array.
 * \param out_size output size of the array.
 * \return 0 when success, -1 when failure happens
 */
int MXDataIterGetIndex (DataIterHandle handle, ulong** out_index, ulong* out_size);
/*!
 * \brief Get the padding number in current data batch
 * \param handle the handle pointer to the data iterator
 * \param pad pad number ptr
 * \return 0 when success, -1 when failure happens
 */
int MXDataIterGetPadNum (DataIterHandle handle, int* pad);

/*!
 * \brief Get the handle to the NDArray of underlying label
 * \param handle the handle pointer to the data iterator
 * \param out the handle to underlying label NDArray
 * \return 0 when success, -1 when failure happens
 */
int MXDataIterGetLabel (DataIterHandle handle, NDArrayHandle* out_);
//--------------------------------------------
// Part 6: basic KVStore interface
//--------------------------------------------
/*!
 * \brief Initialized ps-lite environment variables
 * \param num_vars number of variables to initialize
 * \param keys environment keys
 * \param vals environment values
 */
int MXInitPSEnv (mx_uint num_vars, const(char*)* keys, const(char*)* vals);

/*!
 * \brief Create a kvstore
 * \param type the type of KVStore
 * \param out The output type of KVStore
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreCreate (const(char)* type, KVStoreHandle* out_);
/*!
 * \brief Delete a KVStore handle.
 * \param handle handle to the kvstore
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreFree (KVStoreHandle handle);
/*!
 * \brief Init a list of (key,value) pairs in kvstore
 * \param handle handle to the kvstore
 * \param num the number of key-value pairs
 * \param keys the list of keys
 * \param vals the list of values
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreInit (KVStoreHandle handle, mx_uint num, const(int)* keys, NDArrayHandle* vals);

/*!
 * \brief Push a list of (key,value) pairs to kvstore
 * \param handle handle to the kvstore
 * \param num the number of key-value pairs
 * \param keys the list of keys
 * \param vals the list of values
 * \param priority the priority of the action
 * \return 0 when success, -1 when failure happens
 */
int MXKVStorePush (KVStoreHandle handle, mx_uint num, const(int)* keys, NDArrayHandle* vals, int priority);
/*!
 * \brief pull a list of (key, value) pairs from the kvstore
 * \param handle handle to the kvstore
 * \param num the number of key-value pairs
 * \param keys the list of keys
 * \param vals the list of values
 * \param priority the priority of the action
 * \return 0 when success, -1 when failure happens
 */
int MXKVStorePull (KVStoreHandle handle, mx_uint num, const(int)* keys, NDArrayHandle* vals, int priority);
/*!
 * \brief user-defined updater for the kvstore
 * It's this updater's responsibility to delete \a recv and \a local
 * \param the key
 * \param recv the pushed value on this key
 * \param local the value stored on local on this key
 * \param handle The additional handle to the updater
 */
alias void function (int key, NDArrayHandle recv, NDArrayHandle local, void* handle) MXKVStoreUpdater;
/*!
 * \brief register an push updater
 * \param handle handle to the KVStore
 * \param updater udpater function
 * \param updater_handle The additional handle used to invoke the updater
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreSetUpdater (KVStoreHandle handle, void function () updater, void* updater_handle);
/*!
 * \brief get the type of the kvstore
 * \param handle handle to the KVStore
 * \param type a string type
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreGetType (KVStoreHandle handle, const(char*)* type);
//--------------------------------------------
// Part 6: advanced KVStore for multi-machines
//--------------------------------------------

/*!
 * \brief return The rank of this node in its group, which is in [0, GroupSize).
 *
 * \param handle handle to the KVStore
 * \param ret the node rank
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreGetRank (KVStoreHandle handle, int* ret);

/*!
 * \brief return The number of nodes in this group, which is
 * - number of workers if if `IsWorkerNode() == true`,
 * - number of servers if if `IsServerNode() == true`,
 * - 1 if `IsSchedulerNode() == true`,
 * \param handle handle to the KVStore
 * \param ret the group size
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreGetGroupSize (KVStoreHandle handle, int* ret);

/*!
 * \brief return whether or not this process is a worker node.
 * \param ret 1 for yes, 0 for no
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreIsWorkerNode (int* ret);

/*!
 * \brief return whether or not this process is a server node.
 * \param ret 1 for yes, 0 for no
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreIsServerNode (int* ret);

/*!
 * \brief return whether or not this process is a scheduler node.
 * \param ret 1 for yes, 0 for no
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreIsSchedulerNode (int* ret);

/*!
 * \brief global barrier among all worker machines
 *
 * \param handle handle to the KVStore
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreBarrier (KVStoreHandle handle);

/*!
 * \brief whether to do barrier when finalize
 *
 * \param handle handle to the KVStore
 * \param barrier_before_exit whether to do barrier when kvstore finalize
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreSetBarrierBeforeExit (KVStoreHandle handle, const(int) barrier_before_exit);

/*!
 * \brief the prototype of a server controller
 * \param head the head of the command
 * \param body the body of the command
 * \param controller_handle helper handle for implementing controller
 */
alias void function (int head, const(char)* body_, void* controller_handle) MXKVStoreServerController;

/*!
 * \return Run as server (or scheduler)
 *
 * \param handle handle to the KVStore
 * \param controller the user-defined server controller
 * \param controller_handle helper handle for implementing controller
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreRunServer (KVStoreHandle handle, void function () controller, void* controller_handle);

/*!
 * \return Send a command to all server nodes
 *
 * \param handle handle to the KVStore
 * \param cmd_id the head of the command
 * \param cmd_body the body of the command
 * \return 0 when success, -1 when failure happens
 */
int MXKVStoreSendCommmandToServers (KVStoreHandle handle, int cmd_id, const(char)* cmd_body);

/*!
 * \brief Get the number of ps dead node(s) specified by {node_id}
 *
 * \param handle handle to the KVStore
 * \param node_id Can be a node group or a single node.
 *                kScheduler = 1, kServerGroup = 2, kWorkerGroup = 4
 * \param number Ouptut number of dead nodes
 * \param timeout_sec A node fails to send heartbeart in {timeout_sec} seconds
 *                    will be presumed as 'dead'
 */
int MXKVStoreGetNumDeadNode (KVStoreHandle handle, const(int) node_id, int* number, const(int) timeout_sec);

/*!
 * \brief Create a RecordIO writer object
 * \param uri path to file
 * \param out handle pointer to the created object
 * \return 0 when success, -1 when failure happens
*/
int MXRecordIOWriterCreate (const(char)* uri, RecordIOHandle* out_);

/*!
 * \brief Delete a RecordIO writer object
 * \param handle handle to RecordIO object
 * \return 0 when success, -1 when failure happens
*/
int MXRecordIOWriterFree (RecordIOHandle handle);

/*!
 * \brief Write a record to a RecordIO object
 * \param handle handle to RecordIO object
 * \param buf buffer to write
 * \param size size of buffer
 * \return 0 when success, -1 when failure happens
*/
int MXRecordIOWriterWriteRecord (RecordIOHandle handle, const(char)* buf, size_t size);

/*!
 * \brief Get the current writer pointer position
 * \param handle handle to RecordIO object
 * \param pos handle to output position
 * \return 0 when success, -1 when failure happens
*/
int MXRecordIOWriterTell (RecordIOHandle handle, size_t* pos);

/*!
 * \brief Create a RecordIO reader object
 * \param uri path to file
 * \param out handle pointer to the created object
 * \return 0 when success, -1 when failure happens
*/
int MXRecordIOReaderCreate (const(char)* uri, RecordIOHandle* out_);

/*!
 * \brief Delete a RecordIO reader object
 * \param handle handle to RecordIO object
 * \return 0 when success, -1 when failure happens
*/
int MXRecordIOReaderFree (RecordIOHandle handle);

/*!
 * \brief Write a record to a RecordIO object
 * \param handle handle to RecordIO object
 * \param buf pointer to return buffer
 * \param size point to size of buffer
 * \return 0 when success, -1 when failure happens
*/
int MXRecordIOReaderReadRecord (RecordIOHandle handle, const(char*)* buf, size_t* size);

/*!
 * \brief Set the current reader pointer position
 * \param handle handle to RecordIO object
 * \param pos target position
 * \return 0 when success, -1 when failure happens
*/
int MXRecordIOReaderSeek (RecordIOHandle handle, size_t pos);

/*!
 * \brief Create a MXRtc object
*/
int MXRtcCreate (char* name, mx_uint num_input, mx_uint num_output, char** input_names, char** output_names, NDArrayHandle* inputs, NDArrayHandle* outputs, char* kernel, RtcHandle* out_);

/*!
 * \brief Run cuda kernel
*/
int MXRtcPush (RtcHandle handle, mx_uint num_input, mx_uint num_output, NDArrayHandle* inputs, NDArrayHandle* outputs, mx_uint gridDimX, mx_uint gridDimY, mx_uint gridDimZ, mx_uint blockDimX, mx_uint blockDimY, mx_uint blockDimZ);

/*!
 * \brief Delete a MXRtc object
*/
int MXRtcFree (RtcHandle handle);

int MXCustomOpRegister (const(char)* op_type, scope CustomOpPropCreator creator);

// __cplusplus

// MXNET_C_API_H_
