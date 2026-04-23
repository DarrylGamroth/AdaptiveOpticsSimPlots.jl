# # Tutorial: Closed-Loop Shack-Hartmann
#
# This plotted counterpart wraps the maintained Shack-Hartmann closed-loop
# tutorial and visualizes residual evolution, final WFS signal, and final PSF.

isdefined(@__MODULE__, :run_core_tutorial) || include(joinpath(@__DIR__, "common.jl"))

result = run_core_tutorial("closed_loop_shack_hartmann.jl"; n_iter=8)

display(Plots.plot(
    plot_runtime_timeseries(
        (residual_before=result.residual_before, residual_after=result.residual_after);
        title="Residual RMS",
        ylabel="meters",
    ),
    plot_signal_trace(result.final_slopes; title="Final SH Slopes", ylabel="signal"),
    plot_psf(result.final_psf; title="Final PSF"),
    layout=(1, 3),
    size=(1300, 360),
))
