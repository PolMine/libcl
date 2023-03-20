FROM ubuntu:trusty

RUN apt-get update &&                                                              \
    apt-get -y upgrade &&                                                          \
    apt-get install -y wget make mingw-w64 unzip xz-utils subversion git pkg-config bison flex

ENV PCRE2_VERSION=10.42

ENV ICONV_VERSION=1.16
# newest version: 1.17 

ENV EXPAT_VERSION=2.4.1
# newest version: 2.5.0

ENV GETTEXT_VERSION=0.19.8
# newest version 0.21.1

ENV LIBFFI_VERSION=3.2
# newest version 3.4.4

WORKDIR /root
RUN wget --no-check-certificate https://github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VERSION/pcre2-$PCRE2_VERSION.tar.bz2 && \
    wget --no-check-certificate https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$ICONV_VERSION.tar.gz &&    \
    wget --no-check-certificate https://github.com/libexpat/libexpat/releases/download/R_2_4_1/expat-$EXPAT_VERSION.tar.gz  &&     \
    wget --no-check-certificate https://ftp.gnu.org/gnu/gettext/gettext-$GETTEXT_VERSION.tar.gz &&        \
    wget --no-check-certificate ftp://sourceware.org/pub/libffi/libffi-$LIBFFI_VERSION.tar.gz

RUN tar xf pcre2-$PCRE2_VERSION.tar.bz2 &&                                            \
    tar xf libiconv-$ICONV_VERSION.tar.gz &&                                       \
    tar xf expat-$EXPAT_VERSION.tar.gz &&                                          \
    tar xf gettext-$GETTEXT_VERSION.tar.gz &&                                      \
    tar xf libffi-$LIBFFI_VERSION.tar.gz 

ARG TARGET=x86_64 # or i686
ARG MINGWDIR=/usr/lib/gcc/x86_64-w64-mingw32/4.8/
  
RUN cd /root/pcre2-$PCRE2_VERSION &&                                            \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc  ./configure                    \
      --host=$TARGET-w64-mingw32                                                \
      --enable-jit                                                              \
      --enable-newline-is-any                                                   \
      --enable-static                                                           \
      --disable-dependency-tracking                                             \
      --prefix=$MINGWDIR                                                        \
      --exec-prefix=$MINGWDIR                                                   \
      --libdir=$MINGWDIR                                                        \
      --oldincludedir=$MINGWDIR/include &&                                      \
    make && make install && make clean

RUN cd /root/libiconv-$ICONV_VERSION &&                                         \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure                     \
      --host=$TARGET-w64-mingw32                                                \
      --enable-static                                                           \
      --prefix=$MINGWDIR                                                        \
      --exec-prefix=$MINGWDIR                                                   \
      --libdir=$MINGWDIR                                                        \
      --oldincludedir=$MINGWDIR/include &&                                      \
    make && make install && make clean
    
RUN cd /root/expat-$EXPAT_VERSION &&                                            \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure                     \
      --host=$TARGET-w64-mingw32                                                \
      --prefix=$MINGWDIR                                                        \
      --exec-prefix=$MINGWDIR                                                   \
      --libdir=$MINGWDIR                                                        \
      --oldincludedir=$MINGWDIR/include &&                                      \
    make && make install && make clean

RUN cd /root/gettext-$GETTEXT_VERSION &&                                        \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure                     \
      --enable-static                                                           \
      --enable-shared                                                           \
      --disable-threads                                                         \
      --host=$TARGET-w64-mingw32                                                \
      --prefix=$MINGWDIR                                                        \
      --exec-prefix=$MINGWDIR                                                   \
      --libdir=$MINGWDIR                                                        \
      --oldincludedir=$MINGWDIR/include &&                                      \
      make && make install && make clean; exit 0

RUN cd /root/libffi-$LIBFFI_VERSION &&                                          \ 
    LIBFFI_CFLAGS=${MINGW_OUTPUT}/include                                       \
    LIBFFI_LIBS=${MINGW_OUTPUT}/include                                         \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc                                 \
    ./configure                                                                 \
    --host=$TARGET-w64-mingw32                                                  \
    --prefix=$MINGWDIR                                                          \
    --exec-prefix=$MINGWDIR                                                     \
    --libdir=$MINGWDIR                                                          \
    --oldincludedir=$MINGWDIR/include &&                                        \
    make && make install && make clean

