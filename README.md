# ATEI_test

## ⚠️ Warning: Experimental ⚠️

## Description
This repo name is the acronymum of **"Are They Equal Images"** because this is a study of different ways to know how similar two images are and pros and cons of each method.

* SSIM Index with automatic downsampling, Version 1.0. This is an implementation of the algorithm for calculating the Structural SIMilarity (SSIM) index between two images. More details can be found here: https://github.com/josejuansanchez/ssim

* `imabsdiff` function from `image` package. It returns absolute difference of image or constant to an image. (https://octave.sourceforge.io/image/function/imabsdiff.html)

* `imagesmatch` own function that compares two monochrome bitmap matrices of the same size where 1 = white (background) / 0 = black (foreground) and returns the percentage of coincident foreground bits.



## Table of contents
* [Description](#description)
* [Examples](#examples)
* [Technologies](#technologies)
* [Additional packages needed](#Additional-packages-needed)
* [How to run it](#How-to-run-it)
* [Releases](#releases)
* [To Do](#to-do)
* [Software tree](#software-tree)


## Examples

Some examples of the structures that will be compared, are the following:

![Biznaga](/examples/biznaga.png "Biznaga")
![Caillo](/examples/caillo.png "Caillo")
![Jaramago](/examples/jaramago.png "Jaramago")
![Pececito](/examples/pececito.png "Pececito")
![Rama Frondosa](/examples/ramafrondosa.png "Rama Frondosa")
![Tarajal](/examples/tarajal.png "Tarajal")

## Technologies

It runs in Octave 5.2.0 version and in both Mac OS Catalina version 10.15.5 Beta (19F62f) and UBUNTU 20.0.4

## Additional packages needed

* `image-2.12.0` hosted in Octave Forge (https://octave.sourceforge.io/download.php?package=image-2.12.0.tar.gz).> The Octave-forge Image package provides functions for processing images. The package also provides functions for feature extraction, image statistics, spatial and geometric transformations, morphological operations, linear filtering, and much more.  
* `slf4o` hosted in Octave Forge (https://github.com/apjanke/octave-slf4o/archive/master.zip)

The packages loading instructions are included in `.octaverc` initial lines. So, it means that each time an octave console is opened, the packages will be installed, if they aren't yet, and loaded.

They can be also downloaded directly from Octave Forge and installed manually. 

```
pkg("install", "-forge", "image");
pkg("install", "-forge", "slf4o");
```

## How to run it

From a terminal (in my case it's a -zsh bash) it can execute as following:

```
octave main.m
```

or from an octave terminal:

```
main.m
```

## Releases

Nothing already released.

## To Do 

Work in progress

## Software tree

This tree structure was generated using `md-file-tree` software that generates markdown tree of all the files in a directory, recursively.

More details can be found on GitHub repo: https://github.com/michalbe/md-file-tree. 

- 📂 __ATEI\_test__
   - 📄 [README.md](README.md)
   - 📂 __examples__
     - 📄 [biznaga.png](examples/biznaga.png)
     - 📄 [caillo.png](examples/caillo.png)
     - 📄 [jaramago.png](examples/jaramago.png)
     - 📄 [pececito.png](examples/pececito.png)
     - 📄 [ramafrondosa.png](examples/ramafrondosa.png)
     - 📄 [tarajal.png](examples/tarajal.png)
   - 📂 __src__
     - 📄 [imagesmatch.m](src/imagesmatch.m)
     - 📄 [main.m](src/main.m)
     - 📂 __ssim__
