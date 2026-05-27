using JuMP
function build_model()
    model = Model()
    @variable(model, z1 >= 0)
    @variable(model, z2 >= 0)
    @constraint(model, compl, z1 ⟂ z2)
    @objective(model, Min, 0.5 * (z1 - 1) ^ 2 + (z2 - 1) ^ 2)
    return model
end
