using JuMP
function build_model()
    model = Model()
    @variable(model, z1)
    @variable(model, z2 >= 0)
    @constraint(model, compl, z2 - z1 ⟂ z2)
    @objective(model, Min, (z2 - 1) ^ 2 + z1 ^ 2)
    return model
end
