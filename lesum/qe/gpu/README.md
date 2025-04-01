# How to compile QE-GPU (CUDA version)

To compile Quantum ESPRESSO on GPU that works for NVidia cards, CMake is used. The script provided here should do the job. You may adapt the particular version you want to use. A submission script to show how to use it is also provided.


Note:

- The script has been tested for Quantum ESPRESSO v7.2.
- Oversubscription on the GPU cards provide a good speed up (done via pools parallelization).
- Parallelization over multiple GPUs is not as great (at least, as far as I tested).
