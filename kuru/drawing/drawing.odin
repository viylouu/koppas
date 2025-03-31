package drawing

import rl "vendor:raylib"
import sdl "vendor:sdl2"

rend: ^sdl.Renderer

cur_col: rl.Color

// clears the screen with the specified colors
clear :: proc(r,g,b: u8) {
    /*sdl.SetRenderDrawColor(rend,r,g,b,255)
    sdl.RenderClear(rend)*/
    rl.ClearBackground(rl.Color{r,g,b,1})
}

// sets the current color you are using to draw with to this
fill :: proc(r,g,b: u8, a: u8 = 255) {
    //sdl.SetRenderDrawColor(rend,r,g,b,a)
    cur_col = rl.Color{r,g,b,a}
}

// draws a pixel at a point
point :: proc(x,y: i32) {
    //sdl.RenderDrawPoint(rend,x,y)
    rl.DrawPixel(x,y,cur_col)
}
// draws a pixel at a point
fpoint :: proc(x,y: f32) {
    //sdl.RenderDrawPointF(rend, x,y)
    rl.DrawPixel(i32(x),i32(y),cur_col)
}

// draws a rectangle
rect :: proc(x,y,w,h: i32) {
    /*sdl.RenderDrawRect(
        rend,
        &sdl.Rect {
            x=x,
            y=y,
            w=w,
            h=h,
        }
    )*/
    rl.DrawRectangle(x,y,w,h,cur_col)
}
// draws a rectangle
frect :: proc(x,y,w,h: f32) {
    /*sdl.RenderDrawRectF(
        rend,
        &sdl.FRect {
            x=x,
            y=y,
            w=w,
            h=h,
        }
    )*/
    rl.DrawRectangle(i32(x),i32(y),i32(w),i32(h),cur_col)
}

// draws an image
iimage :: proc(tex: rl.Texture2D, x,y,w,h: i32) {
    //dest: sdl.Rect = { x,y,w,h }
    //sdl.RenderCopy(rend, tex, nil, &dest)
    rl.DrawTexturePro(
        tex,
        rl.Rectangle{0,0,f32(tex.width),f32(tex.height)},
        rl.Rectangle{f32(x),f32(y),f32(w),f32(h)},
        rl.Vector2{}, 0, cur_col
    )
}
// draws an image
image :: proc(tex: rl.Texture2D, x,y,w,h: f32) {
    //dest: sdl.Rect = { i32(x),i32(y),i32(w),i32(h) }
    //sdl.RenderCopy(rend, tex, nil, &dest)
    rl.DrawTexturePro(
        tex,
        rl.Rectangle{0,0,f32(tex.width),f32(tex.height)},
        rl.Rectangle{x,y,w,h},
        rl.Vector2{}, 0, cur_col
    )
}

// draws an image with a specified source and destination
iimage_sd :: proc(tex: rl.Texture2D, sx,sy,sw,sh, dx,dy,dw,dh: i32) {
    //src: sdl.Rect = { sx,sy,sw,sh }
    //dest: sdl.Rect = { dx,dy,dw,dh }
    //sdl.RenderCopy(rend, tex, &src, &dest)
    rl.DrawTexturePro(
        tex,
        rl.Rectangle{f32(sx),f32(sy),f32(sw),f32(sh)},
        rl.Rectangle{f32(dx),f32(dy),f32(dw),f32(dh)},
        rl.Vector2{}, 0, cur_col
    )
}
// draws an image with a specified source and destination
image_sd :: proc(tex: rl.Texture2D, sx,sy,sw,sh, dx,dy,dw,dh: f32) {
    //src: sdl.Rect = { i32(sx),i32(sy),i32(sw),i32(sh) }
    //dest: sdl.Rect = { i32(dx),i32(dy),i32(dw),i32(dh) }
    //sdl.RenderCopy(rend, tex, &src, &dest)
    rl.DrawTexturePro(
        tex,
        rl.Rectangle{sx,sy,sw,sh},
        rl.Rectangle{dx,dy,dw,dh},
        rl.Vector2{}, 0, cur_col
    )
}
