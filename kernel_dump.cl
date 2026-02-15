#define PROGPOW_DAG_ELEMENTS 14090229u
#define PROGPOW_DAG_BYTES 3607098752u
#define LIGHT_WORDS 880603u
#define ACCESSES 64u
#define GROUP_SIZE 256u
#ifndef GROUP_SIZE
#define GROUP_SIZE 128
#endif
#define GROUP_SHARE (GROUP_SIZE / 16)

typedef unsigned int       uint32_t;
typedef unsigned long      uint64_t;
#define ROTL32(x, n) rotate((x), (uint32_t)(n))
#define ROTR32(x, n) rotate((x), (uint32_t)(32-n))

#define PROGPOW_LANES           16
#define PROGPOW_REGS            32
#define PROGPOW_DAG_LOADS       4
#define PROGPOW_CACHE_WORDS     4096
#define PROGPOW_CNT_DAG         64
#define PROGPOW_CNT_MATH        18

typedef struct __attribute__ ((aligned (16))) {uint32_t s[PROGPOW_DAG_LOADS];} dag_t;

// Inner loop for prog_seed 755637
inline void progPowLoop(const uint32_t loop,
        volatile uint32_t mix_arg[PROGPOW_REGS],
        __global const dag_t *g_dag,
        __local const uint32_t c_dag[PROGPOW_CACHE_WORDS],
        __local volatile uint64_t share[GROUP_SHARE],
        const bool hack_false)
{
dag_t data_dag;
uint32_t offset, data;
uint32_t mix[PROGPOW_REGS];
for(int i=0; i<PROGPOW_REGS; i++)
    mix[i] = mix_arg[i];
const uint32_t lane_id = get_local_id(0) & (PROGPOW_LANES-1);
const uint32_t group_id = get_local_id(0) / PROGPOW_LANES;
// global load
if(lane_id == (loop % PROGPOW_LANES))
    share[group_id] = mix[0];
barrier(CLK_LOCAL_MEM_FENCE);
offset = share[group_id];
offset %= PROGPOW_DAG_ELEMENTS;
offset = offset * PROGPOW_LANES + (lane_id ^ loop) % PROGPOW_LANES;
data_dag = g_dag[offset];
// hack to prevent compiler from reordering LD and usage
if (hack_false) barrier(CLK_LOCAL_MEM_FENCE);
// cache load 0
offset = mix[27] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[12] = (mix[12] * 33) + data;
// random math 0
data = ROTL32(mix[0], mix[6] % 32);
mix[30] = ROTL32(mix[30], 12) ^ data;
// cache load 1
offset = mix[5] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[24] = ROTL32(mix[24], 17) ^ data;
// random math 1
data = mix[8] ^ mix[11];
mix[6] = ROTL32(mix[6], 30) ^ data;
// cache load 2
offset = mix[22] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[0] = ROTR32(mix[0], 4) ^ data;
// random math 2
data = min(mix[17], mix[2]);
mix[13] = (mix[13] * 33) + data;
// cache load 3
offset = mix[11] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[1] = ROTL32(mix[1], 14) ^ data;
// random math 3
data = popcount(mix[25]) + popcount(mix[19]);
mix[5] = (mix[5] * 33) + data;
// cache load 4
offset = mix[23] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[18] = (mix[18] ^ data) * 33;
// random math 4
data = mix[19] ^ mix[26];
mix[15] = ROTR32(mix[15], 22) ^ data;
// cache load 5
offset = mix[20] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[25] = ROTR32(mix[25], 21) ^ data;
// random math 5
data = mix[9] & mix[31];
mix[16] = ROTL32(mix[16], 25) ^ data;
// cache load 6
offset = mix[26] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[23] = ROTL32(mix[23], 19) ^ data;
// random math 6
data = min(mix[22], mix[17]);
mix[9] = (mix[9] ^ data) * 33;
// cache load 7
offset = mix[13] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[21] = (mix[21] ^ data) * 33;
// random math 7
data = mix[18] + mix[4];
mix[10] = ROTR32(mix[10], 14) ^ data;
// cache load 8
offset = mix[25] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[29] = (mix[29] ^ data) * 33;
// random math 8
data = mul_hi(mix[3], mix[11]);
mix[19] = (mix[19] * 33) + data;
// cache load 9
offset = mix[8] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[11] = (mix[11] ^ data) * 33;
// random math 9
data = ROTR32(mix[19], mix[31] % 32);
mix[26] = ROTL32(mix[26], 29) ^ data;
// cache load 10
offset = mix[15] % PROGPOW_CACHE_WORDS;
data = c_dag[offset];
mix[27] = (mix[27] ^ data) * 33;
// random math 10
data = mix[4] + mix[23];
mix[20] = (mix[20] ^ data) * 33;
// random math 11
data = mix[12] | mix[5];
mix[31] = (mix[31] * 33) + data;
// random math 12
data = mul_hi(mix[29], mix[27]);
mix[4] = ROTL32(mix[4], 18) ^ data;
// random math 13
data = ROTL32(mix[11], mix[1] % 32);
mix[3] = ROTR32(mix[3], 27) ^ data;
// random math 14
data = mix[26] * mix[7];
mix[2] = ROTL32(mix[2], 29) ^ data;
// random math 15
data = mix[30] | mix[16];
mix[17] = (mix[17] ^ data) * 33;
// random math 16
data = mix[2] + mix[30];
mix[28] = ROTL32(mix[28], 18) ^ data;
// random math 17
data = mix[12] * mix[7];
mix[22] = ROTR32(mix[22], 16) ^ data;
// consume global load data
// hack to prevent compiler from reordering LD and usage
if (hack_false) barrier(CLK_LOCAL_MEM_FENCE);
mix[0] = (mix[0] ^ data_dag.s[0]) * 33;
mix[14] = (mix[14] * 33) + data_dag.s[1];
mix[8] = (mix[8] * 33) + data_dag.s[2];
mix[7] = (mix[7] * 33) + data_dag.s[3];
for(int i=0; i<PROGPOW_REGS; i++)
    mix_arg[i] = mix[i];
}



