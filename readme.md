# Shader Playground

Just some snippets I am working on while I learn about fragment shaders, mainly by following along with the excellent [Book of Shaders](https://thebookofshaders.com).

## Running The Code

The GLSL code is designed to be run with the [Shader Toy](https://github.com/stevensona/shader-toy) extension for the [VS Code](https://code.visualstudio.com/) editor. That is, they assume that the following uniforms are available: `iResolution`, `iGlobalTime`, `iDeltaTime`, `iChannel0-3`.

To run the code in another environment, adjust the names of the uniforms.