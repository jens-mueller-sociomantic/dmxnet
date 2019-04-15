### Update D bindings to MXNet version 1.3.1

`mxnet.c.c_api`

The bindings to the MXNet C interfaces are updated to match MXNet 1.3.1. The
changes should be backward compatible. Only the function
`MXGetGPUMemoryInformation64` was added to the API.
