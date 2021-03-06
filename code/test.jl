using NamedTuples
using Plots
include("functions.jl")
include("seed.jl")

N = 5000

cor_a = zeros(Float64, N)
cor_D = zeros(Float64, N)
cor_c = zeros(Float64, N)

for i in eachindex(cor_a)
    sd = i == 1 ? 0.0 : 0.5
    sim, params = simulation(50.0, 25.0, m=0.2, F=4.0, D=0.5, c=1.0, a=0.5, th= 0.0, m=0.5, f=specialist_dyn, a_sd=sd)
    kval = mapslices((r) -> kvalue_by_generation(r, params), sim, 2)
    a, b = linreg(vec(log10.(sim[:,2])), vec(kval))
    cor_a[i] = b
end

for i in eachindex(cor_D)
    sd = i == 1 ? 0.0 : 0.5
    sim, params = simulation(50.0, 25.0, m=0.2, F=4.0, D=0.5, c=1.0, a=0.5, th= 0.0, m=0.5, f=specialist_dyn, D_sd=sd)
    kval = mapslices((r) -> kvalue_by_generation(r, params), sim, 2)
    a, b = linreg(vec(log10.(sim[:,2])), vec(kval))
    cor_D[i] = b
end

for i in eachindex(cor_c)
    sd = i == 1 ? 0.0 : 0.5
    sim, params = simulation(50.0, 25.0, m=0.2, F=4.0, D=0.5, c=1.0, a=0.5, th= 0.0, m=0.5, f=specialist_dyn, c_sd=sd)
    kval = mapslices((r) -> kvalue_by_generation(r, params), sim, 2)
    a, b = linreg(vec(log10.(sim[:,2])), vec(kval))
    cor_c[i] = b
end

pl_a = density(cor_a[2:end], xlim=(0,0.6), ylim=(0,10), frame=:origin, c=:black, fill=(0, :grey, 0.2), leg=false)
vline!(pl_a, [first(cor_a)], lw=2, ls=:dot, c=:grey)

pl_D = density(cor_D[2:end], xlim=(0,0.6), ylim=(0,10), frame=:origin, c=:black, fill=(0, :grey, 0.2), leg=false)
vline!(pl_D, [first(cor_D)], lw=2, ls=:dot, c=:grey)

pl_c = density(cor_c[2:end], xlim=(0,0.6), ylim=(0,10), frame=:origin, c=:black, fill=(0, :grey, 0.2), leg=false)
vline!(pl_c, [first(cor_c)], lw=2, ls=:dot, c=:grey)

plot(pl_D, pl_c, pl_a, layout=(3,1))

#=
a, b = linreg(vec(log10.(sim3[:,2])), vec(kval3))
f1 = (x) -> a + b*x
fig5f
plot!(fig5f, f1)
=#
