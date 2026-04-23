# # Deformable Mirror Visualization
#
# This example renders both regular-grid and sampled-topology DM commands.

isdefined(@__MODULE__, :build_visual_optics) || include(joinpath(@__DIR__, "common.jl"))

state = build_visual_optics()

display(plot_dm_commands(state.dm))
display(plot_dm_opd(state.dm))

sampled_topology = SampledActuatorTopology(
    actuator_coordinates(state.dm)[:, 1:4];
    metadata=(manufacturer=:alpao,),
)
measured_modes = Array(state.dm.state.modes[:, 1:4])
sampled_dm = DeformableMirror(
    state.tel;
    topology=sampled_topology,
    influence_model=MeasuredInfluenceFunctions(measured_modes),
)
sampled_dm.state.coefs .= [0.1, -0.2, 0.3, -0.4]

display(plot_dm_commands(sampled_dm))
