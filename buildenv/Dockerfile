# Intended usage:
# docker build -t cwbcross:latest --build-arg TARGET=x86_64 .
# docker run -it --rm -v ~/Lab/github/libcl:/libcl cwbcross:latest

FROM debian:latest

RUN apt-get update &&                                                              \
    apt-get -y upgrade &&                                                          \
    apt-get install -y wget make mingw-w64 unzip xz-utils subversion git pkg-config bison flex

ENV PCRE_VERSION=8.44
ENV ICONV_VERSION=1.16
ENV EXPAT_VERSION=2.4.1
ENV GETTEXT_VERSION=0.19.8
ENV LIBFFI_VERSION=3.2

WORKDIR /root
RUN wget https://ftp.pcre.org/pub/pcre/pcre-$PCRE_VERSION.tar.gz &&                \
    wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$ICONV_VERSION.tar.gz &&    \
    wget http://downloads.sourceforge.net/expat/expat-$EXPAT_VERSION.tar.gz &&     \
    wget https://ftp.gnu.org/gnu/gettext/gettext-$GETTEXT_VERSION.tar.gz &&        \
    wget ftp://sourceware.org/pub/libffi/libffi-$LIBFFI_VERSION.tar.gz

RUN tar xf pcre-$PCRE_VERSION.tar.gz &&                                            \
    tar xf libiconv-$ICONV_VERSION.tar.gz &&                                       \
    tar xf expat-$EXPAT_VERSION.tar.gz &&                                          \
    tar xf gettext-$GETTEXT_VERSION.tar.gz &&                                      \
    tar xf libffi-$LIBFFI_VERSION.tar.gz 

ARG TARGET=i686 # or x86_64 
  
RUN cd /root/pcre-$PCRE_VERSION &&                                              \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc  ./configure                    \
      --host=$TARGET-w64-mingw32                                                \
      --enable-utf8 --enable-unicode-properties --enable-jit                    \
      --enable-newline-is-any --disable-cpp --enable-static                     \
      --disable-dependency-tracking                                             \
      --prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                          \
      --exec-prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                     \
      --libdir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//lib                      \
      --oldincludedir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//include &&        \
    make && make install && make clean

RUN cd /root/libiconv-$ICONV_VERSION &&                                         \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure                     \
      --host=$TARGET-w64-mingw32                                                \
      --enable-static                                                           \
      --prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                          \
      --exec-prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                     \
      --libdir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//lib                      \
      --oldincludedir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//include &&        \
    make && make install && make clean
    
RUN cd /root/expat-$EXPAT_VERSION &&                                            \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure                     \
      --host=$TARGET-w64-mingw32                                                \
      --prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                          \
      --exec-prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                     \
      --libdir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//lib                      \
      --oldincludedir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//include &&        \
    make && make install && make clean

RUN cd /root/gettext-$GETTEXT_VERSION &&                                        \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure                     \
      --enable-static                                                           \
      --disable-threads                                                         \
      --host=$TARGET-w64-mingw32                                                \
      --prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                          \
      --exec-prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                     \
      --libdir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//lib                      \
      --oldincludedir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//include &&        \
      make && make install && make clean; exit 0

RUN cd /root/libffi-$LIBFFI_VERSION &&                                          \ 
    LIBFFI_CFLAGS=${MINGW_OUTPUT}/include                                       \
    LIBFFI_LIBS=${MINGW_OUTPUT}/include                                         \
    CC=$TARGET-w64-mingw32-gcc CC_FOR_BUILD=gcc                                 \
    ./configure                                                                 \
    --host=$TARGET-w64-mingw32                                                  \
    --prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                            \
    --exec-prefix=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/                       \
    --libdir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//lib                        \
    --oldincludedir=/usr/lib/gcc/$TARGET-mingw32/8.3-win32//include &&          \
    make && make install && make clean


RUN if [ "$TARGET" =  "x86_64" ]; then ARCH=64; else ARCH=32; fi && \
    cd /opt &&                                                                  \
    mkdir glib &&                                                               \
    cd glib &&                                                                  \
    wget  https://download.gnome.org/binaries/win$ARCH/glib/2.26/glib-dev_2.26.0-1_win$ARCH.zip && \ 
    unzip glib-dev_2.26.0-1_win$ARCH.zip && \
    rm glib-dev_2.26.0-1_win$ARCH.zip && \
    sed -i -E "s/^prefix=.*$/prefix=\/opt\/glib/" /opt/glib/lib/pkgconfig/glib-2.0.pc

