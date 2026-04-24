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

_wfs_frame_figure(frame::AbstractMatrix; title::AbstractString="WFS Frame", kwargs...) =
    _heatmap2d(_plot_matrix_data(frame); title=title, kwargs...)

"""
    shack_hartmann_detector_image(spot_cube, n_subap; gap=1, gap_value=0)
    shack_hartmann_detector_image(wfs; gap=1, gap_value=0)

Tile a Shack-Hartmann lenslet spot cube into a detector-like mosaic image.

The spot cube is expected to have shape `(n_subap^2, n_pix_subap,
n_pix_subap)`. `gap` inserts separator pixels between subaperture tiles.
"""
function shack_hartmann_detector_image(spot_cube::AbstractArray, n_subap::Integer; gap::Integer=1, gap_value=0)
    ndims(spot_cube) == 3 || throw(DimensionMismatch("spot cube must have shape (n_subap^2, n_pix_subap, n_pix_subap)"))
    n_sub = Int(n_subap)
    n_sub > 0 || throw(ArgumentError("n_subap must be positive"))
    gap_px = Int(gap)
    gap_px >= 0 || throw(ArgumentError("gap must be non-negative"))

    spots = _host_array(spot_cube)
    n_spots, n_y, n_x = size(spots)
    n_spots == n_sub * n_sub ||
        throw(DimensionMismatch("spot cube first dimension must equal n_subap^2; got $n_spots for n_subap=$n_sub"))

    T = promote_type(eltype(spots), typeof(gap_value))
    image = fill(T(gap_value),
        n_sub * n_y + (n_sub - 1) * gap_px,
        n_sub * n_x + (n_sub - 1) * gap_px)

    @inbounds for i in 1:n_sub, j in 1:n_sub
        idx = (i - 1) * n_sub + j
        y0 = (i - 1) * (n_y + gap_px) + 1
        x0 = (j - 1) * (n_x + gap_px) + 1
        @views image[y0:(y0 + n_y - 1), x0:(x0 + n_x - 1)] .= spots[idx, :, :]
    end
    return image
end

function shack_hartmann_detector_image(wfs::AdaptiveOpticsSim.ShackHartmann; kwargs...)
    return shack_hartmann_detector_image(
        AdaptiveOpticsSim.sh_exported_spot_cube(wfs),
        wfs.params.n_subap;
        kwargs...)
end

function _shack_hartmann_detector_frame_figure(spot_cube::AbstractArray, n_subap::Integer;
    stretch::Symbol=:linear, title::AbstractString="Shack-Hartmann Detector Frame",
    gap::Integer=1, gap_value=0, kwargs...)
    frame = shack_hartmann_detector_image(spot_cube, n_subap; gap=gap, gap_value=gap_value)
    data = _apply_image_stretch(_plot_matrix_data(frame), stretch)
    return _heatmap2d(data; title=title, kwargs...)
end

function _shack_hartmann_detector_frame_figure(wfs::AdaptiveOpticsSim.ShackHartmann;
    stretch::Symbol=:linear, title::AbstractString="Shack-Hartmann Detector Frame",
    gap::Integer=1, gap_value=0, kwargs...)
    frame = shack_hartmann_detector_image(wfs; gap=gap, gap_value=gap_value)
    data = _apply_image_stretch(_plot_matrix_data(frame), stretch)
    return _heatmap2d(data; title=title, kwargs...)
end

_wfs_frame_figure(wfs::AdaptiveOpticsSim.ShackHartmann; kwargs...) =
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
