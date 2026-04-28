include(joinpath(@__DIR__, "common.jl"))

rng = MersenneTwister(2)
sim = AdaptiveOpticsSim.initialize_ao_shack_hartmann(
    resolution=32,
    diameter=8.0,
    sampling_time=1e-3,
    r0=0.2,
    L0=25.0,
    fractional_cn2=[1.0],
    wind_speed=[8.0],
    wind_direction=[45.0],
    altitude=[0.0],
    n_act=4,
    n_lenslets=4,
)
screens = Vector{Matrix{Float64}}(undef, 5)
for k in 1:5
    advance!(sim.atm, sim.tel; rng=rng)
    screens[k] = copy(sim.atm.state.opd)
end

imat = interaction_matrix(sim.optic, sim.wfs, sim.tel; amplitude=0.1)
recon = ModalReconstructor(imat; gain=0.5)
cmd = similar(sim.optic.state.coefs)
residual = zeros(Float64, length(screens))

for k in eachindex(screens)
    sim.tel.state.opd .= screens[k] .* sim.tel.state.pupil
    apply!(sim.optic, sim.tel, DMAdditive())
    measure!(sim.wfs, sim.tel)
    residual[k] = pupil_rms(sim.tel.state.opd, sim.tel.state.pupil)
    reconstruct!(cmd, recon, sim.wfs.state.slopes)
    sim.optic.state.coefs .= -cmd
end

display(Plots.plot(
    aoplot(screens[end], OPD(); title="Final Phase Screen"),
    loop_summary_figure(sim.optic.state.coefs, sim.wfs.state.slopes, residual; title_prefix="Phase Screens"),
    layout=(1, 2),
    size=(1200, 380),
))