#define OPENCL_PLATFORM_UNKNOWN 0
#define OPENCL_PLATFORM_NVIDIA 1
#define OPENCL_PLATFORM_AMD 2
#define OPENCL_PLATFORM_CLOVER 3
#define OPENCL_PLATFORM_APPLE 4

#ifndef MAX_OUTPUTS
#define MAX_OUTPUTS 63U
#endif

#ifndef PLATFORM
#define PLATFORM OPENCL_PLATFORM_APPLE
#endif

#ifdef cl_clang_storage_class_specifiers
#pragma OPENCL EXTENSION cl_clang_storage_class_specifiers : enable
#endif

#define HASHES_PER_GROUP (GROUP_SIZE / PROGPOW_LANES)

#define FNV_PRIME 0x1000193
#define FNV_OFFSET_BASIS 0x811c9dc5

typedef struct
{
    uint32_t uint32s[32 / sizeof(uint32_t)];
} hash32_t;

// Implementation based on:
// https://github.com/mjosaarinen/tiny_sha3/blob/master/sha3.c

// Moved keccakf_rndc and ravencoin_rndc to local scope


// Implementation of the Keccakf transformation with a width of 800
void keccak_f800_round(uint32_t st[25], const int r)
{
    // Hardcoded round constants to avoid array lookup issues
    uint32_t rc = 0;
    switch(r) {
        case 0: rc = 0x00000001; break;
        case 1: rc = 0x00008082; break;
        case 2: rc = 0x0000808a; break;
        case 3: rc = 0x80008000; break;
        case 4: rc = 0x0000808b; break;
        case 5: rc = 0x80000001; break;
        case 6: rc = 0x80008081; break;
        case 7: rc = 0x00008009; break;
        case 8: rc = 0x0000008a; break;
        case 9: rc = 0x00000088; break;
        case 10: rc = 0x80008009; break;
        case 11: rc = 0x8000000a; break;
        case 12: rc = 0x8000808b; break;
        case 13: rc = 0x0000008b; break;
        case 14: rc = 0x00008089; break;
        case 15: rc = 0x00008003; break;
        case 16: rc = 0x00008002; break;
        case 17: rc = 0x00000080; break;
        case 18: rc = 0x0000800a; break;
        case 19: rc = 0x8000000a; break;
        case 20: rc = 0x80008081; break;
        case 21: rc = 0x00008080; break;
        case 22: rc = 0x80000001; break;
        case 23: rc = 0x80008008; break;
    }

    // Arrays removed (unrolled below)

    uint32_t t, bc[5];

    // Theta
    for (int i = 0; i < 5; i++)
        bc[i] = st[i] ^ st[i + 5] ^ st[i + 10] ^ st[i + 15] ^ st[i + 20];

    for (int i = 0; i < 5; i++)
    {
        t = bc[(i + 4) % 5] ^ ROTL32(bc[(i + 1) % 5], 1u);
        for (uint32_t j = 0; j < 25; j += 5)
            st[j + i] ^= t;
    }

    // Rho Pi (Unrolled)
    t = st[1];
    uint32_t bc0;
    bc0 = st[10]; st[10] = ROTL32(t, 1); t = bc0;
    bc0 = st[7]; st[7] = ROTL32(t, 3); t = bc0;
    bc0 = st[11]; st[11] = ROTL32(t, 6); t = bc0;
    bc0 = st[17]; st[17] = ROTL32(t, 10); t = bc0;
    bc0 = st[18]; st[18] = ROTL32(t, 15); t = bc0;
    bc0 = st[3]; st[3] = ROTL32(t, 21); t = bc0;
    bc0 = st[5]; st[5] = ROTL32(t, 28); t = bc0;
    bc0 = st[16]; st[16] = ROTL32(t, 36); t = bc0;
    bc0 = st[8]; st[8] = ROTL32(t, 45); t = bc0;
    bc0 = st[21]; st[21] = ROTL32(t, 55); t = bc0;
    bc0 = st[24]; st[24] = ROTL32(t, 2); t = bc0;
    bc0 = st[4]; st[4] = ROTL32(t, 14); t = bc0;
    bc0 = st[15]; st[15] = ROTL32(t, 27); t = bc0;
    bc0 = st[23]; st[23] = ROTL32(t, 41); t = bc0;
    bc0 = st[19]; st[19] = ROTL32(t, 56); t = bc0;
    bc0 = st[13]; st[13] = ROTL32(t, 8); t = bc0;
    bc0 = st[12]; st[12] = ROTL32(t, 25); t = bc0;
    bc0 = st[2]; st[2] = ROTL32(t, 43); t = bc0;
    bc0 = st[20]; st[20] = ROTL32(t, 62); t = bc0;
    bc0 = st[14]; st[14] = ROTL32(t, 18); t = bc0;
    bc0 = st[22]; st[22] = ROTL32(t, 39); t = bc0;
    bc0 = st[9]; st[9] = ROTL32(t, 61); t = bc0;
    bc0 = st[6]; st[6] = ROTL32(t, 20); t = bc0;
    bc0 = st[1]; st[1] = ROTL32(t, 44); t = bc0;


    //  Chi
    for (uint32_t j = 0; j < 25; j += 5)
    {
        for (int i = 0; i < 5; i++)
            bc[i] = st[j + i];
        for (int i = 0; i < 5; i++)
            st[j + i] ^= (~bc[(i + 1) % 5]) & bc[(i + 2) % 5];
    }

    //  Iota
    st[0] ^= rc;
}

