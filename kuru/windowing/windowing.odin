package windowing

import d "../drawing"

import rl "vendor:raylib"

//window: rl.IsWindowFocused

// initializes the current window
create_window :: proc(name:cstring, w,h: i32) -> bool {
    /*sdl.CreateWindowAndRenderer(w,h, sdl.WINDOW_SHOWN, &window, &d.rend)
    sdl.SetWindowTitle(window, name)
    return window != nil && d.rend != nil*/

    rl.InitWindow(w,h,name)

    return true
}

// destroys the current window
destroy_window :: proc() {
    //sdl.DestroyWindow(window)
}