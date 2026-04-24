include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=24, central_obstruction=0.0)
src = base_source()
apply_demo_ramp!(tel; scale_x=4e-9, scale_y=-2e-9)
filter = SpatialFilter(tel; shape=CircularFilter(), diameter=24 ÷ 3, zero_padding=2)
phase, amplitude = filter!(filter, tel, src)

display(Plots.plot(
    aoplot(phase, OPD(); title="Filtered Phase"),
    aoplot(abs2.(amplitude), Pupil(); title="Filtered Amplitude"),
    layout=(1, 2),
    size=(900, 380),
))