// Keccak - implemented as a variant of SHAKE
// The width is 800, with a bitrate of 576, a capacity of 224, and no padding
// Only need 64 bits of output for mining
uint64_t keccak_f800(uint32_t* st)
{
    // Complete all 22 rounds as a separate impl to
    // evaluate only first 8 words is wasteful of regsters
    for (int r = 0; r < 22; r++) {
        keccak_f800_round(st, r);
    }
}

#define fnv1a(h, d) (h = (h ^ d) * FNV_PRIME)

typedef struct
{
    uint32_t z, w, jsr, jcong;
} kiss99_t;

// KISS99 is simple, fast, and passes the TestU01 suite
// https://en.wikipedia.org/wiki/KISS_(algorithm)
// http://www.cse.yorku.ca/~oz/marsaglia-rng.html
uint32_t kiss99(kiss99_t* st)
{
    st->z = 36969 * (st->z & 65535) + (st->z >> 16);
    st->w = 18000 * (st->w & 65535) + (st->w >> 16);
    uint32_t MWC = ((st->z << 16) + st->w);
    st->jsr ^= (st->jsr << 17);
    st->jsr ^= (st->jsr >> 13);
    st->jsr ^= (st->jsr << 5);
    st->jcong = 69069 * st->jcong + 1234567;
    return ((MWC ^ st->jcong) + st->jsr);
}

