---
output:
  html_document:
    self_contained: no
---

```r
library(knitr)
knit_hooks$set(webgl = hook_webgl)
cat('<script type="text/javascript">', readLines(system.file('WebGL', 'CanvasMatrix.js', package = 'rgl')), '</script>', sep = '\n')
```

<script type="text/javascript">
CanvasMatrix4=function(m){if(typeof m=='object'){if("length"in m&&m.length>=16){this.load(m[0],m[1],m[2],m[3],m[4],m[5],m[6],m[7],m[8],m[9],m[10],m[11],m[12],m[13],m[14],m[15]);return}else if(m instanceof CanvasMatrix4){this.load(m);return}}this.makeIdentity()};CanvasMatrix4.prototype.load=function(){if(arguments.length==1&&typeof arguments[0]=='object'){var matrix=arguments[0];if("length"in matrix&&matrix.length==16){this.m11=matrix[0];this.m12=matrix[1];this.m13=matrix[2];this.m14=matrix[3];this.m21=matrix[4];this.m22=matrix[5];this.m23=matrix[6];this.m24=matrix[7];this.m31=matrix[8];this.m32=matrix[9];this.m33=matrix[10];this.m34=matrix[11];this.m41=matrix[12];this.m42=matrix[13];this.m43=matrix[14];this.m44=matrix[15];return}if(arguments[0]instanceof CanvasMatrix4){this.m11=matrix.m11;this.m12=matrix.m12;this.m13=matrix.m13;this.m14=matrix.m14;this.m21=matrix.m21;this.m22=matrix.m22;this.m23=matrix.m23;this.m24=matrix.m24;this.m31=matrix.m31;this.m32=matrix.m32;this.m33=matrix.m33;this.m34=matrix.m34;this.m41=matrix.m41;this.m42=matrix.m42;this.m43=matrix.m43;this.m44=matrix.m44;return}}this.makeIdentity()};CanvasMatrix4.prototype.getAsArray=function(){return[this.m11,this.m12,this.m13,this.m14,this.m21,this.m22,this.m23,this.m24,this.m31,this.m32,this.m33,this.m34,this.m41,this.m42,this.m43,this.m44]};CanvasMatrix4.prototype.getAsWebGLFloatArray=function(){return new WebGLFloatArray(this.getAsArray())};CanvasMatrix4.prototype.makeIdentity=function(){this.m11=1;this.m12=0;this.m13=0;this.m14=0;this.m21=0;this.m22=1;this.m23=0;this.m24=0;this.m31=0;this.m32=0;this.m33=1;this.m34=0;this.m41=0;this.m42=0;this.m43=0;this.m44=1};CanvasMatrix4.prototype.transpose=function(){var tmp=this.m12;this.m12=this.m21;this.m21=tmp;tmp=this.m13;this.m13=this.m31;this.m31=tmp;tmp=this.m14;this.m14=this.m41;this.m41=tmp;tmp=this.m23;this.m23=this.m32;this.m32=tmp;tmp=this.m24;this.m24=this.m42;this.m42=tmp;tmp=this.m34;this.m34=this.m43;this.m43=tmp};CanvasMatrix4.prototype.invert=function(){var det=this._determinant4x4();if(Math.abs(det)<1e-8)return null;this._makeAdjoint();this.m11/=det;this.m12/=det;this.m13/=det;this.m14/=det;this.m21/=det;this.m22/=det;this.m23/=det;this.m24/=det;this.m31/=det;this.m32/=det;this.m33/=det;this.m34/=det;this.m41/=det;this.m42/=det;this.m43/=det;this.m44/=det};CanvasMatrix4.prototype.translate=function(x,y,z){if(x==undefined)x=0;if(y==undefined)y=0;if(z==undefined)z=0;var matrix=new CanvasMatrix4();matrix.m41=x;matrix.m42=y;matrix.m43=z;this.multRight(matrix)};CanvasMatrix4.prototype.scale=function(x,y,z){if(x==undefined)x=1;if(z==undefined){if(y==undefined){y=x;z=x}else z=1}else if(y==undefined)y=x;var matrix=new CanvasMatrix4();matrix.m11=x;matrix.m22=y;matrix.m33=z;this.multRight(matrix)};CanvasMatrix4.prototype.rotate=function(angle,x,y,z){angle=angle/180*Math.PI;angle/=2;var sinA=Math.sin(angle);var cosA=Math.cos(angle);var sinA2=sinA*sinA;var length=Math.sqrt(x*x+y*y+z*z);if(length==0){x=0;y=0;z=1}else if(length!=1){x/=length;y/=length;z/=length}var mat=new CanvasMatrix4();if(x==1&&y==0&&z==0){mat.m11=1;mat.m12=0;mat.m13=0;mat.m21=0;mat.m22=1-2*sinA2;mat.m23=2*sinA*cosA;mat.m31=0;mat.m32=-2*sinA*cosA;mat.m33=1-2*sinA2;mat.m14=mat.m24=mat.m34=0;mat.m41=mat.m42=mat.m43=0;mat.m44=1}else if(x==0&&y==1&&z==0){mat.m11=1-2*sinA2;mat.m12=0;mat.m13=-2*sinA*cosA;mat.m21=0;mat.m22=1;mat.m23=0;mat.m31=2*sinA*cosA;mat.m32=0;mat.m33=1-2*sinA2;mat.m14=mat.m24=mat.m34=0;mat.m41=mat.m42=mat.m43=0;mat.m44=1}else if(x==0&&y==0&&z==1){mat.m11=1-2*sinA2;mat.m12=2*sinA*cosA;mat.m13=0;mat.m21=-2*sinA*cosA;mat.m22=1-2*sinA2;mat.m23=0;mat.m31=0;mat.m32=0;mat.m33=1;mat.m14=mat.m24=mat.m34=0;mat.m41=mat.m42=mat.m43=0;mat.m44=1}else{var x2=x*x;var y2=y*y;var z2=z*z;mat.m11=1-2*(y2+z2)*sinA2;mat.m12=2*(x*y*sinA2+z*sinA*cosA);mat.m13=2*(x*z*sinA2-y*sinA*cosA);mat.m21=2*(y*x*sinA2-z*sinA*cosA);mat.m22=1-2*(z2+x2)*sinA2;mat.m23=2*(y*z*sinA2+x*sinA*cosA);mat.m31=2*(z*x*sinA2+y*sinA*cosA);mat.m32=2*(z*y*sinA2-x*sinA*cosA);mat.m33=1-2*(x2+y2)*sinA2;mat.m14=mat.m24=mat.m34=0;mat.m41=mat.m42=mat.m43=0;mat.m44=1}this.multRight(mat)};CanvasMatrix4.prototype.multRight=function(mat){var m11=(this.m11*mat.m11+this.m12*mat.m21+this.m13*mat.m31+this.m14*mat.m41);var m12=(this.m11*mat.m12+this.m12*mat.m22+this.m13*mat.m32+this.m14*mat.m42);var m13=(this.m11*mat.m13+this.m12*mat.m23+this.m13*mat.m33+this.m14*mat.m43);var m14=(this.m11*mat.m14+this.m12*mat.m24+this.m13*mat.m34+this.m14*mat.m44);var m21=(this.m21*mat.m11+this.m22*mat.m21+this.m23*mat.m31+this.m24*mat.m41);var m22=(this.m21*mat.m12+this.m22*mat.m22+this.m23*mat.m32+this.m24*mat.m42);var m23=(this.m21*mat.m13+this.m22*mat.m23+this.m23*mat.m33+this.m24*mat.m43);var m24=(this.m21*mat.m14+this.m22*mat.m24+this.m23*mat.m34+this.m24*mat.m44);var m31=(this.m31*mat.m11+this.m32*mat.m21+this.m33*mat.m31+this.m34*mat.m41);var m32=(this.m31*mat.m12+this.m32*mat.m22+this.m33*mat.m32+this.m34*mat.m42);var m33=(this.m31*mat.m13+this.m32*mat.m23+this.m33*mat.m33+this.m34*mat.m43);var m34=(this.m31*mat.m14+this.m32*mat.m24+this.m33*mat.m34+this.m34*mat.m44);var m41=(this.m41*mat.m11+this.m42*mat.m21+this.m43*mat.m31+this.m44*mat.m41);var m42=(this.m41*mat.m12+this.m42*mat.m22+this.m43*mat.m32+this.m44*mat.m42);var m43=(this.m41*mat.m13+this.m42*mat.m23+this.m43*mat.m33+this.m44*mat.m43);var m44=(this.m41*mat.m14+this.m42*mat.m24+this.m43*mat.m34+this.m44*mat.m44);this.m11=m11;this.m12=m12;this.m13=m13;this.m14=m14;this.m21=m21;this.m22=m22;this.m23=m23;this.m24=m24;this.m31=m31;this.m32=m32;this.m33=m33;this.m34=m34;this.m41=m41;this.m42=m42;this.m43=m43;this.m44=m44};CanvasMatrix4.prototype.multLeft=function(mat){var m11=(mat.m11*this.m11+mat.m12*this.m21+mat.m13*this.m31+mat.m14*this.m41);var m12=(mat.m11*this.m12+mat.m12*this.m22+mat.m13*this.m32+mat.m14*this.m42);var m13=(mat.m11*this.m13+mat.m12*this.m23+mat.m13*this.m33+mat.m14*this.m43);var m14=(mat.m11*this.m14+mat.m12*this.m24+mat.m13*this.m34+mat.m14*this.m44);var m21=(mat.m21*this.m11+mat.m22*this.m21+mat.m23*this.m31+mat.m24*this.m41);var m22=(mat.m21*this.m12+mat.m22*this.m22+mat.m23*this.m32+mat.m24*this.m42);var m23=(mat.m21*this.m13+mat.m22*this.m23+mat.m23*this.m33+mat.m24*this.m43);var m24=(mat.m21*this.m14+mat.m22*this.m24+mat.m23*this.m34+mat.m24*this.m44);var m31=(mat.m31*this.m11+mat.m32*this.m21+mat.m33*this.m31+mat.m34*this.m41);var m32=(mat.m31*this.m12+mat.m32*this.m22+mat.m33*this.m32+mat.m34*this.m42);var m33=(mat.m31*this.m13+mat.m32*this.m23+mat.m33*this.m33+mat.m34*this.m43);var m34=(mat.m31*this.m14+mat.m32*this.m24+mat.m33*this.m34+mat.m34*this.m44);var m41=(mat.m41*this.m11+mat.m42*this.m21+mat.m43*this.m31+mat.m44*this.m41);var m42=(mat.m41*this.m12+mat.m42*this.m22+mat.m43*this.m32+mat.m44*this.m42);var m43=(mat.m41*this.m13+mat.m42*this.m23+mat.m43*this.m33+mat.m44*this.m43);var m44=(mat.m41*this.m14+mat.m42*this.m24+mat.m43*this.m34+mat.m44*this.m44);this.m11=m11;this.m12=m12;this.m13=m13;this.m14=m14;this.m21=m21;this.m22=m22;this.m23=m23;this.m24=m24;this.m31=m31;this.m32=m32;this.m33=m33;this.m34=m34;this.m41=m41;this.m42=m42;this.m43=m43;this.m44=m44};CanvasMatrix4.prototype.ortho=function(left,right,bottom,top,near,far){var tx=(left+right)/(left-right);var ty=(top+bottom)/(top-bottom);var tz=(far+near)/(far-near);var matrix=new CanvasMatrix4();matrix.m11=2/(left-right);matrix.m12=0;matrix.m13=0;matrix.m14=0;matrix.m21=0;matrix.m22=2/(top-bottom);matrix.m23=0;matrix.m24=0;matrix.m31=0;matrix.m32=0;matrix.m33=-2/(far-near);matrix.m34=0;matrix.m41=tx;matrix.m42=ty;matrix.m43=tz;matrix.m44=1;this.multRight(matrix)};CanvasMatrix4.prototype.frustum=function(left,right,bottom,top,near,far){var matrix=new CanvasMatrix4();var A=(right+left)/(right-left);var B=(top+bottom)/(top-bottom);var C=-(far+near)/(far-near);var D=-(2*far*near)/(far-near);matrix.m11=(2*near)/(right-left);matrix.m12=0;matrix.m13=0;matrix.m14=0;matrix.m21=0;matrix.m22=2*near/(top-bottom);matrix.m23=0;matrix.m24=0;matrix.m31=A;matrix.m32=B;matrix.m33=C;matrix.m34=-1;matrix.m41=0;matrix.m42=0;matrix.m43=D;matrix.m44=0;this.multRight(matrix)};CanvasMatrix4.prototype.perspective=function(fovy,aspect,zNear,zFar){var top=Math.tan(fovy*Math.PI/360)*zNear;var bottom=-top;var left=aspect*bottom;var right=aspect*top;this.frustum(left,right,bottom,top,zNear,zFar)};CanvasMatrix4.prototype.lookat=function(eyex,eyey,eyez,centerx,centery,centerz,upx,upy,upz){var matrix=new CanvasMatrix4();var zx=eyex-centerx;var zy=eyey-centery;var zz=eyez-centerz;var mag=Math.sqrt(zx*zx+zy*zy+zz*zz);if(mag){zx/=mag;zy/=mag;zz/=mag}var yx=upx;var yy=upy;var yz=upz;xx=yy*zz-yz*zy;xy=-yx*zz+yz*zx;xz=yx*zy-yy*zx;yx=zy*xz-zz*xy;yy=-zx*xz+zz*xx;yx=zx*xy-zy*xx;mag=Math.sqrt(xx*xx+xy*xy+xz*xz);if(mag){xx/=mag;xy/=mag;xz/=mag}mag=Math.sqrt(yx*yx+yy*yy+yz*yz);if(mag){yx/=mag;yy/=mag;yz/=mag}matrix.m11=xx;matrix.m12=xy;matrix.m13=xz;matrix.m14=0;matrix.m21=yx;matrix.m22=yy;matrix.m23=yz;matrix.m24=0;matrix.m31=zx;matrix.m32=zy;matrix.m33=zz;matrix.m34=0;matrix.m41=0;matrix.m42=0;matrix.m43=0;matrix.m44=1;matrix.translate(-eyex,-eyey,-eyez);this.multRight(matrix)};CanvasMatrix4.prototype._determinant2x2=function(a,b,c,d){return a*d-b*c};CanvasMatrix4.prototype._determinant3x3=function(a1,a2,a3,b1,b2,b3,c1,c2,c3){return a1*this._determinant2x2(b2,b3,c2,c3)-b1*this._determinant2x2(a2,a3,c2,c3)+c1*this._determinant2x2(a2,a3,b2,b3)};CanvasMatrix4.prototype._determinant4x4=function(){var a1=this.m11;var b1=this.m12;var c1=this.m13;var d1=this.m14;var a2=this.m21;var b2=this.m22;var c2=this.m23;var d2=this.m24;var a3=this.m31;var b3=this.m32;var c3=this.m33;var d3=this.m34;var a4=this.m41;var b4=this.m42;var c4=this.m43;var d4=this.m44;return a1*this._determinant3x3(b2,b3,b4,c2,c3,c4,d2,d3,d4)-b1*this._determinant3x3(a2,a3,a4,c2,c3,c4,d2,d3,d4)+c1*this._determinant3x3(a2,a3,a4,b2,b3,b4,d2,d3,d4)-d1*this._determinant3x3(a2,a3,a4,b2,b3,b4,c2,c3,c4)};CanvasMatrix4.prototype._makeAdjoint=function(){var a1=this.m11;var b1=this.m12;var c1=this.m13;var d1=this.m14;var a2=this.m21;var b2=this.m22;var c2=this.m23;var d2=this.m24;var a3=this.m31;var b3=this.m32;var c3=this.m33;var d3=this.m34;var a4=this.m41;var b4=this.m42;var c4=this.m43;var d4=this.m44;this.m11=this._determinant3x3(b2,b3,b4,c2,c3,c4,d2,d3,d4);this.m21=-this._determinant3x3(a2,a3,a4,c2,c3,c4,d2,d3,d4);this.m31=this._determinant3x3(a2,a3,a4,b2,b3,b4,d2,d3,d4);this.m41=-this._determinant3x3(a2,a3,a4,b2,b3,b4,c2,c3,c4);this.m12=-this._determinant3x3(b1,b3,b4,c1,c3,c4,d1,d3,d4);this.m22=this._determinant3x3(a1,a3,a4,c1,c3,c4,d1,d3,d4);this.m32=-this._determinant3x3(a1,a3,a4,b1,b3,b4,d1,d3,d4);this.m42=this._determinant3x3(a1,a3,a4,b1,b3,b4,c1,c3,c4);this.m13=this._determinant3x3(b1,b2,b4,c1,c2,c4,d1,d2,d4);this.m23=-this._determinant3x3(a1,a2,a4,c1,c2,c4,d1,d2,d4);this.m33=this._determinant3x3(a1,a2,a4,b1,b2,b4,d1,d2,d4);this.m43=-this._determinant3x3(a1,a2,a4,b1,b2,b4,c1,c2,c4);this.m14=-this._determinant3x3(b1,b2,b3,c1,c2,c3,d1,d2,d3);this.m24=this._determinant3x3(a1,a2,a3,c1,c2,c3,d1,d2,d3);this.m34=-this._determinant3x3(a1,a2,a3,b1,b2,b3,d1,d2,d3);this.m44=this._determinant3x3(a1,a2,a3,b1,b2,b3,c1,c2,c3)}
</script>

This works fine.


```r
x <- sort(rnorm(1000))
y <- rnorm(1000)
z <- rnorm(1000) + atan2(x,y)
plot3d(x, y, z, col=rainbow(1000))
```

