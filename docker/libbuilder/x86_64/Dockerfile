FROM cwbcross:x86_64

ARG TARGET=x86_64
ARG MINGWDIR=/usr/lib/gcc/x86_64-w64-mingw32/4.8/
WORKDIR /root/RcppCWB/src/cwb

ARG RUN=001

RUN cd /root/RcppCWB && \
    git checkout dev && \
    git pull origin dev

RUN sed -i -E "s/^PLATFORM=.*$/PLATFORM=mingw-cross/" config.mk && \
    sed -i -E "s/^SITE=.*$/SITE=windows-release/" config.mk && \
    sed -i -E "s/#\s+CC\s*=\s*.*$/CC=$TARGET-w64-mingw32-gcc/" config.mk && \
    sed -i -E 's|#\s+(LIBPCRE_DLL_PATH)\s+=.*$|LIBPCRE_DLL_PATH=$MINGWDIR/|g' config.mk && \
    sed -i -E "s|#\s+(LIBGLIB_DLL_PATH)\s+=.*$|LIBGLIB_DLL_PATH=$MINGWDIR/|g" config.mk

RUN sed -i -E "s/i586-mingw32msvc/$TARGET-w64-mingw32/g" /root/RcppCWB/src/cwb/config/platform/mingw-cross && \
    sed -i -E "s/i586/$TARGET/" /root/RcppCWB/src/cwb/config/platform/mingw-cross && \
    sed -i -E "s/^AR\s=\s(.*?)\scq/AR = \1/" /root/RcppCWB/src/cwb/config/platform/mingw-cross

RUN sed -i -E "s/export\s*PKG_CONFIG_PATH=.+MINGW_CROSS_HOME.\/lib\/pkgconfig\s*;//g" definitions.mk && \
    sed -i -E "s/\s+\\$\\(MINGW_CROSS_HOME\\)\/bin\/pcre-config/ pcre-config/g" definitions.mk && \
    sed -i -E "s/^CFLAGS_ALL\s=/CFLAGS_ALL = -DPCRE_STATIC=-1 -DGLIB_STATIC_COMPILATION/g" definitions.mk
    
RUN sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" /root/RcppCWB/src/cwb/Makefile && \
    sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" /root/RcppCWB/src/cwb/cl/Makefile && \
    sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" /root/RcppCWB/src/cwb/cqp/Makefile && \
    sed -i -E "s/^TOP\s=\s\\$\\(R_PACKAGE_SOURCE\\)/TOP = \/root\/RcppCWB\/src\/cwb/g" /root/RcppCWB/src/cwb/utils/Makefile

RUN sed -i -E "s/(.define\sIPAddress\s267)//" /root/RcppCWB/src/cwb/cqp/parser.tab.c

RUN cd /root/RcppCWB/src/cwb && \
    export PKG_CONFIG_PATH=/opt/glib/lib/pkgconfig && \
    export PATH=$PATH:$MINGWDIR/bin/ && \
    make clean && make depend && make cl
    
CMD if [ "$TARGET" =  "x86_64" ]; then export ARCHDIR=x64; else export ARCHDIR=i386; fi && \
    cp /root/RcppCWB/src/cwb/cl/libcl.a /libcl/lib/$ARCHDIR/libcl.a &&                         \
    cp /root/RcppCWB/src/cwb/cqp/libcqp.a /libcl/lib/$ARCHDIR/libcqp.a &&                      \
    cp /root/RcppCWB/src/cwb/utils/libcwb.a /libcl/lib/$ARCHDIR/libcwb.a