void fill_mix(local uint32_t* seed, uint32_t lane_id, uint32_t* mix)
{
    // Use FNV to expand the per-warp seed to per-lane
    // Use KISS to expand the per-lane seed to fill mix
    uint32_t fnv_hash = FNV_OFFSET_BASIS;
    kiss99_t st;
    st.z = fnv1a(fnv_hash, seed[0]);
    st.w = fnv1a(fnv_hash, seed[1]);
    st.jsr = fnv1a(fnv_hash, lane_id);
    st.jcong = fnv1a(fnv_hash, lane_id);
#pragma unroll
    for (int i = 0; i < PROGPOW_REGS; i++)
        mix[i] = kiss99(&st);
}

typedef struct
{
    uint32_t uint32s[PROGPOW_LANES];
    uint64_t uint64s[PROGPOW_LANES / 2];
} shuffle_t;

// NOTE: This struct must match the one defined in CLMiner.cpp
struct SearchResults
{
    struct
    {
        uint gid;
        uint mix[8];
        uint pad[7];  // pad to 16 words for easy indexing
    } rslt[MAX_OUTPUTS];
    uint count;
    uint hashCount;
    uint abort;
};


#if PLATFORM != OPENCL_PLATFORM_NVIDIA  // use maxrregs on nv
__attribute__((reqd_work_group_size(GROUP_SIZE, 1, 1)))
#endif
__kernel void
ethash_search(__global struct SearchResults* restrict g_output, __constant hash32_t const* g_header,
    __global dag_t const* g_dag, ulong start_nonce, ulong target, uint hack_false)
{
    const uint32_t ravencoin_rndc[15] = {
            0x00000072, //R
            0x00000041, //A
            0x00000056, //V
            0x00000045, //E
            0x0000004E, //N
            0x00000043, //C
            0x0000004F, //O
            0x00000049, //I
            0x0000004E, //N
            0x0000004B, //K
            0x00000041, //A
            0x00000057, //W
            0x00000050, //P
            0x0000004F, //O
            0x00000057, //W
    };

    if (g_output->abort)
        return;

    __local shuffle_t share[HASHES_PER_GROUP];
    __local uint32_t c_dag[PROGPOW_CACHE_WORDS];

    uint32_t const lid = get_local_id(0);
    uint32_t const gid = get_global_id(0);
    uint64_t const nonce = start_nonce + gid;

    const uint32_t lane_id = lid & (PROGPOW_LANES - 1);
    const uint32_t group_id = lid / PROGPOW_LANES;

    // Load the first portion of the DAG into the cache
    for (uint32_t word = lid * PROGPOW_DAG_LOADS; word < PROGPOW_CACHE_WORDS;
         word += GROUP_SIZE * PROGPOW_DAG_LOADS)
    {
        dag_t load = g_dag[word / PROGPOW_DAG_LOADS];
        for (int i = 0; i < PROGPOW_DAG_LOADS; i++)
            c_dag[word + i] = load.s[i];
    }

    // Sync threads so shared mem is in sync
    barrier(CLK_LOCAL_MEM_FENCE);


//uint32_t state[25];     // Keccak's state
uint32_t hash_seed[2];  // KISS99 initiator
hash32_t digest;        // Carry-over from mix output

uint32_t state2[8];

{
    // Absorb phase for initial round of keccak

    uint32_t state[25] = {0x0};     // Keccak's state

    // 1st fill with header data (8 words)
    for (int i = 0; i < 8; i++)
        state[i] = g_header->uint32s[i];

    // 2nd fill with nonce (2 words)
    state[8] = nonce;
    state[9] = nonce >> 32;

    // 3rd apply ravencoin input constraints (Hardcoded)
    state[10] = 0x00000072; // R
    state[11] = 0x00000041; // A
    state[12] = 0x00000056; // V
    state[13] = 0x00000045; // E
    state[14] = 0x0000004E; // N
    state[15] = 0x00000043; // C
    state[16] = 0x0000004F; // O
    state[17] = 0x00000049; // I
    state[18] = 0x0000004E; // N
    state[19] = 0x0000004B; // K
    state[20] = 0x00000041; // A
    state[21] = 0x00000057; // W
    state[22] = 0x00000050; // P
    state[23] = 0x0000004F; // O
    state[24] = 0x00000057; // W

    // Run intial keccak round
    keccak_f800(state);

    for (int i = 0; i < 8; i++)
        state2[i] = state[i];
}

#pragma unroll 1
    for (uint32_t h = 0; h < PROGPOW_LANES; h++)
    {
        uint32_t mix[PROGPOW_REGS];

        // share the hash's seed across all lanes
        if (lane_id == h) {
            share[group_id].uint32s[0] = state2[0];
            share[group_id].uint32s[1] = state2[1];
        }

        barrier(CLK_LOCAL_MEM_FENCE);

        // initialize mix for all lanes
        fill_mix(share[group_id].uint32s, lane_id, mix);

#pragma unroll 1
        for (uint32_t l = 0; l < PROGPOW_CNT_DAG; l++)
            progPowLoop(l, mix, g_dag, c_dag, share[0].uint64s, hack_false);

        // Reduce mix data to a per-lane 32-bit digest
        uint32_t mix_hash = FNV_OFFSET_BASIS;
#pragma unroll
        for (int i = 0; i < PROGPOW_REGS; i++)
            fnv1a(mix_hash, mix[i]);

        // Reduce all lanes to a single 256-bit digest
        hash32_t digest_temp;
        for (int i = 0; i < 8; i++)
            digest_temp.uint32s[i] = FNV_OFFSET_BASIS;
        share[group_id].uint32s[lane_id] = mix_hash;
        barrier(CLK_LOCAL_MEM_FENCE);
#pragma unroll
        for (int i = 0; i < PROGPOW_LANES; i++)
            fnv1a(digest_temp.uint32s[i % 8], share[group_id].uint32s[i]);
        if (h == lane_id)
            digest = digest_temp;
    }


    // Absorb phase for last round of keccak (256 bits)
    uint64_t result;

    {
        uint32_t state[25] = {0x0};     // Keccak's state

        // 1st initial 8 words of state are kept as carry-over from initial keccak
        for (int i = 0; i < 8; i++)
            state[i] = state2[i];

        // 2nd subsequent 8 words are carried from digest/mix
        for (int i = 8; i < 16; i++)
            state[i] = digest.uint32s[i - 8];

        // 3rd apply ravencoin input constraints (Hardcoded)
        state[16] = 0x00000072; // R
        state[17] = 0x00000041; // A
        state[18] = 0x00000056; // V
        state[19] = 0x00000045; // E
        state[20] = 0x0000004E; // N
        state[21] = 0x00000043; // C
        state[22] = 0x0000004F; // O
        state[23] = 0x00000049; // I
        state[24] = 0x0000004E; // N


        // Run keccak loop
        keccak_f800(state);

        uint64_t res = (uint64_t)state[1] << 32 | state[0];
        result = as_ulong(as_uchar8(res).s76543210);
    }


    if (lid == 0)
        atomic_inc(&g_output->hashCount);

    // keccak(header .. keccak(header..nonce) .. digest);
    if (result <= target)
    {
        uint slot = atomic_inc(&g_output->count);
        if (slot < MAX_OUTPUTS)
        {
            g_output->rslt[slot].gid = gid;
            for (int i = 0; i < 8; i++)
                g_output->rslt[slot].mix[i] = digest.uint32s[i];
        }
        atomic_inc(&g_output->abort);
    }
}


