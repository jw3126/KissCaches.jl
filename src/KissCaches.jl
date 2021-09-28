module KissCaches
export cached, @cached, iscached

function cached(storage, f, args...; kw...)
    key = makekey(storage, f, args...; kw...)
    get!(storage, key) do
        @debug """
        Adding to cache:
        f = $f
        args = $args
        kw = $kw
        key = $key
        cache = $cache
        """
        f(args...; kw...)
    end
end
# makekey(storage, f, args...; kw...) = Base.hash((f, args, kw))
makekey(storage, f, args...; kw...) = (f, args, (;kw...))

function iscached(storage, f, args...; kw...)
    k = makekey(storage, f, args...; kw...)
    haskey(storage, k)
end

function deletecached!(storage, f, args...; kw...)
    k = makekey(storage, f, args...; kw...)
    delete!(storage, k)
end

const GLOBAL_CACHE = Dict()

macro cached(ex)
    c = GLOBAL_CACHE
    esc(cachedmacro(c, ex))
end

macro cached(cache, ex)
    esc(cachedmacro(cache, ex))
end

function cachedmacro(cache, ex)
    if Meta.isexpr(ex, :call)
        if length(ex.args) >= 2 && Meta.isexpr(ex.args[2], :parameters)
            Expr(:call, cached, ex.args[2], cache, ex.args[1], ex.args[3:end]...)
        else
            Expr(:call, cached, cache, ex.args...)
        end
    else
        ex
    end
end

# function apply_cache_to_all_calls(cache, expr)
#     MacroTools.postwalk(expr) do ex
#         if Meta.isexpr(ex, :call)
#             Expr(:call, cached, cache, ex.args...)
#         else
#             ex
#         end
#     end
# end Write your package code here.

end
