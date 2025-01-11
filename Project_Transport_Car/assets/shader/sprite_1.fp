varying mediump vec2 var_texcoord0;
uniform lowp sampler2D texture_sampler;
uniform lowp vec4 blink_effect_trigger;  // Passed from Lua

void main()
{
    lowp vec4 color_of_pixel = texture2D(texture_sampler, var_texcoord0.xy);

    if (color_of_pixel.a != 0.0) // Ensure non-transparent pixels
    {
        if (blink_effect_trigger.r == 1.0)  // Blink trigger active
        {
            color_of_pixel.rgb = vec3(1.0, 0.0, 0.0); // Red effect
        }
    }

    gl_FragColor = color_of_pixel;  
}
