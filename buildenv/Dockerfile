####################################################################### 
#                                                                     #
# Generate Environment for cross-compiling the Corpus Workbench (CWB) #
#                                                                     #
# NOTE The INSTALL.WIN script in the cwb directory with installation  #
# files is extremely helpful up to the point where it comes to        # 
# cross-compiling glib.                                               #
#                                                                     #
#######################################################################

from ubuntu:trusty

RUN apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y wget make mingw-w64 unzip xz-utils subversion git


############################ 64bit cross-compilation #################################

# get installation directory for cross-compilation:

# ARG MINGW_OUTPUT=`x86_64-w64-mingw32-gcc --print-search-dirs | grep ^install | sed -E 's/install:\s(.*?)/\1/'`
ENV MINGW_OUTPUT=/usr/lib/gcc/x86_64-w64-mingw32/8.3-win32

# install pcre

RUN cd /root && \
  wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz && \ 
  tar xf pcre-8.44.tar.gz && \
  cd pcre-8.44 && \
  CC=x86_64-w64-mingw32-gcc CC_FOR_BUILD=gcc  ./configure    \
  --host=x86_64-w64-mingw32                                  \
  --enable-utf8 --enable-unicode-properties --enable-jit     \
  --enable-newline-is-any --disable-cpp --enable-static      \
  --disable-dependency-tracking                              \
  --prefix=${MINGW_OUTPUT}                                     \
  --exec-prefix=${MINGW_OUTPUT}                                \
  --libdir=${MINGW_OUTPUT}/lib                                 \
  --oldincludedir=${MINGW_OUTPUT}/include && \
  make && \
  make install


# libiconv

RUN cd /root && \
  wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz && \
  tar xf libiconv-1.15.tar.gz && \
  cd libiconv-1.15 && \
  CC=x86_64-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure       \
  --host=x86_64-w64-mingw32                                    \
  --enable-static                                              \
  --prefix=$MINGW_OUTPUT                                       \
  --exec-prefix=$MINGW_OUTPUT                                  \
  --libdir=$MINGW_OUTPUT/lib                                 \
  --oldincludedir=$MINGW_OUTPUT/include && \
  make && \
  make install


# install expat

RUN cd /root && \
  wget http://downloads.sourceforge.net/expat/expat-2.1.0.tar.gz && \
  tar xf expat-2.1.0.tar.gz && \
  cd expat-2.1.0 && \
  CC=x86_64-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure       \
  --host=x86_64-w64-mingw32                                    \
  --prefix=$MINGW_OUTPUT                                       \
  --exec-prefix=$MINGW_OUTPUT                                  \
  --libdir=$MINGW_OUTPUT/lib                                   \
  --oldincludedir=$MINGW_OUTPUT/include && \
  make && \
  make install


# gettext

# RUN cd /root && \
#  wget http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.8.1.tar.gz && \
#  tar xf gettext-0.19.8.1.tar.gz && \
#  cd gettext-0.19.8.1 && \
#  CC=x86_64-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure       \
#  --host=x86_64-w64-mingw32                                    \
#  --prefix=$MINGW_OUTPUT                                       \
#  --exec-prefix=$MINGW_OUTPUT                                  \
#  --libdir=$MINGW_OUTPUT/lib                                   \
#  --oldincludedir=$MINGW_OUTPUT && \
#  make && \
#  make install


### libffi

RUN cd /root && \
  wget ftp://sourceware.org/pub/libffi/libffi-3.2.tar.gz && \
  tar xf libffi-3.2.tar.gz && \ 
  cd libffi-3.2 && \
  LIBFFI_CFLAGS=$MINGW_OUTPUT/include             \
  LIBFFI_LIBS=$MINGW_OUTPUT/lib                   \
  CC=x86_64-w64-mingw32-gcc CC_FOR_BUILD=gcc                            \
  ./configure                                                           \
  --host=x86_64-w64-mingw32                                             \
  --prefix=$MINGW_OUTPUT/                         \
  --exec-prefix=$MINGW_OUTPUT/                    \
  --libdir=$MINGW_OUTPUT/lib                                            \
  --oldincludedir=$MINGW_OUTPUT/include && \
  make && \
  make install
  

