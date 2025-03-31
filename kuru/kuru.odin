package kuru

import "core:fmt"

import "misc"
import d "drawing"
import w "windowing"
import inp "input"

import rl "vendor:raylib"

running: bool

// basic setup for everything
master :: proc(title:cstring, width,height:i32, start,update,render,close: proc()) {
    init(title,width,height)

    rl.SetExitKey(rl.KeyboardKey.KEY_NULL)

    start()

    //running = true
    //e: sdl.Event
    for !rl.WindowShouldClose() {
        /*inp.mouse_scroll_delta_x = 0
        inp.mouse_scroll_delta_y = 0

        for sdl.PollEvent(&e) {
            if e.type == sdl.EventType.QUIT {
                stop()
                continue
            }

            inp.poll_event(e)
        }*/

        inp.poll_event()

        update()
        rl.BeginDrawing()
        render()
        rl.EndDrawing()

        //sdl.RenderPresent(d.rend)
    }

    close()
    cleanup()
}

// initializes the sdl context with the window setup
init :: proc(name:cstring,width,height:i32) {
    /*if sdl.Init(sdl.INIT_VIDEO) < 0 {
        fmt.eprintln("failed to init sdl2! err: %s", sdl.GetError())
        stop()
        return
    }

    if !w.create_window(name,width,height) {
        fmt.eprintln("failed to create window! err: %s", sdl.GetError())
        stop()
        return
    }*/
    w.create_window(name,width,height)
}

// stops the current game loop (does not quit prematurely)
stop :: proc() {
    running = false
}

// this is NOT used to close the program, this is called at the end of the "master" function
cleanup :: proc() {
    w.destroy_window()
    //sdl.Quit()
}