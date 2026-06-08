using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\n\nlet x := 1;\nlet y := 1;\n",
)

function build_model()
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y)
    @constraint(model, compl, x ⟂ y)
    @objective(model, Min, x ^ 2 + y ^ 2 - 4 * x * y)
    return model
end