# glib (download binaries to circumvent difficulties to compile glib)

RUN cd /root && \
  mkdir glib && \
  cd glib && \
  wget http://ftp.gnome.org/pub/gnome/binaries/win64/glib/2.26/glib_2.26.0-1_win64.zip && \ 
  unzip glib_2.26.0-1_win64.zip && \
  rm glib_2.26.0-1_win64.zip && \
  cd bin && \
  cp *.dll $MINGW_OUTPUT/lib/


########################### 32bit Cross-compilation ##################################

# ENV MINGW_OUTPUT_32=`i686-w64-mingw32-gcc --print-search-dirs | grep ^install | sed -E 's/install:\s(.*?)/\1/'`
ENV MINGW_OUTPUT_32=/usr/lib/gcc/i686-w64-mingw32/8.3-win32/

# compile 'pcre'

RUN cd /root/pcre-8.44 && \
  make clean && \
  CC=i686-w64-mingw32-gcc CC_FOR_BUILD=gcc  ./configure      \
  --host=i686-w64-mingw32                                    \
  --enable-utf8 --enable-unicode-properties --enable-jit     \
  --enable-newline-is-any --disable-cpp --enable-static      \
  --prefix=$MINGW_OUTPUT_32                                  \
  --exec-prefix=$MINGW_OUTPUT_32                             \
  --libdir=$MINGW_OUTPUT_32/lib                              \
  --oldincludedir=$MINGW_OUTPUT_32/include && \
  make && \
  make install


# compile 'iconv'

RUN cd /root/libiconv-1.15 && \
  make clean && \
  CC=i686-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure      \
  --host=i686-w64-mingw32                                   \
  --prefix=$MINGW_OUTPUT_32                \
  --enable-static                                           \
  --exec-prefix=$MINGW_OUTPUT_32           \
  --libdir=$MINGW_OUTPUT_32/lib                              \
  --oldincludedir=$MINGW_OUTPUT_32/include && \
  make && \
  make install


# compile 'expat'

RUN cd /root/expat-2.1.0 && \
  make clean && \
  CC=i686-w64-mingw32-gcc CC_FOR_BUILD=gcc                            \
  ./configure                                                         \
  --host=i686-w64-mingw32                                    \
  --prefix=$MINGW_OUTPUT_32/                \
  --exec-prefix=$MINGW_OUTPUT_32/           \
  --libdir=$MINGW_OUTPUT_32/lib                              \
  --oldincludedir=$MINGW_OUTPUT_32/include && \
  make && \
  make install


# compile 'liblzma'

RUN cd /root && \
  wget https://sourceforge.net/projects/lzmautils/files/xz-5.2.5.tar.gz && \
  tar xzfv xz-5.2.5.tar.gz && \
  cd xz-5.2.5 && \
  CC=i686-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure \
    --host=i686-w64-mingw32 \
    --prefix=$MINGW_OUTPUT_32 \
    --exec-prefix=$MINGW_OUTPUT_32 \
    --libdir=$MINGW_OUTPUT_32/lib && \
  make && \
  make install


# compile 'libxml2'

RUN cd /root && \
  wget ftp://xmlsoft.org/libxml2/libxml2-sources-2.9.7.tar.gz && \
  tar xf libxml2-sources-2.9.7.tar.gz && \
  cd libxml2-2.9.7 && \
  CC=i686-w64-mingw32-gcc CC_FOR_BUILD=gcc                            \
  ./configure                                                           \
  --host=i686-w64-mingw32                                    \
  --prefix=$MINGW_OUTPUT_32/                \
  --exec-prefix=$MINGW_OUTPUT_32/ \
  --libdir=$MINGW_OUTPUT_32/lib && \
  export PATH=$PATH:$MINGW_OUTPUT_32/lib && \
  make && \
  make install