<canvas id="testgltextureCanvas" style="display: none;" width="256" height="256">
Your browser does not support the HTML5 canvas element.</canvas>
<!-- ****** points object 6 ****** -->
<script id="testglvshader6" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
void main(void) {
vPosition = mvMatrix * vec4(aPos, 1.);
gl_Position = prMatrix * vPosition;
gl_PointSize = 3.;
vCol = aCol;
}
</script>
<script id="testglfshader6" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
gl_FragColor = lighteffect;
}
</script> 
<!-- ****** text object 8 ****** -->
<script id="testglvshader8" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
attribute vec2 aTexcoord;
varying vec2 vTexcoord;
attribute vec2 aOfs;
void main(void) {
vCol = aCol;
vTexcoord = aTexcoord;
vec4 pos = prMatrix * mvMatrix * vec4(aPos, 1.);
pos = pos/pos.w;
gl_Position = pos + vec4(aOfs, 0.,0.);
}
</script>
<script id="testglfshader8" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
varying vec2 vTexcoord;
uniform sampler2D uSampler;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
vec4 textureColor = lighteffect*texture2D(uSampler, vTexcoord);
if (textureColor.a < 0.1)
discard;
else
gl_FragColor = textureColor;
}
</script> 
<!-- ****** text object 9 ****** -->
<script id="testglvshader9" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
attribute vec2 aTexcoord;
varying vec2 vTexcoord;
attribute vec2 aOfs;
void main(void) {
vCol = aCol;
vTexcoord = aTexcoord;
vec4 pos = prMatrix * mvMatrix * vec4(aPos, 1.);
pos = pos/pos.w;
gl_Position = pos + vec4(aOfs, 0.,0.);
}
</script>
<script id="testglfshader9" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
varying vec2 vTexcoord;
uniform sampler2D uSampler;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
vec4 textureColor = lighteffect*texture2D(uSampler, vTexcoord);
if (textureColor.a < 0.1)
discard;
else
gl_FragColor = textureColor;
}
</script> 
<!-- ****** text object 10 ****** -->
<script id="testglvshader10" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
attribute vec2 aTexcoord;
varying vec2 vTexcoord;
attribute vec2 aOfs;
void main(void) {
vCol = aCol;
vTexcoord = aTexcoord;
vec4 pos = prMatrix * mvMatrix * vec4(aPos, 1.);
pos = pos/pos.w;
gl_Position = pos + vec4(aOfs, 0.,0.);
}
</script>
<script id="testglfshader10" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
varying vec2 vTexcoord;
uniform sampler2D uSampler;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
vec4 textureColor = lighteffect*texture2D(uSampler, vTexcoord);
if (textureColor.a < 0.1)
discard;
else
gl_FragColor = textureColor;
}
</script> 
<!-- ****** lines object 11 ****** -->
<script id="testglvshader11" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
void main(void) {
vPosition = mvMatrix * vec4(aPos, 1.);
gl_Position = prMatrix * vPosition;
vCol = aCol;
}
</script>
<script id="testglfshader11" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
gl_FragColor = lighteffect;
}
</script> 
<!-- ****** text object 12 ****** -->
<script id="testglvshader12" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
attribute vec2 aTexcoord;
varying vec2 vTexcoord;
attribute vec2 aOfs;
void main(void) {
vCol = aCol;
vTexcoord = aTexcoord;
vec4 pos = prMatrix * mvMatrix * vec4(aPos, 1.);
pos = pos/pos.w;
gl_Position = pos + vec4(aOfs, 0.,0.);
}
</script>
<script id="testglfshader12" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
varying vec2 vTexcoord;
uniform sampler2D uSampler;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
vec4 textureColor = lighteffect*texture2D(uSampler, vTexcoord);
if (textureColor.a < 0.1)
discard;
else
gl_FragColor = textureColor;
}
</script> 
<!-- ****** lines object 13 ****** -->
<script id="testglvshader13" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
void main(void) {
vPosition = mvMatrix * vec4(aPos, 1.);
gl_Position = prMatrix * vPosition;
vCol = aCol;
}
</script>
<script id="testglfshader13" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
gl_FragColor = lighteffect;
}
</script> 
<!-- ****** text object 14 ****** -->
<script id="testglvshader14" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
attribute vec2 aTexcoord;
varying vec2 vTexcoord;
attribute vec2 aOfs;
void main(void) {
vCol = aCol;
vTexcoord = aTexcoord;
vec4 pos = prMatrix * mvMatrix * vec4(aPos, 1.);
pos = pos/pos.w;
gl_Position = pos + vec4(aOfs, 0.,0.);
}
</script>
<script id="testglfshader14" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
varying vec2 vTexcoord;
uniform sampler2D uSampler;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
vec4 textureColor = lighteffect*texture2D(uSampler, vTexcoord);
if (textureColor.a < 0.1)
discard;
else
gl_FragColor = textureColor;
}
</script> 
<!-- ****** lines object 15 ****** -->
<script id="testglvshader15" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
void main(void) {
vPosition = mvMatrix * vec4(aPos, 1.);
gl_Position = prMatrix * vPosition;
vCol = aCol;
}
</script>
<script id="testglfshader15" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
gl_FragColor = lighteffect;
}
</script> 
<!-- ****** text object 16 ****** -->
<script id="testglvshader16" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
attribute vec2 aTexcoord;
varying vec2 vTexcoord;
attribute vec2 aOfs;
void main(void) {
vCol = aCol;
vTexcoord = aTexcoord;
vec4 pos = prMatrix * mvMatrix * vec4(aPos, 1.);
pos = pos/pos.w;
gl_Position = pos + vec4(aOfs, 0.,0.);
}
</script>
<script id="testglfshader16" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
varying vec2 vTexcoord;
uniform sampler2D uSampler;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
vec4 textureColor = lighteffect*texture2D(uSampler, vTexcoord);
if (textureColor.a < 0.1)
discard;
else
gl_FragColor = textureColor;
}
</script> 
<!-- ****** lines object 17 ****** -->
<script id="testglvshader17" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
void main(void) {
vPosition = mvMatrix * vec4(aPos, 1.);
gl_Position = prMatrix * vPosition;
vCol = aCol;
}
</script>
<script id="testglfshader17" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
void main(void) {
vec4 colDiff = vCol;
vec4 lighteffect = colDiff;
gl_FragColor = lighteffect;
}
</script> 
<script type="text/javascript"> 
function getShader ( gl, id ){
var shaderScript = document.getElementById ( id );
var str = "";
var k = shaderScript.firstChild;
while ( k ){
if ( k.nodeType == 3 ) str += k.textContent;
k = k.nextSibling;
}
var shader;
if ( shaderScript.type == "x-shader/x-fragment" )
shader = gl.createShader ( gl.FRAGMENT_SHADER );
else if ( shaderScript.type == "x-shader/x-vertex" )
shader = gl.createShader(gl.VERTEX_SHADER);
else return null;
gl.shaderSource(shader, str);
gl.compileShader(shader);
if (gl.getShaderParameter(shader, gl.COMPILE_STATUS) == 0)
alert(gl.getShaderInfoLog(shader));
return shader;
}
var min = Math.min;
var max = Math.max;
var sqrt = Math.sqrt;
var sin = Math.sin;
var acos = Math.acos;
var tan = Math.tan;
var SQRT2 = Math.SQRT2;
var PI = Math.PI;
var log = Math.log;
var exp = Math.exp;
function testglwebGLStart() {
var debug = function(msg) {
document.getElementById("testgldebug").innerHTML = msg;
}
debug("");
var canvas = document.getElementById("testglcanvas");
if (!window.WebGLRenderingContext){
debug(" Your browser does not support WebGL. See <a href=\"http://get.webgl.org\">http://get.webgl.org</a>");
return;
}
var gl;
try {
// Try to grab the standard context. If it fails, fallback to experimental.
gl = canvas.getContext("webgl") 
|| canvas.getContext("experimental-webgl");
}
catch(e) {}
if ( !gl ) {
debug(" Your browser appears to support WebGL, but did not create a WebGL context.  See <a href=\"http://get.webgl.org\">http://get.webgl.org</a>");
return;
}
var width = 505;  var height = 505;
canvas.width = width;   canvas.height = height;
gl.viewport(0, 0, width, height);
var prMatrix = new CanvasMatrix4();
var mvMatrix = new CanvasMatrix4();
var normMatrix = new CanvasMatrix4();
var saveMat = new CanvasMatrix4();
saveMat.makeIdentity();
var distance;
var posLoc = 0;
var colLoc = 1;
var zoom = 1;
var fov = 30;
var userMatrix = new CanvasMatrix4();
userMatrix.load([
1, 0, 0, 0,
0, 0.3420201, -0.9396926, 0,
0, 0.9396926, 0.3420201, 0,
0, 0, 0, 1
]);
function getPowerOfTwo(value) {
var pow = 1;
while(pow<value) {
pow *= 2;
}
return pow;
}
function handleLoadedTexture(texture, textureCanvas) {
gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
gl.bindTexture(gl.TEXTURE_2D, texture);
gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, textureCanvas);
gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
gl.generateMipmap(gl.TEXTURE_2D);
gl.bindTexture(gl.TEXTURE_2D, null);
}
function loadImageToTexture(filename, texture) {   
var canvas = document.getElementById("testgltextureCanvas");
var ctx = canvas.getContext("2d");
var image = new Image();
image.onload = function() {
var w = image.width;
var h = image.height;
var canvasX = getPowerOfTwo(w);
var canvasY = getPowerOfTwo(h);
canvas.width = canvasX;
canvas.height = canvasY;
ctx.imageSmoothingEnabled = true;
ctx.drawImage(image, 0, 0, canvasX, canvasY);
handleLoadedTexture(texture, canvas);
drawScene();
}
image.src = filename;
}  	   
function drawTextToCanvas(text, cex) {
var canvasX, canvasY;
var textX, textY;
var textHeight = 20 * cex;
var textColour = "white";
var fontFamily = "Arial";
var backgroundColour = "rgba(0,0,0,0)";
var canvas = document.getElementById("testgltextureCanvas");
var ctx = canvas.getContext("2d");
ctx.font = textHeight+"px "+fontFamily;
canvasX = 1;
var widths = [];
for (var i = 0; i < text.length; i++)  {
widths[i] = ctx.measureText(text[i]).width;
canvasX = (widths[i] > canvasX) ? widths[i] : canvasX;
}	  
canvasX = getPowerOfTwo(canvasX);
var offset = 2*textHeight; // offset to first baseline
var skip = 2*textHeight;   // skip between baselines	  
canvasY = getPowerOfTwo(offset + text.length*skip);
canvas.width = canvasX;
canvas.height = canvasY;
ctx.fillStyle = backgroundColour;
ctx.fillRect(0, 0, ctx.canvas.width, ctx.canvas.height);
ctx.fillStyle = textColour;
ctx.textAlign = "left";
ctx.textBaseline = "alphabetic";
ctx.font = textHeight+"px "+fontFamily;
for(var i = 0; i < text.length; i++) {
textY = i*skip + offset;
ctx.fillText(text[i], 0,  textY);
}
return {canvasX:canvasX, canvasY:canvasY,
widths:widths, textHeight:textHeight,
offset:offset, skip:skip};
}
// ****** points object 6 ******
var prog6  = gl.createProgram();
gl.attachShader(prog6, getShader( gl, "testglvshader6" ));
gl.attachShader(prog6, getShader( gl, "testglfshader6" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog6, 0, "aPos");
gl.bindAttribLocation(prog6, 1, "aCol");
gl.linkProgram(prog6);
var v=new Float32Array([
-3.723899, -1.174808, -2.862073, 1, 0, 0, 1,
-3.427581, -1.046136, -3.662311, 1, 0.007843138, 0, 1,
-2.856955, 1.768426, -2.192704, 1, 0.01176471, 0, 1,
-2.745353, 0.2406146, -3.170748, 1, 0.01960784, 0, 1,
-2.681754, 0.125107, -2.068935, 1, 0.02352941, 0, 1,
-2.66251, 0.4469104, -1.488732, 1, 0.03137255, 0, 1,
-2.526235, -0.6732168, -1.672588, 1, 0.03529412, 0, 1,
-2.508309, -0.4111649, -0.0360541, 1, 0.04313726, 0, 1,
-2.441543, 0.4003249, -0.5142992, 1, 0.04705882, 0, 1,
-2.295571, -1.666941, -1.926674, 1, 0.05490196, 0, 1,
-2.287787, 0.3627476, -1.389838, 1, 0.05882353, 0, 1,
-2.282546, -1.323847, -1.096779, 1, 0.06666667, 0, 1,
-2.262708, -0.6410999, -3.318885, 1, 0.07058824, 0, 1,
-2.226838, 1.075475, -1.081083, 1, 0.07843138, 0, 1,
-2.217201, 0.1440333, -0.5319436, 1, 0.08235294, 0, 1,
-2.21563, 0.2117469, -1.813251, 1, 0.09019608, 0, 1,
-2.162075, 0.03383597, -0.9668435, 1, 0.09411765, 0, 1,
-2.138978, 1.10674, -1.463239, 1, 0.1019608, 0, 1,
-2.114624, -1.557516, -3.144872, 1, 0.1098039, 0, 1,
-2.054815, -1.021594, -2.080229, 1, 0.1137255, 0, 1,
-2.041716, 0.2437096, -1.458344, 1, 0.1215686, 0, 1,
-2.03093, -0.9067695, -2.432555, 1, 0.1254902, 0, 1,
-2.019136, 0.6047248, -1.623301, 1, 0.1333333, 0, 1,
-1.977349, -0.7066426, -0.4081417, 1, 0.1372549, 0, 1,
-1.970206, -1.053511, -2.8851, 1, 0.145098, 0, 1,
-1.944071, 0.7051514, -0.3514828, 1, 0.1490196, 0, 1,
-1.938763, 0.8939622, -1.456001, 1, 0.1568628, 0, 1,
-1.935846, 2.042911, -1.175815, 1, 0.1607843, 0, 1,
-1.921864, 0.4608665, -0.9473923, 1, 0.1686275, 0, 1,
-1.919328, 0.8599289, -4.443442, 1, 0.172549, 0, 1,
-1.897377, -0.7097372, -2.610484, 1, 0.1803922, 0, 1,
-1.884912, 0.6137511, -1.905356, 1, 0.1843137, 0, 1,
-1.877634, 1.527783, -1.809254, 1, 0.1921569, 0, 1,
-1.874858, -0.759961, -1.032975, 1, 0.1960784, 0, 1,
-1.873809, 2.008901, 0.6135783, 1, 0.2039216, 0, 1,
-1.862452, -1.766395, -2.629311, 1, 0.2117647, 0, 1,
-1.854349, 0.2602721, -0.007155344, 1, 0.2156863, 0, 1,
-1.837561, 1.264542, -1.875503, 1, 0.2235294, 0, 1,
-1.832538, -1.889237, -2.495586, 1, 0.227451, 0, 1,
-1.777246, 1.582728, -0.3171376, 1, 0.2352941, 0, 1,
-1.774978, -0.5184366, -2.900842, 1, 0.2392157, 0, 1,
-1.758299, 0.8300139, -0.7440431, 1, 0.2470588, 0, 1,
-1.746577, -0.7187104, -3.694435, 1, 0.2509804, 0, 1,
-1.736207, 1.993243, 0.4305008, 1, 0.2588235, 0, 1,
-1.716181, -0.094064, -1.092216, 1, 0.2627451, 0, 1,
-1.690898, 0.8038301, -1.808931, 1, 0.2705882, 0, 1,
-1.686234, 0.4868247, -2.605466, 1, 0.2745098, 0, 1,
-1.658709, 0.01562309, 0.07279549, 1, 0.282353, 0, 1,
-1.656825, -0.3963818, 0.5054622, 1, 0.2862745, 0, 1,
-1.6376, -0.7628423, -1.511879, 1, 0.2941177, 0, 1,
-1.633225, -0.242143, -2.0538, 1, 0.3019608, 0, 1,
-1.624535, 0.70881, -2.136641, 1, 0.3058824, 0, 1,
-1.606266, 0.05215101, -2.064869, 1, 0.3137255, 0, 1,
-1.585052, 0.2946248, -2.232705, 1, 0.3176471, 0, 1,
-1.572311, 0.3118526, 0.5047471, 1, 0.3254902, 0, 1,
-1.570317, 1.194734, -1.229809, 1, 0.3294118, 0, 1,
-1.567826, -0.17296, -2.332493, 1, 0.3372549, 0, 1,
-1.56532, -2.120637, -3.468659, 1, 0.3411765, 0, 1,
-1.554685, -0.2691471, -1.433374, 1, 0.3490196, 0, 1,
-1.54731, -0.3164389, -1.124996, 1, 0.3529412, 0, 1,
-1.534123, 1.382846, -2.207459, 1, 0.3607843, 0, 1,
-1.533898, 1.638199, -1.79631, 1, 0.3647059, 0, 1,
-1.531584, -1.121698, -2.070215, 1, 0.372549, 0, 1,
-1.531263, -0.6385744, -1.703488, 1, 0.3764706, 0, 1,
-1.524408, 1.135167, -2.15679, 1, 0.3843137, 0, 1,
-1.516702, -1.717699, -0.2307149, 1, 0.3882353, 0, 1,
-1.513676, -0.1784227, -2.309049, 1, 0.3960784, 0, 1,
-1.480342, 0.2612963, 0.1157612, 1, 0.4039216, 0, 1,
-1.479178, 1.271563, -0.5533691, 1, 0.4078431, 0, 1,
-1.477872, 0.1235162, -1.493248, 1, 0.4156863, 0, 1,
-1.46774, -1.4985, -1.608544, 1, 0.4196078, 0, 1,
-1.465721, -0.9588265, -2.554334, 1, 0.427451, 0, 1,
-1.452213, 0.122277, -3.730535, 1, 0.4313726, 0, 1,
-1.433094, 1.007091, 0.2511797, 1, 0.4392157, 0, 1,
-1.431287, -1.084143, -1.536043, 1, 0.4431373, 0, 1,
-1.420476, 0.188948, -3.860354, 1, 0.4509804, 0, 1,
-1.420127, 0.7835695, -0.2178158, 1, 0.454902, 0, 1,
-1.409853, -1.01944, -2.255015, 1, 0.4627451, 0, 1,
-1.398638, 1.702523, -1.205677, 1, 0.4666667, 0, 1,
-1.391266, 0.5024824, 0.2966643, 1, 0.4745098, 0, 1,
-1.384546, 0.002228824, -0.2917655, 1, 0.4784314, 0, 1,
-1.380774, -0.9266812, -3.306605, 1, 0.4862745, 0, 1,
-1.379075, -3.17163, -1.279858, 1, 0.4901961, 0, 1,
-1.375972, -0.4229557, -1.301228, 1, 0.4980392, 0, 1,
-1.375, 0.8497379, -0.4834183, 1, 0.5058824, 0, 1,
-1.357174, -1.182973, -2.882634, 1, 0.509804, 0, 1,
-1.354338, 2.054375, -1.403988, 1, 0.5176471, 0, 1,
-1.342606, -0.8873053, -0.3400687, 1, 0.5215687, 0, 1,
-1.328409, -1.337338, -4.252946, 1, 0.5294118, 0, 1,
-1.326784, 0.2472245, -1.012787, 1, 0.5333334, 0, 1,
-1.326282, -1.222264, -2.951963, 1, 0.5411765, 0, 1,
-1.315873, -1.711876, -3.596144, 1, 0.5450981, 0, 1,
-1.31551, -0.07759126, -1.365808, 1, 0.5529412, 0, 1,
-1.312093, 1.841865, -0.6149846, 1, 0.5568628, 0, 1,
-1.306495, 0.6486217, -1.843791, 1, 0.5647059, 0, 1,
-1.277099, 0.7508245, -1.742489, 1, 0.5686275, 0, 1,
-1.275854, -0.7060663, -3.718202, 1, 0.5764706, 0, 1,
-1.26518, -1.074411, -2.535691, 1, 0.5803922, 0, 1,
-1.263208, 1.054984, -1.747445, 1, 0.5882353, 0, 1,
-1.260049, 0.3120326, -0.9420762, 1, 0.5921569, 0, 1,
-1.249361, 1.171309, -0.1068759, 1, 0.6, 0, 1,
-1.247665, -2.091709, -1.352006, 1, 0.6078432, 0, 1,
-1.232593, -0.371849, -0.9146267, 1, 0.6117647, 0, 1,
-1.229744, 0.3772203, -1.521757, 1, 0.6196079, 0, 1,
-1.22637, 1.548563, -3.168191, 1, 0.6235294, 0, 1,
-1.219944, -0.5241567, 0.2958312, 1, 0.6313726, 0, 1,
-1.214711, -0.2753627, -2.563764, 1, 0.6352941, 0, 1,
-1.214475, -2.130125, -1.432373, 1, 0.6431373, 0, 1,
-1.212931, 0.886436, -0.1951925, 1, 0.6470588, 0, 1,
-1.21047, -0.5805226, -1.381491, 1, 0.654902, 0, 1,
-1.209921, -1.031795, -0.5499772, 1, 0.6588235, 0, 1,
-1.202962, 0.2296205, -2.750332, 1, 0.6666667, 0, 1,
-1.202355, -0.4142951, -1.578118, 1, 0.6705883, 0, 1,
-1.202267, 0.3736885, -1.973356, 1, 0.6784314, 0, 1,
-1.200779, 1.301898, 1.47926, 1, 0.682353, 0, 1,
-1.193274, 1.700287, -1.018995, 1, 0.6901961, 0, 1,
-1.18969, 1.607534, -0.3525928, 1, 0.6941177, 0, 1,
-1.182851, 1.436274, -0.6513256, 1, 0.7019608, 0, 1,
-1.178394, 1.549653, -1.214149, 1, 0.7098039, 0, 1,
-1.178331, -1.847076, -1.818654, 1, 0.7137255, 0, 1,
-1.169384, -0.4526452, -1.315933, 1, 0.7215686, 0, 1,
-1.166657, 0.6640505, -1.045324, 1, 0.7254902, 0, 1,
-1.160016, -0.9118068, -1.012875, 1, 0.7333333, 0, 1,
-1.158184, -0.746667, -0.2811581, 1, 0.7372549, 0, 1,
-1.15796, 0.3947643, -0.7762097, 1, 0.7450981, 0, 1,
-1.157863, -0.6784438, -3.220386, 1, 0.7490196, 0, 1,
-1.15343, -0.4830916, -1.444741, 1, 0.7568628, 0, 1,
-1.152031, 0.5873079, -1.720062, 1, 0.7607843, 0, 1,
-1.14351, -2.1738, -3.184777, 1, 0.7686275, 0, 1,
-1.139587, -0.243955, -1.315385, 1, 0.772549, 0, 1,
-1.133249, 1.670914, -0.763754, 1, 0.7803922, 0, 1,
-1.118662, -0.544989, -1.019055, 1, 0.7843137, 0, 1,
-1.113919, 0.2686984, -1.225195, 1, 0.7921569, 0, 1,
-1.111533, 0.1206992, -0.2911318, 1, 0.7960784, 0, 1,
-1.110883, -0.5396878, -3.587186, 1, 0.8039216, 0, 1,
-1.109533, -0.1920408, -1.351721, 1, 0.8117647, 0, 1,
-1.106144, 0.7112145, 0.3568049, 1, 0.8156863, 0, 1,
-1.094858, -0.1813561, -2.907635, 1, 0.8235294, 0, 1,
-1.090395, -1.892464, -1.737422, 1, 0.827451, 0, 1,
-1.089164, 0.6366993, -1.625497, 1, 0.8352941, 0, 1,
-1.085682, 1.024064, -0.006786657, 1, 0.8392157, 0, 1,
-1.082935, -0.07153133, -1.604334, 1, 0.8470588, 0, 1,
-1.080158, -0.2055272, 0.4760721, 1, 0.8509804, 0, 1,
-1.069755, 1.365724, 0.3255536, 1, 0.8588235, 0, 1,
-1.068752, 0.3391646, -2.616983, 1, 0.8627451, 0, 1,
-1.059767, -0.6150755, -0.7839214, 1, 0.8705882, 0, 1,
-1.057288, -0.7513286, -4.231937, 1, 0.8745098, 0, 1,
-1.047174, 0.9745672, 0.2892236, 1, 0.8823529, 0, 1,
-1.044325, -0.4916867, -3.618618, 1, 0.8862745, 0, 1,
-1.042585, -1.504911, -2.763294, 1, 0.8941177, 0, 1,
-1.042019, 0.1742235, -1.350734, 1, 0.8980392, 0, 1,
-1.038723, 3.069173, 1.804098, 1, 0.9058824, 0, 1,
-1.037058, -0.2010946, -1.941719, 1, 0.9137255, 0, 1,
-1.03471, 0.684829, -1.818503, 1, 0.9176471, 0, 1,
-1.032407, 0.06768111, -0.1058617, 1, 0.9254902, 0, 1,
-1.02911, -2.40325, -2.616132, 1, 0.9294118, 0, 1,
-1.028319, 0.1361324, -0.7393107, 1, 0.9372549, 0, 1,
-1.024102, 0.4276702, -2.020425, 1, 0.9411765, 0, 1,
-1.022834, 2.300011, 0.2386485, 1, 0.9490196, 0, 1,
-1.019978, 1.933495, -2.030977, 1, 0.9529412, 0, 1,
-1.01494, -1.708348, -1.505744, 1, 0.9607843, 0, 1,
-1.014636, 0.5924899, -3.377526, 1, 0.9647059, 0, 1,
-1.01406, -1.048644, -2.120661, 1, 0.972549, 0, 1,
-1.005623, -0.4116699, -1.162693, 1, 0.9764706, 0, 1,
-0.9980236, 0.3999331, -0.3976511, 1, 0.9843137, 0, 1,
-0.9928768, 0.7424904, -3.236729, 1, 0.9882353, 0, 1,
-0.9917351, 1.246032, 1.274782, 1, 0.9960784, 0, 1,
-0.9915358, -1.298971, -1.37257, 0.9960784, 1, 0, 1,
-0.9896742, -0.9418274, -2.885436, 0.9921569, 1, 0, 1,
-0.9862204, 0.6868169, -1.360128, 0.9843137, 1, 0, 1,
-0.9861142, -0.8857446, -3.189615, 0.9803922, 1, 0, 1,
-0.9817488, 0.3675374, 0.1046237, 0.972549, 1, 0, 1,
-0.9807053, 0.08887215, 1.450502, 0.9686275, 1, 0, 1,
-0.9782221, 0.8134556, -1.304634, 0.9607843, 1, 0, 1,
-0.9670976, 0.6341242, 0.3571605, 0.9568627, 1, 0, 1,
-0.9541621, -2.565286, -2.007432, 0.9490196, 1, 0, 1,
-0.953723, -0.4062905, -2.54193, 0.945098, 1, 0, 1,
-0.9489968, -0.5524504, -2.989305, 0.9372549, 1, 0, 1,
-0.9475687, -1.904708, -0.4930968, 0.9333333, 1, 0, 1,
-0.9422081, -0.7164491, -2.686351, 0.9254902, 1, 0, 1,
-0.9415932, 0.1665552, -2.711516, 0.9215686, 1, 0, 1,
-0.9406415, -0.0717074, -2.670455, 0.9137255, 1, 0, 1,
-0.9363099, -1.162486, -0.4412647, 0.9098039, 1, 0, 1,
-0.9298937, 0.756157, 0.8430582, 0.9019608, 1, 0, 1,
-0.9284343, -0.2440782, -4.254698, 0.8941177, 1, 0, 1,
-0.9269251, 0.7464315, -0.2320329, 0.8901961, 1, 0, 1,
-0.925631, 0.1833154, -2.324828, 0.8823529, 1, 0, 1,
-0.9196384, 0.388375, -1.628374, 0.8784314, 1, 0, 1,
-0.9173442, 0.5180275, 0.1618702, 0.8705882, 1, 0, 1,
-0.9075341, -0.6074507, -2.167737, 0.8666667, 1, 0, 1,
-0.9028065, 7.038956e-05, -3.026059, 0.8588235, 1, 0, 1,
-0.9025725, 1.723501, -2.078718, 0.854902, 1, 0, 1,
-0.9023467, -0.7989613, -4.125688, 0.8470588, 1, 0, 1,
-0.9020711, 0.2846987, -1.520527, 0.8431373, 1, 0, 1,
-0.8979169, 1.042127, -0.4707444, 0.8352941, 1, 0, 1,
-0.8975903, -0.02755251, -3.573378, 0.8313726, 1, 0, 1,
-0.8930877, -0.8690515, -1.603424, 0.8235294, 1, 0, 1,
-0.8867748, -0.7831473, -2.697576, 0.8196079, 1, 0, 1,
-0.8799019, -0.5216552, -3.580835, 0.8117647, 1, 0, 1,
-0.8764384, 0.1062869, -1.969172, 0.8078431, 1, 0, 1,
-0.871517, 1.052297, -1.87975, 0.8, 1, 0, 1,
-0.8710625, -1.509137, -3.692944, 0.7921569, 1, 0, 1,
-0.8686125, -1.951546, -3.252637, 0.7882353, 1, 0, 1,
-0.8684798, -0.5745999, -2.035099, 0.7803922, 1, 0, 1,
-0.8676553, -0.1973071, -1.729902, 0.7764706, 1, 0, 1,
-0.8675202, -0.4982095, -1.464818, 0.7686275, 1, 0, 1,
-0.8625978, 0.7465076, -2.438119, 0.7647059, 1, 0, 1,
-0.8594957, 0.8632941, -0.7147896, 0.7568628, 1, 0, 1,
-0.8577256, -0.5372536, -2.193124, 0.7529412, 1, 0, 1,
-0.8576042, 0.4314426, -2.840227, 0.7450981, 1, 0, 1,
-0.8564775, 0.8602703, 0.4393331, 0.7411765, 1, 0, 1,
-0.8549018, 1.452168, -0.3714827, 0.7333333, 1, 0, 1,
-0.8548387, 0.02232319, -2.661909, 0.7294118, 1, 0, 1,
-0.8538951, -0.7157273, -1.658383, 0.7215686, 1, 0, 1,
-0.8534085, 0.2081508, -1.598811, 0.7176471, 1, 0, 1,
-0.8487267, -0.2409144, -0.1646694, 0.7098039, 1, 0, 1,
-0.8451462, 0.5875477, -0.6962743, 0.7058824, 1, 0, 1,
-0.8403758, 1.805352, 0.239357, 0.6980392, 1, 0, 1,
-0.837243, 0.2734775, -0.7045823, 0.6901961, 1, 0, 1,
-0.8332328, 1.292477, -1.078595, 0.6862745, 1, 0, 1,
-0.8306068, -0.8487861, -1.739327, 0.6784314, 1, 0, 1,
-0.828477, 0.6807617, -1.153495, 0.6745098, 1, 0, 1,
-0.8252169, 0.25244, -1.145994, 0.6666667, 1, 0, 1,
-0.8166401, 0.5377196, -1.690366, 0.6627451, 1, 0, 1,
-0.8153032, 0.3979036, 0.5892745, 0.654902, 1, 0, 1,
-0.8025857, 0.4462683, 0.5679225, 0.6509804, 1, 0, 1,
-0.7877355, 1.852253, -0.5219038, 0.6431373, 1, 0, 1,
-0.7849736, 1.540838, -0.2934482, 0.6392157, 1, 0, 1,
-0.779898, -0.4080557, -3.410397, 0.6313726, 1, 0, 1,
-0.7773473, 0.3576979, -1.557213, 0.627451, 1, 0, 1,
-0.7770708, 0.2300803, 0.5146928, 0.6196079, 1, 0, 1,
-0.7733723, 1.006953, 1.998977, 0.6156863, 1, 0, 1,
-0.7730039, -0.9472206, -2.626283, 0.6078432, 1, 0, 1,
-0.7709777, -0.5264447, -1.35644, 0.6039216, 1, 0, 1,
-0.7692652, 1.056177, -0.4312863, 0.5960785, 1, 0, 1,
-0.7656419, 0.7534432, -0.8913898, 0.5882353, 1, 0, 1,
-0.7602975, 0.4820208, -2.900633, 0.5843138, 1, 0, 1,
-0.7602549, 0.4262793, -1.137708, 0.5764706, 1, 0, 1,
-0.7596326, 0.492118, -2.186286, 0.572549, 1, 0, 1,
-0.7520473, 1.239595, -1.653391, 0.5647059, 1, 0, 1,
-0.7492434, 0.4445724, -1.34607, 0.5607843, 1, 0, 1,
-0.7489356, -1.210599, -2.510075, 0.5529412, 1, 0, 1,
-0.7447134, 2.000248, 0.8100493, 0.5490196, 1, 0, 1,
-0.7373448, 0.6777617, -0.6248254, 0.5411765, 1, 0, 1,
-0.7345873, -0.390019, -1.28211, 0.5372549, 1, 0, 1,
-0.7326894, 0.5721838, -0.742907, 0.5294118, 1, 0, 1,
-0.7321822, -0.2121645, -1.724021, 0.5254902, 1, 0, 1,
-0.7307193, 0.5867652, -1.252678, 0.5176471, 1, 0, 1,
-0.7231988, 0.06559078, -3.020811, 0.5137255, 1, 0, 1,
-0.719531, 0.3040597, -1.085294, 0.5058824, 1, 0, 1,
-0.715444, 0.143363, -1.07073, 0.5019608, 1, 0, 1,
-0.7137702, 2.281805, 1.188481, 0.4941176, 1, 0, 1,
-0.7069963, 0.08719819, -1.002139, 0.4862745, 1, 0, 1,
-0.7062987, -0.9890946, -1.793462, 0.4823529, 1, 0, 1,
-0.7047905, 0.8330279, -1.079168, 0.4745098, 1, 0, 1,
-0.6955718, 0.9987524, -1.485139, 0.4705882, 1, 0, 1,
-0.6888917, -0.05709499, -0.4084838, 0.4627451, 1, 0, 1,
-0.6789625, -1.774471, -3.332248, 0.4588235, 1, 0, 1,
-0.6736014, 0.8113593, -0.8763199, 0.4509804, 1, 0, 1,
-0.673098, 0.9687696, -0.2112656, 0.4470588, 1, 0, 1,
-0.6730584, -1.600206, -0.7999105, 0.4392157, 1, 0, 1,
-0.671514, 1.331513, 1.058506, 0.4352941, 1, 0, 1,
-0.6689327, 2.298997, 1.301666, 0.427451, 1, 0, 1,
-0.6685575, 1.555475, 1.266017, 0.4235294, 1, 0, 1,
-0.6620339, 0.7869548, 1.236279, 0.4156863, 1, 0, 1,
-0.6583707, 0.9180353, 1.344533, 0.4117647, 1, 0, 1,
-0.6580484, -1.058225, -1.019417, 0.4039216, 1, 0, 1,
-0.6521081, 0.6903294, 0.05761723, 0.3960784, 1, 0, 1,
-0.649554, 0.1535451, -2.587261, 0.3921569, 1, 0, 1,
-0.6487852, -1.620428, -4.235984, 0.3843137, 1, 0, 1,
-0.6456727, -2.158959, -2.13879, 0.3803922, 1, 0, 1,
-0.6405653, -0.6007341, -1.905224, 0.372549, 1, 0, 1,
-0.6391456, 0.8935215, -0.4301025, 0.3686275, 1, 0, 1,
-0.6322663, -1.304669, -0.9993231, 0.3607843, 1, 0, 1,
-0.6283665, -0.5170739, -2.663906, 0.3568628, 1, 0, 1,
-0.6265903, 0.5898218, -1.231476, 0.3490196, 1, 0, 1,
-0.6257271, 1.350941, 0.2680455, 0.345098, 1, 0, 1,
-0.6225688, 0.3415103, -0.8385779, 0.3372549, 1, 0, 1,
-0.6211084, 0.5968934, -1.663081, 0.3333333, 1, 0, 1,
-0.6194851, 0.3723135, -0.3600534, 0.3254902, 1, 0, 1,
-0.6192177, -0.5856976, -3.255728, 0.3215686, 1, 0, 1,
-0.6129084, 0.2223195, -1.225157, 0.3137255, 1, 0, 1,
-0.6125401, -0.7657807, -2.843093, 0.3098039, 1, 0, 1,
-0.6095012, -1.405129, -2.097104, 0.3019608, 1, 0, 1,
-0.6094169, 2.212696, -0.6712692, 0.2941177, 1, 0, 1,
-0.6092088, 0.5370407, -0.6515899, 0.2901961, 1, 0, 1,
-0.6077462, -0.865242, -2.933602, 0.282353, 1, 0, 1,
-0.5952857, 0.5158493, -0.2696256, 0.2784314, 1, 0, 1,
-0.5942753, 0.6144778, -1.935609, 0.2705882, 1, 0, 1,
-0.593652, -0.05394804, -0.7797351, 0.2666667, 1, 0, 1,
-0.5936019, -0.3094763, -3.118197, 0.2588235, 1, 0, 1,
-0.5931416, 1.073322, -0.6422964, 0.254902, 1, 0, 1,
-0.5930872, -0.1315962, -2.143291, 0.2470588, 1, 0, 1,
-0.5905653, 0.5934852, -0.4890686, 0.2431373, 1, 0, 1,
-0.5883543, -0.2479481, -0.9154258, 0.2352941, 1, 0, 1,
-0.5876809, -1.122548, -3.571324, 0.2313726, 1, 0, 1,
-0.5851306, -0.008164575, -0.3191325, 0.2235294, 1, 0, 1,
-0.5842478, -1.548167, -2.863144, 0.2196078, 1, 0, 1,
-0.582523, -1.352774, -1.888158, 0.2117647, 1, 0, 1,
-0.5804369, 0.1885044, -0.9767566, 0.2078431, 1, 0, 1,
-0.5778699, -0.7828351, -2.601956, 0.2, 1, 0, 1,
-0.566164, -0.8313401, -1.777196, 0.1921569, 1, 0, 1,
-0.557835, 0.7832905, -1.518665, 0.1882353, 1, 0, 1,
-0.5542786, 1.88116, 0.516654, 0.1803922, 1, 0, 1,
-0.5529186, 0.5815513, 0.3096565, 0.1764706, 1, 0, 1,
-0.5441342, 1.176482, -0.05496055, 0.1686275, 1, 0, 1,
-0.5359592, 1.062843, 0.6487893, 0.1647059, 1, 0, 1,
-0.5342416, -1.150717, -4.325399, 0.1568628, 1, 0, 1,
-0.5333458, 0.974741, -1.662406, 0.1529412, 1, 0, 1,
-0.5328038, 0.6232508, -0.541736, 0.145098, 1, 0, 1,
-0.5314077, -0.3804938, -1.677499, 0.1411765, 1, 0, 1,
-0.528649, -0.8001954, -2.648802, 0.1333333, 1, 0, 1,
-0.5283719, 0.6544627, 0.6884134, 0.1294118, 1, 0, 1,
-0.523703, 0.3048748, -0.8674229, 0.1215686, 1, 0, 1,
-0.5215252, -1.793809, -3.510428, 0.1176471, 1, 0, 1,
-0.5200726, -1.497682, -3.162356, 0.1098039, 1, 0, 1,
-0.5194336, 1.777109, -0.4629432, 0.1058824, 1, 0, 1,
-0.5193478, -0.1968173, -2.688241, 0.09803922, 1, 0, 1,
-0.5128958, 0.7947276, -1.586786, 0.09019608, 1, 0, 1,
-0.5116058, 1.751951, 1.253453, 0.08627451, 1, 0, 1,
-0.5101643, -1.496249, -2.322425, 0.07843138, 1, 0, 1,
-0.5099733, -0.1879501, -2.659186, 0.07450981, 1, 0, 1,
-0.5086982, -0.3571709, -2.979491, 0.06666667, 1, 0, 1,
-0.4958898, -0.1454751, -1.31997, 0.0627451, 1, 0, 1,
-0.4944299, 1.63589, -1.233735, 0.05490196, 1, 0, 1,
-0.4943055, 0.1825204, -2.011615, 0.05098039, 1, 0, 1,
-0.4933615, -1.589053, -2.261135, 0.04313726, 1, 0, 1,
-0.4919859, 0.7399005, -2.240518, 0.03921569, 1, 0, 1,
-0.4886889, 1.183836, -1.685206, 0.03137255, 1, 0, 1,
-0.4883292, 0.4011457, -0.2510886, 0.02745098, 1, 0, 1,
-0.4859614, -1.082812, -1.815034, 0.01960784, 1, 0, 1,
-0.4851987, 1.598418, 0.2145436, 0.01568628, 1, 0, 1,
-0.4827231, -2.408318, -3.312909, 0.007843138, 1, 0, 1,
-0.4805069, 0.7166181, -0.1211463, 0.003921569, 1, 0, 1,
-0.4796414, -0.5433568, -2.382306, 0, 1, 0.003921569, 1,
-0.4775812, 0.09788524, -1.546093, 0, 1, 0.01176471, 1,
-0.4728524, 1.563186, -1.432648, 0, 1, 0.01568628, 1,
-0.4726515, 1.949304, -1.154336, 0, 1, 0.02352941, 1,
-0.4688212, 1.258659, 0.2868575, 0, 1, 0.02745098, 1,
-0.4687471, 1.407343, 0.1734399, 0, 1, 0.03529412, 1,
-0.4682401, -0.1094442, -1.703588, 0, 1, 0.03921569, 1,
-0.4654428, 1.69856, -1.417909, 0, 1, 0.04705882, 1,
-0.4637203, 0.4884702, -1.016355, 0, 1, 0.05098039, 1,
-0.4614093, 2.100477, -1.499217, 0, 1, 0.05882353, 1,
-0.4550155, -0.8728124, -2.978377, 0, 1, 0.0627451, 1,
-0.4544562, 0.953149, -0.7472581, 0, 1, 0.07058824, 1,
-0.4520197, -0.4509206, -1.61831, 0, 1, 0.07450981, 1,
-0.4519918, -1.466117, -3.225052, 0, 1, 0.08235294, 1,
-0.4514574, 0.4118111, -0.1263017, 0, 1, 0.08627451, 1,
-0.4474753, -0.1717925, -3.341898, 0, 1, 0.09411765, 1,
-0.4442485, -0.664884, -2.165685, 0, 1, 0.1019608, 1,
-0.4441818, -1.366904, -0.7420105, 0, 1, 0.1058824, 1,
-0.4435645, -0.6470314, -3.157138, 0, 1, 0.1137255, 1,
-0.4409784, -0.9484434, -3.429233, 0, 1, 0.1176471, 1,
-0.4403009, 0.3640505, -2.702812, 0, 1, 0.1254902, 1,
-0.4401521, -0.9816712, -3.652213, 0, 1, 0.1294118, 1,
-0.4375425, 0.3422718, -2.166455, 0, 1, 0.1372549, 1,
-0.4354239, -0.1344417, -1.410137, 0, 1, 0.1411765, 1,
-0.4349791, 0.7459281, -0.3471935, 0, 1, 0.1490196, 1,
-0.4326984, 0.1276533, -0.1141622, 0, 1, 0.1529412, 1,
-0.4323543, -0.2539048, -1.94356, 0, 1, 0.1607843, 1,
-0.4294159, -0.800072, -2.381454, 0, 1, 0.1647059, 1,
-0.4280309, 1.162404, 1.179402, 0, 1, 0.172549, 1,
-0.4264165, -1.736774, -3.871756, 0, 1, 0.1764706, 1,
-0.4187451, 1.761264, -0.8733773, 0, 1, 0.1843137, 1,
-0.4185766, -0.9387845, -1.897371, 0, 1, 0.1882353, 1,
-0.4153437, -2.129217, -4.246303, 0, 1, 0.1960784, 1,
-0.4152058, -0.6694384, -3.612054, 0, 1, 0.2039216, 1,
-0.4151545, 2.724159, 0.08865369, 0, 1, 0.2078431, 1,
-0.4133289, 1.914767, -0.692538, 0, 1, 0.2156863, 1,
-0.412002, -1.345304, -2.526165, 0, 1, 0.2196078, 1,
-0.406084, -0.7818443, -2.363255, 0, 1, 0.227451, 1,
-0.4033222, 0.897242, 0.0672015, 0, 1, 0.2313726, 1,
-0.3976374, 0.9927598, -0.8725573, 0, 1, 0.2392157, 1,
-0.3970765, -0.5028359, -3.115244, 0, 1, 0.2431373, 1,
-0.3941162, 0.5984747, 0.9401685, 0, 1, 0.2509804, 1,
-0.3927709, 1.108141, -0.8647085, 0, 1, 0.254902, 1,
-0.3905289, -0.1344073, -2.879965, 0, 1, 0.2627451, 1,
-0.382215, 1.337826, 1.656813, 0, 1, 0.2666667, 1,
-0.3775682, 0.4681113, -1.899514, 0, 1, 0.2745098, 1,
-0.3768777, 1.344673, -1.406092, 0, 1, 0.2784314, 1,
-0.3715016, -1.953075, -4.704878, 0, 1, 0.2862745, 1,
-0.3684815, -0.2896957, -2.208179, 0, 1, 0.2901961, 1,
-0.3662277, -0.1404953, -3.125173, 0, 1, 0.2980392, 1,
-0.3647585, -0.2754808, -1.950336, 0, 1, 0.3058824, 1,
-0.3610064, -1.518005, -0.9797122, 0, 1, 0.3098039, 1,
-0.3580893, -1.798972, -0.4509198, 0, 1, 0.3176471, 1,
-0.3579046, 1.678135, 0.03435731, 0, 1, 0.3215686, 1,
-0.3501363, 1.991986, -0.1130983, 0, 1, 0.3294118, 1,
-0.3479843, -0.5675679, -1.20693, 0, 1, 0.3333333, 1,
-0.3451059, -0.3117804, -1.166415, 0, 1, 0.3411765, 1,
-0.3421208, -1.119484, -3.687862, 0, 1, 0.345098, 1,
-0.3367518, 0.1027041, -1.640107, 0, 1, 0.3529412, 1,
-0.3295338, -1.22802, -4.452396, 0, 1, 0.3568628, 1,
-0.3239605, -1.400671, -1.843893, 0, 1, 0.3647059, 1,
-0.3176321, -0.04186469, -1.804823, 0, 1, 0.3686275, 1,
-0.316764, -0.7591729, -3.493178, 0, 1, 0.3764706, 1,
-0.3046649, 1.714666, 1.682104, 0, 1, 0.3803922, 1,
-0.3038115, -0.4779657, -2.263167, 0, 1, 0.3882353, 1,
-0.3025008, 1.790872, 0.9961182, 0, 1, 0.3921569, 1,
-0.3020713, 2.421164, 1.010174, 0, 1, 0.4, 1,
-0.3016832, 2.04724, 0.7529601, 0, 1, 0.4078431, 1,
-0.2971895, 0.2182152, 0.04991271, 0, 1, 0.4117647, 1,
-0.2930385, -1.487828, -2.367185, 0, 1, 0.4196078, 1,
-0.29241, 0.02100733, -2.239332, 0, 1, 0.4235294, 1,
-0.2887771, 0.6610607, -1.098797, 0, 1, 0.4313726, 1,
-0.2769458, -1.956862, -3.001158, 0, 1, 0.4352941, 1,
-0.2765782, -0.812073, -2.285866, 0, 1, 0.4431373, 1,
-0.2761607, 0.2114933, -1.831257, 0, 1, 0.4470588, 1,
-0.2717141, 2.064219, -1.856286, 0, 1, 0.454902, 1,
-0.2705375, 1.271773, -0.0703478, 0, 1, 0.4588235, 1,
-0.2620989, 1.359803, -1.662506, 0, 1, 0.4666667, 1,
-0.2564563, -1.969959, -2.729268, 0, 1, 0.4705882, 1,
-0.2546789, 0.6616604, -1.359711, 0, 1, 0.4784314, 1,
-0.2537269, -1.448724, -3.666827, 0, 1, 0.4823529, 1,
-0.2527709, 0.6398091, -2.897683, 0, 1, 0.4901961, 1,
-0.2505563, -2.112051, -1.803548, 0, 1, 0.4941176, 1,
-0.2481562, 1.74403, 0.1784381, 0, 1, 0.5019608, 1,
-0.2450086, 0.4760576, -1.897503, 0, 1, 0.509804, 1,
-0.2417189, -0.3302926, -2.523005, 0, 1, 0.5137255, 1,
-0.2412526, -0.07642686, -2.495628, 0, 1, 0.5215687, 1,
-0.2408317, 0.6202224, -0.9741758, 0, 1, 0.5254902, 1,
-0.2392306, 0.04795812, -1.825108, 0, 1, 0.5333334, 1,
-0.2370735, -2.970453, -3.752069, 0, 1, 0.5372549, 1,
-0.2362012, -1.364132, -2.674639, 0, 1, 0.5450981, 1,
-0.235479, -1.749119, -3.461643, 0, 1, 0.5490196, 1,
-0.232811, 1.945419, -1.26102, 0, 1, 0.5568628, 1,
-0.2298447, 2.325963, -0.3968894, 0, 1, 0.5607843, 1,
-0.2287888, 1.294375, -0.5367572, 0, 1, 0.5686275, 1,
-0.2274294, 0.9818897, -1.288346, 0, 1, 0.572549, 1,
-0.2255541, -1.117283, -3.715817, 0, 1, 0.5803922, 1,
-0.2247945, 1.034238, 1.386097, 0, 1, 0.5843138, 1,
-0.2209412, -0.2455634, -2.088492, 0, 1, 0.5921569, 1,
-0.2174088, -1.436874, -5.071074, 0, 1, 0.5960785, 1,
-0.2104547, -0.4521708, -0.367959, 0, 1, 0.6039216, 1,
-0.206596, -0.09323037, -1.245188, 0, 1, 0.6117647, 1,
-0.1967657, -1.019738, -3.179181, 0, 1, 0.6156863, 1,
-0.1942529, 0.4965087, 0.4337484, 0, 1, 0.6235294, 1,
-0.1874661, -0.9081845, -1.640732, 0, 1, 0.627451, 1,
-0.1865413, -1.28369, -4.36593, 0, 1, 0.6352941, 1,
-0.1859539, 2.082825, -1.886939, 0, 1, 0.6392157, 1,
-0.1844535, -0.3354126, -2.317173, 0, 1, 0.6470588, 1,
-0.1832368, -0.1238601, -2.432533, 0, 1, 0.6509804, 1,
-0.1821977, 0.8825371, 0.2383934, 0, 1, 0.6588235, 1,
-0.1765736, 0.8882709, 0.2616142, 0, 1, 0.6627451, 1,
-0.1751654, 1.304005, 0.02551487, 0, 1, 0.6705883, 1,
-0.1715224, -0.516925, -4.751801, 0, 1, 0.6745098, 1,
-0.1670301, -0.8284846, -3.860142, 0, 1, 0.682353, 1,
-0.1662069, 0.1566349, -0.9600564, 0, 1, 0.6862745, 1,
-0.1655815, 0.7188349, -1.131666, 0, 1, 0.6941177, 1,
-0.1640668, 0.2918135, -0.7708285, 0, 1, 0.7019608, 1,
-0.163733, 0.2055128, -0.5047642, 0, 1, 0.7058824, 1,
-0.1623281, -0.3161741, -4.497215, 0, 1, 0.7137255, 1,
-0.1594674, 2.085142, -0.3862026, 0, 1, 0.7176471, 1,
-0.1594054, 0.2768332, -0.7431002, 0, 1, 0.7254902, 1,
-0.1581841, 1.007612, 1.425264, 0, 1, 0.7294118, 1,
-0.1578033, 0.6693347, -0.2144346, 0, 1, 0.7372549, 1,
-0.154669, -0.4484975, -2.129242, 0, 1, 0.7411765, 1,
-0.1401004, -0.135916, -1.116733, 0, 1, 0.7490196, 1,
-0.1378451, -0.2454336, -3.045907, 0, 1, 0.7529412, 1,
-0.1373704, 1.164101, -0.6825094, 0, 1, 0.7607843, 1,
-0.132794, -1.304702, -3.339282, 0, 1, 0.7647059, 1,
-0.1283028, 1.3845, -1.155197, 0, 1, 0.772549, 1,
-0.127091, 0.8022229, -1.14697, 0, 1, 0.7764706, 1,
-0.1259235, -1.338845, -2.728697, 0, 1, 0.7843137, 1,
-0.1179273, 1.68036, -1.094882, 0, 1, 0.7882353, 1,
-0.1178817, -0.5821235, -3.016975, 0, 1, 0.7960784, 1,
-0.1131316, -1.042141, -3.670077, 0, 1, 0.8039216, 1,
-0.1075908, -0.8904693, -4.025469, 0, 1, 0.8078431, 1,
-0.1064875, 0.3103443, -0.9307585, 0, 1, 0.8156863, 1,
-0.106221, 0.1283565, 0.4528971, 0, 1, 0.8196079, 1,
-0.1035988, -0.3131643, -0.6050877, 0, 1, 0.827451, 1,
-0.1019115, 0.09626864, 0.005074059, 0, 1, 0.8313726, 1,
-0.1007378, 0.2947959, -2.595794, 0, 1, 0.8392157, 1,
-0.1005616, 0.08585789, -0.4095171, 0, 1, 0.8431373, 1,
-0.09830789, -0.6308268, -3.092365, 0, 1, 0.8509804, 1,
-0.09692983, 1.027628, -1.6451, 0, 1, 0.854902, 1,
-0.09485804, -0.2258326, -1.737706, 0, 1, 0.8627451, 1,
-0.09331537, -1.586803, -2.608293, 0, 1, 0.8666667, 1,
-0.08621641, 1.160919, -0.180584, 0, 1, 0.8745098, 1,
-0.08561933, 1.078356, 2.088506, 0, 1, 0.8784314, 1,
-0.0738298, 0.02274955, -1.356405, 0, 1, 0.8862745, 1,
-0.0716133, 0.4230025, -0.5641416, 0, 1, 0.8901961, 1,
-0.07034445, 0.7682059, 0.5323604, 0, 1, 0.8980392, 1,
-0.06782831, -1.095353, -2.608786, 0, 1, 0.9058824, 1,
-0.06336162, 0.04892766, -0.5878607, 0, 1, 0.9098039, 1,
-0.0571797, 0.8599915, 0.2624654, 0, 1, 0.9176471, 1,
-0.05696657, -0.5543167, -2.21932, 0, 1, 0.9215686, 1,
-0.04795164, -0.4179489, -3.968439, 0, 1, 0.9294118, 1,
-0.04591076, 0.1048027, -1.851232, 0, 1, 0.9333333, 1,
-0.04379577, -0.6487277, -1.898105, 0, 1, 0.9411765, 1,
-0.04092681, 0.8498623, 0.8902293, 0, 1, 0.945098, 1,
-0.02433708, 1.305838, -0.9957497, 0, 1, 0.9529412, 1,
-0.0237897, 1.099113, 1.142987, 0, 1, 0.9568627, 1,
-0.01080667, 2.171082, 0.2159214, 0, 1, 0.9647059, 1,
-0.008729436, 0.6840643, 0.6580881, 0, 1, 0.9686275, 1,
-0.007769526, 1.103421, 1.080129, 0, 1, 0.9764706, 1,
-0.007161918, -0.4048029, -3.934758, 0, 1, 0.9803922, 1,
-0.006930724, 0.9956631, 1.469314, 0, 1, 0.9882353, 1,
0.001219539, 0.1591457, -2.82713, 0, 1, 0.9921569, 1,
0.001704833, -0.4918649, 3.162894, 0, 1, 1, 1,
0.003498518, -2.418861, 1.485498, 0, 0.9921569, 1, 1,
0.004007854, 0.9103662, -0.1527204, 0, 0.9882353, 1, 1,
0.008206617, -1.19365, 3.625415, 0, 0.9803922, 1, 1,
0.008997879, -1.139502, 2.664068, 0, 0.9764706, 1, 1,
0.01975908, -1.540097, 3.169292, 0, 0.9686275, 1, 1,
0.02279575, -1.315502, 0.6092227, 0, 0.9647059, 1, 1,
0.02549624, 1.040911, 0.7907414, 0, 0.9568627, 1, 1,
0.02916914, 0.9308298, -0.5159558, 0, 0.9529412, 1, 1,
0.02968654, 1.597827, -1.41127, 0, 0.945098, 1, 1,
0.03391488, 0.6069543, 0.8868778, 0, 0.9411765, 1, 1,
0.03427552, -1.389871, 4.765063, 0, 0.9333333, 1, 1,
0.0374966, -0.2483693, 2.252429, 0, 0.9294118, 1, 1,
0.03828548, 0.4868284, -0.1496562, 0, 0.9215686, 1, 1,
0.03862356, 0.295131, 0.896687, 0, 0.9176471, 1, 1,
0.04113955, -0.4293142, 3.42068, 0, 0.9098039, 1, 1,
0.04192989, -0.1133664, 3.740098, 0, 0.9058824, 1, 1,
0.04373112, -0.8179761, 2.569706, 0, 0.8980392, 1, 1,
0.04766657, 0.5680977, 1.739274, 0, 0.8901961, 1, 1,
0.04921158, 0.4008954, -0.2295268, 0, 0.8862745, 1, 1,
0.05421181, 1.134564, -0.4488359, 0, 0.8784314, 1, 1,
0.0562811, 0.9918744, -0.03317701, 0, 0.8745098, 1, 1,
0.056608, -0.8136622, 1.818212, 0, 0.8666667, 1, 1,
0.05721388, -2.032167, 1.598727, 0, 0.8627451, 1, 1,
0.06462232, 0.4898255, 0.001855613, 0, 0.854902, 1, 1,
0.06632315, -0.4543938, 2.890639, 0, 0.8509804, 1, 1,
0.06893586, 0.4043029, 1.452154, 0, 0.8431373, 1, 1,
0.06988784, 1.702878, 0.9753977, 0, 0.8392157, 1, 1,
0.07008322, -1.035295, 3.760857, 0, 0.8313726, 1, 1,
0.07147398, -0.7576151, 2.771463, 0, 0.827451, 1, 1,
0.07949637, 0.7376404, 0.8568543, 0, 0.8196079, 1, 1,
0.07950726, 0.9894521, 1.642382, 0, 0.8156863, 1, 1,
0.08258402, -1.01035, 3.379025, 0, 0.8078431, 1, 1,
0.08351152, -0.5670342, 4.329869, 0, 0.8039216, 1, 1,
0.08453715, 1.573284, 0.2630222, 0, 0.7960784, 1, 1,
0.08688621, 0.7030022, 0.6941236, 0, 0.7882353, 1, 1,
0.08753577, -0.2630938, 1.900282, 0, 0.7843137, 1, 1,
0.08766748, 0.587421, 2.423946, 0, 0.7764706, 1, 1,
0.08921459, -0.2591272, 3.389663, 0, 0.772549, 1, 1,
0.08980703, 0.02213161, 0.09384505, 0, 0.7647059, 1, 1,
0.09863049, 0.7197552, 2.019261, 0, 0.7607843, 1, 1,
0.09934024, 0.2884066, -1.263398, 0, 0.7529412, 1, 1,
0.1004169, -1.250368, 3.754371, 0, 0.7490196, 1, 1,
0.1016013, -0.6889648, 3.224412, 0, 0.7411765, 1, 1,
0.102411, 0.4119448, -1.244147, 0, 0.7372549, 1, 1,
0.1047624, 0.8803824, 0.2167245, 0, 0.7294118, 1, 1,
0.105026, 1.490113, -1.341156, 0, 0.7254902, 1, 1,
0.1061837, -0.605748, 4.009259, 0, 0.7176471, 1, 1,
0.1089676, 0.9090301, 1.690251, 0, 0.7137255, 1, 1,
0.1091877, -0.2116593, 2.338996, 0, 0.7058824, 1, 1,
0.1146473, -0.7962971, 2.263951, 0, 0.6980392, 1, 1,
0.1155059, -0.4172834, 1.346053, 0, 0.6941177, 1, 1,
0.1271824, -0.7724879, 3.632755, 0, 0.6862745, 1, 1,
0.1281713, -0.8386358, 1.733827, 0, 0.682353, 1, 1,
0.131022, -0.2988588, 3.777316, 0, 0.6745098, 1, 1,
0.1315709, 1.394821, -0.5743017, 0, 0.6705883, 1, 1,
0.1320455, -0.4442372, 2.063958, 0, 0.6627451, 1, 1,
0.1322069, -0.3784429, 1.667121, 0, 0.6588235, 1, 1,
0.1322632, -2.009024, 2.29295, 0, 0.6509804, 1, 1,
0.1343672, 0.6433499, -0.5854139, 0, 0.6470588, 1, 1,
0.1378701, -1.094659, 3.458965, 0, 0.6392157, 1, 1,
0.1451787, 1.009026, 0.7520938, 0, 0.6352941, 1, 1,
0.1464554, -1.375342, 4.227269, 0, 0.627451, 1, 1,
0.1503105, -1.096311, 0.6227301, 0, 0.6235294, 1, 1,
0.156383, -0.6378381, 1.711258, 0, 0.6156863, 1, 1,
0.1566408, -0.3517095, 1.773862, 0, 0.6117647, 1, 1,
0.1603873, 1.156156, 1.288158, 0, 0.6039216, 1, 1,
0.1701992, -0.6686376, 3.038809, 0, 0.5960785, 1, 1,
0.1740813, 1.027394, -0.6929709, 0, 0.5921569, 1, 1,
0.1762539, -0.009505671, 1.661414, 0, 0.5843138, 1, 1,
0.176608, -0.2940746, 1.462149, 0, 0.5803922, 1, 1,
0.1827117, 1.113486, 0.9080405, 0, 0.572549, 1, 1,
0.1843311, -0.6077639, 3.797778, 0, 0.5686275, 1, 1,
0.1870324, -0.7514484, 2.588846, 0, 0.5607843, 1, 1,
0.1901645, 0.3506367, -0.7703125, 0, 0.5568628, 1, 1,
0.1902245, -0.1326771, 3.986285, 0, 0.5490196, 1, 1,
0.1923493, 0.6050991, -1.106044, 0, 0.5450981, 1, 1,
0.195106, 0.651093, 1.551826, 0, 0.5372549, 1, 1,
0.1985198, -1.92744, 1.840496, 0, 0.5333334, 1, 1,
0.2002612, -1.104317, 2.044692, 0, 0.5254902, 1, 1,
0.2004043, -2.324528, 3.460923, 0, 0.5215687, 1, 1,
0.2023895, -0.2789691, 4.510924, 0, 0.5137255, 1, 1,
0.2025931, -0.4017732, 4.643079, 0, 0.509804, 1, 1,
0.2031321, 0.2855789, 0.07793661, 0, 0.5019608, 1, 1,
0.2032727, 0.6643398, 0.05212244, 0, 0.4941176, 1, 1,
0.2043381, 0.911994, 0.9566951, 0, 0.4901961, 1, 1,
0.2070837, 1.473192, 0.1273621, 0, 0.4823529, 1, 1,
0.2104714, 0.1298516, 1.008535, 0, 0.4784314, 1, 1,
0.2153071, 0.7962821, 2.034572, 0, 0.4705882, 1, 1,
0.2182917, 1.900133, 1.090699, 0, 0.4666667, 1, 1,
0.221537, -1.407587, 1.77643, 0, 0.4588235, 1, 1,
0.2248826, -0.1585707, 1.904154, 0, 0.454902, 1, 1,
0.2253325, 0.2003389, 1.023228, 0, 0.4470588, 1, 1,
0.2272464, 1.369725, 1.629763, 0, 0.4431373, 1, 1,
0.2283318, 0.164792, 2.689409, 0, 0.4352941, 1, 1,
0.228458, 1.007949, 0.7786537, 0, 0.4313726, 1, 1,
0.228839, -0.03004916, 3.571068, 0, 0.4235294, 1, 1,
0.229087, -1.805739, 2.316205, 0, 0.4196078, 1, 1,
0.2315847, -0.1826196, 1.222508, 0, 0.4117647, 1, 1,
0.2324234, -1.900572, 2.502908, 0, 0.4078431, 1, 1,
0.2392136, 0.3824268, 0.4140602, 0, 0.4, 1, 1,
0.2408713, -0.1109741, 2.344719, 0, 0.3921569, 1, 1,
0.2417372, 0.3557263, 2.845777, 0, 0.3882353, 1, 1,
0.2457343, -0.9665728, 1.520215, 0, 0.3803922, 1, 1,
0.2458574, 0.4419104, -0.5063123, 0, 0.3764706, 1, 1,
0.2496853, 0.2207559, 0.7786372, 0, 0.3686275, 1, 1,
0.2501015, 1.513384, -2.011081, 0, 0.3647059, 1, 1,
0.2515944, 0.2933091, 0.9445218, 0, 0.3568628, 1, 1,
0.2550042, -0.5897035, 3.165002, 0, 0.3529412, 1, 1,
0.2558642, -0.6979328, 3.176224, 0, 0.345098, 1, 1,
0.2579699, -0.7580149, 3.701447, 0, 0.3411765, 1, 1,
0.2629401, 1.265393, -0.5543393, 0, 0.3333333, 1, 1,
0.2651736, 0.5150576, 1.405641, 0, 0.3294118, 1, 1,
0.2665262, -0.1374635, 2.395699, 0, 0.3215686, 1, 1,
0.2725579, -0.2396232, 1.380778, 0, 0.3176471, 1, 1,
0.2746024, 1.637916, -0.25455, 0, 0.3098039, 1, 1,
0.2794263, 1.043238, 2.195205, 0, 0.3058824, 1, 1,
0.2830888, -0.9327605, 3.668275, 0, 0.2980392, 1, 1,
0.2861455, 0.150933, 0.6546265, 0, 0.2901961, 1, 1,
0.2894072, -0.500652, 1.995234, 0, 0.2862745, 1, 1,
0.2941574, -0.8999793, 3.175024, 0, 0.2784314, 1, 1,
0.296481, -1.047955, 4.302612, 0, 0.2745098, 1, 1,
0.3014125, 0.8859422, -0.5954125, 0, 0.2666667, 1, 1,
0.3020001, -0.5189298, 4.526032, 0, 0.2627451, 1, 1,
0.3083999, -0.8080802, 1.286245, 0, 0.254902, 1, 1,
0.3088281, 0.6253923, 1.102969, 0, 0.2509804, 1, 1,
0.3089657, -0.4603115, 2.354429, 0, 0.2431373, 1, 1,
0.3094393, 1.311688, 0.5760108, 0, 0.2392157, 1, 1,
0.3109975, 0.02130649, 0.9470279, 0, 0.2313726, 1, 1,
0.3123192, 0.366646, 0.7552225, 0, 0.227451, 1, 1,
0.316535, 0.7009294, 1.570801, 0, 0.2196078, 1, 1,
0.3168089, 0.2575646, 2.487049, 0, 0.2156863, 1, 1,
0.3184977, 3.121705, 0.4803089, 0, 0.2078431, 1, 1,
0.3185145, 0.3216442, 1.603574, 0, 0.2039216, 1, 1,
0.3220885, 0.7982969, -1.525609, 0, 0.1960784, 1, 1,
0.3244564, 0.4849475, 0.5351025, 0, 0.1882353, 1, 1,
0.3245281, 2.562411, 2.214167, 0, 0.1843137, 1, 1,
0.3273158, -0.6566982, 1.952061, 0, 0.1764706, 1, 1,
0.3274307, -0.1238267, -0.4741317, 0, 0.172549, 1, 1,
0.3290916, 1.29275, -0.6399808, 0, 0.1647059, 1, 1,
0.3294051, -1.633431, 2.969657, 0, 0.1607843, 1, 1,
0.3358502, -1.82681, 2.910203, 0, 0.1529412, 1, 1,
0.3370827, 1.501302, -0.1669337, 0, 0.1490196, 1, 1,
0.3397537, 0.7819551, 1.1679, 0, 0.1411765, 1, 1,
0.3402136, 0.5892377, 1.336047, 0, 0.1372549, 1, 1,
0.3443763, 0.9477915, -1.105253, 0, 0.1294118, 1, 1,
0.3552937, 1.025213, -0.5800571, 0, 0.1254902, 1, 1,
0.3574571, 0.1093242, 1.556837, 0, 0.1176471, 1, 1,
0.3587462, -2.068061, 1.565969, 0, 0.1137255, 1, 1,
0.3588261, 0.7589513, 0.5045671, 0, 0.1058824, 1, 1,
0.3614353, 1.607722, 1.884711, 0, 0.09803922, 1, 1,
0.362585, -0.4663649, 1.270001, 0, 0.09411765, 1, 1,
0.3656709, 0.3362903, 0.9825829, 0, 0.08627451, 1, 1,
0.3660716, -0.2011558, 2.696351, 0, 0.08235294, 1, 1,
0.3666186, 0.4336534, 0.4939879, 0, 0.07450981, 1, 1,
0.3677468, 0.5113723, 0.923243, 0, 0.07058824, 1, 1,
0.3729932, -1.193949, 1.906034, 0, 0.0627451, 1, 1,
0.3743951, 1.541941, -0.2656077, 0, 0.05882353, 1, 1,
0.376458, 0.7715258, 1.606834, 0, 0.05098039, 1, 1,
0.3810469, 0.866722, 1.816574, 0, 0.04705882, 1, 1,
0.3851114, 0.02908836, 1.268872, 0, 0.03921569, 1, 1,
0.3861769, 0.5189067, 0.943865, 0, 0.03529412, 1, 1,
0.3924732, 0.2312436, 1.193038, 0, 0.02745098, 1, 1,
0.3939469, -0.7990052, 2.065285, 0, 0.02352941, 1, 1,
0.3962613, -0.1719644, 1.179204, 0, 0.01568628, 1, 1,
0.3975469, -1.492169, 3.483827, 0, 0.01176471, 1, 1,
0.3979358, -1.132759, 2.966211, 0, 0.003921569, 1, 1,
0.3981763, 1.565462, -0.03684429, 0.003921569, 0, 1, 1,
0.4011947, 1.438709, -0.4929226, 0.007843138, 0, 1, 1,
0.4060276, -0.5120755, 2.050335, 0.01568628, 0, 1, 1,
0.4132748, 0.8504304, -2.966754, 0.01960784, 0, 1, 1,
0.4135079, -1.435888, 3.797258, 0.02745098, 0, 1, 1,
0.4202137, -0.3198152, 1.194697, 0.03137255, 0, 1, 1,
0.4222249, -0.0252203, 1.00127, 0.03921569, 0, 1, 1,
0.422668, -0.5539824, 2.980556, 0.04313726, 0, 1, 1,
0.4246233, 0.2804804, 1.302208, 0.05098039, 0, 1, 1,
0.4256315, -0.419175, 0.7600357, 0.05490196, 0, 1, 1,
0.4274856, -2.31797, 4.422239, 0.0627451, 0, 1, 1,
0.4275635, -2.011344, 2.005651, 0.06666667, 0, 1, 1,
0.4294135, -0.4282746, 1.393742, 0.07450981, 0, 1, 1,
0.4317306, -1.213405, 4.065571, 0.07843138, 0, 1, 1,
0.4318567, 0.5480385, 0.4303223, 0.08627451, 0, 1, 1,
0.4370883, -0.2950225, 2.489445, 0.09019608, 0, 1, 1,
0.4389149, 0.551809, 0.5013592, 0.09803922, 0, 1, 1,
0.4390755, -0.3858097, 2.974144, 0.1058824, 0, 1, 1,
0.4396924, -0.6970468, 2.664685, 0.1098039, 0, 1, 1,
0.4402871, -0.0942449, -0.3506022, 0.1176471, 0, 1, 1,
0.4411615, -0.7401239, 4.069596, 0.1215686, 0, 1, 1,
0.4439472, 2.204817, 0.6562603, 0.1294118, 0, 1, 1,
0.4452528, -0.8787975, 2.499334, 0.1333333, 0, 1, 1,
0.4503816, 1.145636, -0.116697, 0.1411765, 0, 1, 1,
0.4524397, -0.6361492, 1.745716, 0.145098, 0, 1, 1,
0.4535287, 0.5021421, 0.7398902, 0.1529412, 0, 1, 1,
0.4540717, 1.005686, -0.6838219, 0.1568628, 0, 1, 1,
0.454542, 0.5896879, 1.412749, 0.1647059, 0, 1, 1,
0.454614, -2.383119, 4.515855, 0.1686275, 0, 1, 1,
0.4671288, -0.6481335, 1.727641, 0.1764706, 0, 1, 1,
0.471942, 0.05103176, 2.054498, 0.1803922, 0, 1, 1,
0.4738281, -0.4445955, 1.899506, 0.1882353, 0, 1, 1,
0.4797886, -0.2188, 1.761709, 0.1921569, 0, 1, 1,
0.4813162, -1.662659, 2.689975, 0.2, 0, 1, 1,
0.4817255, 0.3420978, 2.818926, 0.2078431, 0, 1, 1,
0.4878528, 0.1074167, 0.6429303, 0.2117647, 0, 1, 1,
0.4888866, 0.7088724, 0.09700067, 0.2196078, 0, 1, 1,
0.4900078, -1.542478, 2.440245, 0.2235294, 0, 1, 1,
0.4930615, -0.05356396, -0.294056, 0.2313726, 0, 1, 1,
0.5025263, -1.555725, 1.506859, 0.2352941, 0, 1, 1,
0.5055509, 0.9180011, -0.4045004, 0.2431373, 0, 1, 1,
0.5078605, 0.1833566, 2.455326, 0.2470588, 0, 1, 1,
0.5132307, -1.233904, 2.281092, 0.254902, 0, 1, 1,
0.5145117, 0.2191361, 0.8768464, 0.2588235, 0, 1, 1,
0.5207716, -0.123107, 2.064704, 0.2666667, 0, 1, 1,
0.5208099, 0.2981392, 0.5823594, 0.2705882, 0, 1, 1,
0.5211911, 2.459509, 0.5322948, 0.2784314, 0, 1, 1,
0.5221373, 0.2776989, 1.988578, 0.282353, 0, 1, 1,
0.5244309, -0.6567454, 2.507181, 0.2901961, 0, 1, 1,
0.5276413, -0.6855602, 2.511964, 0.2941177, 0, 1, 1,
0.5285388, -0.8044379, 2.995702, 0.3019608, 0, 1, 1,
0.5326152, 0.5909189, -0.1531338, 0.3098039, 0, 1, 1,
0.5355434, -1.642306, 2.441716, 0.3137255, 0, 1, 1,
0.5439768, 0.843246, 1.19236, 0.3215686, 0, 1, 1,
0.5454133, 1.981376, -1.400808, 0.3254902, 0, 1, 1,
0.5461849, -1.798443, 3.20787, 0.3333333, 0, 1, 1,
0.5463129, 0.2503084, 0.6206641, 0.3372549, 0, 1, 1,
0.5490184, -1.634106, 3.210046, 0.345098, 0, 1, 1,
0.549968, -0.4620486, 1.177622, 0.3490196, 0, 1, 1,
0.5515737, -0.04727908, 4.09581, 0.3568628, 0, 1, 1,
0.5532309, 1.398731, -0.06380877, 0.3607843, 0, 1, 1,
0.55426, 0.8885552, 1.063554, 0.3686275, 0, 1, 1,
0.5560955, 0.7477056, 1.302255, 0.372549, 0, 1, 1,
0.5600862, 0.446787, 1.378156, 0.3803922, 0, 1, 1,
0.5620962, -0.8749639, 3.631769, 0.3843137, 0, 1, 1,
0.5647345, -0.2492768, 0.5129975, 0.3921569, 0, 1, 1,
0.5714285, -0.3193717, 2.692174, 0.3960784, 0, 1, 1,
0.5779681, 1.427036, 1.736961, 0.4039216, 0, 1, 1,
0.5780121, -0.6730273, 1.992898, 0.4117647, 0, 1, 1,
0.5804713, -0.649292, 2.757407, 0.4156863, 0, 1, 1,
0.5864537, 0.7281153, -0.2962675, 0.4235294, 0, 1, 1,
0.5877114, -0.0749789, 2.196407, 0.427451, 0, 1, 1,
0.5882306, 0.1803455, 1.382446, 0.4352941, 0, 1, 1,
0.590093, 0.2881803, 2.462284, 0.4392157, 0, 1, 1,
0.5901197, -0.7496234, 4.150634, 0.4470588, 0, 1, 1,
0.593319, -2.20875, 3.079376, 0.4509804, 0, 1, 1,
0.6004535, 0.7848295, 1.848628, 0.4588235, 0, 1, 1,
0.6043098, 0.003176037, -1.08002, 0.4627451, 0, 1, 1,
0.6087044, -0.9064556, 2.764049, 0.4705882, 0, 1, 1,
0.6105621, -1.792369, 1.340818, 0.4745098, 0, 1, 1,
0.6176475, -1.809961, 3.992062, 0.4823529, 0, 1, 1,
0.6203707, 0.1541092, 1.112434, 0.4862745, 0, 1, 1,
0.6255314, -0.1058584, 2.452757, 0.4941176, 0, 1, 1,
0.632068, 0.2068529, 2.131136, 0.5019608, 0, 1, 1,
0.6400772, -2.34126, 2.929324, 0.5058824, 0, 1, 1,
0.6429459, 0.004594657, 2.460353, 0.5137255, 0, 1, 1,
0.6450915, 1.007467, 1.514408, 0.5176471, 0, 1, 1,
0.6457725, -0.9449177, 2.030626, 0.5254902, 0, 1, 1,
0.6512008, 2.402569, 0.004082744, 0.5294118, 0, 1, 1,
0.6532981, -0.2770464, -0.04536484, 0.5372549, 0, 1, 1,
0.6560643, -1.090149, 2.822868, 0.5411765, 0, 1, 1,
0.6592804, 0.4884041, 2.421279, 0.5490196, 0, 1, 1,
0.6605515, 1.261111, 1.793941, 0.5529412, 0, 1, 1,
0.6635723, 0.3947808, 1.354425, 0.5607843, 0, 1, 1,
0.6653597, 0.5925013, 0.6424487, 0.5647059, 0, 1, 1,
0.6718308, 0.2253223, 0.6261898, 0.572549, 0, 1, 1,
0.6723598, 1.05739, 0.399749, 0.5764706, 0, 1, 1,
0.6833096, 0.3848311, 3.259648, 0.5843138, 0, 1, 1,
0.6854413, 0.2384555, 1.66458, 0.5882353, 0, 1, 1,
0.686087, 0.6958379, 0.928993, 0.5960785, 0, 1, 1,
0.6864513, 0.2756996, 1.321042, 0.6039216, 0, 1, 1,
0.6907477, 0.215565, 0.4538641, 0.6078432, 0, 1, 1,
0.6922313, -1.248864, 3.803852, 0.6156863, 0, 1, 1,
0.6922604, 1.187852, 0.9693772, 0.6196079, 0, 1, 1,
0.6966832, -1.181573, 2.71617, 0.627451, 0, 1, 1,
0.6998447, 2.560908, -1.334416, 0.6313726, 0, 1, 1,
0.7013988, -2.041807, 3.58929, 0.6392157, 0, 1, 1,
0.7021549, -0.3537046, 1.140583, 0.6431373, 0, 1, 1,
0.7024857, -0.3736376, 2.959103, 0.6509804, 0, 1, 1,
0.7025232, -1.392265, 2.108925, 0.654902, 0, 1, 1,
0.7053373, 0.4283258, 1.645369, 0.6627451, 0, 1, 1,
0.7117747, 0.3375047, 0.6793299, 0.6666667, 0, 1, 1,
0.7127482, -0.2769562, 1.39629, 0.6745098, 0, 1, 1,
0.715546, -0.7210174, 3.383814, 0.6784314, 0, 1, 1,
0.7187696, -1.028857, 1.653665, 0.6862745, 0, 1, 1,
0.7250212, 0.7154382, 1.059187, 0.6901961, 0, 1, 1,
0.7256994, 0.279433, 0.02239653, 0.6980392, 0, 1, 1,
0.7296615, 1.508976, 1.600603, 0.7058824, 0, 1, 1,
0.7307287, 0.3384308, 1.179958, 0.7098039, 0, 1, 1,
0.7326188, 1.770351, -1.609467, 0.7176471, 0, 1, 1,
0.7355207, 0.07676698, 1.290207, 0.7215686, 0, 1, 1,
0.7413077, -0.8347363, 0.8982932, 0.7294118, 0, 1, 1,
0.7472786, -0.6442593, 0.4026196, 0.7333333, 0, 1, 1,
0.751825, -0.4818695, 3.540309, 0.7411765, 0, 1, 1,
0.7534716, -0.05594479, 2.596221, 0.7450981, 0, 1, 1,
0.7569468, 0.8954507, 0.4941209, 0.7529412, 0, 1, 1,
0.7589598, -1.009839, 3.453194, 0.7568628, 0, 1, 1,
0.7621374, -0.1461665, 2.047808, 0.7647059, 0, 1, 1,
0.7754127, -0.5081649, 1.461946, 0.7686275, 0, 1, 1,
0.7758146, -0.7290562, 2.400377, 0.7764706, 0, 1, 1,
0.7809841, -0.7849625, 2.905371, 0.7803922, 0, 1, 1,
0.7850596, -1.418969, 4.951069, 0.7882353, 0, 1, 1,
0.7919197, -1.283957, 2.814875, 0.7921569, 0, 1, 1,
0.8010522, 0.7805045, 1.029332, 0.8, 0, 1, 1,
0.8065641, 1.093031, -0.1320742, 0.8078431, 0, 1, 1,
0.8077418, 0.8216671, 2.287275, 0.8117647, 0, 1, 1,
0.810223, 0.1358454, 0.3580839, 0.8196079, 0, 1, 1,
0.8112574, 0.8066399, 2.976826, 0.8235294, 0, 1, 1,
0.8119471, -2.175536, 2.683193, 0.8313726, 0, 1, 1,
0.8176362, -0.02028343, 1.500577, 0.8352941, 0, 1, 1,
0.8209186, -2.162789, 1.49909, 0.8431373, 0, 1, 1,
0.8222531, -1.297234, 3.061077, 0.8470588, 0, 1, 1,
0.823438, -1.973457, 1.994821, 0.854902, 0, 1, 1,
0.8288141, 0.7016112, 1.529384, 0.8588235, 0, 1, 1,
0.8360422, -1.867695, 3.053902, 0.8666667, 0, 1, 1,
0.8368364, -0.730765, 2.879801, 0.8705882, 0, 1, 1,
0.8436727, 1.838132, 1.176435, 0.8784314, 0, 1, 1,
0.8490207, 1.524053, 1.479474, 0.8823529, 0, 1, 1,
0.8521729, 1.141579, -0.07043038, 0.8901961, 0, 1, 1,
0.8549221, -1.731746, 2.987989, 0.8941177, 0, 1, 1,
0.8575863, 0.3723337, -0.1192865, 0.9019608, 0, 1, 1,
0.8582208, -0.399035, 2.409623, 0.9098039, 0, 1, 1,
0.8596602, 0.8724169, 1.174797, 0.9137255, 0, 1, 1,
0.8620926, -0.3854327, 1.619985, 0.9215686, 0, 1, 1,
0.8638405, -0.3030692, 2.576937, 0.9254902, 0, 1, 1,
0.8661147, -1.488537, 2.182631, 0.9333333, 0, 1, 1,
0.8686584, -0.2106228, -0.2026381, 0.9372549, 0, 1, 1,
0.8734738, 0.1262707, 2.537493, 0.945098, 0, 1, 1,
0.8754525, -1.202066, 2.603546, 0.9490196, 0, 1, 1,
0.8819166, 0.1306692, 0.6926153, 0.9568627, 0, 1, 1,
0.8878453, -1.058486, 2.54012, 0.9607843, 0, 1, 1,
0.8894818, -1.452483, 1.777972, 0.9686275, 0, 1, 1,
0.9005938, -0.9445174, 2.81945, 0.972549, 0, 1, 1,
0.9010507, 1.624528, 0.8004807, 0.9803922, 0, 1, 1,
0.9012365, -0.7119036, 2.960691, 0.9843137, 0, 1, 1,
0.9014962, -0.8880293, 1.071142, 0.9921569, 0, 1, 1,
0.906072, 0.6743425, -0.2552006, 0.9960784, 0, 1, 1,
0.9068193, -0.2622569, 1.650779, 1, 0, 0.9960784, 1,
0.9154975, -0.8919083, 3.087955, 1, 0, 0.9882353, 1,
0.9182022, -0.568504, 3.683698, 1, 0, 0.9843137, 1,
0.9185509, 1.631103, 1.47052, 1, 0, 0.9764706, 1,
0.9193084, 1.33645, 0.07143969, 1, 0, 0.972549, 1,
0.9198117, 0.6023666, 0.6542116, 1, 0, 0.9647059, 1,
0.9200692, 0.338908, 2.325414, 1, 0, 0.9607843, 1,
0.9245216, 1.170286, -1.17804, 1, 0, 0.9529412, 1,
0.9257174, -0.7094952, 2.646939, 1, 0, 0.9490196, 1,
0.9299511, 0.1533136, 1.141991, 1, 0, 0.9411765, 1,
0.9381107, 1.190785, 1.878474, 1, 0, 0.9372549, 1,
0.9381678, -0.4746045, 2.853041, 1, 0, 0.9294118, 1,
0.9493043, -1.866601, 2.909206, 1, 0, 0.9254902, 1,
0.9494506, -0.7813994, -0.195689, 1, 0, 0.9176471, 1,
0.9519706, 0.5833389, 2.781082, 1, 0, 0.9137255, 1,
0.9582089, 2.857692, 2.353401, 1, 0, 0.9058824, 1,
0.9639921, 0.6260873, 1.952128, 1, 0, 0.9019608, 1,
0.9791738, -1.713581, 2.271316, 1, 0, 0.8941177, 1,
0.9792929, -0.2895797, 3.993436, 1, 0, 0.8862745, 1,
0.9862394, 0.9948325, 1.338305, 1, 0, 0.8823529, 1,
0.9939089, -0.8152223, 1.052494, 1, 0, 0.8745098, 1,
1.013168, 0.1134449, 0.7933398, 1, 0, 0.8705882, 1,
1.015396, -0.5820512, 1.508925, 1, 0, 0.8627451, 1,
1.015543, 0.4594681, 1.702836, 1, 0, 0.8588235, 1,
1.015699, 2.196918, 0.9233826, 1, 0, 0.8509804, 1,
1.025202, -0.5719351, 2.00046, 1, 0, 0.8470588, 1,
1.026738, -1.738111, 2.374892, 1, 0, 0.8392157, 1,
1.033158, 0.03564237, 3.226393, 1, 0, 0.8352941, 1,
1.033597, -1.693355, 1.934591, 1, 0, 0.827451, 1,
1.034672, 1.646763, 0.641326, 1, 0, 0.8235294, 1,
1.041234, -0.3890079, 1.643763, 1, 0, 0.8156863, 1,
1.04659, -0.5856354, 0.9944965, 1, 0, 0.8117647, 1,
1.051414, 1.338315, -0.3109962, 1, 0, 0.8039216, 1,
1.061882, -0.8127635, 2.468551, 1, 0, 0.7960784, 1,
1.062511, -1.026352, 0.8586898, 1, 0, 0.7921569, 1,
1.062974, -0.7102201, 1.320696, 1, 0, 0.7843137, 1,
1.063538, 0.06013515, 2.563902, 1, 0, 0.7803922, 1,
1.073165, -1.233325, 1.73888, 1, 0, 0.772549, 1,
1.075689, 0.2256082, 0.9750532, 1, 0, 0.7686275, 1,
1.084078, -0.4579466, 2.967087, 1, 0, 0.7607843, 1,
1.084199, 0.03601734, -0.6261376, 1, 0, 0.7568628, 1,
1.084973, -1.060913, 3.170544, 1, 0, 0.7490196, 1,
1.090853, 0.8189965, 0.1053865, 1, 0, 0.7450981, 1,
1.094627, -0.04122735, 2.071004, 1, 0, 0.7372549, 1,
1.098869, -0.1160373, 1.573558, 1, 0, 0.7333333, 1,
1.118142, -0.3015626, -0.03272269, 1, 0, 0.7254902, 1,
1.118277, -0.7325345, 4.191811, 1, 0, 0.7215686, 1,
1.127261, 0.1623164, 0.6449798, 1, 0, 0.7137255, 1,
1.127717, 1.144496, -0.1613174, 1, 0, 0.7098039, 1,
1.13234, 1.024665, 1.275699, 1, 0, 0.7019608, 1,
1.13605, 0.1623413, 0.4248481, 1, 0, 0.6941177, 1,
1.143273, -0.4862761, 2.262187, 1, 0, 0.6901961, 1,
1.144175, 0.1684318, 1.714651, 1, 0, 0.682353, 1,
1.148313, -1.255966, 2.92929, 1, 0, 0.6784314, 1,
1.150532, 1.428464, 0.07932459, 1, 0, 0.6705883, 1,
1.158176, 0.3261495, 2.642394, 1, 0, 0.6666667, 1,
1.159408, -0.278494, 3.258099, 1, 0, 0.6588235, 1,
1.161074, -0.592608, 2.92918, 1, 0, 0.654902, 1,
1.170882, 1.294493, 0.6706604, 1, 0, 0.6470588, 1,
1.186131, 1.133598, 1.126415, 1, 0, 0.6431373, 1,
1.187449, 0.492422, -0.3517848, 1, 0, 0.6352941, 1,
1.194279, -0.7901961, 2.926389, 1, 0, 0.6313726, 1,
1.195328, 1.428515, 0.4987946, 1, 0, 0.6235294, 1,
1.211026, -0.1524145, 3.158807, 1, 0, 0.6196079, 1,
1.228322, -0.6318569, 2.643301, 1, 0, 0.6117647, 1,
1.230498, -0.07042287, 1.693638, 1, 0, 0.6078432, 1,
1.243255, -0.2395758, 2.206864, 1, 0, 0.6, 1,
1.248185, -2.417997, 4.628231, 1, 0, 0.5921569, 1,
1.248262, 0.6931465, -0.07877998, 1, 0, 0.5882353, 1,
1.252663, 1.592959, -1.377016, 1, 0, 0.5803922, 1,
1.253895, 0.7527699, 2.024599, 1, 0, 0.5764706, 1,
1.254939, 1.659052, 1.361285, 1, 0, 0.5686275, 1,
1.260732, -1.126183, 2.837297, 1, 0, 0.5647059, 1,
1.272526, 1.149219, -0.09915034, 1, 0, 0.5568628, 1,
1.280948, 0.3076419, 1.515605, 1, 0, 0.5529412, 1,
1.289842, 1.627775, 1.159736, 1, 0, 0.5450981, 1,
1.290407, 1.3289, 0.6070443, 1, 0, 0.5411765, 1,
1.290582, -0.6345137, 2.674232, 1, 0, 0.5333334, 1,
1.290803, -0.9430569, 2.854928, 1, 0, 0.5294118, 1,
1.294773, 0.9936706, 1.749932, 1, 0, 0.5215687, 1,
1.297864, -0.7918959, 1.470999, 1, 0, 0.5176471, 1,
1.299577, -0.6396596, 1.10645, 1, 0, 0.509804, 1,
1.316568, -1.036432, 3.583486, 1, 0, 0.5058824, 1,
1.318599, -0.5394133, 1.228281, 1, 0, 0.4980392, 1,
1.318694, -1.291657, 3.645307, 1, 0, 0.4901961, 1,
1.32082, -0.749276, 0.5632122, 1, 0, 0.4862745, 1,
1.330144, -0.07176013, 2.949826, 1, 0, 0.4784314, 1,
1.333522, 0.1895363, 2.715373, 1, 0, 0.4745098, 1,
1.337678, -0.8693398, 1.994855, 1, 0, 0.4666667, 1,
1.342997, 1.010803, 2.690386, 1, 0, 0.4627451, 1,
1.343072, -0.1288425, 0.8646902, 1, 0, 0.454902, 1,
1.35069, -0.03242924, 2.649254, 1, 0, 0.4509804, 1,
1.355779, -0.4465154, 1.784166, 1, 0, 0.4431373, 1,
1.356377, 1.203192, 1.577979, 1, 0, 0.4392157, 1,
1.361093, -0.9486493, 2.129908, 1, 0, 0.4313726, 1,
1.375085, -1.882701, 3.143571, 1, 0, 0.427451, 1,
1.377592, -1.473398, 3.004123, 1, 0, 0.4196078, 1,
1.377807, 0.291143, 2.067934, 1, 0, 0.4156863, 1,
1.378457, 1.410434, 1.479233, 1, 0, 0.4078431, 1,
1.379074, 1.407293, -0.1213265, 1, 0, 0.4039216, 1,
1.3846, -0.7328498, 1.466472, 1, 0, 0.3960784, 1,
1.390169, 1.39113, 3.053192, 1, 0, 0.3882353, 1,
1.392962, 1.47848, 1.62279, 1, 0, 0.3843137, 1,
1.401426, -0.316085, 0.6051263, 1, 0, 0.3764706, 1,
1.412227, -0.5079264, 1.118938, 1, 0, 0.372549, 1,
1.413357, -1.3404, 2.475384, 1, 0, 0.3647059, 1,
1.417973, -1.360401, 1.269795, 1, 0, 0.3607843, 1,
1.421133, 3.104734, 2.941546, 1, 0, 0.3529412, 1,
1.425267, 0.1147367, 1.443326, 1, 0, 0.3490196, 1,
1.430088, 0.8282426, 3.733769, 1, 0, 0.3411765, 1,
1.442713, -0.7304509, 2.07237, 1, 0, 0.3372549, 1,
1.446654, 1.321489, 0.4981655, 1, 0, 0.3294118, 1,
1.46116, 0.06431238, 1.831105, 1, 0, 0.3254902, 1,
1.468871, 0.9545047, 0.8150273, 1, 0, 0.3176471, 1,
1.48722, -0.5776291, 0.6755177, 1, 0, 0.3137255, 1,
1.507259, -0.8892632, 2.004795, 1, 0, 0.3058824, 1,
1.507425, 0.8325257, 1.886708, 1, 0, 0.2980392, 1,
1.519195, -1.286065, 2.328193, 1, 0, 0.2941177, 1,
1.530879, -0.8890885, 2.197957, 1, 0, 0.2862745, 1,
1.535635, -1.417622, 1.932433, 1, 0, 0.282353, 1,
1.538403, -0.7990746, 2.156964, 1, 0, 0.2745098, 1,
1.563027, -2.10719, 4.32894, 1, 0, 0.2705882, 1,
1.579992, 0.428701, 1.683481, 1, 0, 0.2627451, 1,
1.584342, 1.024816, 2.538318, 1, 0, 0.2588235, 1,
1.588177, 1.266565, 2.331044, 1, 0, 0.2509804, 1,
1.592158, -1.699652, 1.647516, 1, 0, 0.2470588, 1,
1.615799, -0.2558973, 0.9220982, 1, 0, 0.2392157, 1,
1.621689, -0.5358592, 3.018129, 1, 0, 0.2352941, 1,
1.653139, -0.1974246, 2.11243, 1, 0, 0.227451, 1,
1.655548, 0.9153848, -0.4378383, 1, 0, 0.2235294, 1,
1.65838, -1.776865, 2.678429, 1, 0, 0.2156863, 1,
1.68658, -1.402018, 2.259824, 1, 0, 0.2117647, 1,
1.706091, 0.2059215, 1.494987, 1, 0, 0.2039216, 1,
1.732933, 1.589667, 1.593885, 1, 0, 0.1960784, 1,
1.746505, -0.3220624, 1.805343, 1, 0, 0.1921569, 1,
1.7781, -0.07791012, 0.7807187, 1, 0, 0.1843137, 1,
1.793897, 0.4714487, 1.317235, 1, 0, 0.1803922, 1,
1.81269, -0.9764834, 0.6283538, 1, 0, 0.172549, 1,
1.835452, 0.01160745, -0.2339551, 1, 0, 0.1686275, 1,
1.889054, 0.1312015, -0.3120059, 1, 0, 0.1607843, 1,
1.933942, 2.645133, 0.3726487, 1, 0, 0.1568628, 1,
1.957441, -1.544478, 2.432388, 1, 0, 0.1490196, 1,
1.961769, 1.245782, -1.877897, 1, 0, 0.145098, 1,
1.962742, -0.5029621, 1.460645, 1, 0, 0.1372549, 1,
1.970734, 0.1861844, 2.47656, 1, 0, 0.1333333, 1,
1.971589, -0.03700073, 0.04570556, 1, 0, 0.1254902, 1,
1.971618, -1.301505, 2.514026, 1, 0, 0.1215686, 1,
1.981915, 0.5844358, 2.264728, 1, 0, 0.1137255, 1,
1.987879, 2.559561, 2.270072, 1, 0, 0.1098039, 1,
2.005021, -1.23516, 1.48871, 1, 0, 0.1019608, 1,
2.018074, -0.2412126, 1.358291, 1, 0, 0.09411765, 1,
2.042613, 1.060833, 1.5614, 1, 0, 0.09019608, 1,
2.128617, -1.828878, 1.20187, 1, 0, 0.08235294, 1,
2.13446, -0.102011, -1.439581, 1, 0, 0.07843138, 1,
2.146979, -1.027482, 3.052289, 1, 0, 0.07058824, 1,
2.169582, 0.2959155, 1.708643, 1, 0, 0.06666667, 1,
2.206889, -0.7172513, 1.92205, 1, 0, 0.05882353, 1,
2.285872, -0.4703882, 2.830842, 1, 0, 0.05490196, 1,
2.329109, -0.08511806, 1.569272, 1, 0, 0.04705882, 1,
2.380944, -0.3701869, 1.441354, 1, 0, 0.04313726, 1,
2.390775, -1.057114, 2.529243, 1, 0, 0.03529412, 1,
2.619398, -0.5513233, 1.63314, 1, 0, 0.03137255, 1,
2.773947, 0.09259079, 0.5794399, 1, 0, 0.02352941, 1,
2.793378, 1.47182, 1.867811, 1, 0, 0.01960784, 1,
2.828604, 0.8743314, 0.4134258, 1, 0, 0.01176471, 1,
2.863584, -0.9992427, 1.941149, 1, 0, 0.007843138, 1
]);
var buf6 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf6);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var mvMatLoc6 = gl.getUniformLocation(prog6,"mvMatrix");
var prMatLoc6 = gl.getUniformLocation(prog6,"prMatrix");
// ****** text object 8 ******
var prog8  = gl.createProgram();
gl.attachShader(prog8, getShader( gl, "testglvshader8" ));
gl.attachShader(prog8, getShader( gl, "testglfshader8" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog8, 0, "aPos");
gl.bindAttribLocation(prog8, 1, "aCol");
gl.linkProgram(prog8);
var texts = [
"x"
];
var texinfo = drawTextToCanvas(texts, 1);	 
var canvasX8 = texinfo.canvasX;
var canvasY8 = texinfo.canvasY;
var ofsLoc8 = gl.getAttribLocation(prog8, "aOfs");
var texture8 = gl.createTexture();
var texLoc8 = gl.getAttribLocation(prog8, "aTexcoord");
var sampler8 = gl.getUniformLocation(prog8,"uSampler");
handleLoadedTexture(texture8, document.getElementById("testgltextureCanvas"));
var v=new Float32Array([
-0.4301572, -4.23835, -6.769827, 0, -0.5, 0.5, 0.5,
-0.4301572, -4.23835, -6.769827, 1, -0.5, 0.5, 0.5,
-0.4301572, -4.23835, -6.769827, 1, 1.5, 0.5, 0.5,
-0.4301572, -4.23835, -6.769827, 0, 1.5, 0.5, 0.5
]);
for (var i=0; i<1; i++) 
for (var j=0; j<4; j++) {
ind = 7*(4*i + j) + 3;
v[ind+2] = 2*(v[ind]-v[ind+2])*texinfo.widths[i]/width;
v[ind+3] = 2*(v[ind+1]-v[ind+3])*texinfo.textHeight/height;
v[ind] *= texinfo.widths[i]/texinfo.canvasX;
v[ind+1] = 1.0-(texinfo.offset + i*texinfo.skip 
- v[ind+1]*texinfo.textHeight)/texinfo.canvasY;
}
var f=new Uint16Array([
0, 1, 2, 0, 2, 3
]);
var buf8 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf8);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var ibuf8 = gl.createBuffer();
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf8);
gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, f, gl.STATIC_DRAW);
var mvMatLoc8 = gl.getUniformLocation(prog8,"mvMatrix");
var prMatLoc8 = gl.getUniformLocation(prog8,"prMatrix");
// ****** text object 9 ******
var prog9  = gl.createProgram();
gl.attachShader(prog9, getShader( gl, "testglvshader9" ));
gl.attachShader(prog9, getShader( gl, "testglfshader9" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog9, 0, "aPos");
gl.bindAttribLocation(prog9, 1, "aCol");
gl.linkProgram(prog9);
var texts = [
"y"
];
var texinfo = drawTextToCanvas(texts, 1);	 
var canvasX9 = texinfo.canvasX;
var canvasY9 = texinfo.canvasY;
var ofsLoc9 = gl.getAttribLocation(prog9, "aOfs");
var texture9 = gl.createTexture();
var texLoc9 = gl.getAttribLocation(prog9, "aTexcoord");
var sampler9 = gl.getUniformLocation(prog9,"uSampler");
handleLoadedTexture(texture9, document.getElementById("testgltextureCanvas"));
var v=new Float32Array([
-4.840477, -0.02496231, -6.769827, 0, -0.5, 0.5, 0.5,
-4.840477, -0.02496231, -6.769827, 1, -0.5, 0.5, 0.5,
-4.840477, -0.02496231, -6.769827, 1, 1.5, 0.5, 0.5,
-4.840477, -0.02496231, -6.769827, 0, 1.5, 0.5, 0.5
]);
for (var i=0; i<1; i++) 
for (var j=0; j<4; j++) {
ind = 7*(4*i + j) + 3;
v[ind+2] = 2*(v[ind]-v[ind+2])*texinfo.widths[i]/width;
v[ind+3] = 2*(v[ind+1]-v[ind+3])*texinfo.textHeight/height;
v[ind] *= texinfo.widths[i]/texinfo.canvasX;
v[ind+1] = 1.0-(texinfo.offset + i*texinfo.skip 
- v[ind+1]*texinfo.textHeight)/texinfo.canvasY;
}
var f=new Uint16Array([
0, 1, 2, 0, 2, 3
]);
var buf9 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf9);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var ibuf9 = gl.createBuffer();
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf9);
gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, f, gl.STATIC_DRAW);
var mvMatLoc9 = gl.getUniformLocation(prog9,"mvMatrix");
var prMatLoc9 = gl.getUniformLocation(prog9,"prMatrix");
// ****** text object 10 ******
var prog10  = gl.createProgram();
gl.attachShader(prog10, getShader( gl, "testglvshader10" ));
gl.attachShader(prog10, getShader( gl, "testglfshader10" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog10, 0, "aPos");
gl.bindAttribLocation(prog10, 1, "aCol");
gl.linkProgram(prog10);
var texts = [
"z"
];
var texinfo = drawTextToCanvas(texts, 1);	 
var canvasX10 = texinfo.canvasX;
var canvasY10 = texinfo.canvasY;
var ofsLoc10 = gl.getAttribLocation(prog10, "aOfs");
var texture10 = gl.createTexture();
var texLoc10 = gl.getAttribLocation(prog10, "aTexcoord");
var sampler10 = gl.getUniformLocation(prog10,"uSampler");
handleLoadedTexture(texture10, document.getElementById("testgltextureCanvas"));
var v=new Float32Array([
-4.840477, -4.23835, -0.06000209, 0, -0.5, 0.5, 0.5,
-4.840477, -4.23835, -0.06000209, 1, -0.5, 0.5, 0.5,
-4.840477, -4.23835, -0.06000209, 1, 1.5, 0.5, 0.5,
-4.840477, -4.23835, -0.06000209, 0, 1.5, 0.5, 0.5
]);
for (var i=0; i<1; i++) 
for (var j=0; j<4; j++) {
ind = 7*(4*i + j) + 3;
v[ind+2] = 2*(v[ind]-v[ind+2])*texinfo.widths[i]/width;
v[ind+3] = 2*(v[ind+1]-v[ind+3])*texinfo.textHeight/height;
v[ind] *= texinfo.widths[i]/texinfo.canvasX;
v[ind+1] = 1.0-(texinfo.offset + i*texinfo.skip 
- v[ind+1]*texinfo.textHeight)/texinfo.canvasY;
}
var f=new Uint16Array([
0, 1, 2, 0, 2, 3
]);
var buf10 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf10);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var ibuf10 = gl.createBuffer();
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf10);
gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, f, gl.STATIC_DRAW);
var mvMatLoc10 = gl.getUniformLocation(prog10,"mvMatrix");
var prMatLoc10 = gl.getUniformLocation(prog10,"prMatrix");
// ****** lines object 11 ******
var prog11  = gl.createProgram();
gl.attachShader(prog11, getShader( gl, "testglvshader11" ));
gl.attachShader(prog11, getShader( gl, "testglfshader11" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog11, 0, "aPos");
gl.bindAttribLocation(prog11, 1, "aCol");
gl.linkProgram(prog11);
var v=new Float32Array([
-3, -3.26603, -5.221406,
2, -3.26603, -5.221406,
-3, -3.26603, -5.221406,
-3, -3.428083, -5.479476,
-2, -3.26603, -5.221406,
-2, -3.428083, -5.479476,
-1, -3.26603, -5.221406,
-1, -3.428083, -5.479476,
0, -3.26603, -5.221406,
0, -3.428083, -5.479476,
1, -3.26603, -5.221406,
1, -3.428083, -5.479476,
2, -3.26603, -5.221406,
2, -3.428083, -5.479476
]);
var buf11 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf11);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var mvMatLoc11 = gl.getUniformLocation(prog11,"mvMatrix");
var prMatLoc11 = gl.getUniformLocation(prog11,"prMatrix");
// ****** text object 12 ******
var prog12  = gl.createProgram();
gl.attachShader(prog12, getShader( gl, "testglvshader12" ));
gl.attachShader(prog12, getShader( gl, "testglfshader12" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog12, 0, "aPos");
gl.bindAttribLocation(prog12, 1, "aCol");
gl.linkProgram(prog12);
var texts = [
"-3",
"-2",
"-1",
"0",
"1",
"2"
];
var texinfo = drawTextToCanvas(texts, 1);	 
var canvasX12 = texinfo.canvasX;
var canvasY12 = texinfo.canvasY;
var ofsLoc12 = gl.getAttribLocation(prog12, "aOfs");
var texture12 = gl.createTexture();
var texLoc12 = gl.getAttribLocation(prog12, "aTexcoord");
var sampler12 = gl.getUniformLocation(prog12,"uSampler");
handleLoadedTexture(texture12, document.getElementById("testgltextureCanvas"));
var v=new Float32Array([
-3, -3.75219, -5.995616, 0, -0.5, 0.5, 0.5,
-3, -3.75219, -5.995616, 1, -0.5, 0.5, 0.5,
-3, -3.75219, -5.995616, 1, 1.5, 0.5, 0.5,
-3, -3.75219, -5.995616, 0, 1.5, 0.5, 0.5,
-2, -3.75219, -5.995616, 0, -0.5, 0.5, 0.5,
-2, -3.75219, -5.995616, 1, -0.5, 0.5, 0.5,
-2, -3.75219, -5.995616, 1, 1.5, 0.5, 0.5,
-2, -3.75219, -5.995616, 0, 1.5, 0.5, 0.5,
-1, -3.75219, -5.995616, 0, -0.5, 0.5, 0.5,
-1, -3.75219, -5.995616, 1, -0.5, 0.5, 0.5,
-1, -3.75219, -5.995616, 1, 1.5, 0.5, 0.5,
-1, -3.75219, -5.995616, 0, 1.5, 0.5, 0.5,
0, -3.75219, -5.995616, 0, -0.5, 0.5, 0.5,
0, -3.75219, -5.995616, 1, -0.5, 0.5, 0.5,
0, -3.75219, -5.995616, 1, 1.5, 0.5, 0.5,
0, -3.75219, -5.995616, 0, 1.5, 0.5, 0.5,
1, -3.75219, -5.995616, 0, -0.5, 0.5, 0.5,
1, -3.75219, -5.995616, 1, -0.5, 0.5, 0.5,
1, -3.75219, -5.995616, 1, 1.5, 0.5, 0.5,
1, -3.75219, -5.995616, 0, 1.5, 0.5, 0.5,
2, -3.75219, -5.995616, 0, -0.5, 0.5, 0.5,
2, -3.75219, -5.995616, 1, -0.5, 0.5, 0.5,
2, -3.75219, -5.995616, 1, 1.5, 0.5, 0.5,
2, -3.75219, -5.995616, 0, 1.5, 0.5, 0.5
]);
for (var i=0; i<6; i++) 
for (var j=0; j<4; j++) {
ind = 7*(4*i + j) + 3;
v[ind+2] = 2*(v[ind]-v[ind+2])*texinfo.widths[i]/width;
v[ind+3] = 2*(v[ind+1]-v[ind+3])*texinfo.textHeight/height;
v[ind] *= texinfo.widths[i]/texinfo.canvasX;
v[ind+1] = 1.0-(texinfo.offset + i*texinfo.skip 
- v[ind+1]*texinfo.textHeight)/texinfo.canvasY;
}
var f=new Uint16Array([
0, 1, 2, 0, 2, 3,
4, 5, 6, 4, 6, 7,
8, 9, 10, 8, 10, 11,
12, 13, 14, 12, 14, 15,
16, 17, 18, 16, 18, 19,
20, 21, 22, 20, 22, 23
]);
var buf12 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf12);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var ibuf12 = gl.createBuffer();
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf12);
gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, f, gl.STATIC_DRAW);
var mvMatLoc12 = gl.getUniformLocation(prog12,"mvMatrix");
var prMatLoc12 = gl.getUniformLocation(prog12,"prMatrix");
// ****** lines object 13 ******
var prog13  = gl.createProgram();
gl.attachShader(prog13, getShader( gl, "testglvshader13" ));
gl.attachShader(prog13, getShader( gl, "testglfshader13" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog13, 0, "aPos");
gl.bindAttribLocation(prog13, 1, "aCol");
gl.linkProgram(prog13);
var v=new Float32Array([
-3.822711, -3, -5.221406,
-3.822711, 3, -5.221406,
-3.822711, -3, -5.221406,
-3.992339, -3, -5.479476,
-3.822711, -2, -5.221406,
-3.992339, -2, -5.479476,
-3.822711, -1, -5.221406,
-3.992339, -1, -5.479476,
-3.822711, 0, -5.221406,
-3.992339, 0, -5.479476,
-3.822711, 1, -5.221406,
-3.992339, 1, -5.479476,
-3.822711, 2, -5.221406,
-3.992339, 2, -5.479476,
-3.822711, 3, -5.221406,
-3.992339, 3, -5.479476
]);
var buf13 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf13);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var mvMatLoc13 = gl.getUniformLocation(prog13,"mvMatrix");
var prMatLoc13 = gl.getUniformLocation(prog13,"prMatrix");
// ****** text object 14 ******
var prog14  = gl.createProgram();
gl.attachShader(prog14, getShader( gl, "testglvshader14" ));
gl.attachShader(prog14, getShader( gl, "testglfshader14" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog14, 0, "aPos");
gl.bindAttribLocation(prog14, 1, "aCol");
gl.linkProgram(prog14);
var texts = [
"-3",
"-2",
"-1",
"0",
"1",
"2",
"3"
];
var texinfo = drawTextToCanvas(texts, 1);	 
var canvasX14 = texinfo.canvasX;
var canvasY14 = texinfo.canvasY;
var ofsLoc14 = gl.getAttribLocation(prog14, "aOfs");
var texture14 = gl.createTexture();
var texLoc14 = gl.getAttribLocation(prog14, "aTexcoord");
var sampler14 = gl.getUniformLocation(prog14,"uSampler");
handleLoadedTexture(texture14, document.getElementById("testgltextureCanvas"));
var v=new Float32Array([
-4.331594, -3, -5.995616, 0, -0.5, 0.5, 0.5,
-4.331594, -3, -5.995616, 1, -0.5, 0.5, 0.5,
-4.331594, -3, -5.995616, 1, 1.5, 0.5, 0.5,
-4.331594, -3, -5.995616, 0, 1.5, 0.5, 0.5,
-4.331594, -2, -5.995616, 0, -0.5, 0.5, 0.5,
-4.331594, -2, -5.995616, 1, -0.5, 0.5, 0.5,
-4.331594, -2, -5.995616, 1, 1.5, 0.5, 0.5,
-4.331594, -2, -5.995616, 0, 1.5, 0.5, 0.5,
-4.331594, -1, -5.995616, 0, -0.5, 0.5, 0.5,
-4.331594, -1, -5.995616, 1, -0.5, 0.5, 0.5,
-4.331594, -1, -5.995616, 1, 1.5, 0.5, 0.5,
-4.331594, -1, -5.995616, 0, 1.5, 0.5, 0.5,
-4.331594, 0, -5.995616, 0, -0.5, 0.5, 0.5,
-4.331594, 0, -5.995616, 1, -0.5, 0.5, 0.5,
-4.331594, 0, -5.995616, 1, 1.5, 0.5, 0.5,
-4.331594, 0, -5.995616, 0, 1.5, 0.5, 0.5,
-4.331594, 1, -5.995616, 0, -0.5, 0.5, 0.5,
-4.331594, 1, -5.995616, 1, -0.5, 0.5, 0.5,
-4.331594, 1, -5.995616, 1, 1.5, 0.5, 0.5,
-4.331594, 1, -5.995616, 0, 1.5, 0.5, 0.5,
-4.331594, 2, -5.995616, 0, -0.5, 0.5, 0.5,
-4.331594, 2, -5.995616, 1, -0.5, 0.5, 0.5,
-4.331594, 2, -5.995616, 1, 1.5, 0.5, 0.5,
-4.331594, 2, -5.995616, 0, 1.5, 0.5, 0.5,
-4.331594, 3, -5.995616, 0, -0.5, 0.5, 0.5,
-4.331594, 3, -5.995616, 1, -0.5, 0.5, 0.5,
-4.331594, 3, -5.995616, 1, 1.5, 0.5, 0.5,
-4.331594, 3, -5.995616, 0, 1.5, 0.5, 0.5
]);
for (var i=0; i<7; i++) 
for (var j=0; j<4; j++) {
ind = 7*(4*i + j) + 3;
v[ind+2] = 2*(v[ind]-v[ind+2])*texinfo.widths[i]/width;
v[ind+3] = 2*(v[ind+1]-v[ind+3])*texinfo.textHeight/height;
v[ind] *= texinfo.widths[i]/texinfo.canvasX;
v[ind+1] = 1.0-(texinfo.offset + i*texinfo.skip 
- v[ind+1]*texinfo.textHeight)/texinfo.canvasY;
}
var f=new Uint16Array([
0, 1, 2, 0, 2, 3,
4, 5, 6, 4, 6, 7,
8, 9, 10, 8, 10, 11,
12, 13, 14, 12, 14, 15,
16, 17, 18, 16, 18, 19,
20, 21, 22, 20, 22, 23,
24, 25, 26, 24, 26, 27
]);
var buf14 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf14);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var ibuf14 = gl.createBuffer();
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf14);
gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, f, gl.STATIC_DRAW);
var mvMatLoc14 = gl.getUniformLocation(prog14,"mvMatrix");
var prMatLoc14 = gl.getUniformLocation(prog14,"prMatrix");
// ****** lines object 15 ******
var prog15  = gl.createProgram();
gl.attachShader(prog15, getShader( gl, "testglvshader15" ));
gl.attachShader(prog15, getShader( gl, "testglfshader15" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog15, 0, "aPos");
gl.bindAttribLocation(prog15, 1, "aCol");
gl.linkProgram(prog15);
var v=new Float32Array([
-3.822711, -3.26603, -4,
-3.822711, -3.26603, 4,
-3.822711, -3.26603, -4,
-3.992339, -3.428083, -4,
-3.822711, -3.26603, -2,
-3.992339, -3.428083, -2,
-3.822711, -3.26603, 0,
-3.992339, -3.428083, 0,
-3.822711, -3.26603, 2,
-3.992339, -3.428083, 2,
-3.822711, -3.26603, 4,
-3.992339, -3.428083, 4
]);
var buf15 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf15);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var mvMatLoc15 = gl.getUniformLocation(prog15,"mvMatrix");
var prMatLoc15 = gl.getUniformLocation(prog15,"prMatrix");
// ****** text object 16 ******
var prog16  = gl.createProgram();
gl.attachShader(prog16, getShader( gl, "testglvshader16" ));
gl.attachShader(prog16, getShader( gl, "testglfshader16" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog16, 0, "aPos");
gl.bindAttribLocation(prog16, 1, "aCol");
gl.linkProgram(prog16);
var texts = [
"-4",
"-2",
"0",
"2",
"4"
];
var texinfo = drawTextToCanvas(texts, 1);	 
var canvasX16 = texinfo.canvasX;
var canvasY16 = texinfo.canvasY;
var ofsLoc16 = gl.getAttribLocation(prog16, "aOfs");
var texture16 = gl.createTexture();
var texLoc16 = gl.getAttribLocation(prog16, "aTexcoord");
var sampler16 = gl.getUniformLocation(prog16,"uSampler");
handleLoadedTexture(texture16, document.getElementById("testgltextureCanvas"));
var v=new Float32Array([
-4.331594, -3.75219, -4, 0, -0.5, 0.5, 0.5,
-4.331594, -3.75219, -4, 1, -0.5, 0.5, 0.5,
-4.331594, -3.75219, -4, 1, 1.5, 0.5, 0.5,
-4.331594, -3.75219, -4, 0, 1.5, 0.5, 0.5,
-4.331594, -3.75219, -2, 0, -0.5, 0.5, 0.5,
-4.331594, -3.75219, -2, 1, -0.5, 0.5, 0.5,
-4.331594, -3.75219, -2, 1, 1.5, 0.5, 0.5,
-4.331594, -3.75219, -2, 0, 1.5, 0.5, 0.5,
-4.331594, -3.75219, 0, 0, -0.5, 0.5, 0.5,
-4.331594, -3.75219, 0, 1, -0.5, 0.5, 0.5,
-4.331594, -3.75219, 0, 1, 1.5, 0.5, 0.5,
-4.331594, -3.75219, 0, 0, 1.5, 0.5, 0.5,
-4.331594, -3.75219, 2, 0, -0.5, 0.5, 0.5,
-4.331594, -3.75219, 2, 1, -0.5, 0.5, 0.5,
-4.331594, -3.75219, 2, 1, 1.5, 0.5, 0.5,
-4.331594, -3.75219, 2, 0, 1.5, 0.5, 0.5,
-4.331594, -3.75219, 4, 0, -0.5, 0.5, 0.5,
-4.331594, -3.75219, 4, 1, -0.5, 0.5, 0.5,
-4.331594, -3.75219, 4, 1, 1.5, 0.5, 0.5,
-4.331594, -3.75219, 4, 0, 1.5, 0.5, 0.5
]);
for (var i=0; i<5; i++) 
for (var j=0; j<4; j++) {
ind = 7*(4*i + j) + 3;
v[ind+2] = 2*(v[ind]-v[ind+2])*texinfo.widths[i]/width;
v[ind+3] = 2*(v[ind+1]-v[ind+3])*texinfo.textHeight/height;
v[ind] *= texinfo.widths[i]/texinfo.canvasX;
v[ind+1] = 1.0-(texinfo.offset + i*texinfo.skip 
- v[ind+1]*texinfo.textHeight)/texinfo.canvasY;
}
var f=new Uint16Array([
0, 1, 2, 0, 2, 3,
4, 5, 6, 4, 6, 7,
8, 9, 10, 8, 10, 11,
12, 13, 14, 12, 14, 15,
16, 17, 18, 16, 18, 19
]);
var buf16 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf16);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var ibuf16 = gl.createBuffer();
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf16);
gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, f, gl.STATIC_DRAW);
var mvMatLoc16 = gl.getUniformLocation(prog16,"mvMatrix");
var prMatLoc16 = gl.getUniformLocation(prog16,"prMatrix");
// ****** lines object 17 ******
var prog17  = gl.createProgram();
gl.attachShader(prog17, getShader( gl, "testglvshader17" ));
gl.attachShader(prog17, getShader( gl, "testglfshader17" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog17, 0, "aPos");
gl.bindAttribLocation(prog17, 1, "aCol");
gl.linkProgram(prog17);
var v=new Float32Array([
-3.822711, -3.26603, -5.221406,
-3.822711, 3.216105, -5.221406,
-3.822711, -3.26603, 5.101401,
-3.822711, 3.216105, 5.101401,
-3.822711, -3.26603, -5.221406,
-3.822711, -3.26603, 5.101401,
-3.822711, 3.216105, -5.221406,
-3.822711, 3.216105, 5.101401,
-3.822711, -3.26603, -5.221406,
2.962397, -3.26603, -5.221406,
-3.822711, -3.26603, 5.101401,
2.962397, -3.26603, 5.101401,
-3.822711, 3.216105, -5.221406,
2.962397, 3.216105, -5.221406,
-3.822711, 3.216105, 5.101401,
2.962397, 3.216105, 5.101401,
2.962397, -3.26603, -5.221406,
2.962397, 3.216105, -5.221406,
2.962397, -3.26603, 5.101401,
2.962397, 3.216105, 5.101401,
2.962397, -3.26603, -5.221406,
2.962397, -3.26603, 5.101401,
2.962397, 3.216105, -5.221406,
2.962397, 3.216105, 5.101401
]);
var buf17 = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buf17);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var mvMatLoc17 = gl.getUniformLocation(prog17,"mvMatrix");
var prMatLoc17 = gl.getUniformLocation(prog17,"prMatrix");
gl.enable(gl.DEPTH_TEST);
gl.depthFunc(gl.LEQUAL);
gl.clearDepth(1.0);
gl.clearColor(1, 1, 1, 1);
var xOffs = yOffs = 0,  drag  = 0;
drawScene();
function drawScene(){
gl.depthMask(true);
gl.disable(gl.BLEND);
var radius = 7.449289;
var s = sin(fov*PI/360);
var t = tan(fov*PI/360);
var distance = radius/s;
var near = distance - radius;
var far = distance + radius;
var hlen = t*near;
var aspect = width/height;
prMatrix.makeIdentity();
if (aspect > 1)
prMatrix.frustum(-hlen*aspect*zoom, hlen*aspect*zoom, 
-hlen*zoom, hlen*zoom, near, far);
else  
prMatrix.frustum(-hlen*zoom, hlen*zoom, 
-hlen*zoom/aspect, hlen*zoom/aspect, 
near, far);
mvMatrix.makeIdentity();
mvMatrix.translate( 0.4301572, 0.02496231, 0.06000209 );
mvMatrix.scale( 1.187058, 1.242541, 0.7802449 );   
mvMatrix.multRight( userMatrix );  
mvMatrix.translate(0, 0, -distance);
gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
// ****** points object 6 *******
gl.useProgram(prog6);
gl.bindBuffer(gl.ARRAY_BUFFER, buf6);
gl.uniformMatrix4fv( prMatLoc6, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc6, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.enableVertexAttribArray( colLoc );
gl.vertexAttribPointer(colLoc, 4, gl.FLOAT, false, 28, 12);
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 28,  0);
gl.drawArrays(gl.POINTS, 0, 1000);
// ****** text object 8 *******
gl.useProgram(prog8);
gl.bindBuffer(gl.ARRAY_BUFFER, buf8);
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf8);
gl.uniformMatrix4fv( prMatLoc8, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc8, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.enableVertexAttribArray( texLoc8 );
gl.vertexAttribPointer(texLoc8, 2, gl.FLOAT, false, 28, 12);
gl.activeTexture(gl.TEXTURE0);
gl.bindTexture(gl.TEXTURE_2D, texture8);
gl.uniform1i( sampler8, 0);
gl.enableVertexAttribArray( ofsLoc8 );
gl.vertexAttribPointer(ofsLoc8, 2, gl.FLOAT, false, 28, 20);
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 28,  0);
gl.drawElements(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0);
// ****** text object 9 *******
gl.useProgram(prog9);
gl.bindBuffer(gl.ARRAY_BUFFER, buf9);
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf9);
gl.uniformMatrix4fv( prMatLoc9, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc9, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.enableVertexAttribArray( texLoc9 );
gl.vertexAttribPointer(texLoc9, 2, gl.FLOAT, false, 28, 12);
gl.activeTexture(gl.TEXTURE0);
gl.bindTexture(gl.TEXTURE_2D, texture9);
gl.uniform1i( sampler9, 0);
gl.enableVertexAttribArray( ofsLoc9 );
gl.vertexAttribPointer(ofsLoc9, 2, gl.FLOAT, false, 28, 20);
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 28,  0);
gl.drawElements(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0);
// ****** text object 10 *******
gl.useProgram(prog10);
gl.bindBuffer(gl.ARRAY_BUFFER, buf10);
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf10);
gl.uniformMatrix4fv( prMatLoc10, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc10, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.enableVertexAttribArray( texLoc10 );
gl.vertexAttribPointer(texLoc10, 2, gl.FLOAT, false, 28, 12);
gl.activeTexture(gl.TEXTURE0);
gl.bindTexture(gl.TEXTURE_2D, texture10);
gl.uniform1i( sampler10, 0);
gl.enableVertexAttribArray( ofsLoc10 );
gl.vertexAttribPointer(ofsLoc10, 2, gl.FLOAT, false, 28, 20);
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 28,  0);
gl.drawElements(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0);
// ****** lines object 11 *******
gl.useProgram(prog11);
gl.bindBuffer(gl.ARRAY_BUFFER, buf11);
gl.uniformMatrix4fv( prMatLoc11, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc11, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.lineWidth( 1 );
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 12,  0);
gl.drawArrays(gl.LINES, 0, 14);
// ****** text object 12 *******
gl.useProgram(prog12);
gl.bindBuffer(gl.ARRAY_BUFFER, buf12);
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf12);
gl.uniformMatrix4fv( prMatLoc12, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc12, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.enableVertexAttribArray( texLoc12 );
gl.vertexAttribPointer(texLoc12, 2, gl.FLOAT, false, 28, 12);
gl.activeTexture(gl.TEXTURE0);
gl.bindTexture(gl.TEXTURE_2D, texture12);
gl.uniform1i( sampler12, 0);
gl.enableVertexAttribArray( ofsLoc12 );
gl.vertexAttribPointer(ofsLoc12, 2, gl.FLOAT, false, 28, 20);
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 28,  0);
gl.drawElements(gl.TRIANGLES, 36, gl.UNSIGNED_SHORT, 0);
// ****** lines object 13 *******
gl.useProgram(prog13);
gl.bindBuffer(gl.ARRAY_BUFFER, buf13);
gl.uniformMatrix4fv( prMatLoc13, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc13, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.lineWidth( 1 );
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 12,  0);
gl.drawArrays(gl.LINES, 0, 16);
// ****** text object 14 *******
gl.useProgram(prog14);
gl.bindBuffer(gl.ARRAY_BUFFER, buf14);
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf14);
gl.uniformMatrix4fv( prMatLoc14, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc14, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.enableVertexAttribArray( texLoc14 );
gl.vertexAttribPointer(texLoc14, 2, gl.FLOAT, false, 28, 12);
gl.activeTexture(gl.TEXTURE0);
gl.bindTexture(gl.TEXTURE_2D, texture14);
gl.uniform1i( sampler14, 0);
gl.enableVertexAttribArray( ofsLoc14 );
gl.vertexAttribPointer(ofsLoc14, 2, gl.FLOAT, false, 28, 20);
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 28,  0);
gl.drawElements(gl.TRIANGLES, 42, gl.UNSIGNED_SHORT, 0);
// ****** lines object 15 *******
gl.useProgram(prog15);
gl.bindBuffer(gl.ARRAY_BUFFER, buf15);
gl.uniformMatrix4fv( prMatLoc15, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc15, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.lineWidth( 1 );
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 12,  0);
gl.drawArrays(gl.LINES, 0, 12);
// ****** text object 16 *******
gl.useProgram(prog16);
gl.bindBuffer(gl.ARRAY_BUFFER, buf16);
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, ibuf16);
gl.uniformMatrix4fv( prMatLoc16, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc16, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.enableVertexAttribArray( texLoc16 );
gl.vertexAttribPointer(texLoc16, 2, gl.FLOAT, false, 28, 12);
gl.activeTexture(gl.TEXTURE0);
gl.bindTexture(gl.TEXTURE_2D, texture16);
gl.uniform1i( sampler16, 0);
gl.enableVertexAttribArray( ofsLoc16 );
gl.vertexAttribPointer(ofsLoc16, 2, gl.FLOAT, false, 28, 20);
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 28,  0);
gl.drawElements(gl.TRIANGLES, 30, gl.UNSIGNED_SHORT, 0);
// ****** lines object 17 *******
gl.useProgram(prog17);
gl.bindBuffer(gl.ARRAY_BUFFER, buf17);
gl.uniformMatrix4fv( prMatLoc17, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc17, false, new Float32Array(mvMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.disableVertexAttribArray( colLoc );
gl.vertexAttrib4f( colLoc, 0, 0, 0, 1 );
gl.lineWidth( 1 );
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 12,  0);
gl.drawArrays(gl.LINES, 0, 24);
gl.flush ();
}
var vlen = function(v) {
return sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2])
}
var xprod = function(a, b) {
return [a[1]*b[2] - a[2]*b[1],
a[2]*b[0] - a[0]*b[2],
a[0]*b[1] - a[1]*b[0]];
}
var screenToVector = function(x, y) {
var radius = max(width, height)/2.0;
var cx = width/2.0;
var cy = height/2.0;
var px = (x-cx)/radius;
var py = (y-cy)/radius;
var plen = sqrt(px*px+py*py);
if (plen > 1.e-6) { 
px = px/plen;
py = py/plen;
}
var angle = (SQRT2 - plen)/SQRT2*PI/2;
var z = sin(angle);
var zlen = sqrt(1.0 - z*z);
px = px * zlen;
py = py * zlen;
return [px, py, z];
}
var rotBase;
var trackballdown = function(x,y) {
rotBase = screenToVector(x, y);
saveMat.load(userMatrix);
}
var trackballmove = function(x,y) {
var rotCurrent = screenToVector(x,y);
var dot = rotBase[0]*rotCurrent[0] + 
rotBase[1]*rotCurrent[1] + 
rotBase[2]*rotCurrent[2];
var angle = acos( dot/vlen(rotBase)/vlen(rotCurrent) )*180./PI;
var axis = xprod(rotBase, rotCurrent);
userMatrix.load(saveMat);
userMatrix.rotate(angle, axis[0], axis[1], axis[2]);
drawScene();
}
var y0zoom = 0;
var zoom0 = 1;
var zoomdown = function(x, y) {
y0zoom = y;
zoom0 = log(zoom);
}
var zoommove = function(x, y) {
zoom = exp(zoom0 + (y-y0zoom)/height);
drawScene();
}
var y0fov = 0;
var fov0 = 1;
var fovdown = function(x, y) {
y0fov = y;
fov0 = fov;
}
var fovmove = function(x, y) {
fov = max(1, min(179, fov0 + 180*(y-y0fov)/height));
drawScene();
}
var mousedown = [trackballdown, zoomdown, fovdown];
var mousemove = [trackballmove, zoommove, fovmove];
function relMouseCoords(event){
var totalOffsetX = 0;
var totalOffsetY = 0;
var currentElement = canvas;
do{
totalOffsetX += currentElement.offsetLeft;
totalOffsetY += currentElement.offsetTop;
}
while(currentElement = currentElement.offsetParent)
var canvasX = event.pageX - totalOffsetX;
var canvasY = event.pageY - totalOffsetY;
return {x:canvasX, y:canvasY}
}
canvas.onmousedown = function ( ev ){
if (!ev.which) // Use w3c defns in preference to MS
switch (ev.button) {
case 0: ev.which = 1; break;
case 1: 
case 4: ev.which = 2; break;
case 2: ev.which = 3;
}
drag = ev.which;
var f = mousedown[drag-1];
if (f) {
var coords = relMouseCoords(ev);
f(coords.x, height-coords.y); 
ev.preventDefault();
}
}    
canvas.onmouseup = function ( ev ){	
drag = 0;
}
canvas.onmouseout = canvas.onmouseup;
canvas.onmousemove = function ( ev ){
if ( drag == 0 ) return;
var f = mousemove[drag-1];
if (f) {
var coords = relMouseCoords(ev);
f(coords.x, height-coords.y);
}
}
var wheelHandler = function(ev) {
var del = 1.1;
if (ev.shiftKey) del = 1.01;
var ds = ((ev.detail || ev.wheelDelta) > 0) ? del : (1 / del);
zoom *= ds;
drawScene();
ev.preventDefault();
};
canvas.addEventListener("DOMMouseScroll", wheelHandler, false);
canvas.addEventListener("mousewheel", wheelHandler, false);
}
</script>
<canvas id="testglcanvas" width="1" height="1"></canvas> 
<p id="testgldebug">
You must enable Javascript to view this page properly.</p>
<script>testglwebGLStart();</script>

