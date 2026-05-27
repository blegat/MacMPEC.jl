using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\n\n# starting point 1\nlet{i in {1..2}} x[i] := 1.0;\nlet{i in {1..6}} y[i] := 1.0;\n\n# starting point 2 (simply uncomment)\n## let x[1] := 0.5;\n## let x[1] := 1.0;\n## let{i in {1..6}} y[i] := 1.0;\n## let y[1] := 0.5;\n## let y[2] := 0.5;\n## let{i in {1..6}} w[i] := 0.1;\n\n\n\n        \n\n",
)

function build_model()
    model = Model()
    @variable(model, x[1:2] >= 0)
    @variable(model, y[1:6] >= 0)
    @constraint(model, lin, x[1] + 2 * x[2] - y[3] <= 1.3)
    @constraint(model, KKT1, 2 - y[4] - 2 * y[5] + 4 * y[6] ⟂ y[1])
    @constraint(model, KKT2, 1 + y[4] + 4 * y[5] - 2 * y[6] ⟂ y[2])
    @constraint(model, KKT3, 2 + y[4] - y[5] - y[6] ⟂ y[3])
    @constraint(model, slack1, 1 + y[1] - y[2] - y[3] ⟂ y[4])
    @constraint(model, slack2, 2 - 4 * x[1] + 2 * y[1] - 4 * y[2] + y[3] ⟂ y[5])
    @constraint(model, slack3, 2 - 4 * x[2] - 4 * y[1] + 2 * y[2] + y[3] ⟂ y[6])
    @objective(model, Max, 8 * x[1] + 4 * x[2] - 4 * y[1] + 40 * y[2] + 4 * y[3])
    return model
end
