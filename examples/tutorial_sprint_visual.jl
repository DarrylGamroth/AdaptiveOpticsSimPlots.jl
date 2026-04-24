include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=16, central_obstruction=0.0)
dm = DeformableMirror(tel; n_act=3, influence_width=0.35)
wfs = ShackHartmann(tel; n_subap=2, mode=Geometric())
basis = modal_basis(dm, tel; n_modes=3).M2C
sprint = AdaptiveOpticsSim.SPRINT(tel, dm, wfs, basis; n_mis_reg=2, field_order=[:shift_x, :shift_y],
    save_sensitivity=false)

injected = Misregistration(shift_x=5e-4, shift_y=-5e-4, T=Float64)
dm_in = DeformableMirror(tel; n_act=dm.params.n_act, influence_model=influence_model(dm),
    misregistration=injected)
calib_in = interaction_matrix(dm_in, wfs, tel, basis; amplitude=1e-9).matrix
estimate = AdaptiveOpticsSim.estimate!(sprint, calib_in; precision=4)

labels = ["shift_x", "shift_y"]
plt = Plots.bar(labels, [injected.shift_x, injected.shift_y];
    label="injected",
    title="SPRINT Misregistration",
    ylabel="meters",
)
Plots.bar!(plt, labels, [estimate.shift_x, estimate.shift_y]; label="estimate")
display(plt)
