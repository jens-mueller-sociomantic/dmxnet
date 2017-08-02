# Ensure D2 unittests will fail if stomping prevention is triggered
export ASSERT_ON_STOMPING_PREVENTION=1

override DFLAGS += -w
override LDFLAGS += -lmxnet

ifeq ($(DVER),1)
	override DFLAGS += -v2 -v2=-static-arr-params -v2=-volatile
endif

# use NaiveEngine (non-threaded) MXNet engine since the default (threaded)
# version dead locks
%test: export MXNET_ENGINE_TYPE=NaiveEngine