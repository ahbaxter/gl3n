module gl3n.interpolate;

private {
    import gl3n.linalg : Vector;
    import gl3n.util : is_vector;
    
    version(unittest) {
        import gl3n.linalg : vec2, vec3, vec4;
    }
}



T interp(T)(T x, T y, float a) if(!is_vector!T) {
    return x + a*(y - x);
}

T interp(T)(T x, T y, float a) if(is_vector!T) {
    return T.mix(x, y, a);
}

alias interp interp_linear;
alias interp mix;

unittest {
    vec2 v2_1 = vec2(1.0f);
    vec2 v2_2 = vec2(0.0f);
    vec3 v3_1 = vec3(1.0f);
    vec3 v3_2 = vec3(0.0f);
    vec4 v4_1 = vec4(1.0f);
    vec4 v4_2 = vec4(0.0f);
    
    assert(interp(v2_1, v2_2, 0.5f).vector == [0.5f, 0.5f]);
    assert(interp(v2_1, v2_2, 0.0f) == v2_1);
    assert(interp(v2_1, v2_2, 1.0f) == v2_2);
    assert(interp(v3_1, v3_2, 0.5f).vector == [0.5f, 0.5f, 0.5f]);
    assert(interp(v3_1, v3_2, 0.0f) == v3_1);
    assert(interp(v3_1, v3_2, 1.0f) == v3_2);
    assert(interp(v4_1, v4_2, 0.5f).vector == [0.5f, 0.5f, 0.5f, 0.5f]);
    assert(interp(v4_1, v4_2, 0.0f) == v4_1);
    assert(interp(v4_1, v4_2, 1.0f) == v4_2);
    

    real r1 = 0.0;
    real r2 = 1.0;
    assert(interp(r1, r2, 0.5f) == 0.5);
    assert(interp(r1, r2, 0.0f) == r1);
    assert(interp(r1, r2, 1.0f) == r2);
    
    assert(interp(0.0, 1.0, 0.5f) == 0.5);
    assert(interp(0.0, 1.0, 0.0f) == 0.0);
    assert(interp(0.0, 1.0, 1.0f) == 1.0);
    
    assert(interp(0.0f, 1.0f, 0.5f) == 0.5f);
    assert(interp(0.0f, 1.0f, 0.0f) == 0.0f);
    assert(interp(0.0f, 1.0f, 1.0f) == 1.0f);
}

T interp_nearest(T)(T x, T y, float a) {
    if(a < 0.5f) { return x; }
    else { return y; } 
}

unittest {
    assert(interp_nearest(0.0, 1.0, 0.5f) == 1.0);
    assert(interp_nearest(0.0, 1.0, 0.4f) == 0.0);
    assert(interp_nearest(0.0, 1.0, 0.6f) == 1.0);
}

T interp_catmullrom(T)(T p0, T p1, T p2, T p3, float a) {
    return 0.5 * ((2 * p1) + 
                  (-p0 + p2) * a +
                  (2 * p0 - 5 * p1 + 4 * p2 - p3) * a^^2 +
                  (-p0 + 3 * p1 - 3 * p2 + p3) * a^^3)
}