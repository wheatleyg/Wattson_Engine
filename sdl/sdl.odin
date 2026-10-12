package sdl

//credits to https://github.com/odinphillips/HelloWorld_SDL3/blob/main/main.cpp
// i translated all C++ to odin

import "core:math"
import SDL "vendor:sdl3"


window: ^SDL.Window = nil
renderer: ^SDL.Renderer = nil

Init :: proc() -> int {
    ret := SDL.Init(SDL.INIT_VIDEO)
    if ret != true {
        SDL.Log("SDL.Init() Error: %s", SDL.GetError())
        return -1
    }
    window = SDL.CreateWindow("Hellope, SDL3!", 640, 480, SDL.WINDOW_RESIZABLE)

    if window == nil {
        SDL.Log("SDL.CreateWindow() Error: %s", SDL.GetError())
        return -1
    }
    renderer = SDL.CreateRenderer(window, nil)

    if renderer == nil {
        SDL.Log("SDL.CreateRenderer() Error: %s", SDL.GetError())
    }
    return 0
}

Term :: proc() {
    SDL.DestroyRenderer(renderer)
    SDL.DestroyWindow(window)
    SDL.Quit()
}

Start :: proc() {
    event : SDL.Event
    running : bool = true
    mouseRect : SDL.FRect
    mouseRect.x ,  mouseRect.y = -1000, -1000
    mouseRect.w, mouseRect.h = 50, 50

    for (running) {
        for (SDL.PollEvent(&event)) {
            #partial switch (event.type) {
                case SDL.EventType.QUIT:
                    running = false
                    break
                case SDL.EventType.KEY_DOWN:
                    if (event.key.scancode == SDL.Scancode.ESCAPE) {
                        running = false
                    }
                case SDL.EventType.MOUSE_MOTION: 
                    mouseRect.x = event.motion.x - (mouseRect.w / 2.0)
                    mouseRect.y = event.motion.y - (mouseRect.h / 2.0)
                    break
            

            }

        }

        sinewave: f32 = SDL.sinf((((f32)(SDL.GetTicks() % 3000)) / 3000.0) * 2.0 * math.PI)

        r : u8 = (u8)(sinewave * 127.0) + 127

        SDL.SetRenderDrawColor(renderer, r, 0, 0, 255)

        SDL.RenderClear(renderer)
        
        SDL.SetRenderDrawColor(renderer,255,255,255,255)

        SDL.RenderFillRect(renderer, &mouseRect)

        SDL.RenderPresent(renderer)
    }
}

init :: proc () -> int {
    ret: int = Init()
    if (ret == 0) {
        Start() 

        
    }
    Term()
    return ret
}