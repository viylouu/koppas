package ca // cellular automata


import rl "vendor:raylib"

vec2::struct{x,y:int}
world: map[vec2]chunk

CT_NONE   :u16: 0b000
CT_SAND   :u16: 0b001
CT_STONE  :u16: 0b010

chunk :: struct {
    data: [512][512]u16,
    /* 0000000000_H_CC_TTT (TODO: CHANGE FROM 000_C_RRR_GGG_BBB_TTT)
        magic rgb conversion number: 255/7: ~36

        (T: type)
        (C: variation of color from type)
        (H: has changed current frame)
    */

    img: rl.Image
}