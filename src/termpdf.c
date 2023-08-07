#include <stdio.h>
#include <stdlib.h>
#include <mupdf/fitz.h>

void render_page(fz_context *ctx, fz_document *doc, int page_num, float zoom) {
    fz_page *page = fz_load_page(ctx, doc, page_num);
    if (!page) {
        printf("Failed to load page %d.\n", page_num + 1);
        return;
    }

    fz_rect bounds;
    fz_bound_page(ctx, page, &bounds);
    fz_matrix transform = fz_scale(zoom, zoom);

    fz_device *dev = fz_new_device(ctx, &bounds);
    fz_run_page(ctx, page, dev, &transform, NULL);
    fz_free_device(dev);
    fz_drop_page(ctx, page);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <filename.pdf>\n", argv[0]);
        return 1;
    }

    fz_context *ctx = fz_new_context(NULL, NULL, FZ_STORE_UNLIMITED);
    if (!ctx) {
        printf("Error creating MuPDF context.\n");
        return 1;
    }

    fz_document *doc = fz_open_document(ctx, argv[1]);
    if (!doc) {
        printf("Error opening the PDF file: %s\n", argv[1]);
        fz_free_context(ctx);
        return 1;
    }

    int page_count = fz_count_pages(ctx, doc);
    if (page_count <= 0) {
        printf("No pages found in the PDF.\n");
        fz_close_document(doc);
        fz_free_context(ctx);
        return 1;
    }

    int current_page = 0;
    float zoom = 1.0;
    char input;

    printf("PDF Viewer: %s\n", argv[1]);

    while (1) {
        render_page(ctx, doc, current_page, zoom);

        printf("\nPage %d/%d - Zoom: %.2f - (N)ext, (P)revious, (Z)oom, (G)o to page, (Q)uit: ",
               current_page + 1, page_count, zoom);
        scanf(" %c", &input);

        if (input == 'n' || input == 'N') {
            current_page++;
            if (current_page >= page_count) {
                current_page = page_count - 1;
            }
        } else if (input == 'p' || input == 'P') {
            current_page--;
            if (current_page < 0) {
                current_page = 0;
            }
        } else if (input == 'z' || input == 'Z') {
            printf("Enter zoom factor (e.g. 1.5): ");
            scanf("%f", &zoom);
        } else if (input == 'g' || input == 'G') {
            printf("Enter page number (1-%d): ", page_count);
            int new_page;
            scanf("%d", &new_page);
            if (new_page >= 1 && new_page <= page_count) {
                current_page = new_page - 1;
            }
        } else if (input == 'q' || input == 'Q') {
            break;
        }
    }

    fz_close_document(doc);
    fz_free_context(ctx);

    return 0;
}
