module MacMPEC

import DataFrames as DF
import CSV

const heading_meaning = CSV.read(joinpath(@__DIR__, "..", "data", "heading_meaning.csv"), DF.DataFrame)
const collection = CSV.read(joinpath(@__DIR__, "..", "data", "collection.csv"), DF.DataFrame)

list() = collection.name

@enum Status Optimal Infeasible Unknown

struct Problem
    name::String
    classification::String
    status::Status
    solution::Union{Float64,Nothing}
end

function problem(name::AbstractString)
    idx = findfirst(==(name), collection.name)
    sol = collection.solution[idx]
    solution = nothing
    if sol == "(I)"
        status = Infeasible
    elseif sol == "tba"
        status = Unknown
    else
        status = Optimal
        solution = parse(Float64, sol)
    end
    return Problem(name, collection.classification[idx], status, solution)
end

end # module MacMPEC
