package main

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:math"
import "core:math/rand"

import "kuru"
import d "kuru/drawing"
import inp "kuru/input"

import rl "vendor:raylib"

import "util"
import "ca"


RENDERSCALE :: 3

WIDTH :: 1280
HEIGHT :: 720


fps_update_freq: f32 = 0.45
fps_update_time: f32 = 1
lfps: f32
fpsc: cstring


main :: proc() {
    kuru.master("köppas", WIDTH,HEIGHT, init,tick,draw,quit)
}


init :: proc() {
    util.create_chunk(0,0)
}

tick :: proc() {
    for i := 0; i < 1; i += 1 {
        for j := 0; j < 1; j += 1 {
            chk := util.get_chk_cs(i,j)
            if chk == nil {
                continue
            }

            for x := 0; x < 512; x += 1 {
                for y := 0; y < 512; y += 1 {
                    util.set_cell_changed(chk,x,y,false)
                    //chk.data[y][x] &= 0b111_0_111_111_111_111
                }
            }

            for x := 0; x < 512; x += 1 {
                for y := 0; y < 512; y += 1 {
                    if util.get_cell_changed(chk,x,y) || util.is_cell(x,y, ca.CT_NONE) {
                        continue
                    }

                    wx,wy := util.conv_lw(i,j,x,y)

                    if util.is_cell(wx,wy, ca.CT_SAND) {
                        if util.is_cell(wx,wy+1, ca.CT_NONE) {
                            util.swap(wx,wy, wx,wy+1)
                            continue
                        }

                        if util.is_cell(wx+1,wy+1, ca.CT_NONE) {
                            util.swap(wx,wy, wx+1,wy+1)
                            continue
                        }

                        if util.is_cell(wx-1,wy+1, ca.CT_NONE) {
                            util.swap(wx,wy, wx-1,wy+1)
                            continue
                        }
                    }

                    if util.is_cell(wx,wy, ca.CT_STONE) {
                        if util.is_cell(wx+1,wy-1, ca.CT_STONE) && util.is_cell(wx-1,wy-1, ca.CT_STONE) {
                            util.stay(chk,x,y)
                            continue
                        }

                        if util.is_cell(wx,wy+1, ca.CT_NONE) {
                            util.swap(wx,wy, wx,wy+1)
                            continue
                        }
                    }
                }
            }
        }
    }
}

draw :: proc() {
    d.clear(0,0,0)

    for i := 0; i < 1; i += 1 {
        for j := 0; j < 1; j += 1 {
            chk := util.get_chk_cs(i,j)
            if chk == nil {
                continue
            }

            /*
                for x := 0; x < 512; x += 1 {
                    for y := 0; y < 512; y += 1 {
                        if util.is_cell(x,y, ca.CT_NONE) {
                            continue
                        }

                        d.fill(
                            u8((chk.data[y][x] >> 9) & 0b111) *36,
                            u8((chk.data[y][x] >> 6) & 0b111) *36,
                            u8((chk.data[y][x] >> 3) & 0b111) *36
                        )

                        d.rect(i32(((i<<9)|x)*RENDERSCALE),i32(((j<<9)|y)*RENDERSCALE),RENDERSCALE,RENDERSCALE)
                    }
                }
            */

            tex := rl.LoadTextureFromImage(chk.img) // TODO: FIGURE OUT A WAY TO CLEAR THIS
            rl.DrawTextureEx(tex,rl.Vector2{f32((i<<9)*RENDERSCALE),f32((j<<9)*RENDERSCALE)},0,RENDERSCALE,rl.Color{255,255,255,255})
        }
    }

    if inp.is_mouse_down(rl.MouseButton.LEFT) {
        util.place_cell(int(inp.mouse_x/RENDERSCALE),int(inp.mouse_y/RENDERSCALE), ca.CT_SAND)
    }
    if inp.is_mouse_down(rl.MouseButton.RIGHT) {
        util.place_cell(int(inp.mouse_x/RENDERSCALE),int(inp.mouse_y/RENDERSCALE), ca.CT_STONE)
    }

    if inp.is_mouse_down(rl.MouseButton.MIDDLE) {
        util.place_cell(int(inp.mouse_x/RENDERSCALE),int(inp.mouse_y/RENDERSCALE), ca.CT_NONE)
    }


    fps_update_time += rl.GetFrameTime()

    if fps_update_time >= fps_update_freq {
        lfps = 1/rl.GetFrameTime()
        buf: [32]u8
        fpsc = strings.clone_to_cstring(strings.concatenate({strconv.append_float(buf[:],f64(lfps),'f',-1,32), " FPS"}))
        fps_update_time = 0
    }

    rl.DrawText("köppas pre-alpha (3)", 3,3,16,rl.Color{255,255,255,255})
    rl.DrawText(fpsc, 3,22, 16,rl.Color{255,255,255,255})
}

quit :: proc() {

}