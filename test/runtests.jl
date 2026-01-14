using Test
import MacMPEC

for name in MacMPEC.list()
    @test MacMPEC.problem(name).name == name
end
