using JuMP
function build_model()
    model = Model()
    @variable(model, z[1:3] >= 0)
    @constraint(model, compl1, z[1] ⟂ z[3])
    @constraint(model, compl2, z[2] ⟂ z[3])
    @objective(model, Min, (z[1] - 1) ^ 2 + (z[2] - 2) ^ 2 + (z[3] + 1) ^ 2)
    return model
end
