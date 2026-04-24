include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=32, central_obstruction=0.14)
dm = DeformableMirror(tel; n_act=6, influence_width=0.3)
dm.state.coefs .= range(-0.1, 0.1; length=length(dm.state.coefs))
apply_opd!(dm, tel)

sampled_topology = SampledActuatorTopology(actuator_coordinates(dm)[:, 1:4];
    metadata=(manufacturer=:example,))
measured_modes = Array(dm.state.modes[:, 1:4])
sampled_dm = DeformableMirror(tel; topology=sampled_topology,
    influence_model=MeasuredInfluenceFunctions(measured_modes))
sampled_dm.state.coefs .= [0.1, -0.2, 0.3, -0.4]
apply_opd!(sampled_dm, tel)

display(Plots.plot(
    aoplot(dm, Commands(); title="Grid DM Commands"),
    aoplot(dm, OPD(); title="Grid DM OPD"),
    aoplot(sampled_dm, Commands(); title="Sampled DM Commands"),
    layout=(1, 3),
    size=(1100, 360),
))
