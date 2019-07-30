"/////////////////////////////////////////////////////////////////////////////
" check script loading
"/////////////////////////////////////////////////////////////////////////////

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Read the C syntax to start with
runtime! syntax/c.vim
unlet b:current_syntax

"/////////////////////////////////////////////////////////////////////////////
" syntax defines
"/////////////////////////////////////////////////////////////////////////////

" keyword definitions
" case match
syntax case match
" storage
syn keyword shaderStorage         extern shared static uniform volatile

" base type
syn keyword shaderType            const row_major col_major
syn keyword shaderType            snorm4 unorm4 matrix
syn match   shaderType            "\<\(bool\|int\|half\|float\|double\)[1-4]*\>"
syn match   shaderType            "\<\(bool\|int\|half\|float\|double\)[1-4]x[1-4]\>"
syn keyword shaderType            vertexshader pixelshader struct typedef
syn keyword shaderType            in out

" shader type
syn match   shaderShaderType      "\<\(vs\|ps\|gs\)_[1-4]_[0-4]\>"
syn keyword shaderBaseFunction    CompileShader SetVertexShader SetGeometryShader SetPixelShader SetDepthStencilState pass compile technique

" function
syn keyword shaderFunction        abs acos all any asin atan atan2 ceil clamp clip cos cosh cross 
syn keyword shaderFunction        D3DCOLORtoUBYTE4 ddx ddy degress determinant distance dot exp exp2
syn keyword shaderFunction        faceforward floor fmod frac frexp fwidth isfinite isinf isnan ldexp
syn keyword shaderFunction        length lerp lit log log10 log2 max min modf mul noise normalize pow
syn keyword shaderFunction        radians reflect refract round rsqrt saturate sign sin sincos sinh
syn keyword shaderFunction        smoothstep sqrt step tan tanh tex1D tex1Dqrad tex1Dbias tex1Dgrad 
syn keyword shaderFunction        tex1Dlod tex1Dproj tex2D tex2Dbias tex2Dqrad tex2Dlod tex2Dproj
syn keyword shaderFunction        tex3D tex3Dbias tex3Dqrad tex3Dlod tex3Dproj texCUBE texCUBEqrad
syn keyword shaderFunction        texCUBEproj transpose

" case ignore
syntax case ignore
"syn match   shaderSemantic        "\<\(BINORMAL\|BLENDINDICES\|BLENDWEIGHT\|COLOR\|NORMAL\|POSITION\|PSIZE\|TANGENT\|TESSFACTOR\|TEXCOORD\|DEPTH\)[0-7]*\>" contained
"syn match   shaderSemantic        "\<\(POSITIONT\|FOG\|PSIZE\|VFACE\|VPOS\)\>" contained
"syn match   shaderSemantic        "\<\(SV_ClipDistance\|SV_CullDistance\|SV_Target\)[0-7]*\>" contained
"syn match   shaderSemantic        "\<\(SV_ClipDistance\|SV_CullDistance\|SV_Depth\|SV_InstanceID\|SV_IsFrontFace\|SV_Position\|SV_PrimitiveID\|SV_RenderTargetArrayIndex\|SV_Target\|SV_VertexID\|SV_ViewportArrayIndex\)\>" contained

syn match   shaderType            "\<\(Texture\|sampler\)[1-3]D\>"
syn keyword shaderType            sampler texture filter
syn match   shaderType            "address[u,v,w]"

"/////////////////////////////////////////////////////////////////////////////
" exMacroHighlight Predeined Syntax
"/////////////////////////////////////////////////////////////////////////////

" add shader enable group
syn cluster exEnableContainedGroup add=shaderStorage,shaderType,shaderShaderType,shaderBaseFunction,shaderBaseFunction,shaderFunction

"/////////////////////////////////////////////////////////////////////////////
" highlight defines
"/////////////////////////////////////////////////////////////////////////////

" Define the default highlighting.
if version >= 508 || !exists("did_shader_syntax_inits")
  if version < 508
    let did_shader_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink shaderStorage         StorageClass
  HiLink shaderType            Type
  HiLink shaderBaseFunction    Type
  HiLink shaderShaderType      Special
  HiLink shaderFunction        Function
  HiLink shaderSemantic        Special
  delcommand HiLink
endif

"/////////////////////////////////////////////////////////////////////////////
" finish
"/////////////////////////////////////////////////////////////////////////////

let b:current_syntax = "shader"

" vim: ts=8


