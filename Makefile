
CP      = g++
#CP     += -O3 -fopenmp -fomit-frame-pointer -ffast-math
CP     += -O0 -fopenmp -fstack-check -Wall -Wpointer-arith -g

CU      = nvcc
#CU     += -O3 -m64
CU     += -G -g -m64

INCDIR  = $(patsubst %,-I%,$(subst :, ,${INCLUDE}))
LIBDIR  = $(patsubst %,-L%,$(subst :, ,${LIBRARY_PATH}))

FLAGS   = $(INCDIR) -I ${CONDA_PREFIX}/include/healpix_cxx/ -I${CONDA_PREFIX}/include -I${CUDATOOLKIT_HOME}/include/ -I../libpsht/generic_gcc/include -I ${CUDA_HOME}/samples/common/inc

LDFLAGS = $(LIBDIR) -L${CONDA_PREFIX}/lib -L${CUDATOOLKIT_HOME}/lib64 -L ${CUDA_HOME}/samples/common/lib -L../libpsht/generic_gcc/lib \
	  -lhealpix_cxx -lcxxsupport -lcfitsio\
	  -lpsht -lfftpack -lc_utils -lfftw3f\
	  -lcudart -lcufft

exec    = arkcos
src     = arkcos_main.cxx
obj     = arkcos_main.o arkcos_class.o\
	  arkcos_misc.o arkcos_gpu.o\
	  cubic_hermite.o


default: $(src) $(exec)

$(exec): $(obj)
	$(CP) -o $(exec) $(obj) $(LDFLAGS)

%.o: %.cxx
	$(CP) $(FLAGS) -c $< -o $@

%.o: %.cu
	$(CU) $(FLAGS) -c $< -o $@

clean:
	rm -f *~ *.o *.mod batch_*

cleanall: clean
	rm -f $(exec)
