include(joinpath(@__DIR__, "common.jl"))

rng = MersenneTwister(4)
sim = AdaptiveOpticsSim.initialize_ao_pyramid(
    resolution=32,
    diameter=8.0,
    sampling_time=1e-3,
    r0=0.2,
    L0=25.0,
    fractional_cn2=[1.0],
    wind_speed=[6.0],
    wind_direction=[30.0],
    altitude=[0.0],
    n_act=4,
    pupil_samples=4,
    modulation=2.0,
)
imat = interaction_matrix(sim.optic, sim.wfs, sim.tel; amplitude=0.1)
recon = ModalReconstructor(imat; gain=0.4)
cmd = similar(sim.optic.state.coefs)
n_iter = 6
residual = zeros(Float64, n_iter)
modulation_trace = zeros(Float64, n_iter)

for k in 1:n_iter
    advance!(sim.atm, sim.tel; rng=rng)
    propagate!(sim.atm, sim.tel)
    apply!(sim.optic, sim.tel, DMAdditive())
    measure!(sim.wfs, sim.tel)
    residual[k] = pupil_rms(sim.tel.state.opd, sim.tel.state.pupil)
    reconstruct!(cmd, recon, sim.wfs.state.slopes)
    modulation = 1 + 0.2 * sin(2 * pi * k / n_iter)
    modulation_trace[k] = modulation
    sim.optic.state.coefs .= -cmd .* modulation
end

display(Plots.plot(
    loop_summary_figure(sim.optic.state.coefs, sim.wfs.state.slopes, residual; title_prefix="Sinusoidal"),
    aoplot(modulation_trace, Signal(); title="Command Modulation", ylabel="scale"),
    layout=(1, 2),
    size=(1200, 380),
))
