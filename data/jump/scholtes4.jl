using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    " \n\nlet z[1] := 0;\nlet z[2] := 1;\nlet z3   := 0;\n",
)

function build_model()
    model = Model()
    @variable(model, z[1:2] >= 0)
    @variable(model, z3)
    @constraint(model, lin1, - 4 * z[1] + z3 <= 0)
    @constraint(model, lin2, - 4 * z[2] + z3 <= 0)
    @constraint(model, compl, z[1] ⟂ z[2])
    @objective(model, Min, z[1] + z[2] - z3)
    return model
end
