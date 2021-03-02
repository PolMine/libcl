## Static libraries for building RcppCWB on Windows

Following the model of R packages such as [openssl](https://github.com/jeroen/openssl/tree/master/tools), [libcurl](https://github.com/jeroen/curl) or [tesseract](https://github.com/ropensci/tesseract), building [RcppCWB](https://github.com/PolMine/RcppCWB) on Windows relies on pre-compiled static libraries for C code with dependencies that are hard to satisfy on Windows. Offering cross-compiled binaries for download is an approach to ensure the portability of R packages with C code that works nicely. The [rwinlib](https://github.com/rwinlib) collection of repositories is an established place to host static libraries. This repository is the equivalent for building RcppCWB on Windows.

The approach is as follows:

- Executing an R script (file tools/winlibs.R within the package) is triggered by 'src/Makevars.win' when installing the package. 
- The 'winlibs.R' script performs a download of static libraries necessary to compile C/C++ code from a GitHub repository. In the case of RcppCWB, the content of this repository is downloaded as a zip file.
- The 'PKG_KIBS' variable then includes a flag pointing to the static libraries that have been downloaded.

This repository includes three static libraries with CWB code that have been cross-compiled on a Linux machine for 32bit and 64bit R (lib/i386 and lib/x64 directory, respectively). Additional static libraries are included to ensure that relevant dependencies are present:

- [GLib](https://developer.gnome.org/glib/)
- [LibIntl](http://gnuwin32.sourceforge.net/packages/libintl.htm)
- [PCRE](https://www.pcre.org)

The CWB static libraries have been cross-compiled on a Linux machine as follows:

- The first versions included in this repository were prepared using self-written instructions included in a R Markdown file [crosscompilation.Rmd](https://github.com/PolMine/RcppCWB/blob/master/prep/crosscompilation.Rmd) included in the RcppCWB package. 
- New builds are created using a dockerized build enviroment: At this stage, the Dockerfile in this repository creates libcwb.a.

Note that a Ubuntu 14.04 and GCC 4.8 is used for cross-compilation. Newer GCC versions result in additional dependencies (libcrtdll.a) that are hard to meet when compiling RcppCWB on Windows.




