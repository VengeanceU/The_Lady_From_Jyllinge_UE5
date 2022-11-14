struct FClothVertex
{
    float4 BaryCoordPos;
    float4 BaryCoordNormal;
    float4 BaryCoordTangent;
    uint4 SimulIndices;
    float Weight;
};

cbuffer View
{
    row_major float4x4 View_View_TranslatedWorldToClip : packoffset(c0);
    float3 View_View_ViewTilePosition : packoffset(c60);
    float3 View_View_RelativePreViewTranslation : packoffset(c72);
    uint View_View_InstanceSceneDataSOAStride : packoffset(c277);
};

ByteAddressBuffer View_PrimitiveSceneData;
ByteAddressBuffer View_InstanceSceneData;
ByteAddressBuffer InstanceCulling_InstanceIdsBuffer;
row_major float4x4 ClothToLocal;
float ClothBlendWeight;
uint InputWeightIndexSize;
uint2 GPUSkinApexClothStartIndexOffset;

Buffer<float4> ClothSimulVertsPositionsNormals;
Buffer<uint4> InputWeightStream;
Buffer<float4> GPUSkinApexCloth;
Buffer<float4> BoneMatrices;

static float4 gl_Position;
static int gl_VertexIndex;
static int gl_InstanceIndex;
static float4 in_var_ATTRIBUTE0;
static float3 in_var_ATTRIBUTE1;
static float4 in_var_ATTRIBUTE2;
static uint in_var_ATTRIBUTE3;
static uint in_var_ATTRIBUTE16;
static float4 out_var_TEXCOORD10_centroid;
static float4 out_var_TEXCOORD11_centroid;
static uint out_var_PRIMITIVE_ID;

struct SPIRV_Cross_Input
{
    float4 in_var_ATTRIBUTE0 : ATTRIBUTE0;
    float3 in_var_ATTRIBUTE1 : ATTRIBUTE1;
    float4 in_var_ATTRIBUTE2 : ATTRIBUTE2;
    uint in_var_ATTRIBUTE3 : ATTRIBUTE3;
    uint in_var_ATTRIBUTE16 : ATTRIBUTE16;
    uint gl_VertexIndex : SV_VertexID;
    uint gl_InstanceIndex : SV_InstanceID;
};

struct SPIRV_Cross_Output
{
    float4 out_var_TEXCOORD10_centroid : TEXCOORD10_centroid;
    float4 out_var_TEXCOORD11_centroid : TEXCOORD11_centroid;
    nointerpolation uint out_var_PRIMITIVE_ID : PRIMITIVE_ID;
    precise float4 gl_Position : SV_Position;
};

static float3x3 _130 = float3x3(0.0f.xxx, 0.0f.xxx, 0.0f.xxx);
static float4 _131 = 0.0f.xxxx;

