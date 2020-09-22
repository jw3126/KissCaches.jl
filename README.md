# KissCaches

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jw3126.github.io/KissCaches.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jw3126.github.io/KissCaches.jl/dev)
[![Build Status](https://github.com/jw3126/KissCaches.jl/workflows/CI/badge.svg)](https://github.com/jw3126/KissCaches.jl/actions)
[![Coverage](https://codecov.io/gh/jw3126/KissCaches.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jw3126/KissCaches.jl)

# Usage
```julia

julia> using KissCaches

julia> f(x) = (println("hi"); return x)
f (generic function with 1 method)

julia> @cached f(1)
hi
1

julia> @cached f(1)
1

julia> cache = Dict() # customize cache
Dict{Any,Any}()

julia> @cached cache f(1)
hi
1

julia> @cached cache f(1)
1

julia> empty!(cache)
Dict{Any,Any}()

julia> @cached cache f(1)
hi
1
```

# Alternatives

There are multiple excellent alternatives for caching function calls. Most are more sophisticted
and work by altering the function definition. KissCaches on the other hand is really simple and alters the function call. See also:
* [Memoize.jl](https://github.com/JuliaCollections/Memoize.jl)
* [Memoization.jl](https://github.com/marius311/Memoization.jl)
