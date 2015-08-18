//
//  C++Random.m
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/12/15.
//
//  Copyright (c) 2014, Jonathan Wight
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

#include <random>

// TODO: Thread safety?

// See: http://www.johndcook.com/blog/cpp_TR1_random/

#if defined(__cplusplus)
extern "C" {
#endif

void *NewMT19937Engine(UInt64 seed) {
    auto engine = new std::mt19937_64();
    engine->seed(seed);
    return engine;
}

void DeallocMT19937Engine(void *MT19937Engine) {
    auto engine = reinterpret_cast <std::mt19937_64 *> (MT19937Engine);
    delete engine;
}

UInt64 MT19937EngineGenerate(void *MT19937Engine, UInt64 lower, UInt64 upper) {
    auto engine = reinterpret_cast <std::mt19937_64 *> (MT19937Engine);
    std::uniform_int_distribution<UInt64> uniform(lower, upper);
    return uniform(*engine);
}


#if defined(__cplusplus)
}
#endif
