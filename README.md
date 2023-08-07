# TermPDFViewer
"TermPDF Viewer" is an open-source PDF file viewer designed to run in the terminal on Linux and macOS. It enables users to navigate and explore PDF files directly from the command line, providing an interactive and lightweight experience. Powered by the "MuPDF" library, this project offers high-quality rendering of PDF pages, allowing users to easily move forward and backward between pages. "TermPDF Viewer" is a versatile and practical tool for those who want to access PDF documents without the need for a heavy graphical viewer, harnessing the powerful and efficient environment of the terminal.


#### Features
- Open PDF files in the terminal
- Open PDF files in the browser
- Open PDF files in the PDF viewer
- Open PDF files in the PDF viewer in a separate window
- Open PDF files in the PD

#### Installation

brew install mupd

then, any of these: 

gcc -o termpdf termpdf.c -lmupdf -lmupdf-third

gcc -o termpdf termpdf.c -I/usr/local/include/mupdf -L/usr/local/lib -lmupdf -lmupdf-third

gcc -o termpdf termpdf.c -I/usr/local/include -L/usr/local/lib -lmupdf -lmupdf-third -lm



Or: 

brew install pkg-config

Descargar el código fuente de MuPDF desde GitHub:

wget https://github.com/ArtifexSoftware/mupdf/archive/refs/tags/1.22.2.tar.gz
tar -xzvf 1.22.2.tar.gz
cd mupdf-1.22.2


Compilar la biblioteca MuPDF:

make HAVE_X11=no


Copiar los archivos de la biblioteca en tu proyecto (por ejemplo, en una carpeta llamada "mupdf") y regresar al directorio del proyecto:

mkdir ../mupdf
cp build/release/libmupdf.a ../mupdf
cp thirdparty/libmupdf-third.a ../mupdf
cp -r include ../mupdf
cd ..


Finalmente, compila tu programa utilizando los archivos de la biblioteca MuPDF estáticamente:

gcc -o termpdf termpdf.c mupdf/libmupdf.a mupdf/libmupdf-third.a -I mupdf/include -lm -ldl

En macOS la ruta es:
=====================

find /usr/local/include -name "mupdf*"
/usr/local/include/mupdf

find /usr/local/lib -name "libmupdf*"
/usr/local/lib/libmupdf-third.dylib
/usr/local/lib/libmupdf.dylib

