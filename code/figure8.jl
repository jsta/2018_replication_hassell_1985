include("seed.jl")

N = 5000

cor_D = zeros(Float64, N)
cor_h = zeros(Float64, N)
cor_a = zeros(Float64, N)

for i in eachindex(cor_D)
    sd = i == 1 ? 0.0 : 0.5
    sim, params = simulation(50.0, 25.0, m=0.5, F=4.0, D=0.5, h=10.0, b=25.0, a=0.5, th= 0.0, m=0.5, f=generalist_dyn, D_sd=sd)
    kval = mapslices((r) -> kvalue_by_generation(r, params), sim, 2)
    correlation = cor(vec(log10.(sim[:,2])), vec(kval))
    cor_D[i] = correlation
end

for i in eachindex(cor_h)
    sd = i == 1 ? 0.0 : 5.0
    sim, params = simulation(50.0, 25.0, m=0.5, F=4.0, D=0.5, h=10.0, b=25.0, a=0.5, th= 0.0, m=0.5, f=generalist_dyn, h_sd=sd)
    kval = mapslices((r) -> kvalue_by_generation(r, params), sim, 2)
    correlation = cor(vec(log10.(sim[:,2])), vec(kval))
    cor_h[i] = correlation
end

for i in eachindex(cor_a)
    sd = i == 1 ? 0.0 : 0.5
    sim, params = simulation(50.0, 25.0, m=0.5, F=4.0, D=0.5, h=10.0, b=25.0, a=0.5, th= 0.0, m=0.5, f=generalist_dyn, a_sd=sd)
    kval = mapslices((r) -> kvalue_by_generation(r, params), sim, 2)
    correlation = cor(vec(log10.(sim[:,2])), vec(kval))
    cor_a[i] = correlation
end

pl_D = density(cor_D[2:end], xlim=(0,1.0), ylim=(0,10), frame=:origin, c=:black, fill=(0, :grey, 0.2), leg=false)
vline!(pl_D, [first(cor_D)], lw=2, ls=:dot, c=:grey)
ylabel!(pl_D, "Density")
annotate!(0.45, 9, text("D = 0.5 ± 0.5"))
annotate!(pl_D, 0.05, 9.5, text("(a)"))

pl_h = density(cor_h[2:end], xlim=(0,1.0), ylim=(0,10), frame=:origin, c=:black, fill=(0, :grey, 0.2), leg=false)
vline!(pl_h, [first(cor_h)], lw=2, ls=:dot, c=:grey)
xlabel!(pl_h, "Correlation")
annotate!(0.45, 9, text("h = 10 ± 5"))
annotate!(pl_h, 0.05, 9.5, text("(b)"))

pl_a = density(cor_a[2:end], xlim=(0,1.0), ylim=(0,10), frame=:origin, c=:black, fill=(0, :grey, 0.2), leg=false)
vline!(pl_a, [first(cor_a)], lw=2, ls=:dot, c=:grey)
annotate!(0.45, 9, text("a = 0.5 ± 0.5"))
annotate!(pl_a, 0.05, 9.5, text("(c)"))

plot(pl_D, pl_h, pl_a, layout=(1,3), size=(1200,400), margin=5mm)
savefig("article/figures/figure8.pdf")