# compile 'gettext'

# RUN cd /root && \
#   wget http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.8.1.tar.gz && \
#  tar xf gettext-0.19.8.1.tar.gz && \
#  cd gettext-0.19.8.1 && \
#  export CFLAGS="$CFLAGS -O2" && \
#  export CXXFLAGS="$CXXFLAGS -O2" && \
#  CC=i686-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure         \
#  --host=i686-w64-mingw32                                      \
#  --prefix=$MINGW_OUTPUT_32/                  \
#  --exec-prefix=$MINGW_OUTPUT_32/             \
#  --with-libiconv-prefix=$MINGW_OUTPUT_32/lib \
#  --oldincludedir=$MINGW_OUTPUT_32/include && \
#  make && \
#  make install


# compile 'libffi'

RUN cd /root && \
  wget ftp://sourceware.org/pub/libffi/libffi-3.2.tar.gz && \
  tar xf libffi-3.2.tar.gz && \
  cd libffi-3.2 && \
  LIBFFI_CFLAGS=$MINGW_OUTPUT_32/include             \
  LIBFFI_LIBS=$MINGW_OUTPUT_32/lib                   \
  CC=i686-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure                \
  --host=i686-w64-mingw32                                    \
  --prefix=$MINGW_OUTPUT_32/                \
  --exec-prefix=$MINGW_OUTPUT_32/           \
  --libdir=$MINGW_OUTPUT_32/lib  \
  --oldincludedir=$MINGW_OUTPUT_32/include && \
  make && \
  make install
  

# compile 'zlib'
RUN cd /root && \
  wget http://prdownloads.sourceforge.net/libpng/zlib-1.2.11.tar.gz && \
  tar xzfv zlib-1.2.11.tar.gz && \
  cd zlib-1.2.11 && \
  CC=i686-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure                \
  --prefix=$MINGW_OUTPUT_32/                \
  --libdir=$MINGW_OUTPUT_32/lib  \
  --includedir=$MINGW_OUTPUT_32/include

# compile 'glib'

# RUN cd /root && \
#  wget http://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-2.50.0.tar.xz && \
#  tar xzfv glib-2.50.0.tar.xz && \
#  cd glib-2.50.0 && \
#  export PATH=$PATH:$MINGW_OUTPUT_32/bin && \
#  CFLAGS="-I$MINGW_OUTPUT_32/include"                \
#  LIBFFI_CFLAGS=$MINGW_OUTPUT_32/include             \
#  LIBFFI_LIBS=$MINGW_OUTPUT_32/lib                   \
#  CC=i686-w64-mingw32-gcc CC_FOR_BUILD=gcc  ./configure               \
#  --host=i686-w64-mingw32                                    \
#  --prefix=$MINGW_OUTPUT_32/                \
#  --exec-prefix=$MINGW_OUTPUT_32/           \
#  --oldincludedir=$MINGW_OUTPUT_32/include

RUN cd /root && \
  mkdir glib32 && \
  cd glib32 && \
  wget https://download.gnome.org/binaries/win32/glib/2.26/glib_2.26.1-1_win32.zip && \
  unzip glib_2.26.1-1_win32.zip && \
  cd bin && \
  cp *.dll $MINGW_OUTPUT_32/lib/ 
  

############### libcl #############################

ARG START_FROM_HERE=00002

RUN cd /root && \
  git clone https://github.com/PolMine/libcl.git && \
  cd /root/libcl && \
  git checkout dev

############### utils static library 64 bit ########################


RUN cd /root && \
  git clone https://github.com/PolMine/RcppCWB.git && \
  cd /root/RcppCWB && \
  git checkout dev && \
  git pull origin dev
  
WORKDIR /root/RcppCWB/src/cwb/utils

