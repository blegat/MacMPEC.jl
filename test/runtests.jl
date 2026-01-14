using Test
import MacMPEC

@testset "$name" for name in MacMPEC.list()
    problem = MacMPEC.problem(name)
    @test problem.name == name
    collection = MacMPEC.collection()
    idx = findfirst(==(name), collection.name)
    sol = collection[idx, "dat file"]
    dat_file = MacMPEC.dat_path(problem)
    if sol == "n/a"
        @test isnothing(dat_file)
    else
        @test dat_file isa String
    end
end
