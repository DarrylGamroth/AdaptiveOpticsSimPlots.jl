include(joinpath(@__DIR__, "common.jl"))

rng = MersenneTwister(3)
sim = shack_hartmann_simulation(
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
imat1 = interaction_matrix(sim.optic, sim.wfs, sim.tel; amplitude=0.05)
imat2 = interaction_matrix(sim.optic, sim.wfs, sim.tel; amplitude=0.1)
mat = 0.5 .* (imat1.matrix .+ imat2.matrix)
recon = ModalReconstructor(InteractionMatrix(mat, 0.1); gain=0.4)
branch = ControlLoopBranch(:main, sim, recon; rng=rng)
cfg = SingleControlLoopConfig(name=:run_cl_long_push_pull_demo, branch_label=:main)
scenario = build_control_loop_scenario(cfg, branch)
prepare!(scenario)

residual = zeros(Float64, 5)
for k in eachindex(residual)
    step!(scenario)
    residual[k] = pupil_rms(sim.tel.state.opd, sim.tel.state.pupil)
end
rt = readout(scenario)
display(loop_summary_figure(command(rt), slopes(rt), residual; title_prefix="Long Push-Pull"))
