#FROM ubuntu:trusty
FROM debian:oldstable

ARG ARCH=x86_64

RUN apt-get update && apt-get -q -y install  vc-dev libvigraimpex-dev libsfml-dev libexiv2-dev clang git wget fuse cmake

RUN git clone git clone https://bitbucket.org/kfj/pv && \

RUN mkdir pv-squashfs

RUN mkdir build && \
    cd build cd && \
    cmake -DCMAKE_INSTAL_PREFIX=../pv-squashfs ..
    make
    make install


COPY appimagetool-$ARCH.AppImage /
RUN chmod +x appimagetool-$ARCH.AppImage
RUN ./appimagetool-$ARCH.AppImage --appimage-extract && \
    cp -R squashfs-root/* .

WORKDIR pv-squashfs
RUN mkdir -p usr/share/metainfo
COPY pv.appdata.xml usr/share/metainfo/

COPY AppRun .
RUN chmod +x AppRun
COPY pv.desktop .
#COPY pv.png .

WORKDIR /
RUN ARCH=$ARCH appimagetool pv-squashfs
