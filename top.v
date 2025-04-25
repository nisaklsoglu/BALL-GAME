`timescale 1ns / 1ps

module top(
    input clk_100MHz,       // from Basys 3
    input reset,            // btnR
    input up,               // btnU
    input down,             // btnD
    input left,             //btnL
    input right,
    output hsync,           // to VGA port
    output vsync,           // to VGA port
    output [11:0] rgb       // to DAC, to VGA port
    );
    
    wire w_reset, w_up, w_down, w_right, w_left, w_vid_on, w_p_tick;
    wire [9:0] w_x, w_y;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next1, rgb_next2;
    wire bitti;
    reg state;
    
    vga_controller vga(.clk_100MHz(clk_100MHz), .reset(w_reset), .video_on(w_vid_on),
                       .hsync(hsync), .vsync(vsync), .p_tick(w_p_tick), .x(w_x), .y(w_y));
                       
    pixel_gen pg(.clk(clk_100MHz), .reset(w_reset), .up(w_up), .down(w_down), .left(w_left), .right(w_right), 
                 .video_on(w_vid_on), .x(w_x), .y(w_y), .rgb(rgb_next1), .bitti(bitti));
                 
    pixel_gen2 pg2(.clk(clk_100MHz), .reset(w_reset), .up(w_up), .down(w_down), .left(w_left), .right(w_right), 
                 .video_on(w_vid_on), .x(w_x), .y(w_y), .rgb(rgb_next2));
                 
    debounce dbR(.clk(clk_100MHz), .btn_in(right), .btn_out(w_right));
    debounce dbL(.clk(clk_100MHz), .btn_in(left), .btn_out(w_left));
    debounce dbU(.clk(clk_100MHz), .btn_in(up), .btn_out(w_up));
    debounce dbD(.clk(clk_100MHz), .btn_in(down), .btn_out(w_down));
    debounce dbRes(.clk(clk_100MHz), .btn_in(reset), .btn_out(w_reset));
    
     // Durum kontrol¸
    always @(posedge clk_100MHz or posedge w_reset) begin
        if (w_reset)
            state <= 0; // Ba?lang?Á durumu pixel_gen
        else if (bitti)
            state <= 1; // pixel_gen bitti?inde pixel_gen2'ye geÁi?
    end

    // RGB seÁimi
    wire [11:0] rgb_selected = (state == 0) ? rgb_next1 : rgb_next2;

    // RGB buffer
    always @(posedge clk_100MHz) begin
        if (w_p_tick)
            rgb_reg <= rgb_selected;
    end

    assign rgb = rgb_reg;

    
endmodule