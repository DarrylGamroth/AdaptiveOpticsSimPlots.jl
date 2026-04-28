function _pupil_figure(mask::AbstractMatrix; title::AbstractString="Pupil", kwargs...)
    return _heatmap2d(_plot_matrix_data(mask); title=title, kwargs...)
end

_pupil_figure(tel::AdaptiveOpticsSim.AbstractTelescope; kwargs...) =
    _pupil_figure(AdaptiveOpticsSim.pupil_mask(tel); kwargs...)

function _opd_figure(opd::AbstractMatrix; title::AbstractString="OPD", kwargs...)
    return _heatmap2d(_plot_matrix_data(opd); title=title, kwargs...)
end

_opd_figure(tel::AdaptiveOpticsSim.AbstractTelescope; kwargs...) =
    _opd_figure(AdaptiveOpticsSim.opd_map(tel); kwargs...)

function _psf_figure(psf::AbstractMatrix; stretch::Symbol=:log10, title::AbstractString="PSF", kwargs...)
    data = _apply_image_stretch(_plot_matrix_data(psf), stretch)
    return _heatmap2d(data; title=title, kwargs...)
end

_science_frame_figure(frame::AbstractMatrix; stretch::Symbol=:log10, title::AbstractString="Science Frame", kwargs...) =
    _psf_figure(frame; stretch=stretch, title=title, kwargs...)

function _science_frame_figure(x; stretch::Symbol=:log10, kwargs...)
    frame = AdaptiveOpticsSim.science_frame(x)
    isnothing(frame) && throw(ArgumentError("object of type $(typeof(x)) does not expose a science frame"))
    return _science_frame_figure(frame; stretch=stretch, kwargs...)
end

_detector_frame_figure(frame::AbstractMatrix; title::AbstractString="Detector Frame", kwargs...) =
    _heatmap2d(_plot_matrix_data(frame); title=title, kwargs...)

_detector_frame_figure(det::AdaptiveOpticsSim.AbstractDetector; title::AbstractString="Detector Frame", kwargs...) =
    _detector_frame_figure(AdaptiveOpticsSim.output_frame(det); title=title, kwargs...)

function _wfs_detector_frame_figure(wfs::AdaptiveOpticsSim.AbstractWFS; title::AbstractString="WFS Detector Frame", kwargs...)
    frame = AdaptiveOpticsSim.wfs_detector_image(wfs)
    return _detector_frame_figure(frame; title=title, kwargs...)
end

_wfs_frame_figure(frame::AbstractMatrix; title::AbstractString="WFS Frame", kwargs...) =
    _heatmap2d(_plot_matrix_data(frame); title=title, kwargs...)

function _shack_hartmann_detector_frame_figure(spot_cube::AbstractArray, n_lenslets::Integer;
    stretch::Symbol=:linear, title::AbstractString="Shack-Hartmann Detector Frame",
    gap::Integer=0, gap_value=0, kwargs...)
    frame = AdaptiveOpticsSim.shack_hartmann_detector_image(spot_cube, n_lenslets; gap=gap, gap_value=gap_value)
    data = _apply_image_stretch(_plot_matrix_data(frame), stretch)
    return _heatmap2d(data; title=title, kwargs...)
end

function _shack_hartmann_detector_frame_figure(wfs::AdaptiveOpticsSim.ShackHartmannWFS;
    stretch::Symbol=:linear, title::AbstractString="Shack-Hartmann Detector Frame",
    gap::Integer=0, gap_value=0, kwargs...)
    frame = AdaptiveOpticsSim.wfs_detector_image(wfs; gap=gap, gap_value=gap_value)
    data = _apply_image_stretch(_plot_matrix_data(frame), stretch)
    return _heatmap2d(data; title=title, kwargs...)
end

_wfs_frame_figure(wfs::AdaptiveOpticsSim.ShackHartmannWFS; kwargs...) =
    _shack_hartmann_detector_frame_figure(wfs; kwargs...)

function _wfs_frame_figure(wfs::AdaptiveOpticsSim.AbstractWFS; title::AbstractString="WFS Frame", kwargs...)
    frame = AdaptiveOpticsSim.camera_frame(wfs)
    isnothing(frame) && throw(ArgumentError("WFS of type $(typeof(wfs)) does not expose a camera frame"))
    return _wfs_frame_figure(frame; title=title, kwargs...)
end

function _wfs_frame_figure(x; title::AbstractString="WFS Frame", kwargs...)
    frame = AdaptiveOpticsSim.wfs_frame(x)
    isnothing(frame) && throw(ArgumentError("object of type $(typeof(x)) does not expose a WFS frame"))
    return _wfs_frame_figure(frame; title=title, kwargs...)
end
