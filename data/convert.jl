# Convert every AMPL `.mod` in `data/ampl` to a JuMP `.jl` in `data/jump`
# using JuMPConverter.jl. Each `.dat` companion is converted to a
# directory of CSVs (one file per parameter/set), so the generated
# `build_model("<dat-stem>/")` path-loader can pick them up via the
# `isdir(path)` branch.
#
# Run from a Julia project that has both MacMPEC and JuMPConverter
# available (e.g. `julia --project=. data/convert.jl`).

using MacMPEC
using JuMPConverter

const JUMP_DIR = joinpath(@__DIR__, "jump")
mkpath(JUMP_DIR)

failures = Tuple{String,String}[]
models = Dict{String,JuMPConverter.Model}()
for row in eachrow(MacMPEC.collection())
    mod_file = row["mod file"]
    dat_file = row["dat file"]
    model = get(models, mod_file, nothing)
    if model === nothing
        mod_in = joinpath(MacMPEC.AMPL_DIR, mod_file)
        jl_out = joinpath(JUMP_DIR, replace(mod_file, r"\.mod$" => ".jl"))
        try
            model = JuMPConverter.AMPL.read_model(mod_in)
            open(io -> println(io, model), jl_out, "w")
            models[mod_file] = model
        catch err
            push!(failures, (mod_file, sprint(showerror, err)))
            continue
        end
    end
    if dat_file != "n/a"
        csv_dir = joinpath(JUMP_DIR, replace(dat_file, r"\.dat$" => ""))
        try
            JuMPConverter.AMPL.dat_to_csv(
                joinpath(MacMPEC.AMPL_DIR, dat_file),
                model,
                csv_dir,
            )
        catch err
            push!(failures, (dat_file, sprint(showerror, err)))
        end
    end
end

if !isempty(failures)
    println(stderr, "Conversion failed for $(length(failures)) file(s):")
    for (f, msg) in failures
        println(stderr, "  - ", f, ": ", msg)
    end
end