//
// DAG calculation logic
//


#ifndef LIGHT_WORDS
#define LIGHT_WORDS 262139
#endif

#define ETHASH_DATASET_PARENTS 512
#define NODE_WORDS (64 / 4)

#define FNV_PRIME 0x01000193

__constant uint2 const Keccak_f1600_RC[24] = {
    (uint2)(0x00000001, 0x00000000),
    (uint2)(0x00008082, 0x00000000),
    (uint2)(0x0000808a, 0x80000000),
    (uint2)(0x80008000, 0x80000000),
    (uint2)(0x0000808b, 0x00000000),
    (uint2)(0x80000001, 0x00000000),
    (uint2)(0x80008081, 0x80000000),
    (uint2)(0x00008009, 0x80000000),
    (uint2)(0x0000008a, 0x00000000),
    (uint2)(0x00000088, 0x00000000),
    (uint2)(0x80008009, 0x00000000),
    (uint2)(0x8000000a, 0x00000000),
    (uint2)(0x8000808b, 0x00000000),
    (uint2)(0x0000008b, 0x80000000),
    (uint2)(0x00008089, 0x80000000),
    (uint2)(0x00008003, 0x80000000),
    (uint2)(0x00008002, 0x80000000),
    (uint2)(0x00000080, 0x80000000),
    (uint2)(0x0000800a, 0x00000000),
    (uint2)(0x8000000a, 0x80000000),
    (uint2)(0x80008081, 0x80000000),
    (uint2)(0x00008080, 0x80000000),
    (uint2)(0x80000001, 0x00000000),
    (uint2)(0x80008008, 0x80000000),
};

