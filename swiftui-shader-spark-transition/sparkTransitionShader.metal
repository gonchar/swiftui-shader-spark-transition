//
//  sparkTransitionShader.metal
//  morphspirit
//
//  Created by Sergey Gonchar on 26/09/2023.
//

#include <SwiftUI/SwiftUI_Metal.h>

#include <metal_stdlib>
using namespace metal;

// constexpr for compile time
constexpr sampler textureSampler (coord::normalized,
                                  address::repeat,
                                  filter::linear);


constexpr constant half particle1Scale = 245;
constexpr constant half particle1Speed = 4.8;
constexpr constant half particle1SmoothWidth = 0.069;
constexpr constant half particle1Multiplier = 730;

constexpr constant half particle2Scale = 216;
constexpr constant half particle2Speed = -10.0;
constexpr constant half particle2SmoothWidth = 0.149;
constexpr constant half colorSmooth1Multiplier = 0.8179;

[[ stitchable ]] half4 sparkTransitionShader(float2 position, SwiftUI::Layer layer, float4 bounds, float effectValue, float direction, texture2d<half> particles, float time) {
  float boundsWidth = bounds.z;
  
  float currentPos = (direction > 0 ? position.x : (boundsWidth - position.x) ) / boundsWidth;
  
  if ( effectValue < currentPos ) {
    return half4(0.0,0.0,0.0,0.0);
  }
  
//  effectValue = effectValue * 1.4 - effectValue * 0.2;
  
//  float mul = (effectValue - currentPos) / (1 - currentPos);
//
//  float2 halfSize = bounds.zw / 2.0;
//
//  float2 samplingPos =  halfSize + (position - halfSize) * mul;
  
  half smoothEdge1 = smoothstep(effectValue - particle1SmoothWidth, effectValue, currentPos);
  half smoothEdge2 = smoothstep(effectValue - particle2SmoothWidth, effectValue, currentPos);
  
  float2 particlesPosition = position / particle1Scale;
  particlesPosition.x += -direction * effectValue;
  particlesPosition.x += time / particle1Speed;
  
  half4 particleColor = particles.sample(textureSampler, particlesPosition);
  
  
  float2 particlesPosition2 = position / particle2Scale;
  particlesPosition2.x += -direction * effectValue;
  particlesPosition2.x += time / particle2Speed;
  half4 particleColor2 = particles.sample(textureSampler, particlesPosition2);
  
  
  float2 samplingPosition = position;
  samplingPosition.y += smoothEdge1 * smoothEdge1 * (bounds.w - position.y) / 200.0;
  
//  half4 color = layer.sample(position + float2(smoothEdge * particleColor.xy * 100));
  half4 color = layer.sample(samplingPosition);
  
//  color.xyz = color.xyz + smoothEdge1 * particleColor.xxx * 5.0;
  color.xyz = color.xyz + color.xyz * smoothEdge1 * colorSmooth1Multiplier + color.xyz * smoothEdge2 * particleColor.xxx * particleColor2.xxx * particle1Multiplier;
//  color.xyz = color.xyz + color.xyz * smoothEdge1;
  return color;
}
