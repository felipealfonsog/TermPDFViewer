import os
import platform
import shutil

def install_term_pdf():
    # Determina el nombre del archivo de origen (termpdf.py)
    source_file = 'termpdf.py'

    # Determina la ubicación del directorio de programas en función del sistema operativo
    if platform.system() == 'Darwin':  # macOS
        programs_directory = '/usr/local/bin'
    elif platform.system() == 'Linux':  # Linux
        programs_directory = '/usr/bin'
    else:
        print("Sistema operativo no soportado.")
        return

    # Ruta completa al archivo de destino (el enlace simbólico)
    target_file = os.path.join(programs_directory, 'term-pdf')

    try:
        # Copia termpdf.py al directorio de programas
        shutil.copy(source_file, programs_directory)

        # Crea un enlace simbólico al archivo termpdf.py
        os.symlink(os.path.join(programs_directory, source_file), target_file)

        # Dale permisos de ejecución al archivo termpdf.py
        os.chmod(target_file, 0o755)

        print("TermPDF Viewer ha sido instalado y se puede ejecutar usando 'term-pdf' en la línea de comandos.")
    except Exception as e:
        print(f"Ha ocurrido un error durante la instalación: {str(e)}")

if __name__ == "__main__":
    install_term_pdf()
