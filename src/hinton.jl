module hinton

export hintondiag

using Tk
using Base.Graphics
using Cairo

function hintondiag(matrix::Matrix{Float64}; w_frame = 400, h_frame = 400)
    # Makes hinton diagram of the given matrix
    #
    # Parameters
    # ----------
    # matrix : the weight matrix to be visualized
    # w_frame : width of the window in pixels
    # h_frame : height of the window in pixels

    win = Toplevel("weight matrix", w_frame, h_frame);
    can = Canvas(win);
    pack(can, expand = false, fill = "both");

    context = getgc(can);

    set_coords(context, 0, 0, w_frame, h_frame, 0, w_frame, 0, h_frame);
    set_source_rgb(context, 0.5, 0.5, 0.5); # Set background to gray
    paint(context);

    height, width = size(matrix);

    w_cell = w_frame / width;
    h_cell = h_frame / height;

    cell_area = w_cell * h_cell * 0.7; # 0.7 to stop merging of cells 
    max_weight = 2 ^ (ceil(log(maximum(abs(matrix))) / log(2)));
    area_multiplier = cell_area / max_weight;

    for x in 1:width
        for y in 1:height
            weight = matrix[y, x]
            if weight > 0
                draw_block(context, w_cell * (x - 0.5), h_cell * (y - 0.5), min(1, weight) * area_multiplier, 1);
            elseif weight < 0
                draw_block(context, w_cell * (x - 0.5), h_cell * (y - 0.5), min(1, -weight) * area_multiplier, 0);
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
