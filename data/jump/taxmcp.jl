using JuMP
function build_model(; I = 1:2, lbar, kbar, c0, betal, rev, sigma, alpha = JuMP.Containers.DenseAxisArray(fill(0.5, length(I)), I), phi = JuMP.Containers.DenseAxisArray(fill(1.0, length(I)), I), beta = JuMP.Containers.DenseAxisArray(fill(1.0, length(I)), I))
    model = Model()
    @variable(model, Y[I] >= 0)
    @variable(model, C >= 0)
    @variable(model, G >= 0)
    @variable(model, P[I] >= 0)
    @variable(model, PC >= 0)
    @variable(model, PL >= 0)
    @variable(model, PK >= 0)
    @variable(model, PG >= 0)
    @variable(model, GOVT >= 0)
    @variable(model, T[I] >= 0)
    @variable(model, MU >= 0)
    @variable(model, 0.4 <= TAU[I] <= 0.6)
    @constraint(model, PROFIT[i in I], PL ^ alpha[i] * PK ^ (1 - alpha[i]) >= phi[i] * P[i] ⟂ Y[i])
    @constraint(model, PROFITC, (betal / c0 * PL ^ (1 - sigma) + sum(beta[i] / c0 * (P[i] * (1 + T[i])) ^ (1 - sigma) for i in I)) ^ (1 / (1 - sigma)) >= PC ⟂ C)
    @constraint(model, PROFITG, PG >= PL ⟂ G)
    @constraint(model, MARKETG, G * PG >= GOVT ⟂ PG)
    @constraint(model, MARKET[i in I], Y[i] * phi[i] >= (PC / (P[i] * (1 + T[i]))) ^ sigma * beta[i] * C ⟂ P[i])
    @constraint(model, MARKETL, PL * lbar >= GOVT + sum(Y[i] * P[i] * phi[i] * alpha[i] for i in I) + PL * (PC / PL) ^ sigma * betal * C ⟂ PL)
    @constraint(model, MARKETK, PK * kbar >= sum(Y[i] * P[i] * phi[i] * (1 - alpha[i]) ⟂ PK for i in I))
    @constraint(model, REVENUE, GOVT >= sum(Y[i] * phi[i] * P[i] * T[i] ⟂ GOVT for i in I))
    @constraint(model, INCOME, PC * C * c0 >= PL * lbar + PK * kbar ⟂ PC)
    @constraint(model, REV_CONST, GOVT >= PL * rev ⟂ MU)
    @constraint(model, TAX[i in I], T[i] >= MU * TAU[i] ⟂ T[i])
    @objective(model, Max, C)
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :lbar => 0,
            :kbar => 0,
            :c0 => 0,
            :betal => 0,
            :rev => 0,
            :sigma => 0,
            :alpha => 1,
            :phi => 1,
            :beta => 1,
        ),
        [:I],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
