import os
import platform
import shutil

def install_term_pdf():
    
    source_file = 'https://github.com/felipealfonsog/TermPDFViewer/raw/main/src/termpdf.py'

    if platform.system() == 'Darwin':  # macOS
        programs_directory = '/usr/local/bin'
    elif platform.system() == 'Linux':  # Linux
        programs_directory = '/usr/bin'
    else:
        print("Not supported.")
        return

  
    target_file = os.path.join(programs_directory, 'term-pdf')

    try:
   
        shutil.copy(source_file, programs_directory)

        os.symlink(os.path.join(programs_directory, source_file), target_file)

        os.chmod(target_file, 0o755)

        print("TermPDF Viewer has been installed, type 'term-pdf' in the terminal.")
    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    install_term_pdf()