RUN if [ "$TARGET" =  "x86_64" ]; then ARCH=64; else ARCH=32; fi &&             \
    cd /opt &&                                                                  \
    mkdir glib &&                                                               \
    cd glib &&                                                                  \
    wget --no-check-certificate https://download.gnome.org/binaries/win$ARCH/glib/2.26/glib-dev_2.26.0-1_win$ARCH.zip && \ 
    unzip glib-dev_2.26.0-1_win$ARCH.zip &&                                     \
    rm glib-dev_2.26.0-1_win$ARCH.zip &&                                        \
    sed -i -E "s/^prefix=.*$/prefix=\/opt\/glib/" /opt/glib/lib/pkgconfig/glib-2.0.pc


ARG RCPPCWB_BUILD=0005
RUN cd /root && \
    git clone https://github.com/PolMine/RcppCWB.git && \
    cd /root/RcppCWB && \
    git checkout dev && \
    git pull origin dev

WORKDIR /root/RcppCWB/src/cwb

RUN sed -i -E "s/^PLATFORM=.*$/PLATFORM=mingw-cross/" config.mk && \
    sed -i -E "s/^SITE=.*$/SITE=windows-release/" config.mk && \
    sed -i -E "s/#\s+CC\s*=\s*.*$/CC=$TARGET-w64-mingw32-gcc/" config.mk && \
    sed -i -E 's|#\s+(LIBPCRE2_DLL_PATH)\s+=.*$|LIBPCRE2_DLL_PATH=$MINGWDIR/|g' config.mk && \
    sed -i -E "s|#\s+(LIBGLIB_DLL_PATH)\s+=.*$|LIBGLIB_DLL_PATH=$MINGWDIR/|g" config.mk && \
    sed -i -E "s/^CC\s=\sgcc\s*/#CC = gcc/" config.mk

RUN sed -i -E "s/i586-mingw32msvc/$TARGET-w64-mingw32/g" /root/RcppCWB/src/cwb/config/platform/mingw-cross && \
    sed -i -E "s/i586/$TARGET/" /root/RcppCWB/src/cwb/config/platform/mingw-cross && \
    sed -i -E "s/^AR\s=\s(.*?)\scq/AR = \1/" /root/RcppCWB/src/cwb/config/platform/mingw-cross
    
RUN sed -i -E "s/export\s*PKG_CONFIG_PATH=.+MINGW_CROSS_HOME.\/lib\/pkgconfig\s*;//g" definitions.mk && \
    sed -i -E "s/\s+\\$\\(MINGW_CROSS_HOME\\)\/bin\/pcre2-config/ pcre2-config/g" definitions.mk && \
    sed -i -E "s/^CFLAGS_ALL\s=/CFLAGS_ALL = -DPCRE2_STATIC=-1 -DGLIB_STATIC_COMPILATION/g" definitions.mk && \
    sed -i -E "s/^#PCRE2_DEFINES/PCRE2_DEFINES/" definitions.mk && \
    sed -i -E "s/^#GLIB_DEFINES/GLIB_DEFINES/" definitions.mk && \
    sed -i -E "s/PCRE2_DEFINES\s:=\s-DPCRE2_STATIC//" definitions.mk

RUN sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" /root/RcppCWB/src/cwb/Makefile && \
    sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" /root/RcppCWB/src/cwb/cl/Makefile && \
    sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" /root/RcppCWB/src/cwb/cqp/Makefile && \
    sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" /root/RcppCWB/src/cwb/utils/Makefile

RUN sed -i -E "s/(.define\sIPAddress\s267)//" /root/RcppCWB/src/cwb/cqp/parser.tab.c

RUN cd /root/RcppCWB/src/cwb && \
    export PKG_CONFIG_PATH=/opt/glib/lib/pkgconfig && \
    export PATH=$PATH:$MINGWDIR/bin/ && \
    make clean && make depend && make cl && make cqp && make utils
    
CMD if [ "$TARGET" =  "x86_64" ]; then export ARCHDIR=x64; else export ARCHDIR=i386; fi &&     \
    cp /root/RcppCWB/src/cwb/cl/libcl.a /libcl/lib/$ARCHDIR/libcl.a &&                         \
    cp /root/RcppCWB/src/cwb/cqp/libcqp.a /libcl/lib/$ARCHDIR/libcqp.a &&                      \
    cp /root/RcppCWB/src/cwb/utils/libcwb.a /libcl/lib/$ARCHDIR/libcwb.a &&                    \
    cp $MINGWDIR/libpcre2-8.a /libcl/lib/$ARCHDIR/libpcre2-8.a &&                              \
    cp $MINGWDIR/include/pcre2.h /libcl/include/pcre2.h