void vert_main()
{
    float3 _149 = -View_View_ViewTilePosition;
    uint _168 = 0u;
    if ((in_var_ATTRIBUTE16 & 2147483648u) != 0u)
    {
        _168 = uint(int(asuint(asfloat(View_PrimitiveSceneData.Load4(((in_var_ATTRIBUTE16 & 2147483647u) * 40u) * 16 + 0)).y))) + uint(gl_InstanceIndex);
    }
    else
    {
        _168 = InstanceCulling_InstanceIdsBuffer.Load((in_var_ATTRIBUTE16 + uint(gl_InstanceIndex)) * 4 + 0) & 268435455u;
    }
    uint _174 = asuint(asfloat(View_InstanceSceneData.Load4(_168 * 16 + 0)).x);
    uint _176 = (_174 << 12u) >> 12u;
    float3 _290 = 0.0f.xxx;
    float4x4 _291 = float4x4(0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx);
    float3 _292 = 0.0f.xxx;
    float _293 = 0.0f;
    [branch]
    if (false || (_176 != 1048575u))
    {
        uint4 _190 = asuint(asfloat(View_InstanceSceneData.Load4((View_View_InstanceSceneDataSOAStride + _168) * 16 + 0)));
        uint _192 = (2u * View_View_InstanceSceneDataSOAStride) + _168;
        float4x4 _196 = float4x4(0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx);
        _196[3] = float4(asfloat(View_InstanceSceneData.Load4(_192 * 16 + 0)).x, asfloat(View_InstanceSceneData.Load4(_192 * 16 + 0)).y, asfloat(View_InstanceSceneData.Load4(_192 * 16 + 0)).z, 0.0f.xxxx.w);
        float4x4 _197 = _196;
        _197[3].w = 1.0f;
        uint _198 = _190.x;
        uint _205 = _190.y;
        float _208 = float((_205 >> 0u) & 32767u);
        float2 _212 = (float3(float((_198 >> 0u) & 65535u), float((_198 >> 16u) & 65535u), _208).xy - 32768.0f.xx) * 3.0518509447574615478515625e-05f;
        float _214 = (_208 - 16384.0f) * 4.3161006033187732100486755371094e-05f;
        bool _216 = (_205 & 32768u) != 0u;
        float _217 = _212.x;
        float _218 = _212.y;
        float _219 = _217 + _218;
        float _220 = _217 - _218;
        float3 _226 = normalize(float3(_219, _220, 2.0f - dot(1.0f.xx, abs(float2(_219, _220)))));
        float4 _227 = float4(_226.x, _226.y, _226.z, 0.0f.xxxx.w);
        float4x4 _228 = _197;
        _228[2] = _227;
        float _231 = 1.0f / (1.0f + _226.z);
        float _232 = _226.x;
        float _233 = -_232;
        float _234 = _226.y;
        float _236 = (_233 * _234) * _231;
        float _248 = sqrt(1.0f - (_214 * _214));
        float3 _253 = (float3(1.0f - ((_232 * _232) * _231), _236, _233) * (_216 ? _214 : _248)) + (float3(_236, 1.0f - ((_234 * _234) * _231), -_234) * (_216 ? _248 : _214));
        float4 _254 = float4(_253.x, _253.y, _253.z, 0.0f.xxxx.w);
        float4x4 _255 = _228;
        _255[0] = _254;
        float3 _258 = cross(_226.xyz, _253.xyz);
        float4 _259 = float4(_258.x, _258.y, _258.z, 0.0f.xxxx.w);
        float4x4 _260 = _255;
        _260[1] = _259;
        uint _261 = _190.w;
        uint _266 = _190.z;
        float3 _274 = (float3(uint3(_266 >> 0u, _266 >> 16u, _261 >> 0u) & uint3(65535u, 65535u, 65535u)) - 32768.0f.xxx) * asfloat(((_261 >> 16u) - 15u) << 23u);
        float4x4 _277 = _260;
        _277[0] = _254 * _274.x;
        float4x4 _280 = _277;
        _280[1] = _259 * _274.y;
        float4x4 _283 = _280;
        _283[2] = _227 * _274.z;
        _290 = 1.0f.xxx / abs(_274).xyz;
        _291 = _283;
        _292 = asfloat(View_PrimitiveSceneData.Load4(((_176 * 40u) + 1u) * 16 + 0)).xyz;
        _293 = (((_174 >> 20u) & 1u) != 0u) ? (-1.0f) : 1.0f;
    }
    else
    {
        _290 = 0.0f.xxx;
        _291 = float4x4(0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx);
        _292 = 0.0f.xxx;
        _293 = 0.0f;
    }
    uint _299 = (uint(gl_VertexIndex) - GPUSkinApexClothStartIndexOffset.x) + GPUSkinApexClothStartIndexOffset.y;
    FClothVertex _134[1] = { { 0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx, uint4(0u, 0u, 0u, 0u), 0.0f } };
    for (int _301 = 0; _301 < 1; )
    {
        uint _308 = (_299 + uint(_301)) * 4u;
        _134[_301].BaryCoordPos = GPUSkinApexCloth.Load(_308);
        _134[_301].BaryCoordNormal = GPUSkinApexCloth.Load(_308 + 1u);
        _134[_301].BaryCoordTangent = GPUSkinApexCloth.Load(_308 + 2u);
        uint4 _320 = asuint(GPUSkinApexCloth.Load(_308 + 3u));
        uint2 _321 = _320.xy;
        uint2 _324 = (_321 >> (uint2(16u, 16u) & uint2(31u, 31u))) & uint2(65535u, 65535u);
        _134[_301].SimulIndices = uint4(_134[_301].SimulIndices.x, _324.x, _134[_301].SimulIndices.z, _324.y);
        uint2 _328 = _321 & uint2(65535u, 65535u);
        _134[_301].SimulIndices = uint4(_328.x, _134[_301].SimulIndices.y, _328.y, _134[_301].SimulIndices.w);
        _134[_301].Weight = asfloat(_320.z);
        _301++;
        continue;
    }
    float4 _468 = 0.0f.xxxx;
    if (_134[0].SimulIndices.w < 65535u)
    {
        FClothVertex _135[1] = _134;
        float _348 = 0.0f;
        float3 _351 = 0.0f.xxx;
        float _353 = 0.0f;
        int _355 = 0;
        _348 = 0.0f;
        _351 = 0.0f.xxx;
        _353 = 0.0f;
        _355 = 0;
        float _354 = 0.0f;
        float _349 = 0.0f;
        float3 _352 = 0.0f.xxx;
        int _356 = 0;
        for (int _357 = 0; _357 < 1; _348 = _349, _351 = _352, _353 = _354, _355 = _356, _357++)
        {
            bool _367 = _135[_357].SimulIndices.w < 65535u;
            if (_367)
            {
                int _373 = int(_135[_357].SimulIndices.x) * 3;
                uint _378 = uint(_373 + 1);
                int _386 = int(_135[_357].SimulIndices.y) * 3;
                uint _390 = uint(_386 + 1);
                int _398 = int(_135[_357].SimulIndices.z) * 3;
                uint _402 = uint(_398 + 1);
                _349 = _348 + (1.0f - (float(_135[_357].SimulIndices.w) * 1.525902189314365386962890625e-05f));
                _352 = _351 + (((((float3(ClothSimulVertsPositionsNormals.Load(uint(_373)).xy, ClothSimulVertsPositionsNormals.Load(_378).x) + (float3(ClothSimulVertsPositionsNormals.Load(_378).y, ClothSimulVertsPositionsNormals.Load(uint(_373 + 2)).xy) * _135[_357].BaryCoordPos.w)) * _135[_357].BaryCoordPos.x) + ((float3(ClothSimulVertsPositionsNormals.Load(uint(_386)).xy, ClothSimulVertsPositionsNormals.Load(_390).x) + (float3(ClothSimulVertsPositionsNormals.Load(_390).y, ClothSimulVertsPositionsNormals.Load(uint(_386 + 2)).xy) * _135[_357].BaryCoordPos.w)) * _135[_357].BaryCoordPos.y)) + ((float3(ClothSimulVertsPositionsNormals.Load(uint(_398)).xy, ClothSimulVertsPositionsNormals.Load(_402).x) + (float3(ClothSimulVertsPositionsNormals.Load(_402).y, ClothSimulVertsPositionsNormals.Load(uint(_398 + 2)).xy) * _135[_357].BaryCoordPos.w)) * ((1.0f - _135[_357].BaryCoordPos.x) - _135[_357].BaryCoordPos.y))) * 1.0f);
                _356 = _355 + 1;
            }
            else
            {
                _349 = _348;
                _352 = _351;
                _356 = _355;
            }
            _354 = _367 ? 1.0f : _353;
        }
        bool _456 = (_355 > 0) && (_353 > 9.9999997473787516355514526367188e-05f);
        float3 _462 = 0.0f.xxx;
        if (_456)
        {
            _462 = _351 * (1.0f / _353);
        }
        else
        {
            _462 = 0.0f.xxx;
        }
        _468 = float4(_462, _456 ? _348 : 0.0f);
    }
    else
    {
        _468 = float4(in_var_ATTRIBUTE0.xyz, 0.0f);
    }
    int _470 = int(in_var_ATTRIBUTE3 & 255u);
    uint _473 = uint(int(in_var_ATTRIBUTE3 >> 8u));
    int _479 = int(_473 + (InputWeightIndexSize * uint(_470)));
    float3x4 _481 = float3x4(0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx);
    _481 = float3x4(0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx);
    float3x4 _482 = float3x4(0.0f.xxxx, 0.0f.xxxx, 0.0f.xxxx);
    for (int _484 = 0; _484 < _470; _481 = _482, _484++)
    {
        int _492 = int(_473 + (InputWeightIndexSize * uint(_484)));
        int _497 = int(InputWeightStream.Load(uint(_492)).x);
        if (InputWeightIndexSize > 1u)
        {
            float4 _543 = (float(InputWeightStream.Load(uint(_479 + _484)).x) * 0.0039215688593685626983642578125f).xxxx;
            int _544 = int((InputWeightStream.Load(uint(_492 + 1)).x << 8u) | uint(_497)) * 3;
            _482 = float3x4(_481[0] + (_543 * BoneMatrices.Load(uint(_544))), _481[1] + (_543 * BoneMatrices.Load(uint(_544 + 1))), _481[2] + (_543 * BoneMatrices.Load(uint(_544 + 2))));
        }
        else
        {
            float4 _508 = (float(InputWeightStream.Load(uint(_479 + _484)).x) * 0.0039215688593685626983642578125f).xxxx;
            int _509 = _497 * 3;
            _482 = float3x4(_481[0] + (_508 * BoneMatrices.Load(uint(_509))), _481[1] + (_508 * BoneMatrices.Load(uint(_509 + 1))), _481[2] + (_508 * BoneMatrices.Load(uint(_509 + 2))));
        }
    }
    FClothVertex _133[1] = _134;
    float _739 = 0.0f;
    float3x3 _740 = float3x3(0.0f.xxx, 0.0f.xxx, 0.0f.xxx);
    if (_133[0].SimulIndices.w < 65535u)
    {
        float _575 = 0.0f;
        float3 _578 = 0.0f.xxx;
        float3 _580 = 0.0f.xxx;
        float _582 = 0.0f;
        int _584 = 0;
        float _586 = 0.0f;
        _575 = ClothBlendWeight;
        _578 = 0.0f.xxx;
        _580 = 0.0f.xxx;
        _582 = 0.0f;
        _584 = 0;
        _586 = 0.0f;
        float _576 = 0.0f;
        float _583 = 0.0f;
        float3 _579 = 0.0f.xxx;
        float3 _581 = 0.0f.xxx;
        int _585 = 0;
        float _587 = 0.0f;
        for (int _588 = 0; _588 < 1; _575 = _576, _578 = _579, _580 = _581, _582 = _583, _584 = _585, _586 = _587, _588++)
        {
            bool _599 = _133[_588].SimulIndices.w < 65535u;
            if (_599)
            {
                int _605 = int(_133[_588].SimulIndices.x) * 3;
                uint _610 = uint(_605 + 1);
                float3 _615 = float3(ClothSimulVertsPositionsNormals.Load(uint(_605)).xy, ClothSimulVertsPositionsNormals.Load(_610).x);
                int _618 = int(_133[_588].SimulIndices.y) * 3;
                uint _622 = uint(_618 + 1);
                float3 _627 = float3(ClothSimulVertsPositionsNormals.Load(uint(_618)).xy, ClothSimulVertsPositionsNormals.Load(_622).x);
                int _630 = int(_133[_588].SimulIndices.z) * 3;
                uint _634 = uint(_630 + 1);
                float3 _639 = float3(ClothSimulVertsPositionsNormals.Load(uint(_630)).xy, ClothSimulVertsPositionsNormals.Load(_634).x);
                float3 _647 = float3(ClothSimulVertsPositionsNormals.Load(_610).y, ClothSimulVertsPositionsNormals.Load(uint(_605 + 2)).xy);
                float3 _655 = float3(ClothSimulVertsPositionsNormals.Load(_622).y, ClothSimulVertsPositionsNormals.Load(uint(_618 + 2)).xy);
                float3 _663 = float3(ClothSimulVertsPositionsNormals.Load(_634).y, ClothSimulVertsPositionsNormals.Load(uint(_630 + 2)).xy);
                _579 = _578 + (((((_615 + (_647 * _133[_588].BaryCoordNormal.w)) * _133[_588].BaryCoordNormal.x) + ((_627 + (_655 * _133[_588].BaryCoordNormal.w)) * _133[_588].BaryCoordNormal.y)) + ((_639 + (_663 * _133[_588].BaryCoordNormal.w)) * _133[_588].BaryCoordNormal.z)) * 1.0f);
                _581 = _580 + (((((_615 + (_647 * _133[_588].BaryCoordTangent.w)) * _133[_588].BaryCoordTangent.x) + ((_627 + (_655 * _133[_588].BaryCoordTangent.w)) * _133[_588].BaryCoordTangent.y)) + ((_639 + (_663 * _133[_588].BaryCoordTangent.w)) * _133[_588].BaryCoordTangent.z)) * 1.0f);
                _585 = _584 + 1;
                _587 = _586 + (1.0f - (float(_133[_588].SimulIndices.w) * 1.525902189314365386962890625e-05f));
            }
            else
            {
                _579 = _578;
                _581 = _580;
                _585 = _584;
                _587 = _586;
            }
            _576 = _599 ? ClothBlendWeight : _575;
            _583 = _599 ? 1.0f : _582;
        }
        bool _704 = (_584 > 0) && (_582 > 9.9999997473787516355514526367188e-05f);
        float3x3 _736 = float3x3(0.0f.xxx, 0.0f.xxx, 0.0f.xxx);
        if (_704)
        {
            float _708 = 1.0f / _582;
            float3 _723 = mul(float4(normalize((_580 * _708) - _468.xyz), 0.0f), ClothToLocal).xyz;
            float3x3 _724 = _130;
            _724[0] = _723;
            float3 _730 = mul(float4(normalize((_578 * _708) - _468.xyz), 0.0f), ClothToLocal).xyz;
            float3x3 _731 = _724;
            _731[2] = _730;
            float3x3 _735 = _731;
            _735[1] = cross(_730, _723) * in_var_ATTRIBUTE2.w;
            _736 = _735;
        }
        else
        {
            _736 = float3x3(float3(1.0f, 0.0f, 0.0f), float3(0.0f, 1.0f, 0.0f), float3(0.0f, 0.0f, 1.0f));
        }
        _739 = _575 * (_704 ? _586 : 0.0f);
        _740 = _736;
    }
    else
    {
        _739 = 0.0f;
        _740 = float3x3(float3(1.0f, 0.0f, 0.0f), float3(0.0f, 1.0f, 0.0f), float3(0.0f, 0.0f, 1.0f));
    }
    float3 _746 = normalize(mul(_481, float4(in_var_ATTRIBUTE1, 0.0f)));
    float3 _752 = normalize(mul(_481, float4(in_var_ATTRIBUTE2.xyz, 0.0f)));
    float3 _757 = _739.xxx;
    float3 _765 = (1.0f - _739).xxx;
    float3 _780 = mul(_481, float4(in_var_ATTRIBUTE0.xyz, 1.0f));
    float3 _799 = 0.0f.xxx;
    if (_134[0].SimulIndices.w < 65535u)
    {
        _799 = lerp(_780, mul(float4(_468.xyz, 1.0f), ClothToLocal).xyz, (ClothBlendWeight * _468.w).xxx);
    }
    else
    {
        _799 = _780;
    }
    float3 _803 = _799.xxx * _291[0].xyz;
    float3 _807 = _799.yyy * _291[1].xyz;
    float3 _808 = _803 + _807;
    float3 _812 = _799.zzz * _291[2].xyz;
    float3 _813 = _808 + _812;
    float3 _816 = _813 + _291[3].xyz;
    float3 _817 = _292 + _149;
    float3 _818 = _816 + View_View_RelativePreViewTranslation;
    float3 _819 = _817 * 2097152.0f;
    float3 _820 = _819 + _818;
    float _821 = _820.x;
    float _822 = _820.y;
    float _823 = _820.z;
    float4 _824 = float4(_821, _822, _823, 1.0f);
    float4 _825 = float4(_824.x, _824.y, _824.z, _824.w);
    float4 _826 = mul(_825, View_View_TranslatedWorldToClip);
    float4 _827 = _131;
    _827.w = 0.0f;
    float3x3 _831 = float3x3(_291[0].xyz, _291[1].xyz, _291[2].xyz);
    _831[0] = _291[0].xyz * _290.x;
    float3x3 _834 = _831;
    _834[1] = _291[1].xyz * _290.y;
    float3x3 _837 = _834;
    _837[2] = _291[2].xyz * _290.z;
    float3x3 _838 = mul(float3x3((_740[0] * _757) + (_746 * _765), (_740[1] * _757) + (normalize(cross(_752, _746) * in_var_ATTRIBUTE2.w) * _765), (_740[2] * _757) + (_752 * _765)), _837);
    float3 _839 = _838[0];
    out_var_TEXCOORD10_centroid = float4(_839.x, _839.y, _839.z, _827.w);
    out_var_TEXCOORD11_centroid = float4(_838[2], in_var_ATTRIBUTE2.w * _293);
    out_var_PRIMITIVE_ID = _176;
    gl_Position = _826;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input)
{
    gl_VertexIndex = int(stage_input.gl_VertexIndex);
    gl_InstanceIndex = int(stage_input.gl_InstanceIndex);
    in_var_ATTRIBUTE0 = stage_input.in_var_ATTRIBUTE0;
    in_var_ATTRIBUTE1 = stage_input.in_var_ATTRIBUTE1;
    in_var_ATTRIBUTE2 = stage_input.in_var_ATTRIBUTE2;
    in_var_ATTRIBUTE3 = stage_input.in_var_ATTRIBUTE3;
    in_var_ATTRIBUTE16 = stage_input.in_var_ATTRIBUTE16;
    vert_main();
    SPIRV_Cross_Output stage_output;
    stage_output.gl_Position = gl_Position;
    stage_output.out_var_TEXCOORD10_centroid = out_var_TEXCOORD10_centroid;
    stage_output.out_var_TEXCOORD11_centroid = out_var_TEXCOORD11_centroid;
    stage_output.out_var_PRIMITIVE_ID = out_var_PRIMITIVE_ID;
    return stage_output;
}
