package input

import "../misc"

import sdl "vendor:sdl2"
import rl "vendor:raylib"

key_states: [256]bool
//mouse_states: [25]bool
mouse_x,mouse_y: f32
mouse_scroll_delta_x,mouse_scroll_delta_y: i32

// messi ahh function
poll_event :: proc(/*e: sdl.Event*/) {
    /*#partial switch e.type {
        case sdl.EventType.KEYDOWN:
            key_states[e.key.keysym.scancode] = true
        case sdl.EventType.KEYUP:
            key_states[e.key.keysym.scancode] = false
        case sdl.EventType.MOUSEMOTION:
            mouse_x = f32(e.motion.x)/*misc.scale*/
            mouse_y = f32(e.motion.y)/*misc.scale*/
        case sdl.EventType.MOUSEBUTTONDOWN:
            mouse_states[e.button.button] = true
        case sdl.EventType.MOUSEBUTTONUP:
            mouse_states[e.button.button] = false
        case sdl.EventType.MOUSEWHEEL:
            mouse_scroll_delta_x = e.wheel.x
            mouse_scroll_delta_y = e.wheel.y
    }*/

    mouse_scroll_delta_y = i32(rl.GetMouseWheelMove())
    mouse_x = f32(rl.GetMouseX())
    mouse_y = f32(rl.GetMouseY())
}

// checks if key "x" is currently being pressed
is_key_down :: proc(key: rl.KeyboardKey) -> bool {
    //return key_states[scancode]
    return rl.IsKeyDown(key)
}
// checks if key "x" is currently not being pressed
is_key_up :: proc(key: rl.KeyboardKey) -> bool {
    //return !key_states[scancode]
    return !rl.IsKeyDown(key)
}

// checks if mouse button "x" is currently being pressed
is_mouse_down :: proc(button: rl.MouseButton) -> bool {
    //return mouse_states[button]
    return rl.IsMouseButtonDown(button)
}
// checks if mouse button "x" is currently not being pressed
is_mouse_up :: proc(button: rl.MouseButton) -> bool {
    //return !mouse_states[button]
    return !rl.IsMouseButtonDown(button)
}

// checks if the user is scrolling the mouse wheel horizontally (NOT WORKING)
is_mouse_scroll_x :: proc() -> bool {
    return mouse_scroll_delta_x != 0
}
// checks if the user is scrolling the mouse wheel vertically (normal)
is_mouse_scroll_y :: proc() -> bool {
    return mouse_scroll_delta_y != 0
}