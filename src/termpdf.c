#include <stdio.h>
#include <poppler/glib.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Uso: %s <archivo.pdf>\n", argv[0]);
        return 1;
    }

    GError *error = NULL;
    PopplerDocument *doc = poppler_document_new_from_file(argv[1], NULL, &error);
    if (!doc) {
        g_error("Error al abrir el archivo: %s\n", error->message);
        g_error_free(error);
        return 1;
    }

    int num_pages = poppler_document_get_n_pages(doc);
    printf("Número de páginas: %d\n", num_pages);

    char input;
    int current_page = 0; // Página actual (0-indexada)

    do {
        PopplerPage *page = poppler_document_get_page(doc, current_page);
        if (!page) {
            g_error("Error al obtener la página %d\n", current_page);
            poppler_document_free(doc);
            return 1;
        }

        double width, height;
        poppler_page_get_size(page, &width, &height);
        printf("\nPage %d (%.2f x %.2f) - (N)ext, (P)revious, (Q)uit: ", current_page + 1, width, height);
        scanf(" %c", &input);

        g_object_unref(page);

        switch (input) {
            case 'n':
            case 'N':
                current_page = (current_page + 1) % num_pages;
                break;
            case 'p':
            case 'P':
                current_page = (current_page - 1 + num_pages) % num_pages;
                break;
            case 'q':
            case 'Q':
                break;
            default:
                printf("Opción no válida, intenta de nuevo.\n");
        }
    } while (input != 'q' && input != 'Q');

    g_object_unref(doc);
    return 0;
}
