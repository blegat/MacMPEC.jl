using JuMP
function build_model(; I = 1:61, Y = 1:3, S = 1:48, SS, q, Qm, Z, te, r, pe, v1, v2, M1, M2, n)
    model = Model()
    @variable(model, 1 <= tc <= 30)
    @variable(model, 1 <= tb <= 30)
    @variable(model, 10 <= k <= 500)
    @variable(model, 10 <= h <= 500)
    @variable(model, errQ[SS])
    @variable(model, t[SS, I])
    @variable(model, lw[SS, I, Y] >= 0)
    @variable(model, Qc[s in SS])
    @variable(model, phi[SS, I, Y] >= 0)
    @constraint(model, compl[s in SS, i in I, y in Y], phi[s, i, y] ⟂ lw[s, i, y])
    @constraint(model, traction[s in SS, i in I], t[s, i] == q[s] * te[i] + sum(Z[i, j] * lw[s, j, 3] for j in I))
    @constraint(model, yield[s in SS, i in I, y in Y], tc * v1[y] - tb * v2[y] - k * sum(M1[y, yy] * lw[s, i, yy] for yy in Y) - h * sum(M2[y, yy] * lw[s, i, y] for yy in Y) - t[s, i] * n[y] == phi[s, i, y])
    @constraint(model, err_Q[s in SS], errQ[s] == Qm[s] - Qc[s])
    @constraint(model, def_Qc[s in SS], Qc[s] == q[s] * pe + sum(r[i] * lw[s, i, 3] for i in I))
    @constraint(model, tc_tb, tc >= tb)
    @objective(model, Min, sum(errQ[s] * errQ[s] for s in SS))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :q => 1,
            :Qm => 1,
            :Z => 2,
            :te => 1,
            :r => 1,
            :pe => 0,
            :v1 => 1,
            :v2 => 1,
            :M1 => 2,
            :M2 => 2,
            :n => 1,
        ),
        [:I, :Y, :S, :SS],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
