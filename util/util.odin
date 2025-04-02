package util

import "core:math/rand"

import rl "vendor:raylib"

import "../ca"


// this creates a chunk at a position in chunk space
create_chunk :: proc(x,y:int) {
    ca.world[ca.vec2{x,y}] = ca.chunk{img=rl.GenImageColor(512,512,rl.Color{0,0,0,0})}
}


// this places a cell in a certain position in world space coordinates
place_cell :: proc(x,y:int, type:u16) {
    chk := get_chk_ws(x,y)
    if chk == nil {
        return
    }

    cx,cy := conv_wl(x,y)

    switch type {
        case ca.CT_NONE:
            chk.data[cy][cx] = ca.CT_NONE
        case ca.CT_SAND:
            r := rand.int31_max(3)
            switch r {
                case 0:
                    chk.data[cy][cx] = 0b0000_111_111_000_000 | ca.CT_SAND
                case 1:
                    chk.data[cy][cx] = 0b0000_111_110_000_000 | ca.CT_SAND
                case 2:
                    chk.data[cy][cx] = 0b0000_110_110_000_000 | ca.CT_SAND
            }
        case ca.CT_STONE:
            r := rand.int31_max(3)
            switch r {
                case 0:
                    chk.data[cy][cx] = 0b0000_100_100_100_000 | ca.CT_STONE
                case 1:
                    chk.data[cy][cx] = 0b0000_110_110_110_000 | ca.CT_STONE
                case 2:
                    chk.data[cy][cx] = 0b0000_011_011_011_000 | ca.CT_STONE
            }
    }

    update_pix_col(chk,cx,cy)
}

// this swaps 2 cells in world space coordinates
swap :: proc(x1,y1,x2,y2: int) {
    chk1,chk2 := get_chk_ws(x1,y1), get_chk_ws(x2,y2)
    if chk2 == nil {
        cx1,cy1 := conv_wc(x1,y1)
        set_cell_changed(chk1,cx1,cy1,true)
        return
    }
    if chk1 == nil {
        cx2,cy2 := conv_wc(x2,y2)
        set_cell_changed(chk2,cx2,cy2,true)
        return
    }

    cx1,cy1,cx2,cy2 := conv_wc(x1,y1), conv_wc(x2,y2)
    set_cell_changed(chk1,cx1,cy1,true)
    set_cell_changed(chk2,cx2,cy2,true)
    chk1.data[cy1][cx1] ~= chk2.data[cy2][cx2]
    chk2.data[cy2][cx2] ~= chk1.data[cy1][cx1]
    chk1.data[cy1][cx1] ~= chk2.data[cy2][cx2]
    update_pix_col(chk1,cx1,cy1)
    update_pix_col(chk2,cx2,cy2)
}
// this updates the C value in a cell to 1 using local coordinates
stay :: proc(chk:^ca.chunk, x,y: int) {
    set_cell_changed(chk,x,y,true)
}
// this checks if a certain cell identified in world space coordinates is of a certain type
is_cell :: proc(x,y: int, type:u16) -> bool {
    wx,wy := conv_wc(x,y)

    chk := get_chk_cs(wx,wy)
    if chk == nil {
        return false
    }

    cx,cy := conv_wl(x,y)

    return chk.data[cy][cx] & 0b111 == type

    //return bounds_x(x) && bounds_y(y) && int(world[y][x] & 0b111) == type
}

// sets the C value of a cell using local coordinates
set_cell_changed :: proc(chk:^ca.chunk, x,y:int, val:bool) {
    //chk.data[y][x] &= 0b111_0_111_111_111_111 | u16(val)<<12
    chk.data[y][x] = (chk.data[y][x] & ~u16(1 << 12)) | (u16(val) << 12)
}
// gets the C value of a cell using local coordinates
get_cell_changed :: proc(chk:^ca.chunk, x,y:int) -> bool {
    return (chk.data[y][x] >> 12 & 1) == 1
}


// converts a point in world space coordinates to a point in chunk space coordinates (can be used to obtain the chunk a point is in)
conv_wc :: proc(x,y:int) -> (int,int) {
    //return x >= 0 ? x >> 9 : (x - 511) >> 9,
    //       y >= 0 ? y >> 9 : (y - 511) >> 9
    return int(u32(x + (x >> 31 & 511)) >> 9),
           int(u32(y + (y >> 31 & 511)) >> 9)
}
// converts a point in world space coordinates to a point in local coordinates (can be used to get the data at a point in a chunk)
conv_wl :: proc(x,y:int) -> (int,int) {
    return x & 511,
           y & 511
}
// converts a point in local coordinates to a point in world space coordinates
conv_lw :: proc(i,j,x,y:int) -> (int,int) {
    return (i << 9) | x,
           (j << 9) | y
}

// gets a pointer to the chunk at a position in worldspace
get_chk_ws :: proc(x,y:int) -> ^ca.chunk {
    wx,wy := conv_wc(x,y)
    return &ca.world[ca.vec2{wx,wy}]
}
// gets a pointer to the chunk at a position in chunkspace
get_chk_cs :: proc(x,y:int) -> ^ca.chunk {
    return &ca.world[ca.vec2{x,y}]
}

update_pix_col :: proc(chk:^ca.chunk, x,y:int) {
    rl.ImageDrawPixel(&chk.img, i32(x),i32(y), rl.Color{
        u8((chk.data[y][x] >> 9) & 0b111) *36,
        u8((chk.data[y][x] >> 6) & 0b111) *36,
        u8((chk.data[y][x] >> 3) & 0b111) *36,
        255
    })
}