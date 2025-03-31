package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math/rand"

import "kuru"
import d "kuru/drawing"
import inp "kuru/input"

import rl "vendor:raylib"


CT_NONE   :: 0b000
CT_SAND   :: 0b001
CT_STONE  :: 0b010


RENDERSCALE :: 3

WIDTH :: 256 *RENDERSCALE
HEIGHT :: 256 *RENDERSCALE


world: [256][256]u16
changed: [256][256]u8


/* 0000_RRR_GGG_BBB_TTT 
    magic rgb conversion number: 255/7: ~36

    (R: red)
    (G: green)
    (B: blue)
    (T: type)
*/


fps_update_freq: f32 = 0.45
fps_update_time: f32 = 1
lfps: f32
fpsc: cstring


main :: proc() {
    kuru.master("köppas", WIDTH,HEIGHT, init,tick,draw,quit)
}


init :: proc() {

}

tick :: proc() {
    changed = [256][256]u8{}

    for x : i32 = 0; x < 256; x += 1 {
        for y : i32 = 0; y < 256; y += 1 {
            if changed[y][x] == 1 || is_cell(x,y, CT_NONE) {
                continue
            }

            if is_cell(x,y, CT_SAND) {
                if movable_y(y,1) {
                    if is_cell(x,y+1, CT_NONE) {
                        swap(x,y, x,y+1)
                        continue
                    }

                    if movable_x(x,1) {
                        if is_cell(x+1,y+1, CT_NONE) {
                            swap(x,y, x+1,y+1)
                            continue
                        }
                    }

                    if movable_x(x,-1) {
                        if is_cell(x-1,y+1, CT_NONE) {
                            swap(x,y, x-1,y+1)
                            continue
                        }
                    }
                }
            }

            if is_cell(x,y, CT_STONE) {
                if is_cell(x+1,y-1, CT_STONE) && is_cell(x-1,y-1, CT_STONE) {
                    stay(x,y)
                    continue
                }

                if movable_y(y,1) {
                    if is_cell(x,y+1, CT_NONE) {
                        swap(x,y, x,y+1)
                        continue
                    }

                    /*
                    if movable_x(x,1) {
                        if is_cell(x+1,y+1, CT_NONE) {
                            swap(x,y, x+1,y+1)
                            continue
                        }
                    }

                    if movable_x(x,-1) {
                        if is_cell(x-1,y+1, CT_NONE) {
                            swap(x,y, x-1,y+1)
                            continue
                        }
                    }
                    */
                }
            }
        }
    }
}

draw :: proc() {
    d.clear(0,0,0)

    for x : i32 = 0; x < 256; x += 1 {
        for y : i32 = 0; y < 256; y += 1 {
            if is_cell(x,y, CT_NONE) {
                continue
            }

            d.fill(
                u8((world[y][x] >> 9) & 0b111) *36,
                u8((world[y][x] >> 6) & 0b111) *36,
                u8((world[y][x] >> 3) & 0b111) *36
            )

            d.rect(x*RENDERSCALE,y*RENDERSCALE,RENDERSCALE,RENDERSCALE)
        }
    }

    if inp.is_mouse_down(rl.MouseButton.LEFT) {
        place_cell(i32(inp.mouse_x/RENDERSCALE),i32(inp.mouse_y/RENDERSCALE), CT_SAND)
    }

    if inp.is_mouse_down(rl.MouseButton.MIDDLE) {
        place_cell(i32(inp.mouse_x/RENDERSCALE),i32(inp.mouse_y/RENDERSCALE), CT_NONE)
    }

    if inp.is_key_down(rl.KeyboardKey.C) {
        world = [256][256]u16{}
    }

    fps_update_time += rl.GetFrameTime()

    if fps_update_time >= fps_update_freq {
        lfps = 1/rl.GetFrameTime()
        buf: [32]u8
        fpsc = strings.clone_to_cstring(strings.concatenate({strconv.append_float(buf[:],f64(lfps),'f',-1,32), " FPS"}))
        fps_update_time = 0
    }

    rl.DrawText("köppas pre-alpha (2)", 3,3,16,rl.Color{255,255,255,255})
    rl.DrawText(fpsc, 3,22, 16,rl.Color{255,255,255,255})
}

quit :: proc() {

}


place_cell :: proc(x,y:i32, type:int) {
    if !bounds_x(x) || !bounds_y(y) {
        return
    }

    switch type {
        case CT_NONE:
            world[y][x] = CT_NONE
        case CT_SAND:
            r := rand.int31_max(3)
            switch r {
                case 0:
                    world[y][x] = 0b0000_111_111_000_000 | CT_SAND
                case 1:
                    world[y][x] = 0b0000_111_110_000_000 | CT_SAND
                case 2:
                    world[y][x] = 0b0000_110_110_000_000 | CT_SAND
            }
        case CT_STONE:
            r := rand.int31_max(3)
            switch r {
                case 0:
                    world[y][x] = 0b0000_100_100_100_000 | CT_STONE
                case 1:
                    world[y][x] = 0b0000_100_100_100_000 | CT_STONE
                case 2:
                    world[y][x] = 0b0000_100_100_100_000 | CT_STONE
            }
    }
}

swap :: proc(x1,y1,x2,y2: i32) {
    world[y1][x1] ~= world[y2][x2]
    world[y2][x2] ~= world[y1][x1]
    world[y1][x1] ~= world[y2][x2]
    changed[y1][x1] = 1
    changed[y2][x2] = 1
}

stay :: proc(x,y: i32) {
    changed[y][x] = 1
}

is_cell :: proc(x,y: i32, type:int) -> bool {
    return bounds_x(x) && bounds_y(y) && int(world[y][x] & 0b111) == type
}


movable_x :: proc(x,d:i32) -> bool {
    switch d {
        case -1:
            return x > 0
        case 1:
            return x < 256-1
    }

    fmt.println("%d IS NOT A VALID MOVE DIRECTION (movable_x)",d)
    return false
}

movable_y :: proc(y,d:i32) -> bool {
    switch d {
        case -1:
            return y > 0
        case 1:
            return y < 256-1
    }

    fmt.println("%d IS NOT A VALID MOVE DIRECTION (movable_y)",d)
    return false
}

bounds_x :: proc(x:i32) -> bool {
    return !(x < 0 || x >= 256)
}

bounds_y :: proc(y:i32) -> bool {
    return !(y < 0 || y >= 256)
}