#if PLATFORM == OPENCL_PLATFORM_NVIDIA && COMPUTE >= 35
static uint2 ROL2(const uint2 a, const int offset)
{
    uint2 result;
    if (offset >= 32)
    {
        asm("shf.l.wrap.b32 %0, %1, %2, %3;" : "=r"(result.x) : "r"(a.x), "r"(a.y), "r"(offset));
        asm("shf.l.wrap.b32 %0, %1, %2, %3;" : "=r"(result.y) : "r"(a.y), "r"(a.x), "r"(offset));
    }
    else
    {
        asm("shf.l.wrap.b32 %0, %1, %2, %3;" : "=r"(result.x) : "r"(a.y), "r"(a.x), "r"(offset));
        asm("shf.l.wrap.b32 %0, %1, %2, %3;" : "=r"(result.y) : "r"(a.x), "r"(a.y), "r"(offset));
    }
    return result;
}
#elif PLATFORM == OPENCL_PLATFORM_AMD
#pragma OPENCL EXTENSION cl_amd_media_ops : enable
static uint2 ROL2(const uint2 vv, const int r)
{
    if (r <= 32)
    {
        return amd_bitalign((vv).xy, (vv).yx, 32 - r);
    }
    else
    {
        return amd_bitalign((vv).yx, (vv).xy, 64 - r);
    }
}
#else
static uint2 ROL2(const uint2 v, const int n)
{
    int r = n % 64;
    if (r == 0) return v;
    ulong val = ((ulong)v.y << 32) | v.x;
    ulong res = (val << r) | (val >> (64 - r));
    return (uint2)((uint)res, (uint)(res >> 32));
}
#endif

static void chi(uint2* a, const uint n, const uint2* t)
{
    a[n + 0] = t[n + 0] ^ ((~t[n + 1]) & t[n + 2]);
    a[n + 1] = t[n + 1] ^ ((~t[n + 2]) & t[n + 3]);
    a[n + 2] = t[n + 2] ^ ((~t[n + 3]) & t[n + 4]);
    a[n + 3] = t[n + 3] ^ ((~t[n + 4]) & t[n + 0]);
    a[n + 4] = t[n + 4] ^ ((~t[n + 0]) & t[n + 1]);
}

