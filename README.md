# Sphinx project
This project aims at playing with the concepts around deepdream initially introduced to the world by Alexander Mordvintsev, Michael Tyka and Christopher Olah.

## Licences summary  
This project contains or is derived from software originally developed by third parties. Hereafter is a summary of licenses used:
* this project -> Apache-2.0
* deepdream code -> Apache-2.0 attributed to Google
* Caffe -> BSD-2-Claude
* google images from original deepdream repository -> CC BY-SA 3.0

## Current features  
The main branch currently contains the following features:

* A Dockerfile to build an image with which you can run containers allowing for dream.ipynb usage. Depending on your needs, you can compile caffe with CUDA (Dockerfile.gpu) or 
for CPU only (Dockerfile). Deepdream was originally developed with caffe. Because caffe is an old CNN framework, if you want to compile it with GPU, you will have to check for the compatibility with the compute capability of
your GPU and then specify manually tho options: **-DCUDA_ARCH_BIN=XXX** and **-DCUDA_ARCH_PTX=XXX** in the Dockerfile.gpu. The automatic mode for CUDA architecture detection is 
too outdated to detect recent architectures. Alternatively, the CPU build should work on any computer but it is obviously then quite slower to generate deepdream images...
an example of command to build the image and then to run your container locally and access the notebook:

-> docker build -f Dockerfile -t deepdream-caffe . ### to run from the root of the repository

-> docker run --rm -it -p 8890:8888 -v "$PWD/notebooks:/workspace/notebooks" deepdream-caffe ### you can choose any port of your preference instead of 8890. 
Once running you just have to go to http://localhost:8890 to find the notebook.

* The caffe repository which is only used for the Dockerfile to build the image.

* Inside "notebooks", the dream.ipynb from google deepdream original repository with very very tiny modifications (related to compatibilities issues). 
You will also find the two images distributed with the deepdream repository. Finally, in "notobooks/models", you will find GoogleNet architecture and weights ready 
for the dream.ipynb to use and for you to start making dreams.


