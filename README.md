# snapcraft-package
Snapcraft package for Banana Accounting

## Concept for installation
### Include in the package all binaries and library
The snapcraft package includes the compiled executable file and all the necessary libraries (QT and others). 
Theoretically QT libraries are binary compatible, but due to bugs in QT, Banana Accounting has been optimized to works with a specific library version. Currently it is Qt 5.12.
Therefore we do not use the QT libraries already installed on the computer, but we provide a specific one. 
This approach takes more  space, but the software is stable.

### Files for installation 
All the file that are used for installation are includer in the bananaexpm9.tgz file.
- Banana Accounting 9 Experimental version, with Qt 5.12
- https://www.banana.ch/en/bananaexpm9_en
- https://www.banana.ch/accounting/files/banana9/expm/bananaexpm9.tgz

### Decisions to be made 
- We use a libpng library that can be older then the libpng library available on the OS.
- **Evaluate if it is better to use the "install-banana.sh" or include some commands directly in the snapcraft yalm**
- **Evaluate if it is better to use the "start_bananaExperimental9.sh" or if it better to create a different one or include some commands directly in the snapcraft yalm.**
- Add description and metadata for images and others. 
- **New** the snap will be build based on the tgz file. The tgz file is build for the appimage, with the script  	"create_appImage.sh". In case that for creating a snap it is suitable to change the tgz or the structure, suggest possible changes and modify also the file "create_appImage.sh". New tgz file  should obviously maintain compatibility installing on all linux systems.  

### Todos
1. Create a snapcraft yalm configuration file for Banana Accounting 9 using QT (DONE). Warning  when creating the snap file related to the library Qt Web Engine. The library is not included. The HTML Editor does not work.
2. Verify inclusion for libssl e libcrypto
3. Verify that functioning and solve problems.
  Test under 16.04 and there was problem with the registring the banana accounting file extension ".ac2" MIME TYPE

## Tests 
1. Snap package creation should work.
2. Software installation should works on the reference Distribution Ubuntu 18.10.
3. Software installation should works on all defined Distributions.

### Snap Package creation
Verify that the creation of the snap package works, without problems.

### Software Installation and Software running
Use the snappackage to install the software. Reference Distribution Ubuntu 18.04 LTS.
* [] Installation
* [] Desktop integration
  * [] The program appears below the list of applications
  * [] The icon is correct
  * [] Ac2 and Sba extension is registered
* [] Create new file
* [] Save file (choose user directory)
* [] Open files with double-click
* [] Print preview
* [] Insert license key
* [] HTLM Editor
     - See [Banana Editor Documenatation](https://www.banana.ch/doc9/en/node/8353)
     - Use file  [test/company_htmltest.ac2](https://github.com/BananaInternal/snapcraft-package/raw/master/test/company_htmltest.ac2)

### Different Linux Distribution tests
Verify that the snapcraft package allow to install the software on different Distributions. 
  * [] Ubuntu 18.04 LTS. Reference Distribution. If it works on this, then tests on the other one.
  * [] Ubuntu 18.10.
  * [] Ubuntu 16.04 LTS
  * [] Fedora 29
  * [] SUSE (latest version)

## Info request
- How is the software version determined? Ideally there would be a command that could be run by the build script to gather the version (e.g. "banana --version" to print out 1.24 or something like that)
  - banana9 -cmd=version
  - see https://www.banana.ch/doc9/en/node/4325
- Are there any known errors or warnings in the software currently (popups, stdout output) that I should be aware of?
- Snaps work a bit differently than regular Linux software and are intended to read/write to specific directories, are there any directories Banana uses which will need to be reconfigured? YES for license code see above.
- Should I assume that the snap just needs to be created from the tar archive? YES 
(There are benefits to building the source code with snapcraft so you can also manage the dependencies that way but it is also more complicated to setup)

