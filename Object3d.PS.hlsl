#include "object3d.hlsli"

struct Material {
	float32_t4 color;
	int32_t enableLighting;
};

struct TransformationMatrix {
	float32_t4x4 WVP;
	float32_t4x4 World;
};

struct DirectionalLight {
	float32_t4 color;
	float32_t3 direction;
	float intensity;
};

ConstantBuffer<Material> gMaterial : register(b0);
Texture2D<float32_t4> gTexture : register(t0);
SamplerState gSampler : register(s0);

ConstantBuffer<DirectionalLight> gDirectionalLight : register(b1);

struct PixelShaderOutput {
	float32_t4 color : SV_TARGET0;
};

PixelShaderOutput main(VertexShaderOutput input) {
	PixelShaderOutput output;
	float32_t4 textureColor = gTexture.Sample(gSampler, transformedUV.xy);
	output.color = gMaterial.color * textureColor;
	if (output.color.a == 0.0) {
	//	discard;
	//}
	//output.color = gMaterial.color * texturecolor;

	if (gMaterial.enableLighting != 0) {
		float cos = saturate(dot(normalize(input.normal), -gDirectionalLight.direction));
		output.color = gMaterial.color * textureColor * gDirectionalLight.color * cos * gDirectionalLight.inntensity;
	}
	else {
		output.color = gMaterial.color * textureColor;
	}

	return output;
}
