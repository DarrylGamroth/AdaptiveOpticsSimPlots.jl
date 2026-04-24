module AdaptiveOpticsSimPlots

using AdaptiveOpticsSim
using Plots

export aoplot
export Pupil, OPD, PSF, ScienceFrame, DetectorFrame, WFSFrame
export ShackHartmannDetectorFrame, Commands, Signal, RuntimeTimeseries
export shack_hartmann_detector_image

include("selectors.jl")
include("utils.jl")
include("images.jl")
include("dm.jl")
include("telemetry.jl")
include("dispatch.jl")

end
