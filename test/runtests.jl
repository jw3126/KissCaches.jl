using KissCaches
using KissCaches: deletecached!
using Test


function self(args...; kw...)
    (args, kw)
end

function test_cached(cache, f, args...; kw...)
    @test !iscached(cache, f, args...; kw...)
    @cached cache f(args...; kw...)
    @test iscached(cache, f, args...; kw...)
    deletecached!(cache, f, args...; kw...)
    @test !iscached(cache, f, args...; kw...)
end

@testset "test" begin
    cache = Dict()
    @test !iscached(cache, sin, 1)
    @cached cache sin(1)
    @test iscached(cache, sin, 1)
    empty!(cache)
    @test !iscached(cache, sin, 1)
    @test !iscached(cache, cos, 1)

    test_cached(Dict(), sin, 1)
    test_cached(Dict(), self)
    test_cached(Dict(), self, 1)
    test_cached(Dict(), self, x=:x)
    test_cached(Dict(), self, 1, x=1)
    test_cached(Dict(), self, 1, x=1, y="hi", z=["a", Any])
    test_cached(Dict(), self, 1, x=1, y="hi", z=["a", Any])
end

@testset "GLOBAL_CACHE" begin
    @test !iscached(KissCaches.GLOBAL_CACHE, self)
    @cached self()
    @test iscached(KissCaches.GLOBAL_CACHE, self)
    for (args, kw) in [
            ((1,), NamedTuple()),
            ((), (a=1,)),
        ]
        @test !iscached(KissCaches.GLOBAL_CACHE, self, args...; kw...)
        @cached self(args...; kw...)
        @test iscached(KissCaches.GLOBAL_CACHE, self, args...; kw...)
    end
end

@testset "interesting behaviour" begin
    # This behaviour is not necesserily desired.
    # These tests are there so that we don't forget
    # about it

    cache = Dict()
    @cached cache self(1.0)
    @test iscached(cache, self, UInt(1))
    @test iscached(cache, self, Int(1))
    @test iscached(cache, self, Float64(1))
    @test iscached(cache, self, Bool(1))
    @test iscached(cache, self, Complex(1))
    @test !iscached(cache, self, fill(1, (1,1)))

    @cached cache self("hi")
    @test iscached(cache, self, "hi")
    @test !iscached(cache, self, :hi)

    @cached cache self(1:1)
    @test iscached(cache, self, 1:1)
    @test iscached(cache, self, [1])
    @test iscached(cache, self, [true])
    @test iscached(cache, self, [1.0])
end