RUN x86_64-w64-mingw32-gcc -c -o _cwb_huffcode.o -O2 -Wall -static  \
  -D__MINGW__ -DEMULATE_SETENV -DG_OS_WIN32                                       \
  -I/root/RcppCWB/src/cwb/cl                                                   \
  -I/usr/share/mingw-w64/include \
  -I$MINGW_OUTPUT/include                                      \
  _cwb_huffcode.c

RUN x86_64-w64-mingw32-gcc -c -o _cwb_compress_rdx.o -O2 -Wall -static  \
  -D__MINGW__ -DEMULATE_SETENV -DG_OS_WIN32                                       \
  -I/root/RcppCWB/src/cwb/cl \
  -I$MINGW_OUTPUT/include                                      \
  _cwb_compress_rdx.c

RUN x86_64-w64-mingw32-gcc -c -o _cwb_encode.o -O2 -Wall -static  \
  -D__MINGW__ -DEMULATE_SETENV -DG_OS_WIN32                                       \
  -I/root/RcppCWB/src/cwb/cl \
  -I$MINGW_OUTPUT/include                                      \
  _cwb_encode.c

RUN x86_64-w64-mingw32-gcc -c -o _cwb_makeall.o -O2 -Wall -static  \
  -D__MINGW__ -DEMULATE_SETENV -DG_OS_WIN32                                       \
  -I/root/RcppCWB/src/cwb/cl                                                   \
  -I/usr/share/mingw-w64/include \
  -I$MINGW_OUTPUT/include                                      \
  _cwb_makeall.c
  
RUN x86_64-w64-mingw32-ar cq libcwb.a _cwb_makeall.o _cwb_huffcode.o _cwb_compress_rdx.o _cwb_encode.o && \
  x86_64-w64-mingw32-ranlib libcwb.a

RUN cp /root/RcppCWB/src/cwb/utils/libcwb.a /root/libcl/lib/x64/libcwb.a

RUN cd /root/RcppCWB && git clean -f


################ utils static library 32 bit

WORKDIR /root/RcppCWB/src/cwb/utils

RUN i686-w64-mingw32-gcc -c -o _cwb_huffcode.o -O2 -Wall -static  \
  -D__MINGW__ -DEMULATE_SETENV -DG_OS_WIN32                                       \
  -I/root/RcppCWB/src/cwb/cl                                                   \
  -I$MINGW_OUTPUT/include                                      \
  _cwb_huffcode.c

RUN i686-w64-mingw32-gcc -c -o _cwb_compress_rdx.o -O2 -Wall -static  \
  -D__MINGW__ -DEMULATE_SETENV -DG_OS_WIN32                                       \
  -I/root/RcppCWB/src/cwb/cl \
  -I$MINGW_OUTPUT/include                                      \
  _cwb_compress_rdx.c

RUN i686-w64-mingw32-gcc -c -o _cwb_encode.o -O2 -Wall -static  \
  -D__MINGW__ -DEMULATE_SETENV -DG_OS_WIN32                                       \
  -I/root/RcppCWB/src/cwb/cl \
  -I$MINGW_OUTPUT/include                                      \
  _cwb_encode.c

RUN i686-w64-mingw32-gcc -c -o _cwb_makeall.o -O2 -Wall -static  \
  -D__MINGW__ -DEMULATE_SETENV -DG_OS_WIN32                                       \
  -I/root/RcppCWB/src/cwb/cl                                                   \
  -I$MINGW_OUTPUT/include                                      \
  _cwb_makeall.c
  
RUN i686-w64-mingw32-ar cq libcwb.a _cwb_makeall.o _cwb_huffcode.o _cwb_compress_rdx.o _cwb_encode.o && \
  i686-w64-mingw32-ranlib libcwb.a

RUN cp /root/RcppCWB/src/cwb/utils/libcwb.a /root/libcl/lib/i386/libcwb.a

RUN cd /root/RcppCWB && git clean -f
