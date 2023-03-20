[2023-03-20] Updated Dockerfile to work with pcre2 on new brach v3.4.33-patched
[2022-01-26] New Dockerfile to cross-compile CWB static libraries in Fedora container with GCC11.2: To learn about warnings/errors thrown by recent compiler.
[2022-01-20] Branch v3.4.33 created for static libraries for CWB v3.4.33. New approach to use CWB Makefiles. 2-step procedure with two Dockerfiles.
[2021-07-05] The ./buildenv/Dockerfile has been reworked entirely and will now yield libcl.a, libcqp.a and libcwb.a (32 and 64 bit)
[2021-07-06] Inserted ARG RCPPCWB_BUILD into ./buildenv/Dockerfile to trigger fresh clone of RcppCWB if the package is updated

