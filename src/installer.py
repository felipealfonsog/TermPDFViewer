import os
import platform
import shutil

def install_term_pdf():
    
    source_file = 'src/termpdf.py'

    if platform.system() == 'Darwin':  # macOS
        programs_directory = '/usr/local/bin'
    elif platform.system() == 'Linux':  # Linux
        programs_directory = '/usr/bin'
    else:
        print("Sistema operativo no soportado.")
        return

  
    target_file = os.path.join(programs_directory, 'term-pdf')

    try:
   
        shutil.copy(source_file, programs_directory)

        os.symlink(os.path.join(programs_directory, source_file), target_file)

        os.chmod(target_file, 0o755)

        print("TermPDF Viewer ha sido instalado y se puede ejecutar usando 'term-pdf' en la línea de comandos.")
    except Exception as e:
        print(f"Ha ocurrido un error durante la instalación: {str(e)}")

if __name__ == "__main__":
    install_term_pdf()
