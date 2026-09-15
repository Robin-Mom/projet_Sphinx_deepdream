FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris

# ----------------------------------------------------------------------
# 1. Dépendances système
# ----------------------------------------------------------------------

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    pkg-config \
    ca-certificates \
    wget \
    curl \
    vim \
    nano \
    \
    # Python 3
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-numpy \
    python3-scipy \
    python3-skimage \
    python3-matplotlib \
    python3-pil \
    python3-protobuf \
    \
    # Boost / Boost.Python
    libboost-all-dev \
    libboost-python-dev \
    \
    # Caffe dependencies
    libgoogle-glog-dev \
    libgflags-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libhdf5-dev \
    liblmdb-dev \
    libleveldb-dev \
    libsnappy-dev \
    libatlas-base-dev \
    libopenblas-dev \
    \
    # Graph / visualization
    graphviz \
    \
    # Image libraries
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    \
    && rm -rf /var/lib/apt/lists/*


# ----------------------------------------------------------------------
# 2. Vérification de l'environnement
# ----------------------------------------------------------------------

RUN echo "=== Python ===" && \
    python3 --version && \
    echo "=== Boost.Python ===" && \
    find /usr/lib /usr/lib/x86_64-linux-gnu \
        -name "*boost_python*" \
        -print


# ----------------------------------------------------------------------
# 3. Mise à jour de pip
# ----------------------------------------------------------------------

RUN python3 -m pip install --no-cache-dir \
    --upgrade pip setuptools wheel


# ----------------------------------------------------------------------
# 4. Dépendances Python nécessaires à DeepDream
#
# On ne lance volontairement PAS :
#
#     pip install -r caffe/python/requirements.txt
#
# car ce fichier contient des dépendances historiques incompatibles
# avec un environnement Python moderne.
# ----------------------------------------------------------------------

RUN python3 -m pip install --no-cache-dir \
    "numpy<2" \
    "scipy<2" \
    "Pillow" \
    "ipython" \
    "ipykernel" \
    "jupyterlab" \
    "matplotlib" \
    "pydot"


# ----------------------------------------------------------------------
# 5. Répertoire de travail
# ----------------------------------------------------------------------

WORKDIR /workspace


# ----------------------------------------------------------------------
# 6. Copie de Caffe
# ----------------------------------------------------------------------

COPY caffe /workspace/caffe

WORKDIR /workspace/caffe


# ----------------------------------------------------------------------
# 7. Configuration de Caffe
#
# IMPORTANT :
#
# USE_OPENCV=OFF
#
# Le code Caffe historique utilise les anciennes constantes :
#
#     CV_LOAD_IMAGE_COLOR
#     CV_LOAD_IMAGE_GRAYSCALE
#
# qui ne sont plus disponibles dans les versions modernes d'OpenCV.
#
# DeepDream utilise PIL et n'a pas besoin d'OpenCV.
# ----------------------------------------------------------------------

RUN mkdir -p build && \
    cd build && \
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCPU_ONLY=ON \
        -Dpython_version=3 \
        -DBLAS=Open \
        -DUSE_CUDNN=OFF \
        -DUSE_OPENCV=OFF \
        -DUSE_LMDB=ON \
        -DUSE_LEVELDB=ON \
        -DBUILD_python=ON \
        -DBUILD_python_layer=ON


# ----------------------------------------------------------------------
# 8. Compilation
# ----------------------------------------------------------------------

RUN cd build && \
    make -j"$(nproc)"


# ----------------------------------------------------------------------
# 9. Installation
# ----------------------------------------------------------------------

RUN cd build && \
    make install


# ----------------------------------------------------------------------
# 10. PyCaffe
# ----------------------------------------------------------------------

ENV PYTHONPATH=/workspace/caffe/python


# ----------------------------------------------------------------------
# 11. Test de PyCaffe
# ----------------------------------------------------------------------

RUN python3 -c \
    "import caffe; print('================================'); print('PyCaffe OK'); print('Caffe version:', caffe.__version__); print('================================')"


# ----------------------------------------------------------------------
# 12. Répertoire des notebooks
# ----------------------------------------------------------------------

RUN mkdir -p /workspace/notebooks

WORKDIR /workspace/notebooks


# ----------------------------------------------------------------------
# 13. JupyterLab
# ----------------------------------------------------------------------

EXPOSE 8888

CMD ["jupyter", "lab", \
     "--ip=0.0.0.0", \
     "--port=8888", \
     "--no-browser", \
     "--allow-root", \
     "--ServerApp.token=", \
     "--ServerApp.password="]