static void keccak_f1600_round(uint2* a, uint r)
{
    // Hardcoded constants (switch) to avoid array lookup
    uint2 rc = (uint2)(0,0);
    switch(r) {
        case 0: rc = (uint2)(0x00000001, 0x00000000); break;
        case 1: rc = (uint2)(0x00008082, 0x00000000); break;
        case 2: rc = (uint2)(0x0000808a, 0x80000000); break;
        case 3: rc = (uint2)(0x80008000, 0x80000000); break;
        case 4: rc = (uint2)(0x0000808b, 0x00000000); break;
        case 5: rc = (uint2)(0x80000001, 0x00000000); break;
        case 6: rc = (uint2)(0x80008081, 0x80000000); break;
        case 7: rc = (uint2)(0x00008009, 0x80000000); break;
        case 8: rc = (uint2)(0x0000008a, 0x00000000); break;
        case 9: rc = (uint2)(0x00000088, 0x00000000); break;
        case 10: rc = (uint2)(0x80008009, 0x00000000); break;
        case 11: rc = (uint2)(0x8000000a, 0x00000000); break;
        case 12: rc = (uint2)(0x8000808b, 0x00000000); break;
        case 13: rc = (uint2)(0x0000008b, 0x80000000); break;
        case 14: rc = (uint2)(0x00008089, 0x80000000); break;
        case 15: rc = (uint2)(0x00008003, 0x80000000); break;
        case 16: rc = (uint2)(0x00008002, 0x80000000); break;
        case 17: rc = (uint2)(0x00000080, 0x80000000); break;
        case 18: rc = (uint2)(0x0000800a, 0x00000000); break;
        case 19: rc = (uint2)(0x8000000a, 0x80000000); break;
        case 20: rc = (uint2)(0x80008081, 0x80000000); break;
        case 21: rc = (uint2)(0x00008080, 0x80000000); break;
        case 22: rc = (uint2)(0x80000001, 0x00000000); break;
        case 23: rc = (uint2)(0x80008008, 0x80000000); break;
    }

    uint2 t[25];
    uint2 u;

    // Theta
    t[0] = a[0] ^ a[5] ^ a[10] ^ a[15] ^ a[20];
    t[1] = a[1] ^ a[6] ^ a[11] ^ a[16] ^ a[21];
    t[2] = a[2] ^ a[7] ^ a[12] ^ a[17] ^ a[22];
    t[3] = a[3] ^ a[8] ^ a[13] ^ a[18] ^ a[23];
    t[4] = a[4] ^ a[9] ^ a[14] ^ a[19] ^ a[24];
    u = t[4] ^ ROL2(t[1], 1);
    a[0] ^= u;
    a[5] ^= u;
    a[10] ^= u;
    a[15] ^= u;
    a[20] ^= u;
    u = t[0] ^ ROL2(t[2], 1);
    a[1] ^= u;
    a[6] ^= u;
    a[11] ^= u;
    a[16] ^= u;
    a[21] ^= u;
    u = t[1] ^ ROL2(t[3], 1);
    a[2] ^= u;
    a[7] ^= u;
    a[12] ^= u;
    a[17] ^= u;
    a[22] ^= u;
    u = t[2] ^ ROL2(t[4], 1);
    a[3] ^= u;
    a[8] ^= u;
    a[13] ^= u;
    a[18] ^= u;
    a[23] ^= u;
    u = t[3] ^ ROL2(t[0], 1);
    a[4] ^= u;
    a[9] ^= u;
    a[14] ^= u;
    a[19] ^= u;
    a[24] ^= u;

    // Rho Pi

    t[0] = a[0];
    t[10] = ROL2(a[1], 1);
    t[20] = ROL2(a[2], 62);
    t[5] = ROL2(a[3], 28);
    t[15] = ROL2(a[4], 27);

    t[16] = ROL2(a[5], 36);
    t[1] = ROL2(a[6], 44);
    t[11] = ROL2(a[7], 6);
    t[21] = ROL2(a[8], 55);
    t[6] = ROL2(a[9], 20);

    t[7] = ROL2(a[10], 3);
    t[17] = ROL2(a[11], 10);
    t[2] = ROL2(a[12], 43);
    t[12] = ROL2(a[13], 25);
    t[22] = ROL2(a[14], 39);

    t[23] = ROL2(a[15], 41);
    t[8] = ROL2(a[16], 45);
    t[18] = ROL2(a[17], 15);
    t[3] = ROL2(a[18], 21);
    t[13] = ROL2(a[19], 8);

    t[14] = ROL2(a[20], 18);
    t[24] = ROL2(a[21], 2);
    t[9] = ROL2(a[22], 61);
    t[19] = ROL2(a[23], 56);
    t[4] = ROL2(a[24], 14);

    // Chi
    chi(a, 0, t);

    // Iota
    a[0] ^= rc;

    chi(a, 5, t);
    chi(a, 10, t);
    chi(a, 15, t);
    chi(a, 20, t);
}