This one also works.


```r
open3d()
```

```
## glX 
##   2
```

```r
spheres3d(x, y, z, col=rainbow(1000))
```

<canvas id="testgl2textureCanvas" style="display: none;" width="256" height="256">
Your browser does not support the HTML5 canvas element.</canvas>
<!-- ****** spheres object 22 ****** -->
<script id="testgl2vshader22" type="x-shader/x-vertex">
attribute vec3 aPos;
attribute vec4 aCol;
uniform mat4 mvMatrix;
uniform mat4 prMatrix;
varying vec4 vCol;
varying vec4 vPosition;
attribute vec3 aNorm;
uniform mat4 normMatrix;
varying vec3 vNormal;
void main(void) {
vPosition = mvMatrix * vec4(aPos, 1.);
gl_Position = prMatrix * vPosition;
vCol = aCol;
vNormal = normalize((normMatrix * vec4(aNorm, 1.)).xyz);
}
</script>
<script id="testgl2fshader22" type="x-shader/x-fragment"> 
#ifdef GL_ES
precision highp float;
#endif
varying vec4 vCol; // carries alpha
varying vec4 vPosition;
varying vec3 vNormal;
void main(void) {
vec3 eye = normalize(-vPosition.xyz);
const vec3 emission = vec3(0., 0., 0.);
const vec3 ambient1 = vec3(0., 0., 0.);
const vec3 specular1 = vec3(1., 1., 1.);// light*material
const float shininess1 = 50.;
vec4 colDiff1 = vec4(vCol.rgb * vec3(1., 1., 1.), vCol.a);
const vec3 lightDir1 = vec3(0., 0., 1.);
vec3 halfVec1 = normalize(lightDir1 + eye);
vec4 lighteffect = vec4(emission, 0.);
vec3 n = normalize(vNormal);
n = -faceforward(n, n, eye);
vec3 col1 = ambient1;
float nDotL1 = dot(n, lightDir1);
col1 = col1 + max(nDotL1, 0.) * colDiff1.rgb;
col1 = col1 + pow(max(dot(halfVec1, n), 0.), shininess1) * specular1;
lighteffect = lighteffect + vec4(col1, colDiff1.a);
gl_FragColor = lighteffect;
}
</script> 
<script type="text/javascript"> 
function getShader ( gl, id ){
var shaderScript = document.getElementById ( id );
var str = "";
var k = shaderScript.firstChild;
while ( k ){
if ( k.nodeType == 3 ) str += k.textContent;
k = k.nextSibling;
}
var shader;
if ( shaderScript.type == "x-shader/x-fragment" )
shader = gl.createShader ( gl.FRAGMENT_SHADER );
else if ( shaderScript.type == "x-shader/x-vertex" )
shader = gl.createShader(gl.VERTEX_SHADER);
else return null;
gl.shaderSource(shader, str);
gl.compileShader(shader);
if (gl.getShaderParameter(shader, gl.COMPILE_STATUS) == 0)
alert(gl.getShaderInfoLog(shader));
return shader;
}
var min = Math.min;
var max = Math.max;
var sqrt = Math.sqrt;
var sin = Math.sin;
var acos = Math.acos;
var tan = Math.tan;
var SQRT2 = Math.SQRT2;
var PI = Math.PI;
var log = Math.log;
var exp = Math.exp;
function testgl2webGLStart() {
var debug = function(msg) {
document.getElementById("testgl2debug").innerHTML = msg;
}
debug("");
var canvas = document.getElementById("testgl2canvas");
if (!window.WebGLRenderingContext){
debug(" Your browser does not support WebGL. See <a href=\"http://get.webgl.org\">http://get.webgl.org</a>");
return;
}
var gl;
try {
// Try to grab the standard context. If it fails, fallback to experimental.
gl = canvas.getContext("webgl") 
|| canvas.getContext("experimental-webgl");
}
catch(e) {}
if ( !gl ) {
debug(" Your browser appears to support WebGL, but did not create a WebGL context.  See <a href=\"http://get.webgl.org\">http://get.webgl.org</a>");
return;
}
var width = 505;  var height = 505;
canvas.width = width;   canvas.height = height;
gl.viewport(0, 0, width, height);
var prMatrix = new CanvasMatrix4();
var mvMatrix = new CanvasMatrix4();
var normMatrix = new CanvasMatrix4();
var saveMat = new CanvasMatrix4();
saveMat.makeIdentity();
var distance;
var posLoc = 0;
var colLoc = 1;
var zoom = 1;
var fov = 30;
var userMatrix = new CanvasMatrix4();
userMatrix.load([
1, 0, 0, 0,
0, 0.3420201, -0.9396926, 0,
0, 0.9396926, 0.3420201, 0,
0, 0, 0, 1
]);
function getPowerOfTwo(value) {
var pow = 1;
while(pow<value) {
pow *= 2;
}
return pow;
}
function handleLoadedTexture(texture, textureCanvas) {
gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
gl.bindTexture(gl.TEXTURE_2D, texture);
gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, textureCanvas);
gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR_MIPMAP_NEAREST);
gl.generateMipmap(gl.TEXTURE_2D);
gl.bindTexture(gl.TEXTURE_2D, null);
}
function loadImageToTexture(filename, texture) {   
var canvas = document.getElementById("testgl2textureCanvas");
var ctx = canvas.getContext("2d");
var image = new Image();
image.onload = function() {
var w = image.width;
var h = image.height;
var canvasX = getPowerOfTwo(w);
var canvasY = getPowerOfTwo(h);
canvas.width = canvasX;
canvas.height = canvasY;
ctx.imageSmoothingEnabled = true;
ctx.drawImage(image, 0, 0, canvasX, canvasY);
handleLoadedTexture(texture, canvas);
drawScene();
}
image.src = filename;
}  	   
// ****** sphere object ******
var v=new Float32Array([
-1, 0, 0,
1, 0, 0,
0, -1, 0,
0, 1, 0,
0, 0, -1,
0, 0, 1,
-0.7071068, 0, -0.7071068,
-0.7071068, -0.7071068, 0,
0, -0.7071068, -0.7071068,
-0.7071068, 0, 0.7071068,
0, -0.7071068, 0.7071068,
-0.7071068, 0.7071068, 0,
0, 0.7071068, -0.7071068,
0, 0.7071068, 0.7071068,
0.7071068, -0.7071068, 0,
0.7071068, 0, -0.7071068,
0.7071068, 0, 0.7071068,
0.7071068, 0.7071068, 0,
-0.9349975, 0, -0.3546542,
-0.9349975, -0.3546542, 0,
-0.77044, -0.4507894, -0.4507894,
0, -0.3546542, -0.9349975,
-0.3546542, 0, -0.9349975,
-0.4507894, -0.4507894, -0.77044,
-0.3546542, -0.9349975, 0,
0, -0.9349975, -0.3546542,
-0.4507894, -0.77044, -0.4507894,
-0.9349975, 0, 0.3546542,
-0.77044, -0.4507894, 0.4507894,
0, -0.9349975, 0.3546542,
-0.4507894, -0.77044, 0.4507894,
-0.3546542, 0, 0.9349975,
0, -0.3546542, 0.9349975,
-0.4507894, -0.4507894, 0.77044,
-0.9349975, 0.3546542, 0,
-0.77044, 0.4507894, -0.4507894,
0, 0.9349975, -0.3546542,
-0.3546542, 0.9349975, 0,
-0.4507894, 0.77044, -0.4507894,
0, 0.3546542, -0.9349975,
-0.4507894, 0.4507894, -0.77044,
-0.77044, 0.4507894, 0.4507894,
0, 0.3546542, 0.9349975,
-0.4507894, 0.4507894, 0.77044,
0, 0.9349975, 0.3546542,
-0.4507894, 0.77044, 0.4507894,
0.9349975, -0.3546542, 0,
0.9349975, 0, -0.3546542,
0.77044, -0.4507894, -0.4507894,
0.3546542, -0.9349975, 0,
0.4507894, -0.77044, -0.4507894,
0.3546542, 0, -0.9349975,
0.4507894, -0.4507894, -0.77044,
0.9349975, 0, 0.3546542,
0.77044, -0.4507894, 0.4507894,
0.3546542, 0, 0.9349975,
0.4507894, -0.4507894, 0.77044,
0.4507894, -0.77044, 0.4507894,
0.9349975, 0.3546542, 0,
0.77044, 0.4507894, -0.4507894,
0.4507894, 0.4507894, -0.77044,
0.3546542, 0.9349975, 0,
0.4507894, 0.77044, -0.4507894,
0.77044, 0.4507894, 0.4507894,
0.4507894, 0.77044, 0.4507894,
0.4507894, 0.4507894, 0.77044
]);
var f=new Uint16Array([
0, 18, 19,
6, 20, 18,
7, 19, 20,
19, 18, 20,
4, 21, 22,
8, 23, 21,
6, 22, 23,
22, 21, 23,
2, 24, 25,
7, 26, 24,
8, 25, 26,
25, 24, 26,
7, 20, 26,
6, 23, 20,
8, 26, 23,
26, 20, 23,
0, 19, 27,
7, 28, 19,
9, 27, 28,
27, 19, 28,
2, 29, 24,
10, 30, 29,
7, 24, 30,
24, 29, 30,
5, 31, 32,
9, 33, 31,
10, 32, 33,
32, 31, 33,
9, 28, 33,
7, 30, 28,
10, 33, 30,
33, 28, 30,
0, 34, 18,
11, 35, 34,
6, 18, 35,
18, 34, 35,
3, 36, 37,
12, 38, 36,
11, 37, 38,
37, 36, 38,
4, 22, 39,
6, 40, 22,
12, 39, 40,
39, 22, 40,
6, 35, 40,
11, 38, 35,
12, 40, 38,
40, 35, 38,
0, 27, 34,
9, 41, 27,
11, 34, 41,
34, 27, 41,
5, 42, 31,
13, 43, 42,
9, 31, 43,
31, 42, 43,
3, 37, 44,
11, 45, 37,
13, 44, 45,
44, 37, 45,
11, 41, 45,
9, 43, 41,
13, 45, 43,
45, 41, 43,
1, 46, 47,
14, 48, 46,
15, 47, 48,
47, 46, 48,
2, 25, 49,
8, 50, 25,
14, 49, 50,
49, 25, 50,
4, 51, 21,
15, 52, 51,
8, 21, 52,
21, 51, 52,
15, 48, 52,
14, 50, 48,
8, 52, 50,
52, 48, 50,
1, 53, 46,
16, 54, 53,
14, 46, 54,
46, 53, 54,
5, 32, 55,
10, 56, 32,
16, 55, 56,
55, 32, 56,
2, 49, 29,
14, 57, 49,
10, 29, 57,
29, 49, 57,
14, 54, 57,
16, 56, 54,
10, 57, 56,
57, 54, 56,
1, 47, 58,
15, 59, 47,
17, 58, 59,
58, 47, 59,
4, 39, 51,
12, 60, 39,
15, 51, 60,
51, 39, 60,
3, 61, 36,
17, 62, 61,
12, 36, 62,
36, 61, 62,
17, 59, 62,
15, 60, 59,
12, 62, 60,
62, 59, 60,
1, 58, 53,
17, 63, 58,
16, 53, 63,
53, 58, 63,
3, 44, 61,
13, 64, 44,
17, 61, 64,
61, 44, 64,
5, 55, 42,
16, 65, 55,
13, 42, 65,
42, 55, 65,
16, 63, 65,
17, 64, 63,
13, 65, 64,
65, 63, 64
]);
var sphereBuf = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, sphereBuf);
gl.bufferData(gl.ARRAY_BUFFER, v, gl.STATIC_DRAW);
var sphereIbuf = gl.createBuffer();
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, sphereIbuf);
gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, f, gl.STATIC_DRAW);
// ****** spheres object 22 ******
var prog22  = gl.createProgram();
gl.attachShader(prog22, getShader( gl, "testgl2vshader22" ));
gl.attachShader(prog22, getShader( gl, "testgl2fshader22" ));
//  Force aPos to location 0, aCol to location 1 
gl.bindAttribLocation(prog22, 0, "aPos");
gl.bindAttribLocation(prog22, 1, "aCol");
gl.linkProgram(prog22);
var v=new Float32Array([
-3.723899, -1.174808, -2.862073, 1, 0, 0, 1, 1,
-3.427581, -1.046136, -3.662311, 1, 0.007843138, 0, 1, 1,
-2.856955, 1.768426, -2.192704, 1, 0.01176471, 0, 1, 1,
-2.745353, 0.2406146, -3.170748, 1, 0.01960784, 0, 1, 1,
-2.681754, 0.125107, -2.068935, 1, 0.02352941, 0, 1, 1,
-2.66251, 0.4469104, -1.488732, 1, 0.03137255, 0, 1, 1,
-2.526235, -0.6732168, -1.672588, 1, 0.03529412, 0, 1, 1,
-2.508309, -0.4111649, -0.0360541, 1, 0.04313726, 0, 1, 1,
-2.441543, 0.4003249, -0.5142992, 1, 0.04705882, 0, 1, 1,
-2.295571, -1.666941, -1.926674, 1, 0.05490196, 0, 1, 1,
-2.287787, 0.3627476, -1.389838, 1, 0.05882353, 0, 1, 1,
-2.282546, -1.323847, -1.096779, 1, 0.06666667, 0, 1, 1,
-2.262708, -0.6410999, -3.318885, 1, 0.07058824, 0, 1, 1,
-2.226838, 1.075475, -1.081083, 1, 0.07843138, 0, 1, 1,
-2.217201, 0.1440333, -0.5319436, 1, 0.08235294, 0, 1, 1,
-2.21563, 0.2117469, -1.813251, 1, 0.09019608, 0, 1, 1,
-2.162075, 0.03383597, -0.9668435, 1, 0.09411765, 0, 1, 1,
-2.138978, 1.10674, -1.463239, 1, 0.1019608, 0, 1, 1,
-2.114624, -1.557516, -3.144872, 1, 0.1098039, 0, 1, 1,
-2.054815, -1.021594, -2.080229, 1, 0.1137255, 0, 1, 1,
-2.041716, 0.2437096, -1.458344, 1, 0.1215686, 0, 1, 1,
-2.03093, -0.9067695, -2.432555, 1, 0.1254902, 0, 1, 1,
-2.019136, 0.6047248, -1.623301, 1, 0.1333333, 0, 1, 1,
-1.977349, -0.7066426, -0.4081417, 1, 0.1372549, 0, 1, 1,
-1.970206, -1.053511, -2.8851, 1, 0.145098, 0, 1, 1,
-1.944071, 0.7051514, -0.3514828, 1, 0.1490196, 0, 1, 1,
-1.938763, 0.8939622, -1.456001, 1, 0.1568628, 0, 1, 1,
-1.935846, 2.042911, -1.175815, 1, 0.1607843, 0, 1, 1,
-1.921864, 0.4608665, -0.9473923, 1, 0.1686275, 0, 1, 1,
-1.919328, 0.8599289, -4.443442, 1, 0.172549, 0, 1, 1,
-1.897377, -0.7097372, -2.610484, 1, 0.1803922, 0, 1, 1,
-1.884912, 0.6137511, -1.905356, 1, 0.1843137, 0, 1, 1,
-1.877634, 1.527783, -1.809254, 1, 0.1921569, 0, 1, 1,
-1.874858, -0.759961, -1.032975, 1, 0.1960784, 0, 1, 1,
-1.873809, 2.008901, 0.6135783, 1, 0.2039216, 0, 1, 1,
-1.862452, -1.766395, -2.629311, 1, 0.2117647, 0, 1, 1,
-1.854349, 0.2602721, -0.007155344, 1, 0.2156863, 0, 1, 1,
-1.837561, 1.264542, -1.875503, 1, 0.2235294, 0, 1, 1,
-1.832538, -1.889237, -2.495586, 1, 0.227451, 0, 1, 1,
-1.777246, 1.582728, -0.3171376, 1, 0.2352941, 0, 1, 1,
-1.774978, -0.5184366, -2.900842, 1, 0.2392157, 0, 1, 1,
-1.758299, 0.8300139, -0.7440431, 1, 0.2470588, 0, 1, 1,
-1.746577, -0.7187104, -3.694435, 1, 0.2509804, 0, 1, 1,
-1.736207, 1.993243, 0.4305008, 1, 0.2588235, 0, 1, 1,
-1.716181, -0.094064, -1.092216, 1, 0.2627451, 0, 1, 1,
-1.690898, 0.8038301, -1.808931, 1, 0.2705882, 0, 1, 1,
-1.686234, 0.4868247, -2.605466, 1, 0.2745098, 0, 1, 1,
-1.658709, 0.01562309, 0.07279549, 1, 0.282353, 0, 1, 1,
-1.656825, -0.3963818, 0.5054622, 1, 0.2862745, 0, 1, 1,
-1.6376, -0.7628423, -1.511879, 1, 0.2941177, 0, 1, 1,
-1.633225, -0.242143, -2.0538, 1, 0.3019608, 0, 1, 1,
-1.624535, 0.70881, -2.136641, 1, 0.3058824, 0, 1, 1,
-1.606266, 0.05215101, -2.064869, 1, 0.3137255, 0, 1, 1,
-1.585052, 0.2946248, -2.232705, 1, 0.3176471, 0, 1, 1,
-1.572311, 0.3118526, 0.5047471, 1, 0.3254902, 0, 1, 1,
-1.570317, 1.194734, -1.229809, 1, 0.3294118, 0, 1, 1,
-1.567826, -0.17296, -2.332493, 1, 0.3372549, 0, 1, 1,
-1.56532, -2.120637, -3.468659, 1, 0.3411765, 0, 1, 1,
-1.554685, -0.2691471, -1.433374, 1, 0.3490196, 0, 1, 1,
-1.54731, -0.3164389, -1.124996, 1, 0.3529412, 0, 1, 1,
-1.534123, 1.382846, -2.207459, 1, 0.3607843, 0, 1, 1,
-1.533898, 1.638199, -1.79631, 1, 0.3647059, 0, 1, 1,
-1.531584, -1.121698, -2.070215, 1, 0.372549, 0, 1, 1,
-1.531263, -0.6385744, -1.703488, 1, 0.3764706, 0, 1, 1,
-1.524408, 1.135167, -2.15679, 1, 0.3843137, 0, 1, 1,
-1.516702, -1.717699, -0.2307149, 1, 0.3882353, 0, 1, 1,
-1.513676, -0.1784227, -2.309049, 1, 0.3960784, 0, 1, 1,
-1.480342, 0.2612963, 0.1157612, 1, 0.4039216, 0, 1, 1,
-1.479178, 1.271563, -0.5533691, 1, 0.4078431, 0, 1, 1,
-1.477872, 0.1235162, -1.493248, 1, 0.4156863, 0, 1, 1,
-1.46774, -1.4985, -1.608544, 1, 0.4196078, 0, 1, 1,
-1.465721, -0.9588265, -2.554334, 1, 0.427451, 0, 1, 1,
-1.452213, 0.122277, -3.730535, 1, 0.4313726, 0, 1, 1,
-1.433094, 1.007091, 0.2511797, 1, 0.4392157, 0, 1, 1,
-1.431287, -1.084143, -1.536043, 1, 0.4431373, 0, 1, 1,
-1.420476, 0.188948, -3.860354, 1, 0.4509804, 0, 1, 1,
-1.420127, 0.7835695, -0.2178158, 1, 0.454902, 0, 1, 1,
-1.409853, -1.01944, -2.255015, 1, 0.4627451, 0, 1, 1,
-1.398638, 1.702523, -1.205677, 1, 0.4666667, 0, 1, 1,
-1.391266, 0.5024824, 0.2966643, 1, 0.4745098, 0, 1, 1,
-1.384546, 0.002228824, -0.2917655, 1, 0.4784314, 0, 1, 1,
-1.380774, -0.9266812, -3.306605, 1, 0.4862745, 0, 1, 1,
-1.379075, -3.17163, -1.279858, 1, 0.4901961, 0, 1, 1,
-1.375972, -0.4229557, -1.301228, 1, 0.4980392, 0, 1, 1,
-1.375, 0.8497379, -0.4834183, 1, 0.5058824, 0, 1, 1,
-1.357174, -1.182973, -2.882634, 1, 0.509804, 0, 1, 1,
-1.354338, 2.054375, -1.403988, 1, 0.5176471, 0, 1, 1,
-1.342606, -0.8873053, -0.3400687, 1, 0.5215687, 0, 1, 1,
-1.328409, -1.337338, -4.252946, 1, 0.5294118, 0, 1, 1,
-1.326784, 0.2472245, -1.012787, 1, 0.5333334, 0, 1, 1,
-1.326282, -1.222264, -2.951963, 1, 0.5411765, 0, 1, 1,
-1.315873, -1.711876, -3.596144, 1, 0.5450981, 0, 1, 1,
-1.31551, -0.07759126, -1.365808, 1, 0.5529412, 0, 1, 1,
-1.312093, 1.841865, -0.6149846, 1, 0.5568628, 0, 1, 1,
-1.306495, 0.6486217, -1.843791, 1, 0.5647059, 0, 1, 1,
-1.277099, 0.7508245, -1.742489, 1, 0.5686275, 0, 1, 1,
-1.275854, -0.7060663, -3.718202, 1, 0.5764706, 0, 1, 1,
-1.26518, -1.074411, -2.535691, 1, 0.5803922, 0, 1, 1,
-1.263208, 1.054984, -1.747445, 1, 0.5882353, 0, 1, 1,
-1.260049, 0.3120326, -0.9420762, 1, 0.5921569, 0, 1, 1,
-1.249361, 1.171309, -0.1068759, 1, 0.6, 0, 1, 1,
-1.247665, -2.091709, -1.352006, 1, 0.6078432, 0, 1, 1,
-1.232593, -0.371849, -0.9146267, 1, 0.6117647, 0, 1, 1,
-1.229744, 0.3772203, -1.521757, 1, 0.6196079, 0, 1, 1,
-1.22637, 1.548563, -3.168191, 1, 0.6235294, 0, 1, 1,
-1.219944, -0.5241567, 0.2958312, 1, 0.6313726, 0, 1, 1,
-1.214711, -0.2753627, -2.563764, 1, 0.6352941, 0, 1, 1,
-1.214475, -2.130125, -1.432373, 1, 0.6431373, 0, 1, 1,
-1.212931, 0.886436, -0.1951925, 1, 0.6470588, 0, 1, 1,
-1.21047, -0.5805226, -1.381491, 1, 0.654902, 0, 1, 1,
-1.209921, -1.031795, -0.5499772, 1, 0.6588235, 0, 1, 1,
-1.202962, 0.2296205, -2.750332, 1, 0.6666667, 0, 1, 1,
-1.202355, -0.4142951, -1.578118, 1, 0.6705883, 0, 1, 1,
-1.202267, 0.3736885, -1.973356, 1, 0.6784314, 0, 1, 1,
-1.200779, 1.301898, 1.47926, 1, 0.682353, 0, 1, 1,
-1.193274, 1.700287, -1.018995, 1, 0.6901961, 0, 1, 1,
-1.18969, 1.607534, -0.3525928, 1, 0.6941177, 0, 1, 1,
-1.182851, 1.436274, -0.6513256, 1, 0.7019608, 0, 1, 1,
-1.178394, 1.549653, -1.214149, 1, 0.7098039, 0, 1, 1,
-1.178331, -1.847076, -1.818654, 1, 0.7137255, 0, 1, 1,
-1.169384, -0.4526452, -1.315933, 1, 0.7215686, 0, 1, 1,
-1.166657, 0.6640505, -1.045324, 1, 0.7254902, 0, 1, 1,
-1.160016, -0.9118068, -1.012875, 1, 0.7333333, 0, 1, 1,
-1.158184, -0.746667, -0.2811581, 1, 0.7372549, 0, 1, 1,
-1.15796, 0.3947643, -0.7762097, 1, 0.7450981, 0, 1, 1,
-1.157863, -0.6784438, -3.220386, 1, 0.7490196, 0, 1, 1,
-1.15343, -0.4830916, -1.444741, 1, 0.7568628, 0, 1, 1,
-1.152031, 0.5873079, -1.720062, 1, 0.7607843, 0, 1, 1,
-1.14351, -2.1738, -3.184777, 1, 0.7686275, 0, 1, 1,
-1.139587, -0.243955, -1.315385, 1, 0.772549, 0, 1, 1,
-1.133249, 1.670914, -0.763754, 1, 0.7803922, 0, 1, 1,
-1.118662, -0.544989, -1.019055, 1, 0.7843137, 0, 1, 1,
-1.113919, 0.2686984, -1.225195, 1, 0.7921569, 0, 1, 1,
-1.111533, 0.1206992, -0.2911318, 1, 0.7960784, 0, 1, 1,
-1.110883, -0.5396878, -3.587186, 1, 0.8039216, 0, 1, 1,
-1.109533, -0.1920408, -1.351721, 1, 0.8117647, 0, 1, 1,
-1.106144, 0.7112145, 0.3568049, 1, 0.8156863, 0, 1, 1,
-1.094858, -0.1813561, -2.907635, 1, 0.8235294, 0, 1, 1,
-1.090395, -1.892464, -1.737422, 1, 0.827451, 0, 1, 1,
-1.089164, 0.6366993, -1.625497, 1, 0.8352941, 0, 1, 1,
-1.085682, 1.024064, -0.006786657, 1, 0.8392157, 0, 1, 1,
-1.082935, -0.07153133, -1.604334, 1, 0.8470588, 0, 1, 1,
-1.080158, -0.2055272, 0.4760721, 1, 0.8509804, 0, 1, 1,
-1.069755, 1.365724, 0.3255536, 1, 0.8588235, 0, 1, 1,
-1.068752, 0.3391646, -2.616983, 1, 0.8627451, 0, 1, 1,
-1.059767, -0.6150755, -0.7839214, 1, 0.8705882, 0, 1, 1,
-1.057288, -0.7513286, -4.231937, 1, 0.8745098, 0, 1, 1,
-1.047174, 0.9745672, 0.2892236, 1, 0.8823529, 0, 1, 1,
-1.044325, -0.4916867, -3.618618, 1, 0.8862745, 0, 1, 1,
-1.042585, -1.504911, -2.763294, 1, 0.8941177, 0, 1, 1,
-1.042019, 0.1742235, -1.350734, 1, 0.8980392, 0, 1, 1,
-1.038723, 3.069173, 1.804098, 1, 0.9058824, 0, 1, 1,
-1.037058, -0.2010946, -1.941719, 1, 0.9137255, 0, 1, 1,
-1.03471, 0.684829, -1.818503, 1, 0.9176471, 0, 1, 1,
-1.032407, 0.06768111, -0.1058617, 1, 0.9254902, 0, 1, 1,
-1.02911, -2.40325, -2.616132, 1, 0.9294118, 0, 1, 1,
-1.028319, 0.1361324, -0.7393107, 1, 0.9372549, 0, 1, 1,
-1.024102, 0.4276702, -2.020425, 1, 0.9411765, 0, 1, 1,
-1.022834, 2.300011, 0.2386485, 1, 0.9490196, 0, 1, 1,
-1.019978, 1.933495, -2.030977, 1, 0.9529412, 0, 1, 1,
-1.01494, -1.708348, -1.505744, 1, 0.9607843, 0, 1, 1,
-1.014636, 0.5924899, -3.377526, 1, 0.9647059, 0, 1, 1,
-1.01406, -1.048644, -2.120661, 1, 0.972549, 0, 1, 1,
-1.005623, -0.4116699, -1.162693, 1, 0.9764706, 0, 1, 1,
-0.9980236, 0.3999331, -0.3976511, 1, 0.9843137, 0, 1, 1,
-0.9928768, 0.7424904, -3.236729, 1, 0.9882353, 0, 1, 1,
-0.9917351, 1.246032, 1.274782, 1, 0.9960784, 0, 1, 1,
-0.9915358, -1.298971, -1.37257, 0.9960784, 1, 0, 1, 1,
-0.9896742, -0.9418274, -2.885436, 0.9921569, 1, 0, 1, 1,
-0.9862204, 0.6868169, -1.360128, 0.9843137, 1, 0, 1, 1,
-0.9861142, -0.8857446, -3.189615, 0.9803922, 1, 0, 1, 1,
-0.9817488, 0.3675374, 0.1046237, 0.972549, 1, 0, 1, 1,
-0.9807053, 0.08887215, 1.450502, 0.9686275, 1, 0, 1, 1,
-0.9782221, 0.8134556, -1.304634, 0.9607843, 1, 0, 1, 1,
-0.9670976, 0.6341242, 0.3571605, 0.9568627, 1, 0, 1, 1,
-0.9541621, -2.565286, -2.007432, 0.9490196, 1, 0, 1, 1,
-0.953723, -0.4062905, -2.54193, 0.945098, 1, 0, 1, 1,
-0.9489968, -0.5524504, -2.989305, 0.9372549, 1, 0, 1, 1,
-0.9475687, -1.904708, -0.4930968, 0.9333333, 1, 0, 1, 1,
-0.9422081, -0.7164491, -2.686351, 0.9254902, 1, 0, 1, 1,
-0.9415932, 0.1665552, -2.711516, 0.9215686, 1, 0, 1, 1,
-0.9406415, -0.0717074, -2.670455, 0.9137255, 1, 0, 1, 1,
-0.9363099, -1.162486, -0.4412647, 0.9098039, 1, 0, 1, 1,
-0.9298937, 0.756157, 0.8430582, 0.9019608, 1, 0, 1, 1,
-0.9284343, -0.2440782, -4.254698, 0.8941177, 1, 0, 1, 1,
-0.9269251, 0.7464315, -0.2320329, 0.8901961, 1, 0, 1, 1,
-0.925631, 0.1833154, -2.324828, 0.8823529, 1, 0, 1, 1,
-0.9196384, 0.388375, -1.628374, 0.8784314, 1, 0, 1, 1,
-0.9173442, 0.5180275, 0.1618702, 0.8705882, 1, 0, 1, 1,
-0.9075341, -0.6074507, -2.167737, 0.8666667, 1, 0, 1, 1,
-0.9028065, 7.038956e-05, -3.026059, 0.8588235, 1, 0, 1, 1,
-0.9025725, 1.723501, -2.078718, 0.854902, 1, 0, 1, 1,
-0.9023467, -0.7989613, -4.125688, 0.8470588, 1, 0, 1, 1,
-0.9020711, 0.2846987, -1.520527, 0.8431373, 1, 0, 1, 1,
-0.8979169, 1.042127, -0.4707444, 0.8352941, 1, 0, 1, 1,
-0.8975903, -0.02755251, -3.573378, 0.8313726, 1, 0, 1, 1,
-0.8930877, -0.8690515, -1.603424, 0.8235294, 1, 0, 1, 1,
-0.8867748, -0.7831473, -2.697576, 0.8196079, 1, 0, 1, 1,
-0.8799019, -0.5216552, -3.580835, 0.8117647, 1, 0, 1, 1,
-0.8764384, 0.1062869, -1.969172, 0.8078431, 1, 0, 1, 1,
-0.871517, 1.052297, -1.87975, 0.8, 1, 0, 1, 1,
-0.8710625, -1.509137, -3.692944, 0.7921569, 1, 0, 1, 1,
-0.8686125, -1.951546, -3.252637, 0.7882353, 1, 0, 1, 1,
-0.8684798, -0.5745999, -2.035099, 0.7803922, 1, 0, 1, 1,
-0.8676553, -0.1973071, -1.729902, 0.7764706, 1, 0, 1, 1,
-0.8675202, -0.4982095, -1.464818, 0.7686275, 1, 0, 1, 1,
-0.8625978, 0.7465076, -2.438119, 0.7647059, 1, 0, 1, 1,
-0.8594957, 0.8632941, -0.7147896, 0.7568628, 1, 0, 1, 1,
-0.8577256, -0.5372536, -2.193124, 0.7529412, 1, 0, 1, 1,
-0.8576042, 0.4314426, -2.840227, 0.7450981, 1, 0, 1, 1,
-0.8564775, 0.8602703, 0.4393331, 0.7411765, 1, 0, 1, 1,
-0.8549018, 1.452168, -0.3714827, 0.7333333, 1, 0, 1, 1,
-0.8548387, 0.02232319, -2.661909, 0.7294118, 1, 0, 1, 1,
-0.8538951, -0.7157273, -1.658383, 0.7215686, 1, 0, 1, 1,
-0.8534085, 0.2081508, -1.598811, 0.7176471, 1, 0, 1, 1,
-0.8487267, -0.2409144, -0.1646694, 0.7098039, 1, 0, 1, 1,
-0.8451462, 0.5875477, -0.6962743, 0.7058824, 1, 0, 1, 1,
-0.8403758, 1.805352, 0.239357, 0.6980392, 1, 0, 1, 1,
-0.837243, 0.2734775, -0.7045823, 0.6901961, 1, 0, 1, 1,
-0.8332328, 1.292477, -1.078595, 0.6862745, 1, 0, 1, 1,
-0.8306068, -0.8487861, -1.739327, 0.6784314, 1, 0, 1, 1,
-0.828477, 0.6807617, -1.153495, 0.6745098, 1, 0, 1, 1,
-0.8252169, 0.25244, -1.145994, 0.6666667, 1, 0, 1, 1,
-0.8166401, 0.5377196, -1.690366, 0.6627451, 1, 0, 1, 1,
-0.8153032, 0.3979036, 0.5892745, 0.654902, 1, 0, 1, 1,
-0.8025857, 0.4462683, 0.5679225, 0.6509804, 1, 0, 1, 1,
-0.7877355, 1.852253, -0.5219038, 0.6431373, 1, 0, 1, 1,
-0.7849736, 1.540838, -0.2934482, 0.6392157, 1, 0, 1, 1,
-0.779898, -0.4080557, -3.410397, 0.6313726, 1, 0, 1, 1,
-0.7773473, 0.3576979, -1.557213, 0.627451, 1, 0, 1, 1,
-0.7770708, 0.2300803, 0.5146928, 0.6196079, 1, 0, 1, 1,
-0.7733723, 1.006953, 1.998977, 0.6156863, 1, 0, 1, 1,
-0.7730039, -0.9472206, -2.626283, 0.6078432, 1, 0, 1, 1,
-0.7709777, -0.5264447, -1.35644, 0.6039216, 1, 0, 1, 1,
-0.7692652, 1.056177, -0.4312863, 0.5960785, 1, 0, 1, 1,
-0.7656419, 0.7534432, -0.8913898, 0.5882353, 1, 0, 1, 1,
-0.7602975, 0.4820208, -2.900633, 0.5843138, 1, 0, 1, 1,
-0.7602549, 0.4262793, -1.137708, 0.5764706, 1, 0, 1, 1,
-0.7596326, 0.492118, -2.186286, 0.572549, 1, 0, 1, 1,
-0.7520473, 1.239595, -1.653391, 0.5647059, 1, 0, 1, 1,
-0.7492434, 0.4445724, -1.34607, 0.5607843, 1, 0, 1, 1,
-0.7489356, -1.210599, -2.510075, 0.5529412, 1, 0, 1, 1,
-0.7447134, 2.000248, 0.8100493, 0.5490196, 1, 0, 1, 1,
-0.7373448, 0.6777617, -0.6248254, 0.5411765, 1, 0, 1, 1,
-0.7345873, -0.390019, -1.28211, 0.5372549, 1, 0, 1, 1,
-0.7326894, 0.5721838, -0.742907, 0.5294118, 1, 0, 1, 1,
-0.7321822, -0.2121645, -1.724021, 0.5254902, 1, 0, 1, 1,
-0.7307193, 0.5867652, -1.252678, 0.5176471, 1, 0, 1, 1,
-0.7231988, 0.06559078, -3.020811, 0.5137255, 1, 0, 1, 1,
-0.719531, 0.3040597, -1.085294, 0.5058824, 1, 0, 1, 1,
-0.715444, 0.143363, -1.07073, 0.5019608, 1, 0, 1, 1,
-0.7137702, 2.281805, 1.188481, 0.4941176, 1, 0, 1, 1,
-0.7069963, 0.08719819, -1.002139, 0.4862745, 1, 0, 1, 1,
-0.7062987, -0.9890946, -1.793462, 0.4823529, 1, 0, 1, 1,
-0.7047905, 0.8330279, -1.079168, 0.4745098, 1, 0, 1, 1,
-0.6955718, 0.9987524, -1.485139, 0.4705882, 1, 0, 1, 1,
-0.6888917, -0.05709499, -0.4084838, 0.4627451, 1, 0, 1, 1,
-0.6789625, -1.774471, -3.332248, 0.4588235, 1, 0, 1, 1,
-0.6736014, 0.8113593, -0.8763199, 0.4509804, 1, 0, 1, 1,
-0.673098, 0.9687696, -0.2112656, 0.4470588, 1, 0, 1, 1,
-0.6730584, -1.600206, -0.7999105, 0.4392157, 1, 0, 1, 1,
-0.671514, 1.331513, 1.058506, 0.4352941, 1, 0, 1, 1,
-0.6689327, 2.298997, 1.301666, 0.427451, 1, 0, 1, 1,
-0.6685575, 1.555475, 1.266017, 0.4235294, 1, 0, 1, 1,
-0.6620339, 0.7869548, 1.236279, 0.4156863, 1, 0, 1, 1,
-0.6583707, 0.9180353, 1.344533, 0.4117647, 1, 0, 1, 1,
-0.6580484, -1.058225, -1.019417, 0.4039216, 1, 0, 1, 1,
-0.6521081, 0.6903294, 0.05761723, 0.3960784, 1, 0, 1, 1,
-0.649554, 0.1535451, -2.587261, 0.3921569, 1, 0, 1, 1,
-0.6487852, -1.620428, -4.235984, 0.3843137, 1, 0, 1, 1,
-0.6456727, -2.158959, -2.13879, 0.3803922, 1, 0, 1, 1,
-0.6405653, -0.6007341, -1.905224, 0.372549, 1, 0, 1, 1,
-0.6391456, 0.8935215, -0.4301025, 0.3686275, 1, 0, 1, 1,
-0.6322663, -1.304669, -0.9993231, 0.3607843, 1, 0, 1, 1,
-0.6283665, -0.5170739, -2.663906, 0.3568628, 1, 0, 1, 1,
-0.6265903, 0.5898218, -1.231476, 0.3490196, 1, 0, 1, 1,
-0.6257271, 1.350941, 0.2680455, 0.345098, 1, 0, 1, 1,
-0.6225688, 0.3415103, -0.8385779, 0.3372549, 1, 0, 1, 1,
-0.6211084, 0.5968934, -1.663081, 0.3333333, 1, 0, 1, 1,
-0.6194851, 0.3723135, -0.3600534, 0.3254902, 1, 0, 1, 1,
-0.6192177, -0.5856976, -3.255728, 0.3215686, 1, 0, 1, 1,
-0.6129084, 0.2223195, -1.225157, 0.3137255, 1, 0, 1, 1,
-0.6125401, -0.7657807, -2.843093, 0.3098039, 1, 0, 1, 1,
-0.6095012, -1.405129, -2.097104, 0.3019608, 1, 0, 1, 1,
-0.6094169, 2.212696, -0.6712692, 0.2941177, 1, 0, 1, 1,
-0.6092088, 0.5370407, -0.6515899, 0.2901961, 1, 0, 1, 1,
-0.6077462, -0.865242, -2.933602, 0.282353, 1, 0, 1, 1,
-0.5952857, 0.5158493, -0.2696256, 0.2784314, 1, 0, 1, 1,
-0.5942753, 0.6144778, -1.935609, 0.2705882, 1, 0, 1, 1,
-0.593652, -0.05394804, -0.7797351, 0.2666667, 1, 0, 1, 1,
-0.5936019, -0.3094763, -3.118197, 0.2588235, 1, 0, 1, 1,
-0.5931416, 1.073322, -0.6422964, 0.254902, 1, 0, 1, 1,
-0.5930872, -0.1315962, -2.143291, 0.2470588, 1, 0, 1, 1,
-0.5905653, 0.5934852, -0.4890686, 0.2431373, 1, 0, 1, 1,
-0.5883543, -0.2479481, -0.9154258, 0.2352941, 1, 0, 1, 1,
-0.5876809, -1.122548, -3.571324, 0.2313726, 1, 0, 1, 1,
-0.5851306, -0.008164575, -0.3191325, 0.2235294, 1, 0, 1, 1,
-0.5842478, -1.548167, -2.863144, 0.2196078, 1, 0, 1, 1,
-0.582523, -1.352774, -1.888158, 0.2117647, 1, 0, 1, 1,
-0.5804369, 0.1885044, -0.9767566, 0.2078431, 1, 0, 1, 1,
-0.5778699, -0.7828351, -2.601956, 0.2, 1, 0, 1, 1,
-0.566164, -0.8313401, -1.777196, 0.1921569, 1, 0, 1, 1,
-0.557835, 0.7832905, -1.518665, 0.1882353, 1, 0, 1, 1,
-0.5542786, 1.88116, 0.516654, 0.1803922, 1, 0, 1, 1,
-0.5529186, 0.5815513, 0.3096565, 0.1764706, 1, 0, 1, 1,
-0.5441342, 1.176482, -0.05496055, 0.1686275, 1, 0, 1, 1,
-0.5359592, 1.062843, 0.6487893, 0.1647059, 1, 0, 1, 1,
-0.5342416, -1.150717, -4.325399, 0.1568628, 1, 0, 1, 1,
-0.5333458, 0.974741, -1.662406, 0.1529412, 1, 0, 1, 1,
-0.5328038, 0.6232508, -0.541736, 0.145098, 1, 0, 1, 1,
-0.5314077, -0.3804938, -1.677499, 0.1411765, 1, 0, 1, 1,
-0.528649, -0.8001954, -2.648802, 0.1333333, 1, 0, 1, 1,
-0.5283719, 0.6544627, 0.6884134, 0.1294118, 1, 0, 1, 1,
-0.523703, 0.3048748, -0.8674229, 0.1215686, 1, 0, 1, 1,
-0.5215252, -1.793809, -3.510428, 0.1176471, 1, 0, 1, 1,
-0.5200726, -1.497682, -3.162356, 0.1098039, 1, 0, 1, 1,
-0.5194336, 1.777109, -0.4629432, 0.1058824, 1, 0, 1, 1,
-0.5193478, -0.1968173, -2.688241, 0.09803922, 1, 0, 1, 1,
-0.5128958, 0.7947276, -1.586786, 0.09019608, 1, 0, 1, 1,
-0.5116058, 1.751951, 1.253453, 0.08627451, 1, 0, 1, 1,
-0.5101643, -1.496249, -2.322425, 0.07843138, 1, 0, 1, 1,
-0.5099733, -0.1879501, -2.659186, 0.07450981, 1, 0, 1, 1,
-0.5086982, -0.3571709, -2.979491, 0.06666667, 1, 0, 1, 1,
-0.4958898, -0.1454751, -1.31997, 0.0627451, 1, 0, 1, 1,
-0.4944299, 1.63589, -1.233735, 0.05490196, 1, 0, 1, 1,
-0.4943055, 0.1825204, -2.011615, 0.05098039, 1, 0, 1, 1,
-0.4933615, -1.589053, -2.261135, 0.04313726, 1, 0, 1, 1,
-0.4919859, 0.7399005, -2.240518, 0.03921569, 1, 0, 1, 1,
-0.4886889, 1.183836, -1.685206, 0.03137255, 1, 0, 1, 1,
-0.4883292, 0.4011457, -0.2510886, 0.02745098, 1, 0, 1, 1,
-0.4859614, -1.082812, -1.815034, 0.01960784, 1, 0, 1, 1,
-0.4851987, 1.598418, 0.2145436, 0.01568628, 1, 0, 1, 1,
-0.4827231, -2.408318, -3.312909, 0.007843138, 1, 0, 1, 1,
-0.4805069, 0.7166181, -0.1211463, 0.003921569, 1, 0, 1, 1,
-0.4796414, -0.5433568, -2.382306, 0, 1, 0.003921569, 1, 1,
-0.4775812, 0.09788524, -1.546093, 0, 1, 0.01176471, 1, 1,
-0.4728524, 1.563186, -1.432648, 0, 1, 0.01568628, 1, 1,
-0.4726515, 1.949304, -1.154336, 0, 1, 0.02352941, 1, 1,
-0.4688212, 1.258659, 0.2868575, 0, 1, 0.02745098, 1, 1,
-0.4687471, 1.407343, 0.1734399, 0, 1, 0.03529412, 1, 1,
-0.4682401, -0.1094442, -1.703588, 0, 1, 0.03921569, 1, 1,
-0.4654428, 1.69856, -1.417909, 0, 1, 0.04705882, 1, 1,
-0.4637203, 0.4884702, -1.016355, 0, 1, 0.05098039, 1, 1,
-0.4614093, 2.100477, -1.499217, 0, 1, 0.05882353, 1, 1,
-0.4550155, -0.8728124, -2.978377, 0, 1, 0.0627451, 1, 1,
-0.4544562, 0.953149, -0.7472581, 0, 1, 0.07058824, 1, 1,
-0.4520197, -0.4509206, -1.61831, 0, 1, 0.07450981, 1, 1,
-0.4519918, -1.466117, -3.225052, 0, 1, 0.08235294, 1, 1,
-0.4514574, 0.4118111, -0.1263017, 0, 1, 0.08627451, 1, 1,
-0.4474753, -0.1717925, -3.341898, 0, 1, 0.09411765, 1, 1,
-0.4442485, -0.664884, -2.165685, 0, 1, 0.1019608, 1, 1,
-0.4441818, -1.366904, -0.7420105, 0, 1, 0.1058824, 1, 1,
-0.4435645, -0.6470314, -3.157138, 0, 1, 0.1137255, 1, 1,
-0.4409784, -0.9484434, -3.429233, 0, 1, 0.1176471, 1, 1,
-0.4403009, 0.3640505, -2.702812, 0, 1, 0.1254902, 1, 1,
-0.4401521, -0.9816712, -3.652213, 0, 1, 0.1294118, 1, 1,
-0.4375425, 0.3422718, -2.166455, 0, 1, 0.1372549, 1, 1,
-0.4354239, -0.1344417, -1.410137, 0, 1, 0.1411765, 1, 1,
-0.4349791, 0.7459281, -0.3471935, 0, 1, 0.1490196, 1, 1,
-0.4326984, 0.1276533, -0.1141622, 0, 1, 0.1529412, 1, 1,
-0.4323543, -0.2539048, -1.94356, 0, 1, 0.1607843, 1, 1,
-0.4294159, -0.800072, -2.381454, 0, 1, 0.1647059, 1, 1,
-0.4280309, 1.162404, 1.179402, 0, 1, 0.172549, 1, 1,
-0.4264165, -1.736774, -3.871756, 0, 1, 0.1764706, 1, 1,
-0.4187451, 1.761264, -0.8733773, 0, 1, 0.1843137, 1, 1,
-0.4185766, -0.9387845, -1.897371, 0, 1, 0.1882353, 1, 1,
-0.4153437, -2.129217, -4.246303, 0, 1, 0.1960784, 1, 1,
-0.4152058, -0.6694384, -3.612054, 0, 1, 0.2039216, 1, 1,
-0.4151545, 2.724159, 0.08865369, 0, 1, 0.2078431, 1, 1,
-0.4133289, 1.914767, -0.692538, 0, 1, 0.2156863, 1, 1,
-0.412002, -1.345304, -2.526165, 0, 1, 0.2196078, 1, 1,
-0.406084, -0.7818443, -2.363255, 0, 1, 0.227451, 1, 1,
-0.4033222, 0.897242, 0.0672015, 0, 1, 0.2313726, 1, 1,
-0.3976374, 0.9927598, -0.8725573, 0, 1, 0.2392157, 1, 1,
-0.3970765, -0.5028359, -3.115244, 0, 1, 0.2431373, 1, 1,
-0.3941162, 0.5984747, 0.9401685, 0, 1, 0.2509804, 1, 1,
-0.3927709, 1.108141, -0.8647085, 0, 1, 0.254902, 1, 1,
-0.3905289, -0.1344073, -2.879965, 0, 1, 0.2627451, 1, 1,
-0.382215, 1.337826, 1.656813, 0, 1, 0.2666667, 1, 1,
-0.3775682, 0.4681113, -1.899514, 0, 1, 0.2745098, 1, 1,
-0.3768777, 1.344673, -1.406092, 0, 1, 0.2784314, 1, 1,
-0.3715016, -1.953075, -4.704878, 0, 1, 0.2862745, 1, 1,
-0.3684815, -0.2896957, -2.208179, 0, 1, 0.2901961, 1, 1,
-0.3662277, -0.1404953, -3.125173, 0, 1, 0.2980392, 1, 1,
-0.3647585, -0.2754808, -1.950336, 0, 1, 0.3058824, 1, 1,
-0.3610064, -1.518005, -0.9797122, 0, 1, 0.3098039, 1, 1,
-0.3580893, -1.798972, -0.4509198, 0, 1, 0.3176471, 1, 1,
-0.3579046, 1.678135, 0.03435731, 0, 1, 0.3215686, 1, 1,
-0.3501363, 1.991986, -0.1130983, 0, 1, 0.3294118, 1, 1,
-0.3479843, -0.5675679, -1.20693, 0, 1, 0.3333333, 1, 1,
-0.3451059, -0.3117804, -1.166415, 0, 1, 0.3411765, 1, 1,
-0.3421208, -1.119484, -3.687862, 0, 1, 0.345098, 1, 1,
-0.3367518, 0.1027041, -1.640107, 0, 1, 0.3529412, 1, 1,
-0.3295338, -1.22802, -4.452396, 0, 1, 0.3568628, 1, 1,
-0.3239605, -1.400671, -1.843893, 0, 1, 0.3647059, 1, 1,
-0.3176321, -0.04186469, -1.804823, 0, 1, 0.3686275, 1, 1,
-0.316764, -0.7591729, -3.493178, 0, 1, 0.3764706, 1, 1,
-0.3046649, 1.714666, 1.682104, 0, 1, 0.3803922, 1, 1,
-0.3038115, -0.4779657, -2.263167, 0, 1, 0.3882353, 1, 1,
-0.3025008, 1.790872, 0.9961182, 0, 1, 0.3921569, 1, 1,
-0.3020713, 2.421164, 1.010174, 0, 1, 0.4, 1, 1,
-0.3016832, 2.04724, 0.7529601, 0, 1, 0.4078431, 1, 1,
-0.2971895, 0.2182152, 0.04991271, 0, 1, 0.4117647, 1, 1,
-0.2930385, -1.487828, -2.367185, 0, 1, 0.4196078, 1, 1,
-0.29241, 0.02100733, -2.239332, 0, 1, 0.4235294, 1, 1,
-0.2887771, 0.6610607, -1.098797, 0, 1, 0.4313726, 1, 1,
-0.2769458, -1.956862, -3.001158, 0, 1, 0.4352941, 1, 1,
-0.2765782, -0.812073, -2.285866, 0, 1, 0.4431373, 1, 1,
-0.2761607, 0.2114933, -1.831257, 0, 1, 0.4470588, 1, 1,
-0.2717141, 2.064219, -1.856286, 0, 1, 0.454902, 1, 1,
-0.2705375, 1.271773, -0.0703478, 0, 1, 0.4588235, 1, 1,
-0.2620989, 1.359803, -1.662506, 0, 1, 0.4666667, 1, 1,
-0.2564563, -1.969959, -2.729268, 0, 1, 0.4705882, 1, 1,
-0.2546789, 0.6616604, -1.359711, 0, 1, 0.4784314, 1, 1,
-0.2537269, -1.448724, -3.666827, 0, 1, 0.4823529, 1, 1,
-0.2527709, 0.6398091, -2.897683, 0, 1, 0.4901961, 1, 1,
-0.2505563, -2.112051, -1.803548, 0, 1, 0.4941176, 1, 1,
-0.2481562, 1.74403, 0.1784381, 0, 1, 0.5019608, 1, 1,
-0.2450086, 0.4760576, -1.897503, 0, 1, 0.509804, 1, 1,
-0.2417189, -0.3302926, -2.523005, 0, 1, 0.5137255, 1, 1,
-0.2412526, -0.07642686, -2.495628, 0, 1, 0.5215687, 1, 1,
-0.2408317, 0.6202224, -0.9741758, 0, 1, 0.5254902, 1, 1,
-0.2392306, 0.04795812, -1.825108, 0, 1, 0.5333334, 1, 1,
-0.2370735, -2.970453, -3.752069, 0, 1, 0.5372549, 1, 1,
-0.2362012, -1.364132, -2.674639, 0, 1, 0.5450981, 1, 1,
-0.235479, -1.749119, -3.461643, 0, 1, 0.5490196, 1, 1,
-0.232811, 1.945419, -1.26102, 0, 1, 0.5568628, 1, 1,
-0.2298447, 2.325963, -0.3968894, 0, 1, 0.5607843, 1, 1,
-0.2287888, 1.294375, -0.5367572, 0, 1, 0.5686275, 1, 1,
-0.2274294, 0.9818897, -1.288346, 0, 1, 0.572549, 1, 1,
-0.2255541, -1.117283, -3.715817, 0, 1, 0.5803922, 1, 1,
-0.2247945, 1.034238, 1.386097, 0, 1, 0.5843138, 1, 1,
-0.2209412, -0.2455634, -2.088492, 0, 1, 0.5921569, 1, 1,
-0.2174088, -1.436874, -5.071074, 0, 1, 0.5960785, 1, 1,
-0.2104547, -0.4521708, -0.367959, 0, 1, 0.6039216, 1, 1,
-0.206596, -0.09323037, -1.245188, 0, 1, 0.6117647, 1, 1,
-0.1967657, -1.019738, -3.179181, 0, 1, 0.6156863, 1, 1,
-0.1942529, 0.4965087, 0.4337484, 0, 1, 0.6235294, 1, 1,
-0.1874661, -0.9081845, -1.640732, 0, 1, 0.627451, 1, 1,
-0.1865413, -1.28369, -4.36593, 0, 1, 0.6352941, 1, 1,
-0.1859539, 2.082825, -1.886939, 0, 1, 0.6392157, 1, 1,
-0.1844535, -0.3354126, -2.317173, 0, 1, 0.6470588, 1, 1,
-0.1832368, -0.1238601, -2.432533, 0, 1, 0.6509804, 1, 1,
-0.1821977, 0.8825371, 0.2383934, 0, 1, 0.6588235, 1, 1,
-0.1765736, 0.8882709, 0.2616142, 0, 1, 0.6627451, 1, 1,
-0.1751654, 1.304005, 0.02551487, 0, 1, 0.6705883, 1, 1,
-0.1715224, -0.516925, -4.751801, 0, 1, 0.6745098, 1, 1,
-0.1670301, -0.8284846, -3.860142, 0, 1, 0.682353, 1, 1,
-0.1662069, 0.1566349, -0.9600564, 0, 1, 0.6862745, 1, 1,
-0.1655815, 0.7188349, -1.131666, 0, 1, 0.6941177, 1, 1,
-0.1640668, 0.2918135, -0.7708285, 0, 1, 0.7019608, 1, 1,
-0.163733, 0.2055128, -0.5047642, 0, 1, 0.7058824, 1, 1,
-0.1623281, -0.3161741, -4.497215, 0, 1, 0.7137255, 1, 1,
-0.1594674, 2.085142, -0.3862026, 0, 1, 0.7176471, 1, 1,
-0.1594054, 0.2768332, -0.7431002, 0, 1, 0.7254902, 1, 1,
-0.1581841, 1.007612, 1.425264, 0, 1, 0.7294118, 1, 1,
-0.1578033, 0.6693347, -0.2144346, 0, 1, 0.7372549, 1, 1,
-0.154669, -0.4484975, -2.129242, 0, 1, 0.7411765, 1, 1,
-0.1401004, -0.135916, -1.116733, 0, 1, 0.7490196, 1, 1,
-0.1378451, -0.2454336, -3.045907, 0, 1, 0.7529412, 1, 1,
-0.1373704, 1.164101, -0.6825094, 0, 1, 0.7607843, 1, 1,
-0.132794, -1.304702, -3.339282, 0, 1, 0.7647059, 1, 1,
-0.1283028, 1.3845, -1.155197, 0, 1, 0.772549, 1, 1,
-0.127091, 0.8022229, -1.14697, 0, 1, 0.7764706, 1, 1,
-0.1259235, -1.338845, -2.728697, 0, 1, 0.7843137, 1, 1,
-0.1179273, 1.68036, -1.094882, 0, 1, 0.7882353, 1, 1,
-0.1178817, -0.5821235, -3.016975, 0, 1, 0.7960784, 1, 1,
-0.1131316, -1.042141, -3.670077, 0, 1, 0.8039216, 1, 1,
-0.1075908, -0.8904693, -4.025469, 0, 1, 0.8078431, 1, 1,
-0.1064875, 0.3103443, -0.9307585, 0, 1, 0.8156863, 1, 1,
-0.106221, 0.1283565, 0.4528971, 0, 1, 0.8196079, 1, 1,
-0.1035988, -0.3131643, -0.6050877, 0, 1, 0.827451, 1, 1,
-0.1019115, 0.09626864, 0.005074059, 0, 1, 0.8313726, 1, 1,
-0.1007378, 0.2947959, -2.595794, 0, 1, 0.8392157, 1, 1,
-0.1005616, 0.08585789, -0.4095171, 0, 1, 0.8431373, 1, 1,
-0.09830789, -0.6308268, -3.092365, 0, 1, 0.8509804, 1, 1,
-0.09692983, 1.027628, -1.6451, 0, 1, 0.854902, 1, 1,
-0.09485804, -0.2258326, -1.737706, 0, 1, 0.8627451, 1, 1,
-0.09331537, -1.586803, -2.608293, 0, 1, 0.8666667, 1, 1,
-0.08621641, 1.160919, -0.180584, 0, 1, 0.8745098, 1, 1,
-0.08561933, 1.078356, 2.088506, 0, 1, 0.8784314, 1, 1,
-0.0738298, 0.02274955, -1.356405, 0, 1, 0.8862745, 1, 1,
-0.0716133, 0.4230025, -0.5641416, 0, 1, 0.8901961, 1, 1,
-0.07034445, 0.7682059, 0.5323604, 0, 1, 0.8980392, 1, 1,
-0.06782831, -1.095353, -2.608786, 0, 1, 0.9058824, 1, 1,
-0.06336162, 0.04892766, -0.5878607, 0, 1, 0.9098039, 1, 1,
-0.0571797, 0.8599915, 0.2624654, 0, 1, 0.9176471, 1, 1,
-0.05696657, -0.5543167, -2.21932, 0, 1, 0.9215686, 1, 1,
-0.04795164, -0.4179489, -3.968439, 0, 1, 0.9294118, 1, 1,
-0.04591076, 0.1048027, -1.851232, 0, 1, 0.9333333, 1, 1,
-0.04379577, -0.6487277, -1.898105, 0, 1, 0.9411765, 1, 1,
-0.04092681, 0.8498623, 0.8902293, 0, 1, 0.945098, 1, 1,
-0.02433708, 1.305838, -0.9957497, 0, 1, 0.9529412, 1, 1,
-0.0237897, 1.099113, 1.142987, 0, 1, 0.9568627, 1, 1,
-0.01080667, 2.171082, 0.2159214, 0, 1, 0.9647059, 1, 1,
-0.008729436, 0.6840643, 0.6580881, 0, 1, 0.9686275, 1, 1,
-0.007769526, 1.103421, 1.080129, 0, 1, 0.9764706, 1, 1,
-0.007161918, -0.4048029, -3.934758, 0, 1, 0.9803922, 1, 1,
-0.006930724, 0.9956631, 1.469314, 0, 1, 0.9882353, 1, 1,
0.001219539, 0.1591457, -2.82713, 0, 1, 0.9921569, 1, 1,
0.001704833, -0.4918649, 3.162894, 0, 1, 1, 1, 1,
0.003498518, -2.418861, 1.485498, 0, 0.9921569, 1, 1, 1,
0.004007854, 0.9103662, -0.1527204, 0, 0.9882353, 1, 1, 1,
0.008206617, -1.19365, 3.625415, 0, 0.9803922, 1, 1, 1,
0.008997879, -1.139502, 2.664068, 0, 0.9764706, 1, 1, 1,
0.01975908, -1.540097, 3.169292, 0, 0.9686275, 1, 1, 1,
0.02279575, -1.315502, 0.6092227, 0, 0.9647059, 1, 1, 1,
0.02549624, 1.040911, 0.7907414, 0, 0.9568627, 1, 1, 1,
0.02916914, 0.9308298, -0.5159558, 0, 0.9529412, 1, 1, 1,
0.02968654, 1.597827, -1.41127, 0, 0.945098, 1, 1, 1,
0.03391488, 0.6069543, 0.8868778, 0, 0.9411765, 1, 1, 1,
0.03427552, -1.389871, 4.765063, 0, 0.9333333, 1, 1, 1,
0.0374966, -0.2483693, 2.252429, 0, 0.9294118, 1, 1, 1,
0.03828548, 0.4868284, -0.1496562, 0, 0.9215686, 1, 1, 1,
0.03862356, 0.295131, 0.896687, 0, 0.9176471, 1, 1, 1,
0.04113955, -0.4293142, 3.42068, 0, 0.9098039, 1, 1, 1,
0.04192989, -0.1133664, 3.740098, 0, 0.9058824, 1, 1, 1,
0.04373112, -0.8179761, 2.569706, 0, 0.8980392, 1, 1, 1,
0.04766657, 0.5680977, 1.739274, 0, 0.8901961, 1, 1, 1,
0.04921158, 0.4008954, -0.2295268, 0, 0.8862745, 1, 1, 1,
0.05421181, 1.134564, -0.4488359, 0, 0.8784314, 1, 1, 1,
0.0562811, 0.9918744, -0.03317701, 0, 0.8745098, 1, 1, 1,
0.056608, -0.8136622, 1.818212, 0, 0.8666667, 1, 1, 1,
0.05721388, -2.032167, 1.598727, 0, 0.8627451, 1, 1, 1,
0.06462232, 0.4898255, 0.001855613, 0, 0.854902, 1, 1, 1,
0.06632315, -0.4543938, 2.890639, 0, 0.8509804, 1, 1, 1,
0.06893586, 0.4043029, 1.452154, 0, 0.8431373, 1, 1, 1,
0.06988784, 1.702878, 0.9753977, 0, 0.8392157, 1, 1, 1,
0.07008322, -1.035295, 3.760857, 0, 0.8313726, 1, 1, 1,
0.07147398, -0.7576151, 2.771463, 0, 0.827451, 1, 1, 1,
0.07949637, 0.7376404, 0.8568543, 0, 0.8196079, 1, 1, 1,
0.07950726, 0.9894521, 1.642382, 0, 0.8156863, 1, 1, 1,
0.08258402, -1.01035, 3.379025, 0, 0.8078431, 1, 1, 1,
0.08351152, -0.5670342, 4.329869, 0, 0.8039216, 1, 1, 1,
0.08453715, 1.573284, 0.2630222, 0, 0.7960784, 1, 1, 1,
0.08688621, 0.7030022, 0.6941236, 0, 0.7882353, 1, 1, 1,
0.08753577, -0.2630938, 1.900282, 0, 0.7843137, 1, 1, 1,
0.08766748, 0.587421, 2.423946, 0, 0.7764706, 1, 1, 1,
0.08921459, -0.2591272, 3.389663, 0, 0.772549, 1, 1, 1,
0.08980703, 0.02213161, 0.09384505, 0, 0.7647059, 1, 1, 1,
0.09863049, 0.7197552, 2.019261, 0, 0.7607843, 1, 1, 1,
0.09934024, 0.2884066, -1.263398, 0, 0.7529412, 1, 1, 1,
0.1004169, -1.250368, 3.754371, 0, 0.7490196, 1, 1, 1,
0.1016013, -0.6889648, 3.224412, 0, 0.7411765, 1, 1, 1,
0.102411, 0.4119448, -1.244147, 0, 0.7372549, 1, 1, 1,
0.1047624, 0.8803824, 0.2167245, 0, 0.7294118, 1, 1, 1,
0.105026, 1.490113, -1.341156, 0, 0.7254902, 1, 1, 1,
0.1061837, -0.605748, 4.009259, 0, 0.7176471, 1, 1, 1,
0.1089676, 0.9090301, 1.690251, 0, 0.7137255, 1, 1, 1,
0.1091877, -0.2116593, 2.338996, 0, 0.7058824, 1, 1, 1,
0.1146473, -0.7962971, 2.263951, 0, 0.6980392, 1, 1, 1,
0.1155059, -0.4172834, 1.346053, 0, 0.6941177, 1, 1, 1,
0.1271824, -0.7724879, 3.632755, 0, 0.6862745, 1, 1, 1,
0.1281713, -0.8386358, 1.733827, 0, 0.682353, 1, 1, 1,
0.131022, -0.2988588, 3.777316, 0, 0.6745098, 1, 1, 1,
0.1315709, 1.394821, -0.5743017, 0, 0.6705883, 1, 1, 1,
0.1320455, -0.4442372, 2.063958, 0, 0.6627451, 1, 1, 1,
0.1322069, -0.3784429, 1.667121, 0, 0.6588235, 1, 1, 1,
0.1322632, -2.009024, 2.29295, 0, 0.6509804, 1, 1, 1,
0.1343672, 0.6433499, -0.5854139, 0, 0.6470588, 1, 1, 1,
0.1378701, -1.094659, 3.458965, 0, 0.6392157, 1, 1, 1,
0.1451787, 1.009026, 0.7520938, 0, 0.6352941, 1, 1, 1,
0.1464554, -1.375342, 4.227269, 0, 0.627451, 1, 1, 1,
0.1503105, -1.096311, 0.6227301, 0, 0.6235294, 1, 1, 1,
0.156383, -0.6378381, 1.711258, 0, 0.6156863, 1, 1, 1,
0.1566408, -0.3517095, 1.773862, 0, 0.6117647, 1, 1, 1,
0.1603873, 1.156156, 1.288158, 0, 0.6039216, 1, 1, 1,
0.1701992, -0.6686376, 3.038809, 0, 0.5960785, 1, 1, 1,
0.1740813, 1.027394, -0.6929709, 0, 0.5921569, 1, 1, 1,
0.1762539, -0.009505671, 1.661414, 0, 0.5843138, 1, 1, 1,
0.176608, -0.2940746, 1.462149, 0, 0.5803922, 1, 1, 1,
0.1827117, 1.113486, 0.9080405, 0, 0.572549, 1, 1, 1,
0.1843311, -0.6077639, 3.797778, 0, 0.5686275, 1, 1, 1,
0.1870324, -0.7514484, 2.588846, 0, 0.5607843, 1, 1, 1,
0.1901645, 0.3506367, -0.7703125, 0, 0.5568628, 1, 1, 1,
0.1902245, -0.1326771, 3.986285, 0, 0.5490196, 1, 1, 1,
0.1923493, 0.6050991, -1.106044, 0, 0.5450981, 1, 1, 1,
0.195106, 0.651093, 1.551826, 0, 0.5372549, 1, 1, 1,
0.1985198, -1.92744, 1.840496, 0, 0.5333334, 1, 1, 1,
0.2002612, -1.104317, 2.044692, 0, 0.5254902, 1, 1, 1,
0.2004043, -2.324528, 3.460923, 0, 0.5215687, 1, 1, 1,
0.2023895, -0.2789691, 4.510924, 0, 0.5137255, 1, 1, 1,
0.2025931, -0.4017732, 4.643079, 0, 0.509804, 1, 1, 1,
0.2031321, 0.2855789, 0.07793661, 0, 0.5019608, 1, 1, 1,
0.2032727, 0.6643398, 0.05212244, 0, 0.4941176, 1, 1, 1,
0.2043381, 0.911994, 0.9566951, 0, 0.4901961, 1, 1, 1,
0.2070837, 1.473192, 0.1273621, 0, 0.4823529, 1, 1, 1,
0.2104714, 0.1298516, 1.008535, 0, 0.4784314, 1, 1, 1,
0.2153071, 0.7962821, 2.034572, 0, 0.4705882, 1, 1, 1,
0.2182917, 1.900133, 1.090699, 0, 0.4666667, 1, 1, 1,
0.221537, -1.407587, 1.77643, 0, 0.4588235, 1, 1, 1,
0.2248826, -0.1585707, 1.904154, 0, 0.454902, 1, 1, 1,
0.2253325, 0.2003389, 1.023228, 0, 0.4470588, 1, 1, 1,
0.2272464, 1.369725, 1.629763, 0, 0.4431373, 1, 1, 1,
0.2283318, 0.164792, 2.689409, 0, 0.4352941, 1, 1, 1,
0.228458, 1.007949, 0.7786537, 0, 0.4313726, 1, 1, 1,
0.228839, -0.03004916, 3.571068, 0, 0.4235294, 1, 1, 1,
0.229087, -1.805739, 2.316205, 0, 0.4196078, 1, 1, 1,
0.2315847, -0.1826196, 1.222508, 0, 0.4117647, 1, 1, 1,
0.2324234, -1.900572, 2.502908, 0, 0.4078431, 1, 1, 1,
0.2392136, 0.3824268, 0.4140602, 0, 0.4, 1, 1, 1,
0.2408713, -0.1109741, 2.344719, 0, 0.3921569, 1, 1, 1,
0.2417372, 0.3557263, 2.845777, 0, 0.3882353, 1, 1, 1,
0.2457343, -0.9665728, 1.520215, 0, 0.3803922, 1, 1, 1,
0.2458574, 0.4419104, -0.5063123, 0, 0.3764706, 1, 1, 1,
0.2496853, 0.2207559, 0.7786372, 0, 0.3686275, 1, 1, 1,
0.2501015, 1.513384, -2.011081, 0, 0.3647059, 1, 1, 1,
0.2515944, 0.2933091, 0.9445218, 0, 0.3568628, 1, 1, 1,
0.2550042, -0.5897035, 3.165002, 0, 0.3529412, 1, 1, 1,
0.2558642, -0.6979328, 3.176224, 0, 0.345098, 1, 1, 1,
0.2579699, -0.7580149, 3.701447, 0, 0.3411765, 1, 1, 1,
0.2629401, 1.265393, -0.5543393, 0, 0.3333333, 1, 1, 1,
0.2651736, 0.5150576, 1.405641, 0, 0.3294118, 1, 1, 1,
0.2665262, -0.1374635, 2.395699, 0, 0.3215686, 1, 1, 1,
0.2725579, -0.2396232, 1.380778, 0, 0.3176471, 1, 1, 1,
0.2746024, 1.637916, -0.25455, 0, 0.3098039, 1, 1, 1,
0.2794263, 1.043238, 2.195205, 0, 0.3058824, 1, 1, 1,
0.2830888, -0.9327605, 3.668275, 0, 0.2980392, 1, 1, 1,
0.2861455, 0.150933, 0.6546265, 0, 0.2901961, 1, 1, 1,
0.2894072, -0.500652, 1.995234, 0, 0.2862745, 1, 1, 1,
0.2941574, -0.8999793, 3.175024, 0, 0.2784314, 1, 1, 1,
0.296481, -1.047955, 4.302612, 0, 0.2745098, 1, 1, 1,
0.3014125, 0.8859422, -0.5954125, 0, 0.2666667, 1, 1, 1,
0.3020001, -0.5189298, 4.526032, 0, 0.2627451, 1, 1, 1,
0.3083999, -0.8080802, 1.286245, 0, 0.254902, 1, 1, 1,
0.3088281, 0.6253923, 1.102969, 0, 0.2509804, 1, 1, 1,
0.3089657, -0.4603115, 2.354429, 0, 0.2431373, 1, 1, 1,
0.3094393, 1.311688, 0.5760108, 0, 0.2392157, 1, 1, 1,
0.3109975, 0.02130649, 0.9470279, 0, 0.2313726, 1, 1, 1,
0.3123192, 0.366646, 0.7552225, 0, 0.227451, 1, 1, 1,
0.316535, 0.7009294, 1.570801, 0, 0.2196078, 1, 1, 1,
0.3168089, 0.2575646, 2.487049, 0, 0.2156863, 1, 1, 1,
0.3184977, 3.121705, 0.4803089, 0, 0.2078431, 1, 1, 1,
0.3185145, 0.3216442, 1.603574, 0, 0.2039216, 1, 1, 1,
0.3220885, 0.7982969, -1.525609, 0, 0.1960784, 1, 1, 1,
0.3244564, 0.4849475, 0.5351025, 0, 0.1882353, 1, 1, 1,
0.3245281, 2.562411, 2.214167, 0, 0.1843137, 1, 1, 1,
0.3273158, -0.6566982, 1.952061, 0, 0.1764706, 1, 1, 1,
0.3274307, -0.1238267, -0.4741317, 0, 0.172549, 1, 1, 1,
0.3290916, 1.29275, -0.6399808, 0, 0.1647059, 1, 1, 1,
0.3294051, -1.633431, 2.969657, 0, 0.1607843, 1, 1, 1,
0.3358502, -1.82681, 2.910203, 0, 0.1529412, 1, 1, 1,
0.3370827, 1.501302, -0.1669337, 0, 0.1490196, 1, 1, 1,
0.3397537, 0.7819551, 1.1679, 0, 0.1411765, 1, 1, 1,
0.3402136, 0.5892377, 1.336047, 0, 0.1372549, 1, 1, 1,
0.3443763, 0.9477915, -1.105253, 0, 0.1294118, 1, 1, 1,
0.3552937, 1.025213, -0.5800571, 0, 0.1254902, 1, 1, 1,
0.3574571, 0.1093242, 1.556837, 0, 0.1176471, 1, 1, 1,
0.3587462, -2.068061, 1.565969, 0, 0.1137255, 1, 1, 1,
0.3588261, 0.7589513, 0.5045671, 0, 0.1058824, 1, 1, 1,
0.3614353, 1.607722, 1.884711, 0, 0.09803922, 1, 1, 1,
0.362585, -0.4663649, 1.270001, 0, 0.09411765, 1, 1, 1,
0.3656709, 0.3362903, 0.9825829, 0, 0.08627451, 1, 1, 1,
0.3660716, -0.2011558, 2.696351, 0, 0.08235294, 1, 1, 1,
0.3666186, 0.4336534, 0.4939879, 0, 0.07450981, 1, 1, 1,
0.3677468, 0.5113723, 0.923243, 0, 0.07058824, 1, 1, 1,
0.3729932, -1.193949, 1.906034, 0, 0.0627451, 1, 1, 1,
0.3743951, 1.541941, -0.2656077, 0, 0.05882353, 1, 1, 1,
0.376458, 0.7715258, 1.606834, 0, 0.05098039, 1, 1, 1,
0.3810469, 0.866722, 1.816574, 0, 0.04705882, 1, 1, 1,
0.3851114, 0.02908836, 1.268872, 0, 0.03921569, 1, 1, 1,
0.3861769, 0.5189067, 0.943865, 0, 0.03529412, 1, 1, 1,
0.3924732, 0.2312436, 1.193038, 0, 0.02745098, 1, 1, 1,
0.3939469, -0.7990052, 2.065285, 0, 0.02352941, 1, 1, 1,
0.3962613, -0.1719644, 1.179204, 0, 0.01568628, 1, 1, 1,
0.3975469, -1.492169, 3.483827, 0, 0.01176471, 1, 1, 1,
0.3979358, -1.132759, 2.966211, 0, 0.003921569, 1, 1, 1,
0.3981763, 1.565462, -0.03684429, 0.003921569, 0, 1, 1, 1,
0.4011947, 1.438709, -0.4929226, 0.007843138, 0, 1, 1, 1,
0.4060276, -0.5120755, 2.050335, 0.01568628, 0, 1, 1, 1,
0.4132748, 0.8504304, -2.966754, 0.01960784, 0, 1, 1, 1,
0.4135079, -1.435888, 3.797258, 0.02745098, 0, 1, 1, 1,
0.4202137, -0.3198152, 1.194697, 0.03137255, 0, 1, 1, 1,
0.4222249, -0.0252203, 1.00127, 0.03921569, 0, 1, 1, 1,
0.422668, -0.5539824, 2.980556, 0.04313726, 0, 1, 1, 1,
0.4246233, 0.2804804, 1.302208, 0.05098039, 0, 1, 1, 1,
0.4256315, -0.419175, 0.7600357, 0.05490196, 0, 1, 1, 1,
0.4274856, -2.31797, 4.422239, 0.0627451, 0, 1, 1, 1,
0.4275635, -2.011344, 2.005651, 0.06666667, 0, 1, 1, 1,
0.4294135, -0.4282746, 1.393742, 0.07450981, 0, 1, 1, 1,
0.4317306, -1.213405, 4.065571, 0.07843138, 0, 1, 1, 1,
0.4318567, 0.5480385, 0.4303223, 0.08627451, 0, 1, 1, 1,
0.4370883, -0.2950225, 2.489445, 0.09019608, 0, 1, 1, 1,
0.4389149, 0.551809, 0.5013592, 0.09803922, 0, 1, 1, 1,
0.4390755, -0.3858097, 2.974144, 0.1058824, 0, 1, 1, 1,
0.4396924, -0.6970468, 2.664685, 0.1098039, 0, 1, 1, 1,
0.4402871, -0.0942449, -0.3506022, 0.1176471, 0, 1, 1, 1,
0.4411615, -0.7401239, 4.069596, 0.1215686, 0, 1, 1, 1,
0.4439472, 2.204817, 0.6562603, 0.1294118, 0, 1, 1, 1,
0.4452528, -0.8787975, 2.499334, 0.1333333, 0, 1, 1, 1,
0.4503816, 1.145636, -0.116697, 0.1411765, 0, 1, 1, 1,
0.4524397, -0.6361492, 1.745716, 0.145098, 0, 1, 1, 1,
0.4535287, 0.5021421, 0.7398902, 0.1529412, 0, 1, 1, 1,
0.4540717, 1.005686, -0.6838219, 0.1568628, 0, 1, 1, 1,
0.454542, 0.5896879, 1.412749, 0.1647059, 0, 1, 1, 1,
0.454614, -2.383119, 4.515855, 0.1686275, 0, 1, 1, 1,
0.4671288, -0.6481335, 1.727641, 0.1764706, 0, 1, 1, 1,
0.471942, 0.05103176, 2.054498, 0.1803922, 0, 1, 1, 1,
0.4738281, -0.4445955, 1.899506, 0.1882353, 0, 1, 1, 1,
0.4797886, -0.2188, 1.761709, 0.1921569, 0, 1, 1, 1,
0.4813162, -1.662659, 2.689975, 0.2, 0, 1, 1, 1,
0.4817255, 0.3420978, 2.818926, 0.2078431, 0, 1, 1, 1,
0.4878528, 0.1074167, 0.6429303, 0.2117647, 0, 1, 1, 1,
0.4888866, 0.7088724, 0.09700067, 0.2196078, 0, 1, 1, 1,
0.4900078, -1.542478, 2.440245, 0.2235294, 0, 1, 1, 1,
0.4930615, -0.05356396, -0.294056, 0.2313726, 0, 1, 1, 1,
0.5025263, -1.555725, 1.506859, 0.2352941, 0, 1, 1, 1,
0.5055509, 0.9180011, -0.4045004, 0.2431373, 0, 1, 1, 1,
0.5078605, 0.1833566, 2.455326, 0.2470588, 0, 1, 1, 1,
0.5132307, -1.233904, 2.281092, 0.254902, 0, 1, 1, 1,
0.5145117, 0.2191361, 0.8768464, 0.2588235, 0, 1, 1, 1,
0.5207716, -0.123107, 2.064704, 0.2666667, 0, 1, 1, 1,
0.5208099, 0.2981392, 0.5823594, 0.2705882, 0, 1, 1, 1,
0.5211911, 2.459509, 0.5322948, 0.2784314, 0, 1, 1, 1,
0.5221373, 0.2776989, 1.988578, 0.282353, 0, 1, 1, 1,
0.5244309, -0.6567454, 2.507181, 0.2901961, 0, 1, 1, 1,
0.5276413, -0.6855602, 2.511964, 0.2941177, 0, 1, 1, 1,
0.5285388, -0.8044379, 2.995702, 0.3019608, 0, 1, 1, 1,
0.5326152, 0.5909189, -0.1531338, 0.3098039, 0, 1, 1, 1,
0.5355434, -1.642306, 2.441716, 0.3137255, 0, 1, 1, 1,
0.5439768, 0.843246, 1.19236, 0.3215686, 0, 1, 1, 1,
0.5454133, 1.981376, -1.400808, 0.3254902, 0, 1, 1, 1,
0.5461849, -1.798443, 3.20787, 0.3333333, 0, 1, 1, 1,
0.5463129, 0.2503084, 0.6206641, 0.3372549, 0, 1, 1, 1,
0.5490184, -1.634106, 3.210046, 0.345098, 0, 1, 1, 1,
0.549968, -0.4620486, 1.177622, 0.3490196, 0, 1, 1, 1,
0.5515737, -0.04727908, 4.09581, 0.3568628, 0, 1, 1, 1,
0.5532309, 1.398731, -0.06380877, 0.3607843, 0, 1, 1, 1,
0.55426, 0.8885552, 1.063554, 0.3686275, 0, 1, 1, 1,
0.5560955, 0.7477056, 1.302255, 0.372549, 0, 1, 1, 1,
0.5600862, 0.446787, 1.378156, 0.3803922, 0, 1, 1, 1,
0.5620962, -0.8749639, 3.631769, 0.3843137, 0, 1, 1, 1,
0.5647345, -0.2492768, 0.5129975, 0.3921569, 0, 1, 1, 1,
0.5714285, -0.3193717, 2.692174, 0.3960784, 0, 1, 1, 1,
0.5779681, 1.427036, 1.736961, 0.4039216, 0, 1, 1, 1,
0.5780121, -0.6730273, 1.992898, 0.4117647, 0, 1, 1, 1,
0.5804713, -0.649292, 2.757407, 0.4156863, 0, 1, 1, 1,
0.5864537, 0.7281153, -0.2962675, 0.4235294, 0, 1, 1, 1,
0.5877114, -0.0749789, 2.196407, 0.427451, 0, 1, 1, 1,
0.5882306, 0.1803455, 1.382446, 0.4352941, 0, 1, 1, 1,
0.590093, 0.2881803, 2.462284, 0.4392157, 0, 1, 1, 1,
0.5901197, -0.7496234, 4.150634, 0.4470588, 0, 1, 1, 1,
0.593319, -2.20875, 3.079376, 0.4509804, 0, 1, 1, 1,
0.6004535, 0.7848295, 1.848628, 0.4588235, 0, 1, 1, 1,
0.6043098, 0.003176037, -1.08002, 0.4627451, 0, 1, 1, 1,
0.6087044, -0.9064556, 2.764049, 0.4705882, 0, 1, 1, 1,
0.6105621, -1.792369, 1.340818, 0.4745098, 0, 1, 1, 1,
0.6176475, -1.809961, 3.992062, 0.4823529, 0, 1, 1, 1,
0.6203707, 0.1541092, 1.112434, 0.4862745, 0, 1, 1, 1,
0.6255314, -0.1058584, 2.452757, 0.4941176, 0, 1, 1, 1,
0.632068, 0.2068529, 2.131136, 0.5019608, 0, 1, 1, 1,
0.6400772, -2.34126, 2.929324, 0.5058824, 0, 1, 1, 1,
0.6429459, 0.004594657, 2.460353, 0.5137255, 0, 1, 1, 1,
0.6450915, 1.007467, 1.514408, 0.5176471, 0, 1, 1, 1,
0.6457725, -0.9449177, 2.030626, 0.5254902, 0, 1, 1, 1,
0.6512008, 2.402569, 0.004082744, 0.5294118, 0, 1, 1, 1,
0.6532981, -0.2770464, -0.04536484, 0.5372549, 0, 1, 1, 1,
0.6560643, -1.090149, 2.822868, 0.5411765, 0, 1, 1, 1,
0.6592804, 0.4884041, 2.421279, 0.5490196, 0, 1, 1, 1,
0.6605515, 1.261111, 1.793941, 0.5529412, 0, 1, 1, 1,
0.6635723, 0.3947808, 1.354425, 0.5607843, 0, 1, 1, 1,
0.6653597, 0.5925013, 0.6424487, 0.5647059, 0, 1, 1, 1,
0.6718308, 0.2253223, 0.6261898, 0.572549, 0, 1, 1, 1,
0.6723598, 1.05739, 0.399749, 0.5764706, 0, 1, 1, 1,
0.6833096, 0.3848311, 3.259648, 0.5843138, 0, 1, 1, 1,
0.6854413, 0.2384555, 1.66458, 0.5882353, 0, 1, 1, 1,
0.686087, 0.6958379, 0.928993, 0.5960785, 0, 1, 1, 1,
0.6864513, 0.2756996, 1.321042, 0.6039216, 0, 1, 1, 1,
0.6907477, 0.215565, 0.4538641, 0.6078432, 0, 1, 1, 1,
0.6922313, -1.248864, 3.803852, 0.6156863, 0, 1, 1, 1,
0.6922604, 1.187852, 0.9693772, 0.6196079, 0, 1, 1, 1,
0.6966832, -1.181573, 2.71617, 0.627451, 0, 1, 1, 1,
0.6998447, 2.560908, -1.334416, 0.6313726, 0, 1, 1, 1,
0.7013988, -2.041807, 3.58929, 0.6392157, 0, 1, 1, 1,
0.7021549, -0.3537046, 1.140583, 0.6431373, 0, 1, 1, 1,
0.7024857, -0.3736376, 2.959103, 0.6509804, 0, 1, 1, 1,
0.7025232, -1.392265, 2.108925, 0.654902, 0, 1, 1, 1,
0.7053373, 0.4283258, 1.645369, 0.6627451, 0, 1, 1, 1,
0.7117747, 0.3375047, 0.6793299, 0.6666667, 0, 1, 1, 1,
0.7127482, -0.2769562, 1.39629, 0.6745098, 0, 1, 1, 1,
0.715546, -0.7210174, 3.383814, 0.6784314, 0, 1, 1, 1,
0.7187696, -1.028857, 1.653665, 0.6862745, 0, 1, 1, 1,
0.7250212, 0.7154382, 1.059187, 0.6901961, 0, 1, 1, 1,
0.7256994, 0.279433, 0.02239653, 0.6980392, 0, 1, 1, 1,
0.7296615, 1.508976, 1.600603, 0.7058824, 0, 1, 1, 1,
0.7307287, 0.3384308, 1.179958, 0.7098039, 0, 1, 1, 1,
0.7326188, 1.770351, -1.609467, 0.7176471, 0, 1, 1, 1,
0.7355207, 0.07676698, 1.290207, 0.7215686, 0, 1, 1, 1,
0.7413077, -0.8347363, 0.8982932, 0.7294118, 0, 1, 1, 1,
0.7472786, -0.6442593, 0.4026196, 0.7333333, 0, 1, 1, 1,
0.751825, -0.4818695, 3.540309, 0.7411765, 0, 1, 1, 1,
0.7534716, -0.05594479, 2.596221, 0.7450981, 0, 1, 1, 1,
0.7569468, 0.8954507, 0.4941209, 0.7529412, 0, 1, 1, 1,
0.7589598, -1.009839, 3.453194, 0.7568628, 0, 1, 1, 1,
0.7621374, -0.1461665, 2.047808, 0.7647059, 0, 1, 1, 1,
0.7754127, -0.5081649, 1.461946, 0.7686275, 0, 1, 1, 1,
0.7758146, -0.7290562, 2.400377, 0.7764706, 0, 1, 1, 1,
0.7809841, -0.7849625, 2.905371, 0.7803922, 0, 1, 1, 1,
0.7850596, -1.418969, 4.951069, 0.7882353, 0, 1, 1, 1,
0.7919197, -1.283957, 2.814875, 0.7921569, 0, 1, 1, 1,
0.8010522, 0.7805045, 1.029332, 0.8, 0, 1, 1, 1,
0.8065641, 1.093031, -0.1320742, 0.8078431, 0, 1, 1, 1,
0.8077418, 0.8216671, 2.287275, 0.8117647, 0, 1, 1, 1,
0.810223, 0.1358454, 0.3580839, 0.8196079, 0, 1, 1, 1,
0.8112574, 0.8066399, 2.976826, 0.8235294, 0, 1, 1, 1,
0.8119471, -2.175536, 2.683193, 0.8313726, 0, 1, 1, 1,
0.8176362, -0.02028343, 1.500577, 0.8352941, 0, 1, 1, 1,
0.8209186, -2.162789, 1.49909, 0.8431373, 0, 1, 1, 1,
0.8222531, -1.297234, 3.061077, 0.8470588, 0, 1, 1, 1,
0.823438, -1.973457, 1.994821, 0.854902, 0, 1, 1, 1,
0.8288141, 0.7016112, 1.529384, 0.8588235, 0, 1, 1, 1,
0.8360422, -1.867695, 3.053902, 0.8666667, 0, 1, 1, 1,
0.8368364, -0.730765, 2.879801, 0.8705882, 0, 1, 1, 1,
0.8436727, 1.838132, 1.176435, 0.8784314, 0, 1, 1, 1,
0.8490207, 1.524053, 1.479474, 0.8823529, 0, 1, 1, 1,
0.8521729, 1.141579, -0.07043038, 0.8901961, 0, 1, 1, 1,
0.8549221, -1.731746, 2.987989, 0.8941177, 0, 1, 1, 1,
0.8575863, 0.3723337, -0.1192865, 0.9019608, 0, 1, 1, 1,
0.8582208, -0.399035, 2.409623, 0.9098039, 0, 1, 1, 1,
0.8596602, 0.8724169, 1.174797, 0.9137255, 0, 1, 1, 1,
0.8620926, -0.3854327, 1.619985, 0.9215686, 0, 1, 1, 1,
0.8638405, -0.3030692, 2.576937, 0.9254902, 0, 1, 1, 1,
0.8661147, -1.488537, 2.182631, 0.9333333, 0, 1, 1, 1,
0.8686584, -0.2106228, -0.2026381, 0.9372549, 0, 1, 1, 1,
0.8734738, 0.1262707, 2.537493, 0.945098, 0, 1, 1, 1,
0.8754525, -1.202066, 2.603546, 0.9490196, 0, 1, 1, 1,
0.8819166, 0.1306692, 0.6926153, 0.9568627, 0, 1, 1, 1,
0.8878453, -1.058486, 2.54012, 0.9607843, 0, 1, 1, 1,
0.8894818, -1.452483, 1.777972, 0.9686275, 0, 1, 1, 1,
0.9005938, -0.9445174, 2.81945, 0.972549, 0, 1, 1, 1,
0.9010507, 1.624528, 0.8004807, 0.9803922, 0, 1, 1, 1,
0.9012365, -0.7119036, 2.960691, 0.9843137, 0, 1, 1, 1,
0.9014962, -0.8880293, 1.071142, 0.9921569, 0, 1, 1, 1,
0.906072, 0.6743425, -0.2552006, 0.9960784, 0, 1, 1, 1,
0.9068193, -0.2622569, 1.650779, 1, 0, 0.9960784, 1, 1,
0.9154975, -0.8919083, 3.087955, 1, 0, 0.9882353, 1, 1,
0.9182022, -0.568504, 3.683698, 1, 0, 0.9843137, 1, 1,
0.9185509, 1.631103, 1.47052, 1, 0, 0.9764706, 1, 1,
0.9193084, 1.33645, 0.07143969, 1, 0, 0.972549, 1, 1,
0.9198117, 0.6023666, 0.6542116, 1, 0, 0.9647059, 1, 1,
0.9200692, 0.338908, 2.325414, 1, 0, 0.9607843, 1, 1,
0.9245216, 1.170286, -1.17804, 1, 0, 0.9529412, 1, 1,
0.9257174, -0.7094952, 2.646939, 1, 0, 0.9490196, 1, 1,
0.9299511, 0.1533136, 1.141991, 1, 0, 0.9411765, 1, 1,
0.9381107, 1.190785, 1.878474, 1, 0, 0.9372549, 1, 1,
0.9381678, -0.4746045, 2.853041, 1, 0, 0.9294118, 1, 1,
0.9493043, -1.866601, 2.909206, 1, 0, 0.9254902, 1, 1,
0.9494506, -0.7813994, -0.195689, 1, 0, 0.9176471, 1, 1,
0.9519706, 0.5833389, 2.781082, 1, 0, 0.9137255, 1, 1,
0.9582089, 2.857692, 2.353401, 1, 0, 0.9058824, 1, 1,
0.9639921, 0.6260873, 1.952128, 1, 0, 0.9019608, 1, 1,
0.9791738, -1.713581, 2.271316, 1, 0, 0.8941177, 1, 1,
0.9792929, -0.2895797, 3.993436, 1, 0, 0.8862745, 1, 1,
0.9862394, 0.9948325, 1.338305, 1, 0, 0.8823529, 1, 1,
0.9939089, -0.8152223, 1.052494, 1, 0, 0.8745098, 1, 1,
1.013168, 0.1134449, 0.7933398, 1, 0, 0.8705882, 1, 1,
1.015396, -0.5820512, 1.508925, 1, 0, 0.8627451, 1, 1,
1.015543, 0.4594681, 1.702836, 1, 0, 0.8588235, 1, 1,
1.015699, 2.196918, 0.9233826, 1, 0, 0.8509804, 1, 1,
1.025202, -0.5719351, 2.00046, 1, 0, 0.8470588, 1, 1,
1.026738, -1.738111, 2.374892, 1, 0, 0.8392157, 1, 1,
1.033158, 0.03564237, 3.226393, 1, 0, 0.8352941, 1, 1,
1.033597, -1.693355, 1.934591, 1, 0, 0.827451, 1, 1,
1.034672, 1.646763, 0.641326, 1, 0, 0.8235294, 1, 1,
1.041234, -0.3890079, 1.643763, 1, 0, 0.8156863, 1, 1,
1.04659, -0.5856354, 0.9944965, 1, 0, 0.8117647, 1, 1,
1.051414, 1.338315, -0.3109962, 1, 0, 0.8039216, 1, 1,
1.061882, -0.8127635, 2.468551, 1, 0, 0.7960784, 1, 1,
1.062511, -1.026352, 0.8586898, 1, 0, 0.7921569, 1, 1,
1.062974, -0.7102201, 1.320696, 1, 0, 0.7843137, 1, 1,
1.063538, 0.06013515, 2.563902, 1, 0, 0.7803922, 1, 1,
1.073165, -1.233325, 1.73888, 1, 0, 0.772549, 1, 1,
1.075689, 0.2256082, 0.9750532, 1, 0, 0.7686275, 1, 1,
1.084078, -0.4579466, 2.967087, 1, 0, 0.7607843, 1, 1,
1.084199, 0.03601734, -0.6261376, 1, 0, 0.7568628, 1, 1,
1.084973, -1.060913, 3.170544, 1, 0, 0.7490196, 1, 1,
1.090853, 0.8189965, 0.1053865, 1, 0, 0.7450981, 1, 1,
1.094627, -0.04122735, 2.071004, 1, 0, 0.7372549, 1, 1,
1.098869, -0.1160373, 1.573558, 1, 0, 0.7333333, 1, 1,
1.118142, -0.3015626, -0.03272269, 1, 0, 0.7254902, 1, 1,
1.118277, -0.7325345, 4.191811, 1, 0, 0.7215686, 1, 1,
1.127261, 0.1623164, 0.6449798, 1, 0, 0.7137255, 1, 1,
1.127717, 1.144496, -0.1613174, 1, 0, 0.7098039, 1, 1,
1.13234, 1.024665, 1.275699, 1, 0, 0.7019608, 1, 1,
1.13605, 0.1623413, 0.4248481, 1, 0, 0.6941177, 1, 1,
1.143273, -0.4862761, 2.262187, 1, 0, 0.6901961, 1, 1,
1.144175, 0.1684318, 1.714651, 1, 0, 0.682353, 1, 1,
1.148313, -1.255966, 2.92929, 1, 0, 0.6784314, 1, 1,
1.150532, 1.428464, 0.07932459, 1, 0, 0.6705883, 1, 1,
1.158176, 0.3261495, 2.642394, 1, 0, 0.6666667, 1, 1,
1.159408, -0.278494, 3.258099, 1, 0, 0.6588235, 1, 1,
1.161074, -0.592608, 2.92918, 1, 0, 0.654902, 1, 1,
1.170882, 1.294493, 0.6706604, 1, 0, 0.6470588, 1, 1,
1.186131, 1.133598, 1.126415, 1, 0, 0.6431373, 1, 1,
1.187449, 0.492422, -0.3517848, 1, 0, 0.6352941, 1, 1,
1.194279, -0.7901961, 2.926389, 1, 0, 0.6313726, 1, 1,
1.195328, 1.428515, 0.4987946, 1, 0, 0.6235294, 1, 1,
1.211026, -0.1524145, 3.158807, 1, 0, 0.6196079, 1, 1,
1.228322, -0.6318569, 2.643301, 1, 0, 0.6117647, 1, 1,
1.230498, -0.07042287, 1.693638, 1, 0, 0.6078432, 1, 1,
1.243255, -0.2395758, 2.206864, 1, 0, 0.6, 1, 1,
1.248185, -2.417997, 4.628231, 1, 0, 0.5921569, 1, 1,
1.248262, 0.6931465, -0.07877998, 1, 0, 0.5882353, 1, 1,
1.252663, 1.592959, -1.377016, 1, 0, 0.5803922, 1, 1,
1.253895, 0.7527699, 2.024599, 1, 0, 0.5764706, 1, 1,
1.254939, 1.659052, 1.361285, 1, 0, 0.5686275, 1, 1,
1.260732, -1.126183, 2.837297, 1, 0, 0.5647059, 1, 1,
1.272526, 1.149219, -0.09915034, 1, 0, 0.5568628, 1, 1,
1.280948, 0.3076419, 1.515605, 1, 0, 0.5529412, 1, 1,
1.289842, 1.627775, 1.159736, 1, 0, 0.5450981, 1, 1,
1.290407, 1.3289, 0.6070443, 1, 0, 0.5411765, 1, 1,
1.290582, -0.6345137, 2.674232, 1, 0, 0.5333334, 1, 1,
1.290803, -0.9430569, 2.854928, 1, 0, 0.5294118, 1, 1,
1.294773, 0.9936706, 1.749932, 1, 0, 0.5215687, 1, 1,
1.297864, -0.7918959, 1.470999, 1, 0, 0.5176471, 1, 1,
1.299577, -0.6396596, 1.10645, 1, 0, 0.509804, 1, 1,
1.316568, -1.036432, 3.583486, 1, 0, 0.5058824, 1, 1,
1.318599, -0.5394133, 1.228281, 1, 0, 0.4980392, 1, 1,
1.318694, -1.291657, 3.645307, 1, 0, 0.4901961, 1, 1,
1.32082, -0.749276, 0.5632122, 1, 0, 0.4862745, 1, 1,
1.330144, -0.07176013, 2.949826, 1, 0, 0.4784314, 1, 1,
1.333522, 0.1895363, 2.715373, 1, 0, 0.4745098, 1, 1,
1.337678, -0.8693398, 1.994855, 1, 0, 0.4666667, 1, 1,
1.342997, 1.010803, 2.690386, 1, 0, 0.4627451, 1, 1,
1.343072, -0.1288425, 0.8646902, 1, 0, 0.454902, 1, 1,
1.35069, -0.03242924, 2.649254, 1, 0, 0.4509804, 1, 1,
1.355779, -0.4465154, 1.784166, 1, 0, 0.4431373, 1, 1,
1.356377, 1.203192, 1.577979, 1, 0, 0.4392157, 1, 1,
1.361093, -0.9486493, 2.129908, 1, 0, 0.4313726, 1, 1,
1.375085, -1.882701, 3.143571, 1, 0, 0.427451, 1, 1,
1.377592, -1.473398, 3.004123, 1, 0, 0.4196078, 1, 1,
1.377807, 0.291143, 2.067934, 1, 0, 0.4156863, 1, 1,
1.378457, 1.410434, 1.479233, 1, 0, 0.4078431, 1, 1,
1.379074, 1.407293, -0.1213265, 1, 0, 0.4039216, 1, 1,
1.3846, -0.7328498, 1.466472, 1, 0, 0.3960784, 1, 1,
1.390169, 1.39113, 3.053192, 1, 0, 0.3882353, 1, 1,
1.392962, 1.47848, 1.62279, 1, 0, 0.3843137, 1, 1,
1.401426, -0.316085, 0.6051263, 1, 0, 0.3764706, 1, 1,
1.412227, -0.5079264, 1.118938, 1, 0, 0.372549, 1, 1,
1.413357, -1.3404, 2.475384, 1, 0, 0.3647059, 1, 1,
1.417973, -1.360401, 1.269795, 1, 0, 0.3607843, 1, 1,
1.421133, 3.104734, 2.941546, 1, 0, 0.3529412, 1, 1,
1.425267, 0.1147367, 1.443326, 1, 0, 0.3490196, 1, 1,
1.430088, 0.8282426, 3.733769, 1, 0, 0.3411765, 1, 1,
1.442713, -0.7304509, 2.07237, 1, 0, 0.3372549, 1, 1,
1.446654, 1.321489, 0.4981655, 1, 0, 0.3294118, 1, 1,
1.46116, 0.06431238, 1.831105, 1, 0, 0.3254902, 1, 1,
1.468871, 0.9545047, 0.8150273, 1, 0, 0.3176471, 1, 1,
1.48722, -0.5776291, 0.6755177, 1, 0, 0.3137255, 1, 1,
1.507259, -0.8892632, 2.004795, 1, 0, 0.3058824, 1, 1,
1.507425, 0.8325257, 1.886708, 1, 0, 0.2980392, 1, 1,
1.519195, -1.286065, 2.328193, 1, 0, 0.2941177, 1, 1,
1.530879, -0.8890885, 2.197957, 1, 0, 0.2862745, 1, 1,
1.535635, -1.417622, 1.932433, 1, 0, 0.282353, 1, 1,
1.538403, -0.7990746, 2.156964, 1, 0, 0.2745098, 1, 1,
1.563027, -2.10719, 4.32894, 1, 0, 0.2705882, 1, 1,
1.579992, 0.428701, 1.683481, 1, 0, 0.2627451, 1, 1,
1.584342, 1.024816, 2.538318, 1, 0, 0.2588235, 1, 1,
1.588177, 1.266565, 2.331044, 1, 0, 0.2509804, 1, 1,
1.592158, -1.699652, 1.647516, 1, 0, 0.2470588, 1, 1,
1.615799, -0.2558973, 0.9220982, 1, 0, 0.2392157, 1, 1,
1.621689, -0.5358592, 3.018129, 1, 0, 0.2352941, 1, 1,
1.653139, -0.1974246, 2.11243, 1, 0, 0.227451, 1, 1,
1.655548, 0.9153848, -0.4378383, 1, 0, 0.2235294, 1, 1,
1.65838, -1.776865, 2.678429, 1, 0, 0.2156863, 1, 1,
1.68658, -1.402018, 2.259824, 1, 0, 0.2117647, 1, 1,
1.706091, 0.2059215, 1.494987, 1, 0, 0.2039216, 1, 1,
1.732933, 1.589667, 1.593885, 1, 0, 0.1960784, 1, 1,
1.746505, -0.3220624, 1.805343, 1, 0, 0.1921569, 1, 1,
1.7781, -0.07791012, 0.7807187, 1, 0, 0.1843137, 1, 1,
1.793897, 0.4714487, 1.317235, 1, 0, 0.1803922, 1, 1,
1.81269, -0.9764834, 0.6283538, 1, 0, 0.172549, 1, 1,
1.835452, 0.01160745, -0.2339551, 1, 0, 0.1686275, 1, 1,
1.889054, 0.1312015, -0.3120059, 1, 0, 0.1607843, 1, 1,
1.933942, 2.645133, 0.3726487, 1, 0, 0.1568628, 1, 1,
1.957441, -1.544478, 2.432388, 1, 0, 0.1490196, 1, 1,
1.961769, 1.245782, -1.877897, 1, 0, 0.145098, 1, 1,
1.962742, -0.5029621, 1.460645, 1, 0, 0.1372549, 1, 1,
1.970734, 0.1861844, 2.47656, 1, 0, 0.1333333, 1, 1,
1.971589, -0.03700073, 0.04570556, 1, 0, 0.1254902, 1, 1,
1.971618, -1.301505, 2.514026, 1, 0, 0.1215686, 1, 1,
1.981915, 0.5844358, 2.264728, 1, 0, 0.1137255, 1, 1,
1.987879, 2.559561, 2.270072, 1, 0, 0.1098039, 1, 1,
2.005021, -1.23516, 1.48871, 1, 0, 0.1019608, 1, 1,
2.018074, -0.2412126, 1.358291, 1, 0, 0.09411765, 1, 1,
2.042613, 1.060833, 1.5614, 1, 0, 0.09019608, 1, 1,
2.128617, -1.828878, 1.20187, 1, 0, 0.08235294, 1, 1,
2.13446, -0.102011, -1.439581, 1, 0, 0.07843138, 1, 1,
2.146979, -1.027482, 3.052289, 1, 0, 0.07058824, 1, 1,
2.169582, 0.2959155, 1.708643, 1, 0, 0.06666667, 1, 1,
2.206889, -0.7172513, 1.92205, 1, 0, 0.05882353, 1, 1,
2.285872, -0.4703882, 2.830842, 1, 0, 0.05490196, 1, 1,
2.329109, -0.08511806, 1.569272, 1, 0, 0.04705882, 1, 1,
2.380944, -0.3701869, 1.441354, 1, 0, 0.04313726, 1, 1,
2.390775, -1.057114, 2.529243, 1, 0, 0.03529412, 1, 1,
2.619398, -0.5513233, 1.63314, 1, 0, 0.03137255, 1, 1,
2.773947, 0.09259079, 0.5794399, 1, 0, 0.02352941, 1, 1,
2.793378, 1.47182, 1.867811, 1, 0, 0.01960784, 1, 1,
2.828604, 0.8743314, 0.4134258, 1, 0, 0.01176471, 1, 1,
2.863584, -0.9992427, 1.941149, 1, 0, 0.007843138, 1, 1
]);
var values22 = v;
var normLoc22 = gl.getAttribLocation(prog22, "aNorm");
var mvMatLoc22 = gl.getUniformLocation(prog22,"mvMatrix");
var prMatLoc22 = gl.getUniformLocation(prog22,"prMatrix");
var normMatLoc22 = gl.getUniformLocation(prog22,"normMatrix");
gl.enable(gl.DEPTH_TEST);
gl.depthFunc(gl.LEQUAL);
gl.clearDepth(1.0);
gl.clearColor(1, 1, 1, 1);
var xOffs = yOffs = 0,  drag  = 0;
drawScene();
function drawScene(){
gl.depthMask(true);
gl.disable(gl.BLEND);
var radius = 9.318503;
var s = sin(fov*PI/360);
var t = tan(fov*PI/360);
var distance = radius/s;
var near = distance - radius;
var far = distance + radius;
var hlen = t*near;
var aspect = width/height;
prMatrix.makeIdentity();
if (aspect > 1)
prMatrix.frustum(-hlen*aspect*zoom, hlen*aspect*zoom, 
-hlen*zoom, hlen*zoom, near, far);
else  
prMatrix.frustum(-hlen*zoom, hlen*zoom, 
-hlen*zoom/aspect, hlen*zoom/aspect, 
near, far);
mvMatrix.makeIdentity();
mvMatrix.translate( 0.4301573, 0.02496243, 0.06000209 );
mvMatrix.scale( 1, 1, 1 );   
mvMatrix.multRight( userMatrix );  
mvMatrix.translate(0, 0, -distance);
normMatrix.makeIdentity();
normMatrix.scale( 1, 1, 1 );   
normMatrix.multRight( userMatrix );
gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
// ****** spheres object 22 *******
gl.useProgram(prog22);
gl.bindBuffer(gl.ARRAY_BUFFER, sphereBuf);
gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, sphereIbuf);
gl.uniformMatrix4fv( prMatLoc22, false, new Float32Array(prMatrix.getAsArray()) );
gl.uniformMatrix4fv( mvMatLoc22, false, new Float32Array(mvMatrix.getAsArray()) );
gl.uniformMatrix4fv( normMatLoc22, false, new Float32Array(normMatrix.getAsArray()) );
gl.enableVertexAttribArray( posLoc );
gl.vertexAttribPointer(posLoc,  3, gl.FLOAT, false, 12,  0);
gl.enableVertexAttribArray(normLoc22 );
gl.vertexAttribPointer(normLoc22,  3, gl.FLOAT, false, 12,  0);
gl.disableVertexAttribArray( colLoc );
var sphereNorm = new CanvasMatrix4();
sphereNorm.scale(1, 1, 1);
sphereNorm.multRight(normMatrix);
gl.uniformMatrix4fv( normMatLoc22, false, new Float32Array(sphereNorm.getAsArray()) );
for (var i = 0; i < 1000; i++) {
var sphereMV = new CanvasMatrix4();
var baseofs = i*8
var ofs = baseofs + 7;	       
var scale = values22[ofs];
sphereMV.scale(1*scale, 1*scale, 1*scale);
sphereMV.translate(values22[baseofs], 
values22[baseofs+1], 
values22[baseofs+2]);
sphereMV.multRight(mvMatrix);
gl.uniformMatrix4fv( mvMatLoc22, false, new Float32Array(sphereMV.getAsArray()) );
ofs = baseofs + 3;       
gl.vertexAttrib4f( colLoc, values22[ofs], 
values22[ofs+1], 
values22[ofs+2],
values22[ofs+3] );
gl.drawElements(gl.TRIANGLES, 384, gl.UNSIGNED_SHORT, 0);
}
gl.flush ();
}
var vlen = function(v) {
return sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2])
}
var xprod = function(a, b) {
return [a[1]*b[2] - a[2]*b[1],
a[2]*b[0] - a[0]*b[2],
a[0]*b[1] - a[1]*b[0]];
}
var screenToVector = function(x, y) {
var radius = max(width, height)/2.0;
var cx = width/2.0;
var cy = height/2.0;
var px = (x-cx)/radius;
var py = (y-cy)/radius;
var plen = sqrt(px*px+py*py);
if (plen > 1.e-6) { 
px = px/plen;
py = py/plen;
}
var angle = (SQRT2 - plen)/SQRT2*PI/2;
var z = sin(angle);
var zlen = sqrt(1.0 - z*z);
px = px * zlen;
py = py * zlen;
return [px, py, z];
}
var rotBase;
var trackballdown = function(x,y) {
rotBase = screenToVector(x, y);
saveMat.load(userMatrix);
}
var trackballmove = function(x,y) {
var rotCurrent = screenToVector(x,y);
var dot = rotBase[0]*rotCurrent[0] + 
rotBase[1]*rotCurrent[1] + 
rotBase[2]*rotCurrent[2];
var angle = acos( dot/vlen(rotBase)/vlen(rotCurrent) )*180./PI;
var axis = xprod(rotBase, rotCurrent);
userMatrix.load(saveMat);
userMatrix.rotate(angle, axis[0], axis[1], axis[2]);
drawScene();
}
var y0zoom = 0;
var zoom0 = 1;
var zoomdown = function(x, y) {
y0zoom = y;
zoom0 = log(zoom);
}
var zoommove = function(x, y) {
zoom = exp(zoom0 + (y-y0zoom)/height);
drawScene();
}
var y0fov = 0;
var fov0 = 1;
var fovdown = function(x, y) {
y0fov = y;
fov0 = fov;
}
var fovmove = function(x, y) {
fov = max(1, min(179, fov0 + 180*(y-y0fov)/height));
drawScene();
}
var mousedown = [trackballdown, zoomdown, fovdown];
var mousemove = [trackballmove, zoommove, fovmove];
function relMouseCoords(event){
var totalOffsetX = 0;
var totalOffsetY = 0;
var currentElement = canvas;
do{
totalOffsetX += currentElement.offsetLeft;
totalOffsetY += currentElement.offsetTop;
}
while(currentElement = currentElement.offsetParent)
var canvasX = event.pageX - totalOffsetX;
var canvasY = event.pageY - totalOffsetY;
return {x:canvasX, y:canvasY}
}
canvas.onmousedown = function ( ev ){
if (!ev.which) // Use w3c defns in preference to MS
switch (ev.button) {
case 0: ev.which = 1; break;
case 1: 
case 4: ev.which = 2; break;
case 2: ev.which = 3;
}
drag = ev.which;
var f = mousedown[drag-1];
if (f) {
var coords = relMouseCoords(ev);
f(coords.x, height-coords.y); 
ev.preventDefault();
}
}    
canvas.onmouseup = function ( ev ){	
drag = 0;
}
canvas.onmouseout = canvas.onmouseup;
canvas.onmousemove = function ( ev ){
if ( drag == 0 ) return;
var f = mousemove[drag-1];
if (f) {
var coords = relMouseCoords(ev);
f(coords.x, height-coords.y);
}
}
var wheelHandler = function(ev) {
var del = 1.1;
if (ev.shiftKey) del = 1.01;
var ds = ((ev.detail || ev.wheelDelta) > 0) ? del : (1 / del);
zoom *= ds;
drawScene();
ev.preventDefault();
};
canvas.addEventListener("DOMMouseScroll", wheelHandler, false);
canvas.addEventListener("mousewheel", wheelHandler, false);
}
</script>
<canvas id="testgl2canvas" width="1" height="1"></canvas> 
<p id="testgl2debug">
You must enable Javascript to view this page properly.</p>
<script>testgl2webGLStart();</script>
