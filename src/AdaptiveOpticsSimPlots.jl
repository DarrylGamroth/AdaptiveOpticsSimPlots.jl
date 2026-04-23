module AdaptiveOpticsSimPlots

using AdaptiveOpticsSim
using Plots

export aoplot
export plot_pupil, plot_opd, plot_psf
export plot_science_frame, plot_detector_frame, plot_wfs_frame
export plot_dm_commands, plot_dm_opd
export plot_signal_trace, plot_runtime_timeseries

include("utils.jl")
include("images.jl")
include("dm.jl")
include("telemetry.jl")
include("dispatch.jl")

end
