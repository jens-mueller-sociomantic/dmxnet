### Update D bindings to MXNet version 1.2.0

`mxnet.c.c_api`

The bindings to the MXNet C interfaces are updated to match MXNet 1.2.0. The
changes should be backward compatible except for the functions
`MXSetProfilerConfig` and `MXDumpProfile` which need to be updated when used in
calling code.
