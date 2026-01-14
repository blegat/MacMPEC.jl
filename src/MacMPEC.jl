module MacMPEC

import DataFrames as DF
import CSV

const HEADING_MEANING = CSV.read(joinpath(@__DIR__, "..", "data", "heading_meaning.csv"), DF.DataFrame)
const COLLECTION = CSV.read(joinpath(@__DIR__, "..", "data", "collection.csv"), DF.DataFrame)

heading_meaning() = HEADING_MEANING
collection() = COLLECTION

list() = collection().name

@enum Status Optimal Infeasible Unknown

struct Problem
    name::String
    mod_file::String
    dat_file::Union{String,Nothing}
    classification::String
    status::Status
    solution::Union{Float64,Nothing}
end

function problem(name::AbstractString)
    idx = findfirst(==(name), COLLECTION.name)
    sol = COLLECTION.solution[idx]
    solution = nothing
    if sol == "(I)"
        status = Infeasible
    elseif sol == "tba"
        status = Unknown
    else
        status = Optimal
        solution = parse(Float64, sol)
    end
    mod_file = COLLECTION[idx, "mod file"]
    dat_file = COLLECTION[idx, "dat file"]
    dat_file = dat_file == "n/a" ? nothing : dat_file
    return Problem(name, mod_file, dat_file, COLLECTION.classification[idx], status, solution)
end

const PROBLEMS_DIR = joinpath(dirname(dirname(pathof(MacMPEC))), "data", "problems")

function dat_path(p::Problem)
    if isnothing(p.dat_file)
        @assert !isfile(joinpath(PROBLEMS_DIR, "$(p.name).dat"))
        return
    end
    # For `design-cent-21`, the `dat_file` is `design-cent-2.dat`, without the `1`
    # so we cannot just do `"$(p.name).dat"`
    path = joinpath(dirname(dirname(pathof(MacMPEC))), "data", "problems", p.dat_file)
    @assert isfile(path)
    return path
end

end # module MacMPEC
