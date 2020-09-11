using KissCaches
using Documenter

makedocs(;
    modules=[KissCaches],
    authors="Jan Weidner <jw3126@gmail.com> and contributors",
    repo="https://github.com/jw3126/KissCaches.jl/blob/{commit}{path}#L{line}",
    sitename="KissCaches.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jw3126.github.io/KissCaches.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jw3126/KissCaches.jl",
)
