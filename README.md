## Static libraries for building RcppCWB on Windows

Following the model of R packages such as [openssl](https://github.com/jeroen/openssl/tree/master/tools), [libcurl](https://github.com/jeroen/curl) or [tesseract](https://github.com/ropensci/tesseract), building [RcppCWB](https://github.com/PolMine/RcppCWB) on Windows relies on pre-compiled static libraries for C code with dependencies that are hard to satisfy on Windows. Offering cross-compiled binaries for download is an approach to ensure the portability of R packages with C code that works nicely. The [rwinlib](https://github.com/rwinlib) collection of repositories is an established place to host static libraries. This repository is the equivalent for building RcppCWB on Windows.

The approach is as follows:

- Executing an R script (file tools/winlibs.R within the package) is triggered by 'src/Makevars.win' when installing the package. 
- The 'winlibs.R' script performs a download of static libraries necessary to compile C/C++ code from a GitHub repository. In the case of RcppCWB, the content of this repository is downloaded as a zip file.
- The 'PKG_LIBS' variable then includes a flag pointing to the static libraries that have been downloaded.

This repository includes three static libraries with CWB code that have been cross-compiled on a Linux machine for 32bit and 64bit R (lib/i386 and lib/x64 directory, respectively). Additional static libraries are included to ensure that relevant dependencies are present:

- [GLib](https://developer.gnome.org/glib/)
- [LibIntl](http://gnuwin32.sourceforge.net/packages/libintl.htm)
- [PCRE](https://www.pcre.org)

The CWB static libraries have been cross-compiled using Docker containers. The respective Dockerfiles are part of this repository.

- The Dockerfile in docker/gcc4.8 uses a Ubuntu 14.04 Docker container and GCC 4.8 is used for cross-compilation. This is historically the approach that runs smoothly, with limited side-effects. A bash file will run through the process and yield both 32 and 64 bit versions of the static libraries. These are copied into the repository.
- The Dockerfile in docker/gcc11.2 can be used to check errors and warnings that result from the most recent version of GCC.

A note on branches:

- Starting with RcppCWB v0.4.4.9003, static libraries are retrieved from the branch named after the version number of the CWB version to build.
- The branch gcc11 is there for historic reasons, because it is the branch retrieved by the CRAN release of RcppCWB.
- The main branch of this repository is not actively used.



