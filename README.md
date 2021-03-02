## Static libraries for building RcppCWB on Windows

Following the model of R packages such as [openssl](https://github.com/jeroen/openssl/tree/master/tools), [libcurl](https://github.com/jeroen/curl) or [tesseract](https://github.com/ropensci/tesseract), building [RcppCWB](https://github.com/PolMine/RcppCWB) on Windows relies on pre-compiled static libraries for C code with dependencies that are hard to satisfy on Windows. Offering cross-compiled binaries for download is an approach to make R packages that include extensive C code with extensive dependencies portable to Windows. This repository is the equivalent for RcppCWB to the repositories of the [rwinlib](https://github.com/rwinlib) collection.

Essentially the approach is as follows:

- An R script (tools/winlibs.R) is called by the 'src/Makevars.win' script. 
- The 'winlibs.R' script performs a download of static libraries necessary to compile C/C++ code from a GitHub repository. In the case of RcppCWB, the content of this repository is downloaded as a zip file.
- The 'PKG_KIBS' variable then includes a flag that leads to the static libraries that have been downloaded.

This repository includes three static libraries with CWB code that have been cross-compiled on a Linux machine (see below) for 32bit and 64bit R (i386 and x64 directory, respectively). Additional static libraries are included to ensure that these libraries are present on Windows:

- [GLib](https://developer.gnome.org/glib/)
- [LibIntl](http://gnuwin32.sourceforge.net/packages/libintl.htm)
- [PCRE](https://www.pcre.org)

The CWB static libraries have been cross-compiled on a Linux machine. The first versions included in this repository were prepared using self-written instructions included in a R Markdown file [crosscompilation.Rmd](https://github.com/PolMine/RcppCWB/blob/master/prep/crosscompilation.Rmd) included in the RcppCWB package. We then move to using a dockerized build enviroment. The Dockerfile in this repository results in the libcwb.a file at this stage.

Note that a Ubuntu 14.04 and GCC 4.8 is used for cross-compilation because late GCC versions result in additional dependencies (libcrtdll.a) that are hard to meet when compiling RcppCWB on Windows.




