# Refresh problems folder

using CSV
using DataFrames
using ProgressMeter
import HTTP

collection = CSV.read(joinpath(@__DIR__, "collection.csv"), DataFrame)

# Update mod files
@showprogress for row in eachrow(collection)
    mod_file = row["mod file"]
    if row.name == "bard1"
        # It still fails because `HTTP.get` does not support HTTPS
        url = "http://wiki.mcs.anl.gov/leyffer/images/1/1c/Bard1.mod"
        mod_file = lowercase(mod_file)
    else
        url = "http://www.mcs.anl.gov/~leyffer/MacMPEC/problems/$mod_file"
    end
    response = HTTP.get(url)
    @assert response.status == 200
    open(joinpath(@__DIR__, "problems", mod_file), "w") do f
        write(f, String(response.body))
    end
end

# Update dat files
@showprogress for row in eachrow(collection)
    dat_file = row["dat file"]
    if dat_file == "n/a"
        continue
    end
    url = "http://www.mcs.anl.gov/~leyffer/MacMPEC/problems/$dat_file"
    response = HTTP.get(url)
    @assert response.status == 200
    open(joinpath(@__DIR__, "problems", dat_file), "w") do f
        write(f, String(response.body))
    end
end