static void keccak_f1600_no_absorb(uint2* a, uint out_size, uint isolate)
{
    // Originally I unrolled the first and last rounds to interface
    // better with surrounding code, however I haven't done this
    // without causing the AMD compiler to blow up the VGPR usage.


    // uint o = 25;
    for (uint r = 0; r < 24;)
    {
        // This dynamic branch stops the AMD compiler unrolling the loop
        // and additionally saves about 33% of the VGPRs, enough to gain another
        // wavefront. Ideally we'd get 4 in flight, but 3 is the best I can
        // massage out of the compiler. It doesn't really seem to matter how
        // much we try and help the compiler save VGPRs because it seems to throw
        // that information away, hence the implementation of keccak here
        // doesn't bother.
        if (isolate)
        {
            keccak_f1600_round(a, r++);
            // if (r == 23) o = out_size;
        }
    }


    // final round optimised for digest size
    // keccak_f1600_round(a, 23, out_size);
}

#define copy(dst, src, count)         \
    for (uint i = 0; i != count; ++i) \
    {                                 \
        (dst)[i] = (src)[i];          \
    }

static uint fnv(uint x, uint y)
{
    return x * FNV_PRIME ^ y;
}

static uint4 fnv4(uint4 x, uint4 y)
{
    return x * FNV_PRIME ^ y;
}

typedef union
{
    uint words[64 / sizeof(uint)];
    uint2 uint2s[64 / sizeof(uint2)];
    uint4 uint4s[64 / sizeof(uint4)];
} hash64_t;

typedef union
{
    uint words[200 / sizeof(uint)];
    uint2 uint2s[200 / sizeof(uint2)];
    uint4 uint4s[200 / sizeof(uint4)];
} hash200_t;

typedef struct
{
    uint4 uint4s[128 / sizeof(uint4)];
} hash128_t;

static void SHA3_512(uint2* s, uint isolate)
{
    for (uint i = 8; i != 25; ++i)
    {
        s[i] = (uint2){0, 0};
    }
    s[8].x = 0x00000001;
    s[8].y = 0x80000000;
    keccak_f1600_no_absorb(s, 8, isolate);
}

__kernel void ethash_calculate_dag_item(
    uint start, __global hash64_t const* g_light, __global hash64_t* g_dag, uint isolate)
{
    uint const node_index = start + get_global_id(0);
    if (node_index * sizeof(hash64_t) >= PROGPOW_DAG_BYTES)
        return;

    hash200_t dag_node;
    copy(dag_node.uint4s, g_light[node_index % LIGHT_WORDS].uint4s, 4);
    dag_node.words[0] ^= node_index;
    SHA3_512(dag_node.uint2s, isolate);

    for (uint i = 0; i != ETHASH_DATASET_PARENTS; ++i)
    {
        uint parent_index = fnv(node_index ^ i, dag_node.words[i % NODE_WORDS]) % LIGHT_WORDS;

        for (uint w = 0; w != 4; ++w)
        {
            dag_node.uint4s[w] = fnv4(dag_node.uint4s[w], g_light[parent_index].uint4s[w]);
        }
    }
    SHA3_512(dag_node.uint2s, isolate);
    copy(g_dag[node_index].uint4s, dag_node.uint4s, 4);
}


