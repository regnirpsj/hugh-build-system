====================================================================
Hull University Graphics Helper (HUGH) Build System -- Dummy Project
====================================================================

:Author: Jan P Springer <regnirpsj@gmail.com>

.. contents::

.. _CMake:                          http://www.cmake.org/
.. _Department of Computer Science: http://www2.hull.ac.uk/science/computer_science.aspx
.. _The University of Hull:         http://www.hull.ac.uk/

Introduction
============

``hugh-build-system`` is an (experimental) infrastructure project to support the various graphics modules at the `Department of Computer Science`_, `The University of Hull`_. This sub-project shows the (preferred) setup of external projects depending on ``hugh-build-system``

Building and Installation
=========================

Quick Setup
-----------

Linux::

 $> cd <src-dir-created-by-git-clone>
 $> mkdir build && cd build
 $> cmake -DCMAKE_INSTALL_PREFIX=../install ..
 $> cmake --build . --target test_all
 $> cmake --build . --target install

Windows x86::

 $> cd <src-dir-created-by-git-clone>
 $> mkdir build.x86 && cd build.x86
 $> cmake -DCMAKE_INSTALL_PREFIX=../install.x86 ..
 $> cmake --build . --target test_all -- /nologo /v:q
 $> cmake --build . --target install -- /nologo /v:q

 Options after `--` apply to `MSBuild.exe`.
 
Windows x64::

 $> cd <src-dir-created-by-git-clone>
 $> mkdir build.x64 && cd build.x64
 $> cmake -G "Visual Studio 12 2013 Win64" -DCMAKE_INSTALL_PREFIX=../install.x64 ..
 $> cmake --build . --target test_all -- /nologo /v:q
 $> cmake --build . --target install -- /nologo /v:q

 Replace the `Visual Studio 12 2013 Win64` generator version as needed.
 
Overview
--------

[to be written]

Requirements
------------

Mandatory:

* `CMake`_

Optional:

* none so far

Acknowledgements
================

[to be written]

License
=======

Copyright 2016 `The University of Hull`_. Distributed under the LGPLv2.1 (see the accompanying file LICENSE).
