# Initially, this script was written for crosscompiling static CWB libraries
# for UCRT-Windows. This is not necessary because with the new Rtools toolchain,
# CWB code will compile natively on Windows. One important remaining purpose 
# of this dockerfile is to check warnings and errors thrown by a recent 
# compiler when cross-compiling.

FROM fedora:latest


# yum check-update will return 100 if updates are available, but docker
# will see this as an error and stop. This hack will ensure 0 return value.
RUN yum check-update || { rc=$?; [ "$rc" -eq 100 ] && exit 0; exit "$rc"; }
RUN yum -y upgrade

RUN yum install -y wget make unzip xz bzip2 git pkg-config bison flex
# static libraries are available out of the box!
RUN yum install -y mingw64-gcc mingw64-pcre-static mingw64-gettext-static mingw64-expat-static mingw64-libffi-static mingw64-glib2-static

ENV ICONV_VERSION=1.16
ENV PKG_CONFIG_PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig
ENV MINGWDIR=/usr/lib/gcc/x86_64-w64-mingw32/11.2.1/
ENV LIBDIR=/usr/x86_64-w64-mingw32/sys-root/mingw/lib
ENV BINDIR=/usr/x86_64-w64-mingw32/sys-root/mingw/bin
ENV PATH=$PATH:$MINGWDIR/bin/:$BINDIR

# download and (cross-)compile iconv (not available via yum)
WORKDIR /root
RUN wget --no-check-certificate https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$ICONV_VERSION.tar.gz && \
    tar xf libiconv-$ICONV_VERSION.tar.gz &&                                    \
    cd /root/libiconv-$ICONV_VERSION &&                                         \
    CC=x86_64-w64-mingw32-gcc CC_FOR_BUILD=gcc ./configure                     \
      --host=x86_64-w64-mingw32                                                \
      --enable-static                                                           \
      --prefix=$MINGWDIR                          \
      --exec-prefix=$MINGWDIR                     \
      --libdir=$MINGWDIR                      \
      --oldincludedir=$MINGWDIR/include &&        \
    make && make install && make clean
  
# re-setting RCPPCWB_BUILD can be used to trigger re-building docker from here if RcppCWB code has changed  
ARG RCPPCWB_BUILD=0004
RUN cd /root && \
    git clone https://github.com/PolMine/RcppCWB.git && \
    cd /root/RcppCWB && \
    git checkout dev && \
    git pull origin dev

WORKDIR /root/RcppCWB/src/cwb

# adjust cwb/config.mk
RUN sed -i -E "s/^PLATFORM=.*$/PLATFORM=mingw-cross/" config.mk && \
    sed -i -E "s/^SITE=.*$/SITE=windows-release/" config.mk && \
    sed -i -E "s/#\s+CC\s*=\s*.*$/CC=x86_64-w64-mingw32-gcc/" config.mk && \
    sed -i -E 's|#\s+(LIBPCRE_DLL_PATH)\s+=.*$|LIBPCRE_DLL_PATH=$LIBDIR/|g' config.mk && \
    sed -i -E "s|#\s+(LIBGLIB_DLL_PATH)\s+=.*$|LIBGLIB_DLL_PATH=$LIBDIR/|g" config.mk && \
    sed -i -E "s/^CC\s=\sgcc\s*/#CC = gcc/" config.mk

RUN sed -i -E "s/export\s*PKG_CONFIG_PATH=.+MINGW_CROSS_HOME.\/lib\/pkgconfig\s*;//g" definitions.mk && \
    sed -i -E "s/\s+\\$\\(MINGW_CROSS_HOME\\)\/bin\/pcre-config/ pcre-config/g" definitions.mk && \
    sed -i -E "s/^CFLAGS_ALL\s=/CFLAGS_ALL = -DPCRE_STATIC=-1 -DGLIB_STATIC_COMPILATION/g" definitions.mk && \
    sed -i -E "s/^#PCRE_DEFINES/PCRE_DEFINES/" definitions.mk && \
    sed -i -E "s/^#GLIB_DEFINES/GLIB_DEFINES/" definitions.mk && \
    sed -i -E "s/PCRE_DEFINES\s:=\s-DPCRE_STATIC//" definitions.mk

RUN sed -i -E "s/i586-mingw32msvc/x86_64-w64-mingw32/g" ./config/platform/mingw-cross && \
    sed -i -E "s/i586/x86_64/" ./config/platform/mingw-cross && \
    sed -i -E "s/^AR\s=\s(.*?)\scq/AR = \1/" ./config/platform/mingw-cross

RUN sed -i -E "s/(.define\sIPAddress\s267)//" ./cqp/parser.tab.c

RUN sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" Makefile && \
    sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" ./cl/Makefile && \
    sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" ./cqp/Makefile && \
    sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" ./utils/Makefile

# RUN make clean && make depend && make cl && make cqp && make utils
    
# CMD if [ "x86_64" =  "x86_64" ]; then export ARCHDIR=x64; else export ARCHDIR=i386; fi && \
#    cp /root/RcppCWB/src/cwb/cl/libcl.a /libcl/lib/$ARCHDIR/libcl.a &&                         \
#    cp /root/RcppCWB/src/cwb/cqp/libcqp.a /libcl/lib/$ARCHDIR/libcqp.a &&                      \
#    cp /root/RcppCWB/src/cwb/utils/libcwb.a /libcl/lib/$ARCHDIR/libcwb.a

