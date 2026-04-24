abstract type AbstractAOPlot end

"""
    Pupil()

Select a pupil/support intensity view. Supported inputs include telescope
objects and pupil-like matrices.
"""
struct Pupil <: AbstractAOPlot end

"""
    OPD()

Select an optical-path-difference surface view. Supported inputs include
telescope objects, deformable mirrors, controllable optics, and OPD matrices.
"""
struct OPD <: AbstractAOPlot end

"""
    PSF()

Select a point-spread-function image view for PSF matrices.
"""
struct PSF <: AbstractAOPlot end

"""
    ScienceFrame()

Select a science detector/readout frame view.
"""
struct ScienceFrame <: AbstractAOPlot end

"""
    DetectorFrame()

Select a detector frame view for detector objects or detector-frame matrices.
"""
struct DetectorFrame <: AbstractAOPlot end

"""
    WFSFrame()

Select a wavefront-sensor frame view. Shack-Hartmann WFS objects render as a
tiled detector-like subaperture mosaic.
"""
struct WFSFrame <: AbstractAOPlot end

"""
    ShackHartmannDetectorFrame()

Select the explicit Shack-Hartmann detector mosaic view, exposing the lenslet
spot cube as a single tiled image.
"""
struct ShackHartmannDetectorFrame <: AbstractAOPlot end

"""
    Commands()

Select command/actuator values for deformable mirrors and compatible
controllable optics.
"""
struct Commands <: AbstractAOPlot end

"""
    Signal()

Select a one-dimensional signal trace, including WFS slopes and runtime
telemetry signals.
"""
struct Signal <: AbstractAOPlot end

"""
    RuntimeTimeseries()

Select a multi-series telemetry plot from a `NamedTuple` of vectors or a vector
of named-tuple log entries.
"""
struct RuntimeTimeseries <: AbstractAOPlot end