WORKDIR /root
RUN cd /root && \
    wget https://sourceforge.net/projects/cwb/files/cwb/cwb-3.4-beta/cwb-3.4.22-source.tar.gz && \
    tar xzfv cwb-3.4.22-source.tar.gz
    
WORKDIR /root/cwb-3.4.22
RUN sed -i -E "s/^PLATFORM=.*$/PLATFORM=mingw-cross/" /root/cwb-3.4.22/config.mk && \
    sed -i -E "s/^SITE=.*$/SITE=windows-release/" /root/cwb-3.4.22/config.mk && \
    sed -i -E "s/#\s+CC\s*=\s*.*$/CC=$TARGET-w64-mingw32-gcc/" /root/cwb-3.4.22/config.mk && \
    sed -i -E 's|#\s+(LIBPCRE_DLL_PATH)\s+=.*$|LIBPCRE_DLL_PATH=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/|g' /root/cwb-3.4.22/config.mk && \
    sed -i -E "s|#\s+(LIBGLIB_DLL_PATH)\s+=.*$|LIBGLIB_DLL_PATH=/usr/lib/gcc/$TARGET-mingw32/8.3-win32/|" /root/cwb-3.4.22/config.mk

RUN sed -i -E "s/i586-mingw32msvc/$TARGET-w64-mingw32/g" /root/cwb-3.4.22/config/platform/mingw-cross && \
    sed -i -E "s/i586/$TARGET/" /root/cwb-3.4.22/config/platform/mingw-cross

RUN sed -i -E "s/export\s*PKG_CONFIG_PATH=.+MINGW_CROSS_HOME.\/lib\/pkgconfig\s*;//g" /root/cwb-3.4.22/definitions.mk && \
    sed -i -E "s/\s+\\$\\(MINGW_CROSS_HOME\\)\/bin\/pcre-config/ pcre-config/g" /root/cwb-3.4.22/definitions.mk
    
RUN sed -i -E "s/^all\\:.*PROGRAMS.$/all: libcqp\\.a/g" /root/cwb-3.4.22/cqp/Makefile && \
    printf '\nlibcqp.a: $(OBJS) $(CQI_OBJS)\n\t$(RM) $@\n\t$(AR) $@ $^\n' >> /root/cwb-3.4.22/cqp/Makefile

ENV PKG_CONFIG_PATH=/opt/glib/lib/pkgconfig  
RUN export PKG_CONFIG_PATH=/opt/glib/lib/pkgconfig && \
    export PATH=$PATH:/usr/lib/gcc/$TARGET-mingw32/8.3-win32/bin/ && \
    make clean && make depend && make cqp && make cl


RUN cd /root && \
    git clone https://github.com/PolMine/RcppCWB.git && \
    cd /root/RcppCWB && \
    git checkout dev && \
    git pull origin dev

RUN cd /root/RcppCWB/src/cwb/utils &&                                                                      \
    for FILE in _cwb_huffcode _cwb_compress_rdx _cwb_encode _cwb_makeall; do                               \
      $TARGET-w64-mingw32-gcc -c -o $FILE.o -O2 -Wall -static                                              \
        -D__MINGW__ -DEMULATE_SETENV -DG_OS_WIN32                                                          \
        -I/root/RcppCWB/src/cwb/cl -I/usr/share/mingw-w64/include -I$MINGW_OUTPUT/include                  \
        $FILE.c;                                                                                           \
    done &&                                                                                                \
    $TARGET-w64-mingw32-ar cq libcwb.a _cwb_makeall.o _cwb_huffcode.o _cwb_compress_rdx.o _cwb_encode.o && \
    $TARGET-w64-mingw32-ranlib libcwb.a
    
RUN cd /root && \
    git clone https://github.com/PolMine/libcl.git && \
    cd /root/libcl && \
    git checkout dev

CMD if [ "$TARGET" =  "x86_64" ]; then export ARCHDIR=x64; else export ARCHDIR=i386; fi && \
    cp /root/cwb-3.4.22/cl/libcl.a /libcl/lib/$ARCHDIR/libcl.a &&                         \
    cp /root/cwb-3.4.22/cqp/libcqp.a /libcl/lib/$ARCHDIR/libcqp.a &&                      \
    cp /root/RcppCWB/src/cwb/utils/libcwb.a /libcl/lib/$ARCHDIR/libcwb.a

