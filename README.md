This project aims at playing with the concepts around deepdream initially introduced to the world by Alexander Mordvintsev, Michael Tyka and Christopher Olah.

##############################################################################################################################################################
This project contains or is derived from software originally developed by third parties. Hereafter is a summary of licenses used:
this project -> Apache-2.0
deepdream code -> Apache-2.0 attributed to Google
Caffe -> BSD-2-Claude
google images from original deepdream repository -> CC BY-SA 3.0

##############################################################################################################################################################
The main branch currently contain the following features:

_ A Dockerfile to build an image with which you can run containers allowing for dream.ipynb usage.
an example of command to build the image and then to run your container locally and access the notebook:
-> docker build -t deepdream-caffe . ### to run from the root of the repository
-> docker run --rm -it -p 8890:8888 -v "$PWD/notebooks:/workspace/notebooks" deepdream-caffe ### you can choose any port of your preference instead of 8890. Once running you just have to go to http://localhost:8890 to find the notebook.



