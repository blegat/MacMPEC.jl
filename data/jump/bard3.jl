using JuMP
function build_model(; N = 1:2)
    model = Model()
    @variable(model, x[N] >= 0)
    @variable(model, y[N] >= 0)
    @variable(model, l[N] >= 0)
    @constraint(model, nlncs, x[1] ^ 2 + 2 * x[2] <= 4)
    @constraint(model, KKT1, 2 * y[1] + l[1] * 2 - l[2] * 3 == 0)
    @constraint(model, KKT2, - 5 - l[1] + l[2] * 4 == 0)
    @constraint(model, lin_1, x[1] ^ 2 - 2 * x[1] + x[2] ^ 2 - 2 * y[1] + y[2] + 3 ⟂ l[1])
    @constraint(model, lin_2, x[2] + 3 * y[1] - 4 * y[2] - 4 ⟂ l[2])
    @objective(model, Min, - x[1] ^ 2 - 3 * x[2] - 4 * y[1] + y[2] ^ 2)
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
        ),
        [:N],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
