include(joinpath(@__DIR__, "common.jl"))

rng = MersenneTwister(1)
sim = shack_hartmann_simulation(
    resolution=32,
    diameter=8.0,
    sampling_time=1e-3,
    r0=0.2,
    L0=25.0,
    fractional_cn2=[0.7, 0.3],
    wind_speed=[5.0, 10.0],
    wind_direction=[0.0, 90.0],
    altitude=[0.0, 8000.0],
    n_act=4,
    n_lenslets=4,
)
imat = interaction_matrix(sim.optic, sim.wfs, sim.tel; amplitude=0.1)
recon = ModalReconstructor(imat; gain=0.4)
cmd = similar(sim.optic.state.coefs)
residual = zeros(Float64, 5)
n_half = div(length(cmd), 2)

for k in eachindex(residual)
    advance!(sim.atm, sim.tel; rng=rng)
    propagate!(sim.atm, sim.tel)
    apply!(sim.optic, sim.tel, DMAdditive())
    measure!(sim.wfs, sim.tel)
    residual[k] = pupil_rms(sim.tel.state.opd, sim.tel.state.pupil)
    reconstruct!(cmd, recon, sim.wfs.state.slopes)
    sim.optic.state.coefs .= 0
    sim.optic.state.coefs[1:n_half] .= -cmd[1:n_half]
end

display(loop_summary_figure(sim.optic.state.coefs, sim.wfs.state.slopes, residual; title_prefix="First Stage"))
