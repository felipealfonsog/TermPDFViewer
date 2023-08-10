## 📄 Terminal PDF Viewer (Experimental) 🚀

TermPDF Viewer is a Python program that enables users to view and navigate PDF files directly within the terminal.

"TermPDF Viewer" is an open-source PDF file viewer designed to run in the terminal on Linux and macOS. It enables users to navigate and explore PDF files directly from the command line, providing an interactive and lightweight experience. Powered by the "PyMuPDF" library, this project offers high-quality rendering of PDF pages, allowing users to easily move forward and backward between pages. "TermPDF Viewer" is a versatile and practical tool for those who want to access PDF documents without the need for a heavy graphical viewer, harnessing the powerful and efficient environment of the terminal.

TermPDF Viewer is a command-line utility built in Python that empowers users to effortlessly view and interact with PDF files from their terminal environment. 

The program offers a menu-driven interface allowing users to scan and list PDF files in a directory, choose a file to view by entering its corresponding number, and then navigate through its pages. Additionally, the program offers convenient options to move forward, go back, or quit the PDF viewing session, ensuring a seamless and efficient document viewing experience directly within the terminal.

#

This is an experimental project aimed at bringing a PDF viewer or reader to the terminal environment. The Terminal PDF Viewer leverages the capabilities of the MuPDF library to enable users to view PDF documents directly within the terminal.

#


![Version](https://img.shields.io/github/release/felipealfonsog/TermPDFViewer.svg?style=flat&color=blue)
![Main Language](https://img.shields.io/github/languages/top/felipealfonsog/TermPDFViewer.svg?style=flat&color=blue)
[![Open Source? Yes!](https://badgen.net/badge/Open%20Source%20%3F/Yes%21/blue?icon=github)](https://github.com/Naereen/badges/)

[![Experimental Project](https://img.shields.io/badge/Project-Type%3A%20Experimental-blueviolet)](#)

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
<!--
[![GPL license](https://img.shields.io/badge/License-GPL-blue.svg)](http://perso.crans.org/besson/LICENSE.html)
-->

[![Vim](https://img.shields.io/badge/--019733?logo=vim)](https://www.vim.org/)
[![Visual Studio Code](https://img.shields.io/badge/--007ACC?logo=visual%20studio%20code&logoColor=ffffff)](https://code.visualstudio.com/)

#### Screenshots

![Screenshot of the application interface](images/linux/sshot-termpdf-1.jpg)
<!-- 
**Arch Linux** 

![Screenshot of the application interface](images/linux/sshot-termpdf-1.jpg)

**macOS** 

![Screenshot of the application interface](images/mac/sshot-termpdf-1.png)
-->

#### Prerequisites:

* Python 3.x: The program is written in Python and requires a Python 3.x interpreter to run.
* PyMuPDF: A Python binding for the MuPDF library, used to handle PDF file rendering and interaction.
*   You can install it using pip: pip install PyMuPDF
*   Make sure to include the appropriate model or adapt it for your needs.

#### How to run the TermPDF Viewer (Installation):

* Installar with AUR in Arch
  yay -S term-pdf

* Install with bash
  ./installer.sh

* Run the TermPDF Viewer:
  python termpdf.py

* The TermPDF Viewer will start, allowing you to:
* Scan for PDF files in the current directory.
* Select a PDF file to view by entering its number.
* View the PDF with options to move back, forward, or return to the main menu.
* Quit and return to the main menu.
* To exit the TermPDF Viewer, use 'q' in the main menu.


#### 🌟 Features

- View PDF documents within the terminal.
- Navigate through pages using keyboard commands.
- Experimental project with limited functionality.
- Built using the MuPDF library for rendering PDF content.

#### NOTES FOR THE AUTHOR

#### Python (Working fine)

pip install PyMuPDF

python3 termpdf.py

> Generating the executable

Recommended:

brew install pyinstaller

in Arch:
yay -S pyinstaller


pyinstaller --onefile termpdf.py

pyinstaller --onefile --distpath ../ termpdf.py




#### Libs - experiments in C 

brew install mupd

brew install freeglut

brew install glfw

brew install sdl2

#### Libs - experiments in C++:

brew install poppler
brew install podofo



then, any of these: 

```
gcc -o termpdf termpdf.c -lmupdf -lmupdf-third
```

```
gcc -o termpdf termpdf.c -I/usr/local/include/mupdf -L/usr/local/lib -lmupdf -lmupdf-third
```

```
gcc -o termpdf termpdf.c -I/usr/local/include -L/usr/local/lib -lmupdf -lmupdf-third -lm
```

gcc -o termpdf termpdf.c -I/usr/local/include -L/usr/local/lib -lmupdf -lmupdf-third -lm -lglut -lGL


#

Or: 

```
brew install pkg-config
```

Descargar el código fuente de MuPDF desde GitHub:

```
wget https://github.com/ArtifexSoftware/mupdf/archive/refs/tags/1.22.2.tar.gz
tar -xzvf 1.22.2.tar.gz
cd mupdf-1.22.2
```

Compilar la biblioteca MuPDF:

```
make HAVE_X11=no
```

Copiar los archivos de la biblioteca en tu proyecto (por ejemplo, en una carpeta llamada "mupdf") y regresar al directorio del proyecto:

```
mkdir ../mupdf
cp build/release/libmupdf.a ../mupdf
cp thirdparty/libmupdf-third.a ../mupdf
cp -r include ../mupdf
cd ..
```

Finalmente, compila tu programa utilizando los archivos de la biblioteca MuPDF estáticamente:
```
gcc -o termpdf termpdf.c mupdf/libmupdf.a mupdf/libmupdf-third.a -I mupdf/include -lm -ldl
````

#### En macOS la ruta es:

```
find /usr/local/include -name "mupdf*"
````

> /usr/local/include/mupdf


```
find /usr/local/lib -name "libmupdf*"
```
> /usr/local/lib/libmupdf-third.dylib
> /usr/local/lib/libmupdf.dylib


#### 📋 Requirements

- MuPDF library installed (libmupdf and libmupdf-third).
- Terminal environment.

#### 📝Important

This project is still in its experimental stage and may have limitations in terms of features and compatibility. Use at your own discretion.

#### 🤝 Support and Contributions

If you find this project helpful and would like to support its development, there are several ways you can contribute:

- **Code Contributions**: If you're a developer, you can contribute by submitting pull requests with bug fixes, new features, or improvements. Feel free to fork the project and create your own branch to work on.
- **Bug Reports and Feedback**: If you encounter any issues or have suggestions for improvement, please open an issue on the project's GitHub repository. Your feedback is valuable in making the project better.
- **Documentation**: Improving the documentation is always appreciated. If you find any gaps or have suggestions to enhance the project's documentation, please let me know.

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-%E2%98%95-FFDD00?style=flat-square&logo=buy-me-a-coffee&logoColor=black)](https://www.buymeacoffee.com/felipealfonsog)
[![PayPal](https://img.shields.io/badge/Donate%20with-PayPal-00457C?style=flat-square&logo=paypal&logoColor=white)](https://www.paypal.com/felipealfonsog)
[![GitHub Sponsors](https://img.shields.io/badge/Sponsor%20me%20on-GitHub-%23EA4AAA?style=flat-square&logo=github-sponsors&logoColor=white)](https://github.com/sponsors/felipealfonsog)

Your support and contributions are greatly appreciated! Thank you for your help in making this project better.

#### 📄 License

This project is licensed under the [MIT License](LICENSE).