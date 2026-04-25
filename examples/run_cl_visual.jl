include(joinpath(@__DIR__, "common.jl"))

rng = MersenneTwister(0)
sim = AdaptiveOpticsSim.initialize_ao_shwfs(
    resolution=32,
    diameter=8.0,
    sampling_time=1e-3,
    r0=0.2,
    L0=25.0,
    fractional_cn2=[1.0],
    wind_speed=[5.0],
    wind_direction=[0.0],
    altitude=[0.0],
    n_act=4,
    n_lenslets=4,
)
imat = interaction_matrix(sim.optic, sim.wfs, sim.tel; amplitude=0.1)
recon = ModalReconstructor(imat; gain=0.5)
branch = RuntimeBranch(:main, sim, recon; rng=rng)
cfg = SingleRuntimeConfig(name=:run_cl_demo, branch_label=:main)
scenario = build_runtime_scenario(cfg, branch)
prepare!(scenario)

residual = zeros(Float64, 5)
for k in eachindex(residual)
    step!(scenario)
    residual[k] = pupil_rms(sim.tel.state.opd, sim.tel.state.pupil)
end
rt = readout(scenario)
display(loop_summary_figure(command(rt), slopes(rt), residual; title_prefix="SH Closed Loop"))
