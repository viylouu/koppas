package image

import "core:fmt"

//import sdl "vendor:sdl2"
//import sdli "vendor:sdl2/image"

import rl "vendor:raylib"

import "../" // kuru
import d "../drawing"


/*// this loads a surface using the sdl LoadBMP function and converts it to a texture for you to use
load_bmp :: proc(path: cstring) -> ^sdl.Texture {
    surf := sdl.LoadBMP("assets/backgrounds.bmp")
    return surf_to_tex_with_free(surf)
}*/


// this loads a surface using the raylib Load function and converts it to a texture for you to use
//
// load tends to be slower than using just bmp apparently, but bmp is a lot larger (bmp also doesent support transparency), so pick your poisson (🐟)
load :: proc(path: cstring) -> rl.Texture2D {
    /*surf := sdli.Load(path)
    return surf_to_tex_with_free(surf)*/
    return rl.LoadTexture(path)
}

/*
// this converts a surface to a texture
surf_to_tex :: proc(surf: ^sdl.Surface) -> ^sdl.Texture {
    if surf == nil {
        fmt.eprintln("failed to load image \"bgtex\"! err: ", sdl.GetError())
        kuru.stop()
        return nil
    }

    tex := sdl.CreateTextureFromSurface(d.rend, surf)
    sdl.FreeSurface(surf)

    if tex == nil {
        fmt.eprintln("failed to convert surface to texture! err: ", sdl.GetError())
        kuru.stop()
        return nil
    }

    return tex
}
// this converts a surface to a texture and frees the surface
surf_to_tex_with_free :: proc(surf: ^sdl.Surface) -> ^sdl.Texture {
    tex := surf_to_tex(surf)
    sdl.FreeSurface(surf)
    return tex
}
*/