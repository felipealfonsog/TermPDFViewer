#include <stdio.h>
#include <SDL2/SDL.h>
#include <mupdf/fitz.h>

#define INITIAL_ZOOM 1.0

void renderPage(SDL_Renderer *renderer, fz_page *page, float zoom) {
    fz_matrix transform;
    fz_rect bounds;
    fz_device *dev;

    // Calculate bounds and initialize a rendering device
    fz_bound_page(fz_page_bound_context(page), page, &bounds);
    dev = fz_new_draw_device(fz_page_bound_context(page), &transform, NULL);
    fz_run_page(fz_page_bound_context(page), page, dev, &transform, NULL);

    // Create a display list and draw the page contents onto it
    fz_display_list *list = fz_device_list(dev);
    fz_matrix ctm = fz_scale(zoom, -zoom);
    fz_pixmap *pix = fz_new_pixmap_with_bbox(fz_page_bound_context(page), fz_device_colorspace(dev), &bounds);
    fz_device *draw_dev = fz_new_draw_device(fz_page_bound_context(page), &ctm, pix);

    fz_run_display_list(fz_page_bound_context(page), list, draw_dev, fz_identity, NULL);
    fz_free_display_list(fz_page_bound_context(page), list);
    fz_free_device(dev);
    fz_free_device(draw_dev);

    // Create a texture from the pixmap and render it on the window
    SDL_Texture *texture = SDL_CreateTextureFromSurface(renderer, SDL_CreateRGBSurfaceFrom(
        pix->samples, pix->w, pix->h, 8 * 4, pix->stride,
        0x000000FF, 0x0000FF00, 0x00FF0000, 0xFF000000
    ));

    SDL_Rect destRect = { 0, 0, pix->w, pix->h };
    SDL_RenderCopy(renderer, texture, NULL, &destRect);

    SDL_DestroyTexture(texture);
    fz_drop_pixmap(fz_page_bound_context(page), pix);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input.pdf>\n", argv[0]);
        return 1;
    }

    // Initialize MuPDF context and open the PDF document
    fz_context *ctx = fz_new_context(NULL, NULL, FZ_STORE_UNLIMITED);
    if (!ctx) {
        fprintf(stderr, "Failed to create MuPDF context\n");
        return 1;
    }

    fz_document *doc = fz_open_document(ctx, argv[1]);
    if (!doc) {
        fprintf(stderr, "Failed to open document: %s\n", argv[1]);
        fz_free_context(ctx);
        return 1;
    }

    int num_pages = fz_count_pages(ctx, doc);
    int current_page = 0;
    float zoom = INITIAL_ZOOM;

    // Initialize SDL and create a window and renderer
    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window *window = SDL_CreateWindow("PDF Viewer", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 800, 600, 0);
    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

    SDL_Event e;
    int quit = 0;

    // Main loop for handling events and rendering pages
    while (!quit) {
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) {
                quit = 1;
            } else if (e.type == SDL_KEYDOWN) {
                if (e.key.keysym.sym == SDLK_LEFT && current_page > 0) {
                    current_page--;
                } else if (e.key.keysym.sym == SDLK_RIGHT && current_page < num_pages - 1) {
                    current_page++;
                } else if (e.key.keysym.sym == SDLK_PLUS || e.key.keysym.sym == SDLK_KP_PLUS) {
                    zoom += 0.1;
                } else if (e.key.keysym.sym == SDLK_MINUS || e.key.keysym.sym == SDLK_KP_MINUS) {
                    if (zoom > 0.1) {
                        zoom -= 0.1;
                    }
                }
            }
        }

        // Clear the renderer and render the current page
        SDL_RenderClear(renderer);

        fz_page *page = fz_load_page(ctx, doc, current_page);
        renderPage(renderer, page, zoom);
        fz_free_page(ctx, page);

        SDL_RenderPresent(renderer);
    }

    // Clean up and exit
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    fz_close_document(doc);
    fz_free_context(ctx);

    return 0;
}
