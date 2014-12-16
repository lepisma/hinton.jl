module hinton

export hintondiag

using Tk
using Base.Graphics
using Cairo

function hintondiag(matrix::Matrix{Float64}; w_frame = 400, h_frame = 400)
    # Makes hinton diagram of the given matrix

    win = Toplevel("hinton diagram", w_frame, h_frame);
    can = Canvas(win);
    pack(can, expand = false, fill = "both");

    context = getgc(can);

    set_coords(context, 0, 0, w_frame, h_frame, 0, w_frame, 0, h_frame);
    set_source_rgb(context, 0.5, 0.5, 0.5); # Set background to gray
    paint(context);

    height, width = size(matrix);

    w_ratio = w_frame / width;
    h_ratio = h_frame / height;

    cell_area = w_ratio * h_ratio;

    for x in 1:width
        for y in 1:height
            weight = matrix[y, x]
            if weight > 0
                draw_block(context, w_ratio * (x - 0.5), h_ratio * (y - 0.5), weight * cell_area, 1);
            elseif weight < 0
                draw_block(context, w_ratio * (x - 0.5), h_ratio * (y - 0.5), - weight * cell_area, 0);
            end
        end
    end

    reveal(can);
    Tk.update();
end

function draw_block(ctx::CairoContext, x, y, area, color)
    # Draws block of given size on the context
    # x, y define the center of block
    # color 1 = white, 0 = black

    side = sqrt(area);
    rectangle(ctx, x - side / 2, y - side / 2, side, side);

    if color == 1
        set_source_rgb(ctx, 1, 1, 1);
    else
        set_source_rgb(ctx, 0, 0, 0);
    end
    fill(ctx);
end

end # module
