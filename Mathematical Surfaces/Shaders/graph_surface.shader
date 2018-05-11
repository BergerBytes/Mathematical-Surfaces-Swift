vec4 col = u_inverseViewTransform * vec4(_surface.position, 1.0);
_surface.diffuse.rgba = clamp(col + vec4(0.5), vec4(0.1), vec4(0.9));
